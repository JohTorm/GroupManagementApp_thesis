import 'package:app/screens/group_events.dart';
import 'package:app/screens/group_screen.dart';
import 'package:app/screens/login_screen.dart';

import 'package:app/screens/second.dart';
import 'package:app/screens/signup_screen.dart';
import 'package:app/screens/create_group_screen.dart';
import 'package:app/viewModel/group_events_view_model.dart';
import 'package:app/viewModel/group_view_model.dart';

import 'package:app/viewModel/login_view_model.dart';
import 'package:app/viewModel/second_view_model.dart';
import 'package:app/viewModel/signup_view_model.dart';
import 'package:app/viewModel/create_group_view_model.dart';
import 'package:app/viewModel/group_events_view_model.dart';

import 'package:flutter/material.dart';
import 'package:app/model/event.dart';




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
        final email = arguments['email'] as String;

        print(user);
        if (user == null) {
          throw Exception('Route ${settings.name} requires a user');
        }

        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SecondPage(
            viewModel: SecondPageViewModel(user: user, email: email),
          ),
        );
      case '/signup':
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => SignupScreen(viewModel: SignupScreenViewModel()),
        );
      case '/createGroup':
        final email = arguments['email'] as String?;
        final user = arguments['user'] as String;

        print(email);
        if (email == null) {
          throw Exception('Route ${settings.name} requires a email');
        }


        return MaterialPageRoute(
          settings: settings,
          builder: (_) => CreateGroup(viewModel: CreateGroupViewModel(email: email, user: user)),
        );

      case '/userGroups':
        final userGroups = arguments['group'] as List<String>?;

        print(userGroups);
        if (userGroups == null) {
          throw Exception('Route ${settings.name} requires a groupnames');
        }


        return MaterialPageRoute(
          settings: settings,
          builder: (_) => GroupPage(viewModel: GroupPageViewModel(userGroupNames: userGroups)),
        );

      case '/groupEvents':
        final group = arguments['group'] as String?;

        if (group == null) {
          throw Exception('Route ${settings.name} requires a group');
        }
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => GroupEventPage(viewModel: GroupEventPageViewModel(group: group)),
        );


      default:
        throw Exception('Route ${settings.name} not implemented');
    }
  }
}