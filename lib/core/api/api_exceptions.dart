class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;
  final String? code;

  ApiException(this.message, {this.statusCode, this.data, this.code});

  @override
  String toString() {
    if (statusCode != null) {
      return 'ApiException [$statusCode]: $message';
    }
    return 'ApiException: $message';
  }
}

class NetworkException extends ApiException {
  NetworkException(String message) : super(message);
}

class UnauthorizedException extends ApiException {
  UnauthorizedException(String message) : super(message, statusCode: 401, code: 'UNAUTHORIZED');
}
