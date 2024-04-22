import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class LoggingInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print(response.requestOptions.baseUrl + response.requestOptions.path);
      print(response.statusCode);
      print(response.headers);
      print(response.data);
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print(options.baseUrl + options.path);
      print(options.headers);
      print(options.data);
    }
    super.onRequest(options, handler);
  }
}
