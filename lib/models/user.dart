import 'package:flutter_attendance/enums/user_role.dart';

class User {
  static String table = 'users';
  static String columnId = '_id';
  static String columnName = 'name';
  static String columnEmail = 'email';
  static String columnPassword = 'password';
  static String columnRole = 'role';

  final int? id;
  final String name;
  final String email;
  final String password;
  final UserRole role;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.role,
  });

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      columnName: name,
      columnEmail: email,
      columnPassword: password,
      columnRole: role.name
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map[columnId],
      name: map[columnName],
      email: map[columnEmail],
      password: map[columnPassword],
      role: UserRole.values.firstWhere(
        (e) => e.name == map[columnRole],
      ),
    );
  }
}
