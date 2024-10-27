import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:test_ashkryab/blocs/movie_lib_bloc/movie_lib_event.dart';
import 'package:test_ashkryab/blocs/movie_lib_bloc/movie_lib_state.dart';
import 'package:test_ashkryab/core/providers/movie_provider/movie_local_source_impl.dart';
import 'package:test_ashkryab/core/repos/movie_repo_impl.dart';
import 'package:test_ashkryab/core/sources/networking/api/api.dart';

//todo add loading state with spinner
class MovieLibBloc extends Bloc<MovieLibEvent, VideoLibState> {
  int nextPage = 1;
  Completer? _previousSearchCompleter;
  String searchQuery = '';

  //todo: use get_it for dependency injection
  final MovieRepo _movieRepo = MovieRepo(
    movieSource: Api(),
    movieLocalSource: MovieLocalProviderImpl(),
  );

  MovieLibBloc() : super(VideoLibState()) {
    on<MovieLibGetNextPage>(_onGetMovie);
    on<RefreshVideoLibEvent>(_onRefreshMovieLib);
    on<MoviesReceivedEvent>(_onReceiveMovies);
    on<MovieLibSearch>(_onSearchMovie,
        transformer: _debounce(const Duration(milliseconds: 300)));
  }

  FutureOr<void> _onGetMovie(event, emit) async {
    //disable pagination when searching
    if (searchQuery.isNotEmpty) return;
    _movieRepo.getMovies(nextPage).listen((movies) {
      var mergedMovies = {
        ...state.movies,
        ...movies.map((e) => MovieModel.fromMovie(e))
      }.toList();
      add(MoviesReceivedEvent(movies: mergedMovies));
    });
    nextPage++;
  }

  FutureOr<void> _onRefreshMovieLib(event, emit) async {
    searchQuery = '';
    nextPage = 1;
    _movieRepo.getMovies(nextPage).listen((movies) {
      add(MoviesReceivedEvent(
          movies: movies.map((e) => MovieModel.fromMovie(e)).toList()));
    });
    nextPage++;
  }

  FutureOr<void> _onReceiveMovies(MoviesReceivedEvent event, emit) {
    emit(state.copyWith(movies: event.movies));
  }

  FutureOr<void> _onSearchMovie(MovieLibSearch event, emit) async {
    if (event.query.isNotEmpty && event.query.length < 2) return;
    nextPage = 1;
    if (_previousSearchCompleter != null &&
        !_previousSearchCompleter!.isCompleted) {
      _previousSearchCompleter!.completeError('Cancelled');
    }

    _previousSearchCompleter = Completer();
    try {
      final movies = await (event.query.isEmpty
          ? _movieRepo.getMovies(nextPage).first
          : _movieRepo.searchMovies(event.query));
      nextPage++;
      if (!_previousSearchCompleter!.isCompleted) {
        searchQuery = event.query;
        emit(state.copyWith(
            movies:
                (movies ?? []).map((e) => MovieModel.fromMovie(e)).toList()));
        _previousSearchCompleter!.complete();
      }
    } catch (e) {
      if (!_previousSearchCompleter!.isCompleted) {
        _previousSearchCompleter!.completeError(e);
      }
    }
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }
}
