import 'package:dio/dio.dart';
import 'package:test_ashkryab/core/sources/networking/client/api_client.dart';

/// Mixin providing Dio-specific options for API clients.
///
/// This mixin extends the functionality of [ApiClient] by providing
/// Dio-specific configurations for HTTP requests. It includes base options
/// and request-specific options that can be customized per request.
mixin DioOptionsMixin on ApiClient {
  /// Generates Dio [BaseOptions] for the client.
  BaseOptions get baseDioOptions => BaseOptions(
        //move to env
        baseUrl: 'https://api.themoviedb.org',
        // Retrieves the base URL from the environment settings.
        contentType: Headers.jsonContentType,
        // Sets content type to JSON.
        connectTimeout: const Duration(seconds: 5),
      );

  /// Generates Dio [Options] for individual requests.
  ///
  /// This getter returns a new instance of [Options] for Dio requests,
  /// allowing for request-specific configurations. By default, it initializes
  /// headers as an empty map, which can be customized further in the request.
  Options get options {
    final opt = Options();
    opt.headers = {}; // Initializes request headers as an empty map.
    return opt;
  }
}
