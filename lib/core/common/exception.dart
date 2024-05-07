import 'package:equatable/equatable.dart';

abstract class AppException extends Equatable {
  final Object? code;
  final String? message;

  const AppException({
    this.code,
    this.message,
  });

  @override
  List<Object?> get props => [code, message];
}

class AppUnexpectedException extends AppException {
  const AppUnexpectedException({
    super.code,
    super.message,
  });
}

class AppNetworkException extends AppException {
  const AppNetworkException({
    super.code,
    super.message,
  });
}

class AppHttpException extends AppException {
  const AppHttpException({
    super.code,
    super.message,
  });
}
