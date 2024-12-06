import 'package:flutter/material.dart';

class DialogUtils {
  static Future<T?> showDismissDialog<T>({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    return showDialog<T>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              FilledButton(
                  onPressed: () {
                    Navigator.pop(_);
                  },
                  child: const Text("Dismiss"))
            ],
          );
        });
  }

  static Future<bool?> showConfirmationDialog<bool>({
    required BuildContext context,
    required String title,
    required String content,
  }) {
    return showDialog<bool>(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Navigator.pop(_, false);
                  },
                  child: const Text("Cancel")),
              FilledButton(
                  onPressed: () {
                    Navigator.pop(_, true);
                  },
                  child: const Text("Confirm"))
            ],
          );
        });
  }
}
