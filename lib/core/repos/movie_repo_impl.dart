import 'package:test_ashkryab/core/entity/movie.dart';
import 'package:test_ashkryab/core/providers/movie_provider/local_saver.dart';
import 'package:test_ashkryab/core/providers/movie_provider/movie_source.dart';

class MovieRepo {
  final MovieProvider _movieSource;
  final MovieProvider _movieLocalSource;

  MovieRepo(
      {required MovieProvider movieSource, required MovieProvider movieLocalSource})
      : _movieSource = movieSource,
        _movieLocalSource = movieLocalSource,
        assert(movieLocalSource is LocalSaver<List<Movie>>,
            'movieLocalSource should implement LocalSaver<List<Movie>>');

  Stream<List<Movie>> getMovies(int page) async* {
    var local = await _movieLocalSource.getMovies(page);
    if (local != null) {
      yield local;
    }
    var movies = await _movieSource.getMovies(page);
    if (movies != null) {
      yield movies;
      (_movieLocalSource as LocalSaver<List<Movie>>).cache(movies);
    }
  }

  //todo add pagination
  Future<List<Movie>?> searchMovies(String query) async {
    try {
      var movies = await _movieSource.searchMovies(query);
      if (movies != null) {
        (_movieLocalSource as LocalSaver<List<Movie>>).cache(movies);
      }
      return movies ?? [];
    } catch (e) {
      try {
        var local = await _movieLocalSource.searchMovies(query);
        return  local;
      } catch (e) {
        return [];
      }
    }
  }

  //todo use stream instead of future for fastest display
  Future<Movie?> getById(String id) async {
    try {
      var movie = await _movieSource.getById(id);
      if (movie != null) {
        (_movieLocalSource as LocalSaver<List<Movie>>).cache([movie]);
      }
      return movie;
    } catch (e) {
      try {
        return _movieLocalSource.getById(id);
      } catch (e) {
        return null;
      }
    }
  }
}
