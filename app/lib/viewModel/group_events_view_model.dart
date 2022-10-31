
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/subjects.dart';

import '../mvvm/app_routes.dart';
import '../mvvm/view_model.abs.dart';
import 'package:app/mvvm/event_list.dart';


import 'package:app/viewModel/event_view_model.dart';

import 'event_list_view_model.dart';

class GroupPageState {
  final String group;


  GroupPageState({
    this.group = '',

  });

  GroupPageState copyWith({
    String? group,

  }) {
    return GroupPageState(
      group: group ?? this.group,

    );
  }
}

class GroupPageViewModel extends ViewModel {
  final _stateSubject =
  BehaviorSubject<GroupPageState>.seeded(GroupPageState());
  Stream<GroupPageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  GroupPageViewModel({required String group}) {
    _stateSubject.add(GroupPageState(group: group));
  }

  void showMemberMenu(context) async {
    final List<String> popList = ['ROHIT', 'REKHA', 'DHRUV'];
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(200, 150, 100, 100),
      items: List.generate(
        popList.length,
            (index) => PopupMenuItem(
          value: 1,
          child: Text(
            popList[index],
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
        ),
      ),
      elevation: 8.0,
    ).then((value) {
      if (value != null) print(value);
    });
  }

  Future<void> displayDialog(context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_stateSubject.value.group),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('${_stateSubject.value.group} Sukunimi'),
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
      ),
    );
    print('testi11 ');
  }

  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}