import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test_ashkryab/core/sources/networking/client/api_client.dart';
import 'package:test_ashkryab/core/sources/networking/client/dio/interceptor/auth_interceptor.dart';
import 'package:test_ashkryab/core/sources/networking/client/dio/options_mixin.dart';

class DioClient extends ApiClient with DioOptionsMixin {

  late final Dio dio = _dioClientBuilder(baseDioOptions);

  DioClient();

  Dio _dioClientBuilder(BaseOptions opts) {
    final dioClient = Dio(opts);
    dioClient.interceptors.addAll([
      AuthInterceptor(),
      // ErrorInterceptor(),
    ]);
    return dioClient;
  }

  @override
  Future<R> delete<R, T>(String path,
      {required R Function(T) jsonParser,
        dynamic params,
        Map<String, dynamic>? queryParams}) async {
    final response = await dio.delete<Map<String, dynamic>>(path,
        data: params, queryParameters: queryParams, options: options);
    return jsonParser(_checkResponseAndUnwrap.call(response));
  }

  @override
  Future<R> get<R, T>(String path,
      {required R Function(T) jsonParser,
        Map<String, dynamic>? queryParams}) async {
    Response<dynamic> response;
    response = await dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParams,
      options: options,
    );
    return jsonParser(_checkResponseAndUnwrap.call(response));
  }

  @override
  Future<R> post<R, T>(String path,
      {required R Function(T) jsonParser,
        dynamic params,
        Map<String, dynamic>? options}) async {
    Options? overrideOption;
    if (options != null) {
      overrideOption = Options(headers: options);
    }
    final response = await dio.post<Map<String, dynamic>>(path,
        data: params, options: overrideOption ?? this.options);

    return jsonParser(_checkResponseAndUnwrap(response));
  }

  @override
  Future<R> put<R, T>(String path,
      {required R Function(T) jsonParser,
        dynamic params,
        bool withGzip = false}) async {
    final response = await dio.put<Map<String, dynamic>>(path,
        data: params, options: options);

    return jsonParser(_checkResponseAndUnwrap(response));
  }

  dynamic _checkResponseAndUnwrap(Response<dynamic> rsp) {
    final statusCode = rsp.statusCode;
    final body = rsp.data;

    if (statusCode! < 200 || statusCode >= 300) {
      throw HttpException(
          'Error: $statusCode,  Message: ${rsp.statusMessage}, Body: $body');
    }

    if (body != null) {
      if (body is Map<String, dynamic>) {
        if (body['error_code'] == null || body['error_code'] == 0) {
          var results = body['results'];
          return results;
        } else {
          //todo custom exceptions
          throw 'API ERROR ${body['error_message']}';
        }
      }else{
        return body;
      }
    }

    throw 'DIO unwrap exception';
  }
}
