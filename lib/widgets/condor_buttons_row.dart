import 'package:flutter/material.dart';
import 'package:wireless_debugging_devices_manager/services/adb_commands.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_switch_theme_mode.dart';

class CondorButtonsRow extends StatelessWidget {
  const CondorButtonsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor:
                WidgetStateProperty.all(Colors.lightBlue.shade300),
          ),
          child: const Text('Add Device'),
        ),
        const SizedBox(
          width: 33,
        ),
        ElevatedButton(
          onPressed: () => condorAdbCommands.killServer(),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.deepOrange),
          ),
          child: const Text('Kill Adb Server'),
        ),
        const SizedBox(
          width: 33,
        ),
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(Colors.lime),
          ),
          child: const Text('Info Page'),
        ),
        const SizedBox(
          width: 33,
        ),
        const CondorSwitchThemeMode(),
      ],
    );
  }
}
