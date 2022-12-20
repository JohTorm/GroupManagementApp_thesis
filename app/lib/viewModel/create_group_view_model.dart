import 'package:app/model/view_model.abs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rxdart/rxdart.dart';

import '../model/app_routes.dart';
import '../model/user.dart';
import '../model/group.dart';
import '../services/webservice.dart';


class CreateGroupViewState {
  final String group;
  final String password;
  final String email;
  final String user;
  CreateGroupViewState({this.user = 'jee', this.group = 'jee', this.password = 'jee', this.email = 'jee'});

  CreateGroupViewState copyWith({
    String? group,
    String? password,
    String? email,

  }) {
    return CreateGroupViewState(
      group: group ?? this.group,
      password: password ?? this.password,
      email: email ?? this.email,
    );
  }


}


class CreateGroupViewModel extends ViewModel {
  final _stateSubject = BehaviorSubject<CreateGroupViewState>.seeded(CreateGroupViewState());
  Stream<CreateGroupViewState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  CreateGroupViewModel({required String email, required String user}) {
    _stateSubject.add(CreateGroupViewState(email: email, user: user));
  }

  Future<void> createGroup(context,String groupName) async {


    final userCreated = await Webservice().createGroup(groupName,_stateSubject.value.email);

    if(userCreated["CreateGroupResponse"][0]["message"] == 'Group created!') {
      updateState(groupName);
      Group ryhma = Group.fromJson(userCreated["CreateGroupResponse"][0]);

      displayDialog2(context, userCreated["CreateGroupResponse"][0]["groupPassword"]);




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
                Text('The email or password you gave were invalid'),

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

  Future<void> displayDialog2(context, String pwd) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Group created'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You have successfully created a group! Press `close` to copy password to clipboard'),

              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('close'),
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: pwd));
                Navigator.of(context).pop();
                secondScreen();


              },
            ),
          ],
        );
      },
    );
  }

  void secondScreen() {
    _routesSubject.add(
      AppRouteSpec(
        name: '/second',
        arguments: {
          'user': _stateSubject.value.user,
          'email': _stateSubject.value.email,
        },
      ),
    );
  }



  void updateState(String newgroup) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        group: newgroup,
      ),
    );
  }

  @override
  void dispose() {
    _stateSubject.close();
  }
}