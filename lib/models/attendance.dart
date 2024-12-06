import 'package:flutter_attendance/enums/attendance_status.dart';

class Attendance {
  static String table = 'attendance';
  static String columnId = '_id';
  static String columnUserId = 'user_id';
  static String columnClassName = 'class_name';
  static String columnTimeIn = 'time_in';
  static String columnStatus = 'status';

  final int? id;
  final int userId;
  final String className;
  final DateTime timeIn;
  final AttendanceStatus status;

  Attendance({
    this.id,
    required this.userId,
    required this.className,
    required this.timeIn,
    required this.status,
  });

  Map<String, Object?> toMap() {
    Map<String, Object?> map = {
      columnUserId: userId,
      columnTimeIn: timeIn.toIso8601String(),
      columnClassName: className,
      columnStatus: status.name
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map[columnId],
      userId: map[columnUserId],
      className: map[columnClassName],
      timeIn: DateTime.parse(map[columnTimeIn]),
      status: AttendanceStatus.values.firstWhere(
        (e) => e.name == map[columnStatus],
      ),
    );
  }
}
