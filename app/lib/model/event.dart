import 'package:table_calendar/table_calendar.dart';
import 'dart:collection';

class Event {
  final String eventName;
  final String info;
  final String location;
  final String startDate;
  final String endDate;
  final String groupName;
  final int inParticipants;
  final int outParticipants;
  final int id;

  Event({required this.location,
    required this.endDate,
    required this.startDate,
    required this.groupName,
    required this.info,
    required this.id,
    required this.eventName,
    required this.inParticipants,
    required this.outParticipants
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
        eventName: json["EventName"],
        location: json["EventLocation"],
        endDate: json["EventEndDate"],
        startDate: json["EventStartDate"],
        info: json["EventInfo"],
        inParticipants: json["numberOfParticipants"],
        outParticipants: json["numberOfParticipantsOut"],
        groupName: json["groupName"],
        id: json["id"]

    );
  }
}

  final kEvents = LinkedHashMap<DateTime, List<Event>>(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(_kEventSource);

final _kEventSource = Map.fromIterable(List.generate(50, (index) => index),
    key: (item) => DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5),
    value: (item) => List.generate(
        item % 4 + 1, (index) => Event(location: '$item | ${index + 1}', endDate: '$item | ${index + 1}', startDate: '$item | ${index + 1}', groupName: '$item | ${index + 1}', info: '$item | ${index + 1}', id: 1, eventName: '$item | ${index + 1}', inParticipants: 0, outParticipants: 0)))
  ..addAll({
    kToday: [
      Event(location: 'testi', endDate: '', startDate: '', groupName: 'ryhma', info: 'JeeJeeJee', id: 1, eventName: 'TestiTapahtuma', inParticipants: 0, outParticipants: 0),
      Event(location: '', endDate: '', startDate: '', groupName: '', info: '', id: 1, eventName: '', inParticipants: 0, outParticipants: 0),
    ],
  });

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  /// Returns a list of [DateTime] objects from [first] to [last], inclusive.
  List<DateTime> daysInRange(DateTime first, DateTime last) {
    final dayCount = last.difference(first).inDays + 1;
    return List.generate(
      dayCount,
          (index) => DateTime.utc(first.year, first.month, first.day + index),
    );
  }

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);