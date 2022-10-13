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



  @override
  void dispose() {
    _stateSubject.close();
    _routesSubject.close();
  }
}