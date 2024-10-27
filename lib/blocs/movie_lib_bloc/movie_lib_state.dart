import 'package:test_ashkryab/core/entity/movie.dart';

class VideoLibState {
  final List<MovieModel> movies;

  VideoLibState({this.movies = const []});

  VideoLibState copyWith({List<MovieModel>? movies}) {
    return VideoLibState(movies: movies ?? this.movies);
  }
}

class MovieModel {
  final int id;
  final String title;
  final String posterPath;
  final String overview;

  MovieModel(
      {required this.id,
      required this.title,
      required this.overview,
      required this.posterPath});

  String get posterUrl => 'https://image.tmdb.org/t/p/w500/$posterPath';

  factory MovieModel.fromMovie(Movie movie) {
    return MovieModel(
      id: movie.id!,
      title: movie.title??'No title',
      overview: movie.overview??'No overview',
      posterPath: movie.posterPath??'',
    );
  }
}
