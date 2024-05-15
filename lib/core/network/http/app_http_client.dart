import 'dart:async';

import 'package:dio/dio.dart';

import '../../common/exception.dart';

class AppHttpClient {
  final Dio dio;

  AppHttpClient({
    required this.dio,
  });

  Future<Response> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        throw AppHttpException(
          code: response.statusCode,
        );
      } else {
        throw const AppUnexpectedException();
      }
    } catch (e) {
      throw const AppUnexpectedException();
    }
  }

  Future<Response> post({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        throw AppHttpException(
          code: response.statusCode,
        );
      } else {
        throw const AppUnexpectedException();
      }
    } catch (e) {
      throw const AppUnexpectedException();
    }
  }

  Future<Response> patch({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        throw AppHttpException(
          code: response.statusCode,
        );
      } else {
        throw const AppUnexpectedException();
      }
    } catch (e) {
      throw const AppUnexpectedException();
    }
  }
}
