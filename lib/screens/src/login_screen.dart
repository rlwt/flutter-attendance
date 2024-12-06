// ignore_for_file: unused_local_variable, avoid_print, unused_element
import 'package:flutter/material.dart';
import 'package:flutter_attendance/screens/src/register_screen.dart';
import 'package:flutter_attendance/screens/src/student_home_screen.dart';
import 'package:flutter_attendance/services/database_service.dart';
import 'package:flutter_attendance/services/shared_preferences_service.dart';
// import 'package:flutter_attendance/screens/admin_dashboard_screen.dart';
// import 'package:flutter_attendance/screens/student_home_screen.dart';
// import 'package:flutter_attendance/screens/register_screen.dart';
import 'package:flutter_attendance/utils/dialog_utils.dart';
import 'package:flutter_attendance/widgets/email_text_form_field.dart';
import 'package:flutter_attendance/widgets/password_text_form_field.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_viewer2/sqlite_viewer.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login-screen";
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool loading = false;
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return DatabaseList();
        }));
      }),
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            shrinkWrap: true,
            children: [
              EmailTextFormField(controller: emailTEC),
              PasswordTextFormField(controller: passwordTEC),
              const SizedBox(height: 20),
              FilledButton(onPressed: login, child: const Text("Login")),
              const Text(
                "or",
                textAlign: TextAlign.center,
              ),
              ElevatedButton(onPressed: register, child: const Text("Register"))
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    Navigator.pushNamed(context, RegisterScreen.routeName);
  }

  void setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  Widget buildLoginButton() {
    if (loading) return const Center(child: CircularProgressIndicator());
    return FilledButton(onPressed: login, child: const Text("Login"));
  }

  Future<void> login() async {
    if (!formKey.currentState!.validate()) return;
    try {
      final user = await context
          .read<DatabaseService>()
          .checkCrendential(emailTEC.text, passwordTEC.text);
      if (!mounted) return;
      context.read<SharedPreferencesService>().setEmail(emailTEC.text);
      Navigator.pushReplacementNamed(context, StudentHomeScreen.routeName);
    } catch (err) {
      if (!mounted) return;
      DialogUtils.showDismissDialog(
        context: context,
        title: "Error",
        content: err.toString(),
      );
    }
  }
}
