import 'package:app/model/view_model.abs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

import '../model/app_routes.dart';
import '../services/webservice.dart';


class LoginViewState {
  final String username;
  final String password;
  final int count;
  LoginViewState({this.username = 'jee', this.password = 'jee', this.count = 0});

  LoginViewState copyWith({
    String? username,
    String? password,
    int? count,

  }) {
    return LoginViewState(
      username: username ?? this.username,
      password: password ?? this.password,
      count: count ?? this.count,
    );
  }


}


class LoginScreenViewModel extends ViewModel {
  final _stateSubject = BehaviorSubject<LoginViewState>.seeded(LoginViewState());
  Stream<LoginViewState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  Future<void> login(context, String email, String pwd) async {
    final userCreated = await Webservice().login(email, pwd);

    if(userCreated['message'] == 'LOGIN_OK') {
      updateState(userCreated['nickname']);


      _routesSubject.add(
        AppRouteSpec(
          name: '/second',
          arguments: {
            'user': _stateSubject.value.username,
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
          title: Text('Invalid login information'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

                Text('The email or password you gave was invalid')


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

  void signup() {
    _routesSubject.add(
      AppRouteSpec(
        name: '/signup',
      ),
    );

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