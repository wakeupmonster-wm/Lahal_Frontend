import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:lahal_application/utils/constants/enum.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../local/user_prefrence.dart';

import '../../exceptions/app_exception.dart';
import '../../../utils/extensions/extensions.dart';

typedef MapSS = Map<String, String>;
typedef MapSD = Map<String, dynamic>;

class NetworkApiServices {
  // Public method to send HTTP requests
  Future<MapSD> sendHttpRequest({
    required Uri url,
    required HttpMethod method,
    MapSS? body,
    MapSS? queryParams,
    Map<String, XFile>? files,
    String? id,
    bool includeHeaders = true,
  }) async {
    // Process URL with ID and query parameters
    final processedUrl = _buildUrl(url, id, queryParams);

    try {
      if (files != null && files.isNotEmpty) {
        // Handle file upload requests
        return await _sendMultipartRequest(
          url: processedUrl,
          method: method,
          body: body,
          files: files,
          includeHeaders: includeHeaders,
        );
      } else {
        // Handle regular requests
        return await _sendRegularRequest(
          url: processedUrl,
          method: method,
          body: body,
          includeHeaders: includeHeaders,
        );
      }
    } on SocketException {
      throw FetchDataException("No Internet Connection");
    } on TimeoutException {
      throw FetchDataException("Request timed out. Please try again later.");
    }
  }

  // Private helper to build URL with ID and query parameters
  Uri _buildUrl(Uri url, String? id, MapSS? queryParams) {
    if (id != null && id.isNotEmpty) {
      final pathWithId = '${url.path}/$id';
      url = url.replace(path: pathWithId);
    }
    return queryParams != null
        ? Uri.https(url.authority, url.path, queryParams)
        : url;
  }

  // Private method to send regular HTTP requests
  Future<MapSD> _sendRegularRequest({
    required Uri url,
    required HttpMethod method,
    MapSS? body,
    bool includeHeaders = true,
  }) async {
    final request = _createRequest(url, method, body);
    if (includeHeaders) {
      final headers = await UserPreferences().getHeader();
      request.headers.addAll(headers);
    } else {
      request.headers.addAll({'Accept': 'application/json'});
    }

    request.headers.log("Headers");
    final response = await _sendAndHandleRequest(request);
    return handleApiResponse(response);
  }

  // Private method to send multipart requests
  Future<MapSD> _sendMultipartRequest({
    required Uri url,
    required HttpMethod method,
    MapSS? body,
    required Map<String, XFile> files,
    bool includeHeaders = true,
  }) async {
    final request = http.MultipartRequest(method.name.toUpperCase(), url);

    // Add fields to the request
    if (body != null) {
      request.fields.addAll(body);
    }

    // Add files to the request
    for (var entry in files.entries) {
      final file = entry.value;
      final fileStream = http.ByteStream(file.openRead());
      final fileLength = await file.length();
      final multipartFile = http.MultipartFile(
        entry.key,
        fileStream,
        fileLength,
        filename: file.path.split('/').last,
      );
      request.files.add(multipartFile);
    }

    // Add headers
    if (includeHeaders) {
      final headers = await UserPreferences().getHeader();
      request.headers.addAll(headers);
    } else {
      request.headers.addAll({'Accept': 'application/json'});
    }

    final response = await _sendAndHandleRequest(request);
    return handleApiResponse(response);
  }

  // Private helper to create a request for regular HTTP methods
  http.Request _createRequest(Uri url, HttpMethod method, MapSS? body) {
    final request = http.Request(method.name.toUpperCase(), url);
    if (body != null) {
      if (method == HttpMethod.post || method == HttpMethod.delete) {
        request.bodyFields = body;
      } else if (method == HttpMethod.put) {
        request.body = json.encode(body);
      }
    }
    return request;
  }

  // Private helper to send the request and handle streaming
  Future<http.Response> _sendAndHandleRequest(http.BaseRequest request) async {
    final streamedResponse = await request.send().timeout(
      const Duration(seconds: 30),
    );
    return await http.Response.fromStream(streamedResponse);
  }

  // Public method to handle API responses
  MapSD handleApiResponse(http.Response response) {
    try {
      final statusCode = response.statusCode;
      final responseJson = statusCode != 500 ? jsonDecode(response.body) : null;

      if (statusCode >= 200 && statusCode < 300) {
        return responseJson;
      } else if (statusCode >= 400 && statusCode < 500) {
        if (responseJson != null && responseJson['message'] != null) {
          throw ApiException(responseJson['message']);
        } else {
          throw ApiException("An error occurred. Status code: $statusCode");
        }
      } else if (statusCode == 500) {
        throw InternalSeverException(
          "Internal server error. Please try again.",
        );
      } else {
        throw Exception("Unexpected error. Status code: $statusCode");
      }
    } catch (e) {
      throw FetchDataException("Failed to process response: ${e.toString()}");
    }
  }
}
