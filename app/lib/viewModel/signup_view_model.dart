import 'package:app/model/view_model.abs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:rxdart/rxdart.dart';

import '../model/app_routes.dart';

import '../model/user.dart';
import '../services/webservice.dart';


class SignupViewState {
  final String username;
  final String password;
  final String email;
  final int count;
  SignupViewState({this.username = 'jee', this.password = 'jee', this.count = 0, this.email = 'jee'});

  SignupViewState copyWith({
    String? username,
    String? password,
    String? email,
    int? count,

  }) {
    return SignupViewState(
      username: username ?? this.username,
      password: password ?? this.password,
      count: count ?? this.count,
      email: email ?? this.email
    );
  }


}


class SignupScreenViewModel extends ViewModel {
  final _stateSubject = BehaviorSubject<SignupViewState>.seeded(SignupViewState());
  Stream<SignupViewState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;



  Future<void> signup(context, String email, String nickname, String pwd) async {
    final userCreated = await Webservice().signUp(email, nickname, pwd);
    if(userCreated == 'STATUS_OK') {
      updateState(nickname, email);

      _routesSubject.add(
        AppRouteSpec(
          name: '/second',
          arguments: {
            'user': nickname,
            'email': email
          },
        ),
      );
    } else {
      displayDialog(context);
    }
  }

  Future<void> displayDialog(context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email already exists'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This email is already in use'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('close'),
              onPressed: () {
                Navigator.of(context).pop();

              },
            ),
          ],
        );
      },
    );
  }

  void secondPageButtonTapped(String username, String email) {
    updateState(username, email);
    _routesSubject.add(
      AppRouteSpec(
        name: '/second',
        arguments: {
          'user': _stateSubject.value.username,
        },
      ),
    );
  }

  void updateState(String newUsername, String email) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        username: newUsername,
      ),
    );
    _stateSubject.add(
        state.copyWith(
          email: email,
        ),
    );
  }

  @override
  void dispose() {
    _stateSubject.close();
  }
}