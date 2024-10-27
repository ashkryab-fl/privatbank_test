import 'package:dio/dio.dart';
import 'package:test_ashkryab/core/sources/networking/utils/api_exeption.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      return handler.next(err);
    }

    if (err.response == null ||
        err.response?.data == null ||
        err.response?.data is String) {
      if (err.response?.statusCode == null) {
        return handler
            .reject(NoInternetException(requestOptions: err.requestOptions));
      } else if (err.response?.statusCode == 405) {
        return handler.reject(
            MethodNotAllowedException(requestOptions: err.requestOptions));
      }
      return handler.next(UnknownException(
          requestOptions: err.requestOptions,
          text: err.response?.statusCode.toString() ?? ''));
    }

    if (err.response?.data['error_code'] != null) {
      var knownException = getException(err);
      return handler.reject(knownException ?? err);
    }
    return handler.reject(err);
  }

  ApiException? getException(
    DioException err,
  ) {
    //todo: add known exceptions
    return ServerException(requestOptions: err.requestOptions);
  }
}
