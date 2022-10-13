import 'package:app/routes.dart';
import 'package:flutter/material.dart';
import 'package:app/screens/movie_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/viewModel/movies_list_view_model.dart';
import 'package:provider/provider.dart';

import 'mvvm/view.abs.dart';
void main() => runApp(App());
class App extends StatelessWidget {
  final _router = AppRouter();

  App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Movies MVVM Example",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
      navigatorObservers: [routeObserver],
      initialRoute: '/',
      onGenerateRoute: _router.route,
    );


  }
}
