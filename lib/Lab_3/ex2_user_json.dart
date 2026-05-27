import 'dart:convert';

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      email: json['email'],
    );
  }

  @override
  String toString() => '$name - $email';
}

Future<List<User>> fetchUsers() async {
  await Future.delayed(Duration(seconds: 1));

  String jsonString = '''
  [
    {"name": "Duy", "email": "duy@gmail.com"},
    {"name": "An", "email": "an@gmail.com"}
  ]
  ''';

  List data = jsonDecode(jsonString);
  return data.map((e) => User.fromJson(e)).toList();
}

Future<void> runExercise2() async {
  var users = await fetchUsers();
  users.forEach(print);
}