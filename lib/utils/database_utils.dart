import 'package:flutter_attendance/models/attendance.dart';
import 'package:flutter_attendance/models/user.dart';

class DatabaseUtils {
  static String getCreateUsersTableQuery() {
    return "CREATE TABLE IF NOT EXISTS ${User.table} "
        "("
        "${User.columnId} INTEGER PRIMARY KEY AUTOINCREMENT, "
        "${User.columnName} TEXT NOT NULL, "
        "${User.columnEmail} TEXT NOT NULL UNIQUE, "
        "${User.columnPassword} TEXT NOT NULL, "
        "${User.columnRole} TEXT NOT NULL"
        ")";
  }

  static String getUserByEmailQuery(String value) {
    return "select * "
        "from ${User.table} "
        "where ${User.columnEmail} = '$value'";
  }

  static String getAllStudentsQuery() {
    return "select * "
        "from ${User.table} "
        "where ${User.columnRole} = 'student'";
  }

  static String getCheckCredentialQuery(String email, String password) {
    return "select * "
        "from ${User.table} "
        "where ${User.columnEmail} = '$email' "
        "and ${User.columnPassword} = '$password'";
  }

  static String getCreateAttendanceTableQuery() {
    return "CREATE TABLE IF NOT EXISTS ${Attendance.table} "
        "("
        "${Attendance.columnId} INTEGER PRIMARY KEY AUTOINCREMENT, "
        "${Attendance.columnUserId} INTEGER NOT NULL, "
        "${Attendance.columnClassName} TEXT NOT NULL, "
        "${Attendance.columnTimeIn} TEXT NOT NULL, "
        "${Attendance.columnStatus} TEXT NOT NULL"
        ")";
  }

  static String getAttendanceListQuery(int userId) {
    return "select * "
        "from ${Attendance.table} "
        "where ${Attendance.columnUserId} = $userId "
        "order by ${Attendance.columnId} desc ";
  }
}
