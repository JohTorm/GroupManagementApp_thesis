import 'package:app/model/event.dart';
class EventViewModel {
  final Event event;
  EventViewModel({required this.event});

  String get title {
    return event.eventName;
  }

  String get startDate {
    return event.startDate;
  }

  String get info {
    return event.info;
  }

  String get location {
    return event.location;
  }

  String get endDate {
    return event.endDate;
  }



}