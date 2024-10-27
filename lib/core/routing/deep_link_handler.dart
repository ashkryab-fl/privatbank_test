import 'package:go_router/go_router.dart';

Future<void> deepLinkHandler(context, Uri uri) async {
  // Extract the movie ID from the path
  final String movieId = uri.pathSegments.last;

  // Use GoRouter to navigate to the movie details screen
  GoRouter.of(context).push('/movie/$movieId');
}