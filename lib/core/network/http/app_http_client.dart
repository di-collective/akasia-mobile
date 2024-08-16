import 'dart:async';

import 'package:dio/dio.dart';

import '../../common/exception.dart';
import '../../utils/logger.dart';

class AppHttpClient {
  final Dio dio;

  AppHttpClient({
    required this.dio,
  });

  Future<Response> get({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      Logger.info("---- URL ----\n$url");

      Logger.info("---- DATA ----\n$data");

      Logger.info("---- QUERY PARAMETERS ----\n$queryParameters");

      Logger.info("---- FORMDATA ----\n${formData?.fields}");

      // add default headers
      headers ??= {};
      if (headers['Content-Type'] == null) {
        // add default content type
        headers['Content-Type'] = 'application/json';
      }
      Logger.info("---- HEADERS ----\n$headers");

      Logger.info("---- CANCELTOKEN ----\n$cancelToken");

      final response = await dio.get(
        url,
        data: data ?? formData,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      throw const AppUnexpectedException();
    }
  }

  Future<Response> post({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      Logger.info("---- URL ----\n$url");

      Logger.info("---- DATA ----\n$data");

      Logger.info("---- QUERY PARAMETERS ----\n$queryParameters");

      Logger.info("---- FORMDATA ----\n${formData?.fields}");

      // add default headers
      headers ??= {};
      if (headers['Content-Type'] == null) {
        // add default content type
        headers['Content-Type'] = 'application/json';
      }
      Logger.info("---- HEADERS ----\n$headers");

      Logger.info("---- CANCELTOKEN ----\n$cancelToken");

      final response = await dio.post(
        url,
        data: data ?? formData,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      throw const AppUnexpectedException();
    }
  }

  Future<Response> patch({
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
  }) async {
    try {
      Logger.info("---- URL ----\n$url");

      Logger.info("---- DATA ----\n$data");

      Logger.info("---- QUERY PARAMETERS ----\n$queryParameters");

      Logger.info("---- FORMDATA ----\n${formData?.fields}");

      // add default headers
      headers ??= {};
      if (headers['Content-Type'] == null) {
        // add default content type
        headers['Content-Type'] = 'application/json';
      }

      Logger.info("---- HEADERS ----\n$headers");

      Logger.info("---- CANCELTOKEN ----\n$cancelToken");

      final response = await dio.patch(
        url,
        data: data ?? formData,
        queryParameters: queryParameters,
        options: Options(
          headers: headers,
        ),
        cancelToken: cancelToken,
      );

      return response;
    } on DioException catch (_) {
      rethrow;
    } catch (e) {
      throw const AppUnexpectedException();
    }
  }
}
