import 'dart:io';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';
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
          message: condorLocalization.l10n.adbServerKilledSuccess,
          isSuccess: true,
        );
      case 1:
        // This error should never occur because of the nature of the 'adb kill-server' command.
        condorSnackBar.show(
          message: condorLocalization.l10n.adbServerKilledError,
          isSuccess: false,
        );
      default:
        // This error should never occur because of the nature of the 'adb kill-server' command.
        condorSnackBar.show(
          message: condorLocalization.l10n.adbServerUnknownError,
          isSuccess: false,
        );
    }
  }

  ///Method to get the list of devices connected to the computer.
  ///
  /// It returns a list of devices connected to the computer.
  /// If it returns an empty list then there are either no devices connected to the computer or an error occurred.
  Future<List<Map<String, dynamic>>> getConnectedDevicesList() async {
    const List<String> arguments = ['devices', '-l'];

    var result = await Process.run(executable, arguments);

    printCommandDetails(commandArguments: arguments, result: result);

    switch (result.exitCode) {
      case 0:
        // Trim the output.
        String trimmedOutput = result.stdout.toString().trim();
        // Split the output into lines.
        List<String> lines = trimmedOutput.split('\n');
        // Find the index where the device list starts.
        int startIndex = lines
            .indexWhere((line) => line.startsWith('List of devices attached'));
        // Remove the 'List of devices attached' line and empty lines.
        List<String> filteredLines = lines
            .sublist(startIndex + 1)
            .where((line) => line.trim().isNotEmpty)
            .toList();

        // If no devices are connected then return an empty list.
        if (filteredLines.isEmpty) {
          return [];
        }

        List<Map<String, dynamic>> connectedDevicesList = [];
        for (String line in filteredLines) {
          // Split the line into parts.
          List<String> parts = line.split(RegExp(r'\s+'));
          if (parts.length >= 2) {
            // Extract device identifier (IP or serial number).
            String ipOrSerial = parts[0];
            // Determine if the identifier is an IP address or a serial number, if it is a serial number then continue, if not then skip to the next device.
            if (ipOrSerial.contains(':')) {
              break;
            }
            // Extract device model.
            String model = parts
                .firstWhere((part) => part.startsWith('model:'),
                    orElse: () => 'model: Unknown')
                .split(':')
                .last;

            Map<String, dynamic> deviceInformations =
                await getDeviceInformation(serialNumber: ipOrSerial);
            // If in the device informations map is present a null value then return an empty list, otherwise continue.
            if (deviceInformations.containsValue(null)) {
              condorSnackBar.show(
                message: condorLocalization.l10n.getDeviceInformationError,
                isSuccess: false,
              );
              return [];
            }

            connectedDevicesList.add({
              'ipAddress': deviceInformations['ipAddress'].toString(),
              'serialNumber': ipOrSerial,
              'model': model,
              'manufacturer':
                  deviceInformations['manufacturer'].toString().toUpperCase(),
              'androidVersion':
                  deviceInformations['androidVersion'].toString(),
            });
          }
        }
        return connectedDevicesList;
      case 1:
        condorSnackBar.show(
          message: condorLocalization.l10n.getConnectedDevicesListError,
          isSuccess: false,
        );
        return [];
      default:
        condorSnackBar.show(
          message: condorLocalization.l10n.getConnectedDevicesListUnknownError,
          isSuccess: false,
        );
        return [];
    }
  }

  /// Method to retrieve the IP address, manufacturer and android version of a connected device based on its serial number.
  ///
  /// It returns a map containing the manufacturer, android version and IP address of the device.
  /// In case of an error, it returns null in the value of the keys.
  Future<Map<String, dynamic>> getDeviceInformation(
      {required String serialNumber}) async {
    final Map<String, dynamic> deviceInformation = {
      'manufacturer': null,
      'androidVersion': null,
      'ipAddress': null
    };

    final List<String> commonArguments = ['-s', serialNumber, 'shell'];
    final List<String> manufacturerArguments = [
      ...commonArguments,
      'getprop ro.product.manufacturer'
    ];
    final List<String> androidArguments = [
      ...commonArguments,
      'getprop ro.build.version.release'
    ];

    var manufacturerResult =
        await Process.run(executable, manufacturerArguments);
    printCommandDetails(
        commandArguments: manufacturerArguments, result: manufacturerResult);

    var androidResult = await Process.run(executable, androidArguments);
    printCommandDetails(
        commandArguments: androidArguments, result: androidResult);

    switch (manufacturerResult.exitCode) {
      case 0:
        deviceInformation['manufacturer'] =
            manufacturerResult.stdout.toString().trim();
      case 1:
      default:
        break;
    }
    switch (androidResult.exitCode) {
      case 0:
        deviceInformation['androidVersion'] =
            androidResult.stdout.toString().trim();
      case 1:
      default:
        break;
    }

    deviceInformation['ipAddress'] =
        await getDeviceIPAddress(serialNumber: serialNumber);

    return deviceInformation;
  }

  /// Method to retrieve the IP address of a connected device based on its serial number.
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
        return deviceIPAddress;
      case 1:
      default:
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
              condorLocalization.l10n.runTcpipSuccess(serialNumber, tcpipPort),
          isSuccess: true,
        );
        return true;
      case 1:
        condorSnackBar.show(
          message: condorLocalization.l10n.runTcpipError(serialNumber),
          isSuccess: false,
        );
        return false;
      default:
        condorSnackBar.show(
          message: condorLocalization.l10n.runTcpipUnknownError(serialNumber),
          isSuccess: false,
        );
        return false;
    }
  }

  /// Method to connect to a device based on its IP address.
  ///
  /// It shows a snackbar with the result of the command execution.
  Future<bool> connectToDevice({required String completeIpAddress}) async {
    final List<String> arguments = ['connect', completeIpAddress];

    var result = await Process.run(executable, arguments);

    printCommandDetails(commandArguments: arguments, result: result);

    switch (result.exitCode) {
      case 0:
        // Split the output into lines.
        List<String> lines = result.stdout.trim().split('\n');
        // Find the index where the true message starts.
        // the 'connect' is present in almost all the correct output.
        int startIndex = lines.indexWhere((line) => line.contains('connect'));

        // Handles the failed to authenticate correct ouput error.
        if (startIndex == -1) {
          condorSnackBar.show(
            message: condorLocalization.l10n
                .connectToDeviceAuthError(completeIpAddress),
            isSuccess: false,
          );
          return false;
        }

        // Extract the relevant message.
        String message = lines[startIndex];
        // Determine the connection status, if there is a 'connected' in the message the device is connected.
        bool connected = message.contains('connected');

        if (connected) {
          condorSnackBar.show(
            message: condorLocalization.l10n
                .connectToDeviceSuccess(completeIpAddress),
            isSuccess: true,
          );
          return true;
        } else {
          condorSnackBar.show(
            message:
                condorLocalization.l10n.connectToDeviceError(completeIpAddress),
            isSuccess: false,
          );
          return false;
        }
      case 1:
        // This error should never occur because of the nature of the 'adb connect', I think, but I don't know though.
        condorSnackBar.show(
          message:
              condorLocalization.l10n.connectToDeviceError(completeIpAddress),
          isSuccess: false,
        );
        return false;
      default:
        condorSnackBar.show(
          message: condorLocalization.l10n
              .connectToDeviceUnknownError(completeIpAddress),
          isSuccess: false,
        );
        return false;
    }
  }

  /// Method to disconnect from a device based on its IP address.
  ///
  /// It doesn't return a boolean like the connectToDevice method because it always returns true anyway.
  /// It shows a snackbar with the result of the command execution.
  Future<void> disconnectFromDevice({required String completeIpAddress}) async {
    final List<String> arguments = ['disconnect', completeIpAddress];

    var result = await Process.run(executable, arguments);

    printCommandDetails(commandArguments: arguments, result: result);

    switch (result.exitCode) {
      case 0:
        condorSnackBar.show(
          message: condorLocalization.l10n
              .disconnectFromDeviceSuccess(completeIpAddress),
          isSuccess: true,
        );
        break;
      case 1:
        condorSnackBar.show(
          message: condorLocalization.l10n
              .disconnectFromDeviceError(completeIpAddress),
          isSuccess: false,
        );
        break;
      default:
        condorSnackBar.show(
          message: condorLocalization.l10n
              .disconnectFromDeviceUnknownError(completeIpAddress),
          isSuccess: false,
        );
        break;
    }
  }

  /// Method to display screen of a connected device based on its IP address.
  /// I don't think I will use it but it's here just in case.
  /// Powered by scrcpy.
  Future<void> mirrorScreen({required String completeIPAddress}) async {
    final List<String> arguments = ['-s', completeIPAddress];

    try {
      // ignore: unused_local_variable
      var process = await Process.run('scrcpy', arguments);

      /* // Manage the process output asynchronously.
      process.stdout.transform(const SystemEncoding().decoder).listen((data) {
        print('scrcpy output: $data');
      });
      process.stderr.transform(const SystemEncoding().decoder).listen((data) {
        print('scrcpy error: $data');
      }); */
    } catch (e) {
      condorSnackBar.show(
        message: condorLocalization.l10n.mirrorScreenPathError,
        isSuccess: false,
      );
    }
  }
}

/// Global instance for easy access.
final condorAdbCommands = CondorAdbCommands();
