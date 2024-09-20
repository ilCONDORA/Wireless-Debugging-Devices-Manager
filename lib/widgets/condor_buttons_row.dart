import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wireless_debugging_devices_manager/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/devices_bloc/devices_bloc.dart';
import 'package:wireless_debugging_devices_manager/services/adb_commands.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';
import 'package:wireless_debugging_devices_manager/services/condor_snackbar_service.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_dropdown_menu_locale.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_switch_theme_mode.dart';

class CondorButtonsRow extends StatelessWidget {
  const CondorButtonsRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
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
                  child: Text(condorLocalization.l10n.addDeviceButton),
                ),
                ElevatedButton(
                  /// When the user clicks on this button the ADB server is killed and
                  /// subsequently all devices connection statuses are registered as disconnected.
                  onPressed: () => condorAdbCommands.killServer().then((_) {
                    if (context.mounted) {
                      context.read<DevicesBloc>().add(DisconnectAllDevices());
                    }
                  }),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.deepOrange),
                  ),
                  child: Text(condorLocalization.l10n.killAdbServerButton),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.lime),
                  ),
                  child: Text(condorLocalization.l10n.infoPageButton),
                ),
                const CondorSwitchThemeMode(),
                const CondorDropdownMenuLocale(),
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
                  child: Text(condorLocalization.l10n.buyMeATeaButton),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
