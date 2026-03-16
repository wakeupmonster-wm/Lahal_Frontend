sealed class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic rawBody;

  const AppException(this.message, {this.statusCode, this.rawBody});

  @override
  String toString() => message;
}

// ---- Network Exceptions ----

class NetworkException extends AppException {
  const NetworkException([String? msg])
    : super(msg ?? 'Please check your internet connection');
}

class TimeoutException extends AppException {
  const TimeoutException([String? msg])
    : super(msg ?? 'Request timed out. Please try again');
}

// ---- HTTP Status Exceptions ----

class BadRequestException extends AppException {
  const BadRequestException(String message, {dynamic rawBody})
    : super(message, statusCode: 400, rawBody: rawBody);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([String? msg])
    : super(msg ?? 'Session expired. Please login again', statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([String? msg])
    : super(msg ?? 'Access denied', statusCode: 403);
}

class NotFoundException extends AppException {
  const NotFoundException([String? msg])
    : super(msg ?? 'Resource not found', statusCode: 404);
}

class ConflictException extends AppException {
  const ConflictException(String message, {dynamic rawBody})
    : super(message, statusCode: 409, rawBody: rawBody);
}

class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException(String message, {this.errors, dynamic rawBody})
    : super(message, statusCode: 422, rawBody: rawBody);
}

class RateLimitException extends AppException {
  const RateLimitException([String? msg])
    : super(
        msg ?? 'Too many requests. Please wait and try again',
        statusCode: 429,
      );
}

class ServerException extends AppException {
  const ServerException([String? msg])
    : super(msg ?? 'Server error. Please try again later', statusCode: 500);
}

// ---- Business Logic Exceptions ----

class ApiStatusFalseException extends AppException {
  /// Thrown when HTTP is 200 but response.status == false
  const ApiStatusFalseException(String message) : super(message);
}

class TokenRefreshException extends AppException {
  const TokenRefreshException([String? msg])
    : super(msg ?? 'Unable to refresh session');
}
