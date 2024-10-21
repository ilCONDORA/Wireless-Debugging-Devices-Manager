import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wireless_debugging_devices_manager/blocs/app_settings/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/blocs/devices/devices_bloc.dart';
import 'package:wireless_debugging_devices_manager/screens/info_screen.dart';
import 'package:wireless_debugging_devices_manager/services/adb_commands.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';
import 'package:wireless_debugging_devices_manager/services/condor_snackbar_service.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_add_device_dialog.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_dropdown_menu_locale.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_switch_theme_mode.dart';

/// A widget that displays a row of buttons for various actions in the Condor app.
///
/// This widget includes buttons for adding a device, killing the ADB server,
/// showing info, switching theme mode, changing locale, and a donation link.
class CondorButtonsRow extends StatelessWidget {
  /// Creates a CondorButtonsRow widget.
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
                // Button to add a device
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) => const CondorAddDeviceDialog(),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(Colors.lightBlue.shade300),
                  ),
                  child: Text(condorLocalization.l10n.addDeviceButton),
                ),
                // Button to kill the ADB server
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
                // Button to show info page
                ElevatedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const InfoScreen())),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.lime),
                  ),
                  child: Text(condorLocalization.l10n.infoPageButton),
                ),
                // Widget to switch theme mode
                const CondorSwitchThemeMode(),
                // Widget to change locale
                const CondorDropdownMenuLocale(),
                // Button for donation link
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
