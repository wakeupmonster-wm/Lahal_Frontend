class AppException implements Exception {
  final String? prefix;
  final String? message;

  AppException(this.message, this.prefix);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "Error During Communication \n");
}

class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Invalid Request \n");
}

class UnauthorizedException extends AppException {
  UnauthorizedException([String? message]) : super(message, "Unauthorized Request");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input Exception \n");
}

class InternalSeverException extends AppException {
  InternalSeverException([String? message]) : super(message, "Internal Sever Error");
}

class ApiException extends AppException {
  ApiException([String? message]) : super(message, "");
}
