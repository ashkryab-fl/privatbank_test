import 'package:test_ashkryab/core/entity/movie.dart';
import 'package:test_ashkryab/core/providers/movie_provider/movie_source.dart';
import 'package:test_ashkryab/core/sources/networking/client/api_client.dart';
import 'package:test_ashkryab/core/sources/networking/client/dio/dio_client.dart';

class ApiEndpoints {
  static String apiVersion = '/3';
  static String search = '$apiVersion/search';
}

class Api implements MovieProvider {
  //todo: use get_it for dependency injection
  static final Api _instance = Api._internal(DioClient());

  factory Api() {
    return _instance;
  }

  Api._internal(this.client);

  final ApiClient client;

  @override
  Future<List<Movie>> searchMovies(String query) async {
    return client.get<List<Movie>, List>(
        '${ApiEndpoints.apiVersion}/search/movie',
        queryParams: {'query': query}, jsonParser: (List json) {
      return json.map((e) => Movie.fromJson(e)).toList();
    });
  }

  @override
  Future<List<Movie>> getMovies(int page) {
    return client.get<List<Movie>, List>(
        '${ApiEndpoints.apiVersion}/discover/movie',
        queryParams: {'page': page, 'sort_by': 'popularity.desc'},
        jsonParser: (List json) {
      return json.map((e) => Movie.fromJson(e)).toList();
    });
  }

  @override
  Future<Movie?> getById(String id) {
    return client.get<Movie?, Map<String, dynamic>>(
        '${ApiEndpoints.apiVersion}/movie/$id',
        jsonParser: (json) => Movie.fromJson(json));
  }
}
