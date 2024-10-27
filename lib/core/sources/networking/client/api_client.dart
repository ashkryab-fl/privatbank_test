/// Abstract class `ApiClient` serving as a blueprint for API client implementations.
///
/// This class defines the core functionalities for making HTTP requests such as GET, POST, PUT, and DELETE.
/// Each method is designed to interact with a server's endpoint and handle the response accordingly.
/// The methods require a path, a JSON parser function to convert the response, and optionally, query parameters
/// and other request options.
///
/// Implementations of this class should provide concrete logic for these HTTP operations, tailored to the
/// specific needs of the application's API.
///
/// Methods have next parameters:
/// - `path`: The endpoint URL path where the request is sent.
/// - `jsonParser`: A function that parses the JSON response into a model of type `R`.
/// - `queryParams`: Optional query parameters to include in the request.
/// - `params`: The data to send in the request body.
/// - `options`: Optional headers or other options for the request.
/// - Returns: A future of type `R` which is the result of the `jsonParser` function.
abstract class ApiClient {
  Future<R> get<R, T>(String path,
      {required R Function(T) jsonParser,
      Map<String, dynamic> queryParams});

  Future<R> post<R,T>(String path,
      {required R Function(T) jsonParser,
      dynamic params,
      Map<String, dynamic> options});

  Future<R> put<R,T>(String path,
      {required R Function(T) jsonParser, dynamic params});

  Future<R> delete<R,T>(String path,
      {required R Function(T) jsonParser,
      dynamic params,
      Map<String, dynamic> queryParams});
}
