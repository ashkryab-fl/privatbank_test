part of 'movie_details_bloc.dart';

@immutable
class MovieDetailsState {
  final bool isLoading;
  final String posterPath;
  final String title;
  final String overview;
  final double? rating;

  const MovieDetailsState(
      {required this.isLoading,
      required this.posterPath,
      required this.title,
      required this.overview,
      required this.rating});

  factory MovieDetailsState.initial() {
    return const MovieDetailsState(
      isLoading: true,
      posterPath: '',
      title: '',
      overview: '',
      rating: 0.0,
    );
  }

  String get posterUrl => 'https://image.tmdb.org/t/p/w500/$posterPath';

  MovieDetailsState copyWith({
    bool? isLoading,
    String? posterPath,
    String? title,
    String? overview,
    double? rating,
  }) {
    return MovieDetailsState(
      isLoading: isLoading ?? this.isLoading,
      posterPath: posterPath ?? this.posterPath,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      rating: rating ?? this.rating,
    );
  }
}
