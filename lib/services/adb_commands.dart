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

  /// Method to run the 'adb tcpip' command to open a port for a connection with a device.
  ///
  /// The parameters [serialNumber] and [tcpipPort] are required, duh.
  /// It shows a snackbar with the result of the command execution.
  Future<bool> runTcpip(
      {required String serialNumber, required int tcpipPort}) async {
    final List<String> arguments = ['-s', serialNumber, 'tcpip', '$tcpipPort'];

    var result = await Process.run(executable, arguments);

    printCommandDetails(commandArguments: arguments, result: result);

    switch (result.exitCode) {
      case 0:
        condorSnackBar.show(
          message:
              'Successfully ran tcpip on $serialNumber. New port is -> $tcpipPort.',
          isSuccess: true,
        );
        return true;
      case 1:
        condorSnackBar.show(
          message:
              'Could not set new port for $serialNumber. Check if the new port is fine or the device is connected or the serial number is correct and retry from the start.',
          isSuccess: false,
        );
        return false;
      default:
        condorSnackBar.show(
          message:
              "Unknown error while setting new port for $serialNumber with 'adb tcpip' command.",
          isSuccess: false,
        );
        return false;
    }
  }

  /// Method to connect to a device based on its IP address.
  ///
  /// It shows a snackbar with the result of the command execution.
  Future<bool> connectToDevice({required String completeIp}) async {
    final List<String> arguments = ['connect', completeIp];

    var result = await Process.run(executable, arguments);

    printCommandDetails(commandArguments: arguments, result: result);

    switch (result.exitCode) {
      case 0:
        // Split the output into lines.
        List<String> lines = result.stdout.trim().split('\n');
        // Find the index where the true message starts.
        // the 'connect' is present in all the correct output.
        int startIndex = lines.indexWhere((line) => line.contains('connect'));
        // Extract the relevant message.
        String message = lines[startIndex];
        // Determine the connection status, if there is a 'connected' in the message the device is connected.
        bool connected = message.contains('connected');

        if (connected) {
          condorSnackBar.show(
            message: 'Successfully connected to $completeIp.',
            isSuccess: true,
          );
          return true;
        } else {
          condorSnackBar.show(
            message:
                'Could not connect to $completeIp. Check if the IP address is correct and retry.',
            isSuccess: false,
          );
          return false;
        }
      case 1:
        // This error should never occur because of the nature of the 'adb connect', I think, but I don't know though.
        condorSnackBar.show(
          message:
              'Could not connect to $completeIp. Check if the IP address is correct and retry.',
          isSuccess: false,
        );
        return false;
      default:
        condorSnackBar.show(
          message:
              "Unknown error while connecting to $completeIp with 'adb connect' command.",
          isSuccess: false,
        );
        return false;
    }
  }

  /// Method to disconnect from a device based on its IP address.
  ///
  /// It doesn't return a boolean like the connectToDevice method because it always returns true anyway.
  /// It shows a snackbar with the result of the command execution.
  Future<void> disconnectFromDevice({required String completeIp}) async {
    final List<String> arguments = ['disconnect', completeIp];

    var result = await Process.run(executable, arguments);

    printCommandDetails(commandArguments: arguments, result: result);

    switch (result.exitCode) {
      case 0:
        condorSnackBar.show(
          message: 'Successfully disconnected from $completeIp.',
          isSuccess: true,
        );
        break;
      case 1:
        condorSnackBar.show(
          message:
              'Error while disconnecting from $completeIp. Maybe the device is already disconnected. I will updated the connection status anyways.',
          isSuccess: false,
        );
        break;
      default:
        condorSnackBar.show(
          message:
              "Unknown error while disconnecting from $completeIp with 'adb disconnect' command. I will updated the connection status anyways.",
          isSuccess: false,
        );
        break;
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
