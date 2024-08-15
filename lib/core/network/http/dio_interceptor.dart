import 'package:dio/dio.dart';

import '../../ui/extensions/string_extension.dart';
import '../../utils/logger.dart';
import '../error_code.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    Logger.info('REQUEST[${options.method}] => PATH: ${options.path}');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    Logger.success(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}\n DATA => ${response.data}');

    return super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    Logger.error(
        'ERROR[${err.response?.statusCode}] || TYPE[${err.type}] => PATH: ${err.requestOptions.path} => DATA: ${err.response?.data}');

    String? message;
    String? error;

    if (err.response?.data is String) {
      message = err.response?.data;
    } else if (err.response?.data is Map) {
      // get data
      error = err.response?.data['error'];
      message = err.response?.data['message'];

      // if message is null, get error
      message ??= err.response?.data['error'];
    }

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw DeadlineExceededException(err.requestOptions);
      case DioExceptionType.badResponse:
        switch (err.response?.statusCode) {
          case 400:
            if (error?.isSame(otherValue: ErrorCode.dataNotFound) == true) {
              throw NotFoundException(
                err.requestOptions,
                message: message,
              );
            }

            throw BadRequestException(
              err.requestOptions,
              message: message,
            );
          case 401:
            throw UnauthorizedException(
              err.requestOptions,
              message: message,
            );
          case 404:
            throw NotFoundException(
              err.requestOptions,
              message: message,
            );
          case 409:
            throw ConflictException(
              err.requestOptions,
              message: message,
            );
          case 422:
            throw BadRequestException(
              err.requestOptions,
              message: message,
            );
          case 500:
            throw InternalServerErrorException(
              err.requestOptions,
              message: message,
            );
        }
        break;
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        throw NoInternetConnectionException(err.requestOptions);
    }

    return handler.next(err);
  }
}

class BadRequestException extends DioException {
  BadRequestException(
    RequestOptions r, {
    super.message,
  }) : super(
          requestOptions: r,
        );

  @override
  String toString() {
    if (message != null) {
      return message!;
    }

    return 'Bad request';
  }
}

class InternalServerErrorException extends DioException {
  InternalServerErrorException(
    RequestOptions r, {
    super.message,
  }) : super(
          requestOptions: r,
        );

  @override
  String toString() {
    if (message != null) {
      return message!;
    }

    return 'Internal server error';
  }
}

class ConflictException extends DioException {
  ConflictException(
    RequestOptions r, {
    super.message,
  }) : super(
          requestOptions: r,
        );

  @override
  String toString() {
    if (message != null) {
      return message!;
    }

    return 'Conflict occurred';
  }
}

class UnauthorizedException extends DioException {
  UnauthorizedException(
    RequestOptions r, {
    super.message,
  }) : super(
          requestOptions: r,
        );

  @override
  String toString() {
    if (message != null) {
      return message!;
    }

    return 'Unauthorized';
  }
}

class NotFoundException extends DioException {
  NotFoundException(
    RequestOptions r, {
    super.message,
  }) : super(
          requestOptions: r,
        );

  @override
  String toString() {
    if (message != null) {
      return message!;
    }

    return 'The requested information could not be found';
  }
}

class NoInternetConnectionException extends DioException {
  NoInternetConnectionException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'No internet connection detected, please try again.';
  }
}

class DeadlineExceededException extends DioException {
  DeadlineExceededException(RequestOptions r) : super(requestOptions: r);

  @override
  String toString() {
    return 'The connection has timed out, please try again.';
  }
}
