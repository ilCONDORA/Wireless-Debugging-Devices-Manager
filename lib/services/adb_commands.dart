import 'dart:io';
import 'package:wireless_debugging_devices_manager/services/condor_snackbar_service.dart';

/// Service to execute adb commands.
///
/// It executes adb commands and shows a SnackBar with the result of the command execution using the [CondorSnackBarService] by passing a message and a success status.
/// It also prints the command details to the console.
class CondorAdbCommands {
  static const String executable = 'adb';

  /// Prints command details to the console.
  static void printCommandDetails(
          {required List commandArguments, required ProcessResult result}) =>
      print('''
-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-
Command: '$executable ${commandArguments.join(' ')}'.
Standard output: '${result.stdout.toString().trim()}'.
Error output: '${result.stderr.toString().trim()}'.
Exit code: '${result.exitCode}'.
-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-!-
''');

  /// Method to kill the adb server.
  ///
  /// It shows a snackbar with the result of the command execution.
  Future<void> killServer() async {
    const List<String> arguments = ['kill-server'];

    var result = await Process.run(executable, arguments);

    printCommandDetails(commandArguments: arguments, result: result);

    switch (result.exitCode) {
      case 0:
        condorSnackBar.show(
          message: 'ADB server killed successfully.',
          isSuccess: true,
        );
      case 1:
        // This error should never occur because of the nature of the 'adb kill-server' command.
        condorSnackBar.show(
          message: 'Cannot kill ADB server.',
          isSuccess: false,
        );
      default:
        // This error should never occur because of the nature of the 'adb kill-server' command.
        condorSnackBar.show(
          message: 'Unknown error while killing ADB server.',
          isSuccess: false,
        );
    }
  }

  /// Method to retrieve the IP address of a connected device based on its serial number.
  /// 
  /// It shows a snackbar with the result of the command execution.
  Future<String?> getDeviceIPAddress({required String serialNumber}) async {
    final List<String> arguments = [
      '-s',
      serialNumber,
      'shell',
      "ip addr show wlan0 | awk '/inet / {print \$2}' | cut -d/ -f1"
    ];

    var result = await Process.run(executable, arguments);

    printCommandDetails(commandArguments: arguments, result: result);

    switch (result.exitCode) {
      case 0:
        final String deviceIPAddress = result.stdout.toString().trim();
        condorSnackBar.show(
          message:
              'Successfully retrieved device IP address of $serialNumber, here it is -> $deviceIPAddress.',
          isSuccess: true,
        );
        return deviceIPAddress;
      case 1:
        condorSnackBar.show(
          message:
              'Cannot retrieve device IP address of $serialNumber. Check if the device is connected or the serial number is correct and retry from the start.',
          isSuccess: false,
        );
        return null;
      default:
        condorSnackBar.show(
          message: 'Unknown error while getting device IP address.',
          isSuccess: false,
        );
        return null;
    }
  }

  /// Method to display screen of a connected device based on its IP address.
  /// I don't think I will use it but it's here just in case.
  /// Powered by scrcpy.
  Future<void> displayScreen({required String deviceIPAddress}) async {
    final List<String> arguments = ['--tcpip=$deviceIPAddress'];

    var process = await Process.run('scrcpy', arguments);

    // Manage the process output asynchronously.
    process.stdout.transform(const SystemEncoding().decoder).listen((data) {
      print('scrcpy output: $data');
    });
    process.stderr.transform(const SystemEncoding().decoder).listen((data) {
      print('scrcpy error: $data');
    });
  }
}

/// Global instance for easy access.
final condorAdbCommands = CondorAdbCommands();
