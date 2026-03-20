import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:lahal_application/data/datasources/local/user_prefrence.dart';
import 'package:lahal_application/data/exceptions/app_exception.dart';
import 'package:lahal_application/data/models/api_response.dart';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:lahal_application/utils/services/helper/app_logger.dart';

class NetworkApiServices {
  final UserPreferences _prefs = UserPreferences();

  // ---- Headers ----

  Future<Map<String, String>> _getHeaders({
    bool useRefreshToken = false,
  }) async {
    final token = await _prefs
        .getToken(); // Modify if separating refresh token logic

    if (useRefreshToken) {
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if  (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };
    } else {
      return {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };
    }
  }

  // ---- Main Request Method ----

  Future<ApiResponse<T>> sendRequest<T>({
    required Uri url,
    required HttpMethod method,
    Map<String, dynamic>? body,
    Map<String, String>? customHeaders,
    bool useRefreshToken = false,
    bool includeHeaders = true, // Added for backward compatibility
    T Function(dynamic json)? fromJsonT,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    final headers =
        customHeaders ??
        (includeHeaders
            ? await _getHeaders(useRefreshToken: useRefreshToken)
            : {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              });

    AppLogger.apiRequest(
      method.name.toUpperCase(),
      url.path.toString(),
      headers,
    );

    try {
      final http.Response response;

      switch (method) {
        case HttpMethod.get:
          response = await http.get(url, headers: headers).timeout(timeout);
        case HttpMethod.post:
          response = await http
              .post(
                url,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
        case HttpMethod.put:
          response = await http
              .put(
                url,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
        case HttpMethod.patch:
          response = await http
              .patch(
                url,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
        case HttpMethod.delete:
          response = await http
              .delete(
                url,
                headers: headers,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
      }

      AppLogger.apiResponse(
        method.name.toUpperCase(),
        url.path.toString(),
        response.statusCode,
        response.body,
      );
      return _processResponse<T>(response, fromJsonT: fromJsonT);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException();
    } on AppException {
      rethrow;
    } on http.ClientException catch (e) {
      throw NetworkException('Connection error: ${e.message}');
    } catch (e) {
      throw NetworkException('Unexpected error: $e');
    }
  }

  // ---- Multipart Request ----

  Future<ApiResponse<T>> multipartRequest<T>({
    required Uri url,
    required HttpMethod method,
    required List<File> files,
    String fileFieldName = 'photos',
    Map<String, String>? fields,
    bool includeHeaders = true, // Added for backward compatibility
    T Function(dynamic json)? fromJsonT,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final headers = includeHeaders
        ? await _getHeaders()
        : {'Accept': 'application/json'};
    headers.remove('Content-Type'); // Let multipart set its own

    AppLogger.apiRequest(
      'MULTIPART ${method.name.toUpperCase()}',
      url.path.toString(),
      headers,
    );

    try {
      final request = http.MultipartRequest(
        method == HttpMethod.post ? 'POST' : 'PUT',
        url,
      );

      request.headers.addAll(headers);
      if (fields != null) request.fields.addAll(fields);

      for (final file in files) {
        request.files.add(
          await http.MultipartFile.fromPath(fileFieldName, file.path),
        );
      }

      final streamed = await request.send().timeout(timeout);
      final response = await http.Response.fromStream(streamed);

      AppLogger.apiResponse('MULTIPART', url.toString(), response.statusCode);
      return _processResponse<T>(response, fromJsonT: fromJsonT);
    } on SocketException {
      throw const NetworkException();
    } on TimeoutException {
      throw const TimeoutException('Upload timed out');
    } on AppException {
      rethrow;
    } catch (e) {
      throw NetworkException('Upload error: $e');
    }
  }

  // ---- Response Processing ----

  ApiResponse<T> _processResponse<T>(
    http.Response response, {
    T Function(dynamic json)? fromJsonT,
  }) {
    final Map<String, dynamic> body;

    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      // Response is not valid JSON
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse<T>(status: true, message: 'Success', data: null);
      }
      _throwForStatusCode(response.statusCode, response.body);
    }

    // Check HTTP status code first
    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body['message']?.toString() ?? 'Request failed';
      _throwForStatusCode(response.statusCode, message, body);
    }

    // HTTP is 200-299, now check API status field
    final apiStatus = body['status'] == 'success' || body['success'] == true;
    if (!apiStatus) {
      final message = body['message']?.toString() ?? 'Operation failed';
      throw ApiStatusFalseException(message);
    } // modified to support typical standard or "status: success" convention

    // Success — parse with wrapper
    final res = ApiResponse<T>.fromJson(body, fromJsonT: fromJsonT);
    return res;
  }

  Never _throwForStatusCode(
    int statusCode,
    dynamic message, [
    Map<String, dynamic>? body,
  ]) {
    final msg = message is String ? message : 'Request failed';

    switch (statusCode) {
      case 400:
        throw BadRequestException(msg, rawBody: body);
      case 401:
        throw UnauthorizedException(msg);
      case 403:
        throw ForbiddenException(msg);
      case 404:
        throw NotFoundException(msg);
      case 409:
        throw ConflictException(msg, rawBody: body);
      case 422:
        throw ValidationException(
          msg,
          errors: body?['errors'] as Map<String, dynamic>?,
          rawBody: body,
        );
      case 429:
        throw const RateLimitException();
      default:
        if (statusCode >= 500) {
          throw ServerException(msg);
        }
        throw ServerException('Request failed with status $statusCode: $msg');
    }
  }
}
