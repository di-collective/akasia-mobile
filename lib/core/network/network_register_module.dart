import 'http/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@module
abstract class NetworkRegisterModule {
  @lazySingleton
  Dio dio(LoggingInterceptor loggingInterceptor) => Dio()..interceptors.add(loggingInterceptor);
}
