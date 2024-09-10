import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/app_settings_bloc/app_settings_bloc.dart';

/// CondorSwitchThemeMode is a stateless widget that allows users to toggle between light and dark modes.
/// It listens to the AppSettingsBloc to check the current theme mode and updates the UI accordingly.
class CondorSwitchThemeMode extends StatelessWidget {
  const CondorSwitchThemeMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      /// Rebuilds this widget only when the user changes the theme mode.
      buildWhen: (previous, current) =>
          previous.appSettingsModel.themeMode !=
          current.appSettingsModel.themeMode,
      builder: (context, state) {
        /// Determines if the current theme mode is dark.
        final isDarkMode = state.appSettingsModel.themeMode == ThemeMode.dark;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              size: 30,
              isDarkMode ? Icons.dark_mode : Icons.light_mode,
              color: isDarkMode ? Colors.grey.shade300 : Colors.orange.shade400,
            ),
            const SizedBox(width: 8),
            Text(
              isDarkMode ? 'Dark Mode Enabled' : 'Light Mode Enabled',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(width: 8),

            /// Switch widget that allows the user to toggle between light and dark modes.
            Switch(
              value: isDarkMode,
              onChanged: (bool value) {
                /// Updates the app settings by dispatching the ChangeAppSettings event to the BLoC.
                context.read<AppSettingsBloc>().add(
                      ChangeAppSettings(
                        appSettingsModel: state.appSettingsModel.copyWith(
                          themeMode: value ? ThemeMode.dark : ThemeMode.light,
                        ),
                      ),
                    );
              },
            )
          ],
        );
      },
    );
  }
}
