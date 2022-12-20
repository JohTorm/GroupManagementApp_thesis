class User {
  final String email;
  final String username;
  final String password;

  User({required this.email, required this.username, required this.password});

  factory User.fromJson(Map <String, dynamic> json) {
    return User(
      email: json['email'],
      username: json['username'],
      password: json['password'],

    );
  }

}