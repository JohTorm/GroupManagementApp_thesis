import 'package:app/mvvm/event.dart';
class EventViewModel {
  final Event event;
  EventViewModel({required this.event});

  String get title {
    return event.title;
  }

  DateTime get startDate {
    return event.startDate;
  }

  String get info {
    return event.info;
  }

  String get location {
    return event.location;
  }

  DateTime get endDate {
    return event.endDate;
  }

  DateTime get startHour {
    return event.startHour;
  }

  DateTime get endHour {
    return event.endHour;
  }

}