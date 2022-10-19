import 'package:app/mvvm/view_model.abs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

import '../mvvm/app_routes.dart';


class SignupViewState {
  final String username;
  final String password;
  final int count;
  SignupViewState({this.username = 'jee', this.password = 'jee', this.count = 0});

  SignupViewState copyWith({
    String? username,
    String? password,
    int? count,

  }) {
    return SignupViewState(
      username: username ?? this.username,
      password: password ?? this.password,
      count: count ?? this.count,
    );
  }


}


class SignupScreenViewModel extends ViewModel {
  final _stateSubject = BehaviorSubject<SignupViewState>.seeded(SignupViewState());
  Stream<SignupViewState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  void signup() {
    _routesSubject.add(
      AppRouteSpec(
        name: '/',
      ),
    );
  }

  void secondPageButtonTapped(String username) {
    updateState(username);
    _routesSubject.add(
      AppRouteSpec(
        name: '/second',
        arguments: {
          'user': _stateSubject.value.username,
        },
      ),
    );
    print('testi ' + _stateSubject.value.username);
  }

  void updateState(String newUsername) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        username: newUsername,
      ),
    );
  }

  @override
  void dispose() {
    _stateSubject.close();
  }
}