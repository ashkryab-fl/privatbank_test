import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_ashkryab/blocs/movie_lib_bloc/movie_lib_bloc.dart';
import 'package:test_ashkryab/core/routing/router.dart';
import 'package:test_ashkryab/core/sources/sql/sql_data_source.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieLibBloc(),
      child: FutureBuilder<bool>(
          future: SqlDataSource().init(),
          initialData: false,
          builder: (context, snapshot) {
            return snapshot.hasData && snapshot.data == true
                ? MaterialApp.router(

              routerConfig: AppRouter.router,
            )
                : Container(color: Colors.white);
          }),
    );
  }
}
