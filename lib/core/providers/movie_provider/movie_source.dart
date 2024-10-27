import 'package:test_ashkryab/core/entity/movie.dart';

abstract class MovieProvider {
  static int limit = 20;

  Future<List<Movie>?> searchMovies(String query);

  Future<List<Movie>?> getMovies(int page);

  Future<Movie?> getById(String id);
}