import 'package:flutter/material.dart';
import 'package:flutter_attendance/services/database_service.dart';
import 'package:flutter_attendance/utils/dialog_utils.dart';
import 'package:flutter_attendance/widgets/email_text_form_field.dart';
import 'package:flutter_attendance/widgets/password_text_form_field.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "/register-screen";
  const RegisterScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  TextEditingController nameTEC = TextEditingController();
  TextEditingController emailTEC = TextEditingController();
  TextEditingController passwordTEC = TextEditingController();
  TextEditingController confirmPasswordTEC = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
      ),
      body: Form(
        key: formKey,
        child: Center(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 60),
            shrinkWrap: true,
            children: [
              _NameTextFormField(controller: nameTEC),
              EmailTextFormField(controller: emailTEC),
              PasswordTextFormField(controller: passwordTEC),
              _ConfirmPasswordTextFormField(
                controller: confirmPasswordTEC,
                passwordController: passwordTEC,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: register, child: const Text("Register"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    try {
      await context.read<DatabaseService>().addStudent(
          name: nameTEC.text, email: emailTEC.text, password: passwordTEC.text);
      clearForm();
      if (!mounted) return;
      DialogUtils.showDismissDialog(
        context: context,
        title: "Success",
        content: "Register Successfully",
      );
    } catch (err) {
      if (!mounted) return;
      DialogUtils.showDismissDialog(
        context: context,
        title: "Error",
        content: err.toString(),
      );
    }
  }

  void clearForm() {
    nameTEC.clear();
    emailTEC.clear();
    passwordTEC.clear();
    confirmPasswordTEC.clear();
    formKey.currentState?.reset();
  }
}

class _NameTextFormField extends StatelessWidget {
  final TextEditingController controller;
  const _NameTextFormField({
    required this.controller,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Name"),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) return "Required";
        return null;
      },
    );
  }
}

class _ConfirmPasswordTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextEditingController passwordController;
  const _ConfirmPasswordTextFormField({
    required this.controller,
    required this.passwordController,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(labelText: "Confirm Password"),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) return "Required";
        if (value != passwordController.text) return "Wrong Password";
        return null;
      },
    );
  }
}
