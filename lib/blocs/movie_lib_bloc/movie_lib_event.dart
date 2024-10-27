import 'package:flutter/foundation.dart';
import 'package:test_ashkryab/blocs/movie_lib_bloc/movie_lib_state.dart';

@immutable
sealed class MovieLibEvent {}

class MovieLibGetNextPage extends MovieLibEvent {}
class RefreshVideoLibEvent extends MovieLibEvent {}
class MoviesReceivedEvent extends MovieLibEvent {
  final List<MovieModel> movies;

  MoviesReceivedEvent({required this.movies});
}

class MovieLibSearch extends MovieLibEvent {
  final String query;

  MovieLibSearch({required this.query});
}
