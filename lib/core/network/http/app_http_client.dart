import 'dart:async';
import '../../common/exception.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@LazySingleton()
class AppHttpClient {
  AppHttpClient(this._dio);

  final Dio _dio;

  Future<dynamic> get({
    required String url,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        throw AppHttpException(response.statusCode);
      } else {
        throw AppUnexpectedException();
      }
    } catch (e) {
      throw AppUnexpectedException();
    }
  }

  Future<dynamic> post({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        throw AppHttpException(response.statusCode);
      } else {
        throw AppUnexpectedException();
      }
    } catch (e) {
      throw AppUnexpectedException();
    }
  }

  Future<dynamic> patch({
    required String url,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      final response = e.response;
      if (response != null) {
        throw AppHttpException(response.statusCode);
      } else {
        throw AppUnexpectedException();
      }
    } catch (e) {
      throw AppUnexpectedException();
    }
  }
}
