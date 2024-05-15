import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../app/observers/logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      Logger.info(
          response.requestOptions.baseUrl + response.requestOptions.path);
      Logger.info(response.statusCode.toString());
      Logger.info(response.headers.toString());
      Logger.info(response.data);
    }
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      Logger.info(options.baseUrl + options.path);
      Logger.info(options.headers.toString());
      Logger.info(options.data);
    }
    super.onRequest(options, handler);
  }
}
