import 'package:flutter/material.dart';
import 'package:flutter_attendance/enums/attendance_status.dart';
import 'package:flutter_attendance/models/attendance.dart';
import 'package:flutter_attendance/models/user.dart';
import 'package:flutter_attendance/screens/src/clinics_screen.dart';
import 'package:flutter_attendance/screens/src/splash_screen.dart';
import 'package:flutter_attendance/services/database_service.dart';
import 'package:flutter_attendance/services/shared_preferences_service.dart';
import 'package:flutter_attendance/utils/data_time_utils.dart';
import 'package:flutter_attendance/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

class StudentHomeScreen extends StatefulWidget {
  static const String routeName = "/student-home-screen";
  const StudentHomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _StudentHomeScreen();
}

class _StudentHomeScreen extends State<StudentHomeScreen> {
  User? user;
  List<Attendance> attendanceList = [];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((value) async {
      await getUser();
      await getAttendanceList();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            onPressed: () async {
              await addAttendance();
              await getAttendanceList();
            },
            icon: const Icon(Icons.qr_code),
          ),
          IconButton(onPressed: logout, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                const Text("Welcome back!"),
                Text(
                  user?.name ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pushNamed(context, ClinicsScreen.routeName);
            },
            title: const Text("Clinic Nearby"),
            trailing: const Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }

  Widget buildBody() {
    if (user == null) {
      return Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Something went wrong, try relogin",
          ),
          FilledButton(onPressed: logout, child: const Text("Logout"))
        ],
      ));
    }

    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Welcome back ${user?.name}"),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await getAttendanceList();
              },
              child: ListView.builder(
                itemCount: attendanceList.length,
                itemBuilder: (_, index) {
                  final attendance = attendanceList[index];
                  return ListTile(
                    title: Text(
                        "${attendance.className} : ${DateTimeUtils.formatDate(attendance.timeIn)}"),
                    subtitle: Text(
                      attendance.status.name,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getUser() async {
    try {
      final email = context.read<SharedPreferencesService>().getEmail();
      user = await context.read<DatabaseService>().getUserByEmail(email);
      setState(() {});
    } catch (err) {
      if (!mounted) return;
      DialogUtils.showDismissDialog(
        context: context,
        title: "Error",
        content: err.toString(),
      );
    }
  }

  Future<void> getAttendanceList() async {
    try {
      attendanceList =
          await context.read<DatabaseService>().getAttendanceList(user!.id!);
      setState(() {});
    } catch (err) {
      if (!mounted) return;
      DialogUtils.showDismissDialog(
          context: context, title: "Error", content: err.toString());
    }
  }

  Future<void> addAttendance() async {
    try {
      await context
          .read<DatabaseService>()
          .addAttendance(user!.id!, "MATH", AttendanceStatus.present);
    } catch (err) {
      if (!mounted) return;
      DialogUtils.showDismissDialog(
          context: context, title: "Error", content: err.toString());
    }
  }

  Future<void> logout() async {
    bool? ok = await DialogUtils.showConfirmationDialog(
        context: context, title: "Logout", content: "Are you sure to logout?");
    if (ok == null) return;
    if (!ok) return;
    if (!mounted) return;
    await context.read<SharedPreferencesService>().clear();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, SplashScreen.routeName);
  }
}
