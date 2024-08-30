import 'dart:io';
import 'package:wireless_debugging_devices_manager/services/condor_snackbar_service.dart';

/// Service to execute adb commands.
/// 
/// It executes adb commands and shows a SnackBar with the result of the command execution using the [CondorSnackBarService] by passing a message and a success status.
/// It also prints the command details to the console.
class CondorAdbCommands {
  static const String executable = 'adb';

  /// Prints command details to the console.
  static void printCommandDetails(List commandArguments, ProcessResult result) {
    // ignore: avoid_print
    print('''
Command: '$executable ${commandArguments.join(' ')}'.
Standard output: '${result.stdout.toString().trim()}'.
Error output: '${result.stderr.toString().trim()}'.
Exit code: '${result.exitCode}'.
''');
  }

  /// Method to kill the adb server.
  /// 
  /// It shows a snackbar with the result of the command execution.
  Future<void> killServer() async {
    const List<String> arguments = ['kill-server'];

    var result = await Process.run(executable, arguments);

    printCommandDetails(arguments, result);

    switch (result.exitCode) {
      case 0:
        condorSnackBar.show(
          message: 'ADB server killed successfully',
          isSuccess: true,
        );
      case 1:
        // This error should never occur because of the nature of the 'adb kill-server' command
        condorSnackBar.show(
          message: 'Cannot kill ADB server',
          isSuccess: false,
        );
      default:
        // This error should never occur because of the nature of the 'adb kill-server' command
        condorSnackBar.show(
          message: 'Unknown error while killing ADB server',
          isSuccess: false,
        );
    }
  }
}

/// Global instance for easy access.
final condorAdbCommands = CondorAdbCommands();