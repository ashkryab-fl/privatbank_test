import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_ashkryab/blocs/movie_lib_bloc/movie_lib_bloc.dart';
import 'package:test_ashkryab/blocs/movie_lib_bloc/movie_lib_event.dart';
import 'package:test_ashkryab/blocs/movie_lib_bloc/movie_lib_state.dart';

class MovieLibPage extends StatefulWidget {
  const MovieLibPage({super.key});

  @override
  State<MovieLibPage> createState() => _MovieLibPageState();
}

class _MovieLibPageState extends State<MovieLibPage> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _searchController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieLibBloc>().add(MovieLibGetNextPage());
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<MovieLibBloc>().add(MovieLibGetNextPage());
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: BlocBuilder<MovieLibBloc, VideoLibState>(
        builder: (context, state) {
          return _searchController.text.isEmpty && state.movies.isEmpty
              ? const Center(child: Text('No movies found'))
              : GridView.count(
                  controller: _scrollController,
                  crossAxisCount: 2,
                  padding: const EdgeInsets.only(
                      left: 24, right: 24, bottom: 24, top: 16),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 2 / 4.3,
                  children: List.generate(
                    state.movies.length,
                    (index) {
                      final movie = state.movies[index];
                      return _buildItem(movie, context);
                    },
                  ),
                );
        },
      ),
    );
  }

  Widget _buildItem(MovieModel movie, BuildContext context) {
    return GestureDetector(
      onTap: () {
        //posterUrl for hero animation
        context.go('/movie/${movie.id}?posterUrl=${movie.posterUrl}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(8)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Hero(
              tag: movie.id,
              child: CachedNetworkImage(
                imageUrl: movie.posterUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.overview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Movie Library'),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24, bottom: 8),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search...',
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.all(12.0),
            ),
            onChanged: (query) {
              context.read<MovieLibBloc>().add(MovieLibSearch(query: query));
              // Handle search query change
            },
          ),
        ),
      ),
    );
  }
}
