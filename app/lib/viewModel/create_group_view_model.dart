import 'package:app/mvvm/view_model.abs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

import '../mvvm/app_routes.dart';


class CreateGroupViewState {
  final String group;
  final String password;
  final int count;
  CreateGroupViewState({this.group = 'jee', this.password = 'jee', this.count = 0});

  CreateGroupViewState copyWith({
    String? group,
    String? password,
    int? count,

  }) {
    return CreateGroupViewState(
      group: group ?? this.group,
      password: password ?? this.password,
      count: count ?? this.count,
    );
  }


}


class CreateGroupViewModel extends ViewModel {
  final _stateSubject = BehaviorSubject<CreateGroupViewState>.seeded(CreateGroupViewState());
  Stream<CreateGroupViewState> get state => _stateSubject;

  final _routesSubject = PublishSubject<AppRouteSpec>();
  Stream<AppRouteSpec> get routes => _routesSubject;

  void login(String username, String password) {
    _routesSubject.add(
      AppRouteSpec(
        name: '/second',
        arguments: {

        },
      ),
    );
  }

  void createGroup(String group) {
    updateState(group);
    _routesSubject.add(
      AppRouteSpec(
        name: '/groupEvents',
        arguments: {
          'group': _stateSubject.value.group,
        },
      ),
    );
    print('testi ' + _stateSubject.value.group);
  }

  void secondPageButtonTapped(String username) {
    updateState(username);
    _routesSubject.add(
      AppRouteSpec(
        name: '/second',
        arguments: {
          'user': _stateSubject.value.group,
        },
      ),
    );
    print('testi ' + _stateSubject.value.group);
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