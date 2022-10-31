import 'package:flutter/material.dart';



import '../viewModel/event_view_model.dart';

class EventList extends StatelessWidget {
  final List<EventViewModel> events;
  EventList({required this.events});


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: this.events.length,
      itemBuilder: (context, index) {
        final event = this.events[index];
        return ListTile(
          contentPadding: EdgeInsets.all(10),
          leading: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6)
            ),
            width: 50,
            height: 100,
          ),
          title: Text(event.title),
        );
      },
    );
  }
}