import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:test_ashkryab/core/providers/movie_provider/movie_local_source_impl.dart';
import 'package:test_ashkryab/core/repos/movie_repo_impl.dart';
import 'package:test_ashkryab/core/sources/networking/api/api.dart';

part 'movie_details_event.dart';
part 'movie_details_state.dart';

class MovieDetailsBloc extends Bloc<MovieDetailsEvent, MovieDetailsState> {
  //todo: use get_it for dependency injection
  final MovieRepo _movieRepo = MovieRepo(
    movieSource: Api(),
    movieLocalSource: MovieLocalProviderImpl(),
  );

  MovieDetailsBloc() : super(MovieDetailsState.initial()) {
    on<FetchMovieDetailsEvent>(_onFetchMovieDetails);
  }

  Future<void> _onFetchMovieDetails(
      FetchMovieDetailsEvent event, Emitter<MovieDetailsState> emit) async {
    var movie = await _movieRepo.getById(event.id);
    if (movie != null) {
      emit(state.copyWith(
          isLoading: false,
          title: movie.title,
          overview: movie.overview,
          posterPath: movie.posterPath,
          rating: movie.voteAverage));
    }
  }
}
