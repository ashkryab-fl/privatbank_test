part of 'movie_details_bloc.dart';

@immutable
sealed class MovieDetailsEvent {}

class FetchMovieDetailsEvent extends MovieDetailsEvent {
  final String id;

  FetchMovieDetailsEvent(this.id);
}
