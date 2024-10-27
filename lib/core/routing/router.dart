import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_ashkryab/ui/movie_details_page/movie_details_page.dart';
import 'package:test_ashkryab/ui/movie_lib_page/movie_lib_page.dart';

abstract class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const MovieLibPage();
        },
        routes: [
          GoRoute(
            path: '/movie/:id',
            builder: (BuildContext context, GoRouterState state) {
              var id = state.pathParameters['id'];
              if (id == null) {
                //todo 404 page
                return const SizedBox();
              }

              return MovieDetailsPage(
                movieId: id,
                posterUrl: state.uri.queryParameters['posterUrl'],
              );
            },
          ),
        ],
      ),
    ],
  );
}
