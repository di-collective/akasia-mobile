import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

@LazySingleton()
class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor(this.dio);

  final Dio dio;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // todo: get saved token
    var token = '';
    const refreshToken = '';
    final isTokenExpired = JwtDecoder.isExpired(token);
    final isRefreshTokenExpired = JwtDecoder.isExpired(refreshToken);
    if (isTokenExpired) {
      // todo: refresh token
      token = 'new token';
    } else if (isRefreshTokenExpired) {
      handler.reject(DioException.requestCancelled(requestOptions: options, reason: null));
      //todo: logout
    }
    options.headers['Authorization'] = 'Bearer $token';
    super.onRequest(options, handler);
  }
}
