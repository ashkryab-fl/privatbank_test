import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {

  AuthInterceptor();

@override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
  //todo: do not save api keys in the code, just for testing
  options.queryParameters.addAll({
    'api_key': 'b04a4ef27c5e493be58c7dd7a0640bf0',
  });
    super.onRequest(options, handler);
  }
}