
import 'package:dio/dio.dart';

class ApiException extends DioException {
  ApiException({required super.requestOptions});
}

class UnknownException extends ApiException {
  UnknownException({required super.requestOptions, this.text});

  String? text;

  @override
  get message => '${'errors.unknown_error'}: $text';
}

class MethodNotAllowedException extends ApiException {
  MethodNotAllowedException({required super.requestOptions});

  @override
  get message => '405 Method Not Allowed';
}

class NoInternetException extends ApiException {
  NoInternetException({required super.requestOptions});

  @override
  get message => 'errors.no_internet';
}

class ServerException extends ApiException {
  ServerException({required super.requestOptions});

  @override
  get message => 'errors.service_error';
}


