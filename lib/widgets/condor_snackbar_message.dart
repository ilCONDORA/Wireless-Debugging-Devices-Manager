import 'package:flutter/material.dart';

class CondorSnackBarMessage {
  static void show(
      {required BuildContext context,
      required String message,
      required bool isSuccess}) {
    /// Close any open snackbar
    ScaffoldMessenger.of(context).clearSnackBars();

    /// Show snackbar with message and with color of success or error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: SelectableText(
          message,
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
