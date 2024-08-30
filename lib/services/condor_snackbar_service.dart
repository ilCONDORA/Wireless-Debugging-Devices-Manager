import 'package:flutter/material.dart';

/// Service to show a SnackBar with a message and a different background color depending on the result [isSuccess].
class CondorSnackBarService {
  static final CondorSnackBarService _instance =
      CondorSnackBarService._internal();
  factory CondorSnackBarService() => _instance;
  CondorSnackBarService._internal();

  late BuildContext _context;

  /// Initialize the service by getting the context so that it's passed to the [show] method.
  void init(BuildContext context) {
    _context = context;
  }

  void show({required String message, required bool isSuccess}) {
    if (!_context.mounted) return;

    /// Close any open snackbar.
    ScaffoldMessenger.of(_context).clearSnackBars();

    /// Show snackbar with message and with color of success or error.
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: SelectableText(
          message,
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(_context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

/// Global instance for easy access.
final condorSnackBar = CondorSnackBarService();
