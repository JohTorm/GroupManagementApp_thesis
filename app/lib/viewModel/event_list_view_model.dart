import 'package:flutter/material.dart';
import 'package:app/services/webservice.dart';
import 'package:app/viewModel/event_view_model.dart';

class EventListViewModel extends ChangeNotifier {

  List<EventViewModel> events = <EventViewModel>[];

  Future<void> fetchMovies(String keyword) async {
    final results =  await Webservice().fetchMovies(keyword);
    this.events = results.map((item) => EventViewModel(event: item)).toList();

    notifyListeners();
  }

}