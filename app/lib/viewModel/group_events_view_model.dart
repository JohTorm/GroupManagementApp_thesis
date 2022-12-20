
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../model/app_routes.dart';
import '../model/view_model.abs.dart';


class GroupEventPageState {
  final String group;


  GroupEventPageState({
    this.group = '',

  });

  GroupEventPageState copyWith({
    String? group,

  }) {
    return GroupEventPageState(
      group: group ?? this.group,

    );
  }
}

class GroupEventPageViewModel extends ViewModel {
  final _stateSubject =
  BehaviorSubject<GroupEventPageState>.seeded(GroupEventPageState());
  Stream<GroupEventPageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  GroupEventPageViewModel({required String group}) {
    _stateSubject.add(GroupEventPageState(group: group));
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

  }

  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}