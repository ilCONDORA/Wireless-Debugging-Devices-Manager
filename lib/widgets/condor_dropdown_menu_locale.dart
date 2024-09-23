import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/l10n/l10n.dart';

/// A widget that displays a dropdown menu for selecting the app's locale.
///
/// This widget listens to the AppSettingsBloc to get the current locale
/// and provides options to change it.
class CondorDropdownMenuLocale extends StatelessWidget {
  /// Creates a CondorDropdownMenuLocale widget.
  const CondorDropdownMenuLocale({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
      builder: (context, state) {
        /// Determines if the current theme mode is dark.
        final isDarkMode = state.appSettingsModel.themeMode == ThemeMode.dark;
        return Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey.shade300 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<Locale>(
            borderRadius: BorderRadius.circular(8),
            focusColor: Colors.transparent,
            value: state.appSettingsModel.locale,
            items: L10n.supportedLocales.map((iterableLocale) {
              return DropdownMenuItem(
                value: iterableLocale,
                child: Text(
                  iterableLocale.languageCode.toUpperCase(),
                ),
              );
            }).toList(),
            onChanged: (newLocale) {
              /// Updates the app settings by dispatching the ChangeAppSettings event to the BLoC.
              context.read<AppSettingsBloc>().add(
                    ChangeAppSettings(
                      appSettingsModel: state.appSettingsModel.copyWith(
                        locale: newLocale,
                      ),
                    ),
                  );
            },
          ),
        );
      },
    );
  }
}
