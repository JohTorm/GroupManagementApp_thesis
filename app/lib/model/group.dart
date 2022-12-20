class Group {
  final int id;
  final String name;
  final String password;


  Group({
    required this.name,
    required this.id,
    required this.password,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json["idGroup"],
      name: json["groupName"],
      password: json["groupPassword"]
    );
  }
}