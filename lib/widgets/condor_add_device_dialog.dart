import 'package:flutter/material.dart';
import 'package:wireless_debugging_devices_manager/services/adb_commands.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';

class CondorAddDeviceDialog extends StatelessWidget {
  const CondorAddDeviceDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(condorLocalization.l10n.addDeviceButton),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder(
              future: condorAdbCommands.getConnectedDevicesList(),
              builder: (context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Text(condorLocalization.l10n.noDevicesFound);
                  }
                  return Column(
                    children: snapshot.data!
                        .map((device) => Text(device.toString()))
                        .toList(),
                  );
                } else {
                  return Text(condorLocalization.l10n.noDevicesFound);
                }
              })
        ],
      ),
    );
  }
}
