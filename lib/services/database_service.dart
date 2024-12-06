import 'dart:developer';

import 'package:flutter_attendance/models/user.dart';
import 'package:flutter_attendance/utils/database_utils.dart';
import 'package:flutter_attendance/models/attendance.dart';
import 'package:flutter_attendance/enums/attendance_status.dart';
import 'package:flutter_attendance/enums/user_role.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  late Database database;

  Future<void> initialise() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'attendance.db');
    database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        // When creating the db, create the table
        Batch batch = db.batch();
        batch.execute(DatabaseUtils.getCreateUsersTableQuery());
        batch.execute(DatabaseUtils.getCreateAttendanceTableQuery());
        await batch.commit();
        // addDummyAdmin(db);
      },
    );
  }

  Future<int> insert(String table, Map<String, Object?> values) async {
    return await database.insert(table, values);
  }

  Future<void> addStudent({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = User(
        name: name, email: email, password: password, role: UserRole.student);
    await insert(User.table, user.toMap());
  }

  Future<User> getUserByEmail(String email) async {
    final list =
        await database.rawQuery(DatabaseUtils.getUserByEmailQuery(email));
    return User.fromMap(list[0]);
  }

  Future<User> checkCrendential(String email, String password) async {
    try {
      final list = await database
          .rawQuery(DatabaseUtils.getCheckCredentialQuery(email, password));
      return User.fromMap(list[0]);
    } catch (err) {
      throw Exception("Invalid Email or Password");
    }
  }

  Future<List<User>> getAllStudents() async {
    try {
      final list = await database.rawQuery(DatabaseUtils.getAllStudentsQuery());
      log("getAllStudents list $list");
      return list.map((e) => User.fromMap(e)).toList();
    } catch (err) {
      return [];
    }
  }

  Future<void> addDummyAdmin(Database db) async {
    final user = User(
        name: "Admin",
        email: "admin@agmo.com",
        password: "admin",
        role: UserRole.admin);
    db.insert(User.table, user.toMap());
  }

  Future<void> addAttendance(
    int userId,
    String className,
    AttendanceStatus status,
  ) async {
    final attendance = Attendance(
      userId: userId,
      className: className,
      timeIn: DateTime.now(),
      status: status,
    );
    await insert(Attendance.table, attendance.toMap());
  }

  Future<List<Attendance>> getAttendanceList(
    int userId,
  ) async {
    final list =
        await database.rawQuery(DatabaseUtils.getAttendanceListQuery(userId));
    return list.map((e) => Attendance.fromMap(e)).toList();
  }
}
