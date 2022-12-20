
import 'package:flutter/material.dart';

import 'package:rxdart/subjects.dart';

import '../model/app_routes.dart';
import '../model/view_model.abs.dart';
import '../model/user.dart';

import '../services/webservice.dart';


class GroupPageState {
  final String groupName;
  final String email;
  final userGroupNames;
  final Group;


  GroupPageState({
    this.groupName = '',
    this.email = '',
    this.userGroupNames = List<String>,
    this.Group = Object,

  });

  GroupPageState copyWith({
    String? groupName,
    List<String>? userGroupNames,
    String? email,
    Object? Group,
  }) {
    return GroupPageState(
      groupName: groupName ?? this.groupName,
      email: email ?? this.email,
      userGroupNames: userGroupNames ?? this.userGroupNames,
      Group: Group ?? this.Group,

    );
  }
}

class GroupPageViewModel extends ViewModel {
  final _stateSubject =
  BehaviorSubject<GroupPageState>.seeded(GroupPageState());
  Stream<GroupPageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  GroupPageViewModel({required List<String> userGroupNames}) {
    _stateSubject.add(GroupPageState(userGroupNames: userGroupNames));
  }

  List <User> userGroupNames = <User>[];
  int count = 0;

  Future<void> getUserGroups(context,) async {

    final userGroups = await Webservice().getUserGroups(_stateSubject.value.email);
    List <String> groupNames = <String>[];
    if (userGroups.length > 0 && count==0) {
      for (var i = 0; i<userGroups["UsersGroups"].length; i++) {

        groupNames.add(userGroups["UsersGroups"][i]["groupName"]);
      }

      updateState(groupNames);


    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      throw Exception('Failed to create album.');
    }

  }

  Future<void> displayDialogGroup(context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // groupName must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_stateSubject.value.email),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('${_stateSubject.value.email} Sukunimi'),
                Row(
                  children: <Widget>[
                    Icon(Icons.map),
                    Text('Location'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.calendar_month ),
                    Text('time'),
                  ],
                ),
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

  void createGroup() {
    _routesSubject.add(
      AppRouteSpec(
        name: '/createGroup',
        arguments: {
          'email': _stateSubject.value.groupName,
        },
      ),

    );

  }

  void updateState(List<String> groupNames) {
    final state = _stateSubject.value;
    _stateSubject.add(
      state.copyWith(
        userGroupNames: groupNames,
      ),
    );
  }


  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}