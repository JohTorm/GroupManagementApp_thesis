class Event {
  final String title;
  final String info;
  final String location;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime startHour;
  final DateTime endHour;

  Event({required this.location,
    required this.endDate,
    required this.startDate,
    required this.endHour,
    required this.info,
    required this.startHour,
    required this.title});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json["Title"],
      location: json["location"],
      endDate: json["endDate"],
      startDate: json["StartDate"],
      endHour: json["endHour"],
      info: json["info"],
      startHour: json["StartHour"],
    );
  }
}