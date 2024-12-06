import 'package:flutter/material.dart';

class PasswordTextFormField extends StatelessWidget {
  final TextEditingController controller;
  const PasswordTextFormField({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: true,
      decoration: const InputDecoration(labelText: "Password"),
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) return "Required";
        if (value.length <= 8) return "Password length must be more than 8 ";
        return null;
      },
    );
  }
}
