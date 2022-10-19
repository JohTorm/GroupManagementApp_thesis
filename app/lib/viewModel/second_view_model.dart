
import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';

import '../mvvm/app_routes.dart';
import '../mvvm/view_model.abs.dart';

class SecondPageState {
  final String user;

  SecondPageState({
    this.user = '',
  });

  SecondPageState copyWith({
    String? user,
  }) {
    return SecondPageState(
      user: user ?? this.user,
    );
  }
}

class SecondPageViewModel extends ViewModel {
  final _stateSubject =
  BehaviorSubject<SecondPageState>.seeded(SecondPageState());
  Stream<SecondPageState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  SecondPageViewModel({required String user}) {
    _stateSubject.add(SecondPageState(user: user));
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
          title: Text(_stateSubject.value.user),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('This is a demo alert dialog.'),
                Text('${_stateSubject.value.user} Sukunimi'),
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

  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}