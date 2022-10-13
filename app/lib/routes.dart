import 'package:app/screens/login_screen.dart';
import 'package:app/screens/movie_screen.dart';
import 'package:app/screens/second.dart';
import 'package:app/viewModel/movies_list_view_model.dart';
import 'package:app/viewModel/login_view_model.dart';
import 'package:app/viewModel/second_view_model.dart';

import 'package:flutter/material.dart';




class AppRouter {
  Route<dynamic>? route(RouteSettings settings) {
    final arguments = settings.arguments as Map<String, dynamic>? ?? {};

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => LoginScreen(viewModel: LoginScreenViewModel()),
        );
      case '/second':
        final user = arguments['user'] as String?;
        print(user);
        if (user == null) {
          throw Exception('Route ${settings.name} requires a user');
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SecondPage(
            viewModel: SecondPageViewModel(user: user),
          ),
        );


      default:
        throw Exception('Route ${settings.name} not implemented');
    }
  }
}