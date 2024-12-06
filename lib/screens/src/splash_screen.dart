import 'package:flutter/material.dart';
import 'package:flutter_attendance/screens/src/login_screen.dart';
import 'package:flutter_attendance/screens/src/student_home_screen.dart';
import 'package:flutter_attendance/services/database_service.dart';
import 'package:flutter_attendance/services/shared_preferences_service.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_viewer2/sqlite_viewer.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/";
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((value) async {
      await context.read<DatabaseService>().initialise();
      if (!mounted) return;
      final email = context.read<SharedPreferencesService>().getEmail();
      if (email.isNotEmpty) {
        Navigator.pushReplacementNamed(context, StudentHomeScreen.routeName);
        return;
      }
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () {
                  const email = "email";
                  context.read<DatabaseService>().addStudent(
                      name: "name", email: email, password: "password");
                },
                child: const Text("Add Student")),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const DatabaseList()));
                },
                child: const Text("View Database Listing")),
          ],
        ),
      ),
    );
  }
}
