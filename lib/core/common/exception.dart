sealed class AppException {}

final class AppUnexpectedException implements AppException {
  final String? message;

  AppUnexpectedException({this.message});
}

final class AppNetworkException implements AppException {}

final class AppHttpException implements AppException {
  final int? code;

  AppHttpException(int? statusCode, {this.code});
}
