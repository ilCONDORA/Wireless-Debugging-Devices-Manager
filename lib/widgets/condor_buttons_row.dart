import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wireless_debugging_devices_manager/bloc/devices_bloc/devices_bloc.dart';
import 'package:wireless_debugging_devices_manager/services/adb_commands.dart';
import 'package:wireless_debugging_devices_manager/services/condor_snackbar_service.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_switch_theme_mode.dart';

class CondorButtonsRow extends StatelessWidget {
  const CondorButtonsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevicesBloc, DevicesState>(
      builder: (context, state) {
        return Wrap(
          spacing: 28,
          runSpacing: 8,
          children: [
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.lightBlue.shade300),
              ),
              child: const Text('Add Device'),
            ),
            ElevatedButton(
              /// When the user clicks on this button the ADB server is killed and
              /// subsequently all devices connection statuses are registered as disconnected.
              //TODO: to try after implementing device card
              onPressed: () => condorAdbCommands.killServer().then((_) {
                if (context.mounted) {
                  context.read<DevicesBloc>().add(DisconnectAllDevices());
                }
              }),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.deepOrange),
              ),
              child: const Text('Kill Adb Server'),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.lime),
              ),
              child: const Text('Info Page'),
            ),
            const CondorSwitchThemeMode(),
            ElevatedButton(
              onPressed: () async {
                final Uri url = Uri.parse('https://ko-fi.com/ilcondora');
                if (!await launchUrl(url)) {
                  condorSnackBar.show(
                    message: 'Could not launch $url',
                    isSuccess: false,
                  );
                }
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.tealAccent.shade400),
              ),
              child: const Text('Buy me a Tea'),
            ),
          ],
        );
      },
    );
  }
}
