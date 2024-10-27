import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_ashkryab/blocs/movie_details_bloc/movie_details_bloc.dart';

class MovieDetailsPage extends StatelessWidget {
  final String movieId;
  final String? posterUrl;

  const MovieDetailsPage(
      {super.key, required this.movieId, required this.posterUrl});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MovieDetailsBloc, MovieDetailsState>(
      bloc: MovieDetailsBloc()..add(FetchMovieDetailsEvent(movieId)),
      builder: (context, state) {
        return Scaffold(
          appBar: buildAppBar(state),
          body: Stack(
            children: [
              SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: movieId,
                            child: CachedNetworkImage(
                              imageUrl: posterUrl??state.posterUrl,
                              height: MediaQuery.of(context).size.height / 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(state.overview),
                    ],
                  )),
              if (state.isLoading)
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        );
      },
    );
  }

  AppBar buildAppBar(MovieDetailsState state) {
    return AppBar(
      title: Row(
        children: state.isLoading
            ? []
            : [
                const Icon(Icons.star_half),
                Text(state.rating!.toStringAsPrecision(2)),
                const SizedBox(width: 16),
                Expanded(child: Text(state.title)),
              ],
      ),
    );
  }
}
