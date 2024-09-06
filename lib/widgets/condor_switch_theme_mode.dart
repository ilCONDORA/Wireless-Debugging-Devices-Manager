import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/theme_bloc.dart';

class CondorSwitchThemeMode extends StatelessWidget {
  const CondorSwitchThemeMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      /// rebuild this widget only when user changes theme
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        final isDarkMode = state.themeMode == ThemeMode.dark;
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
            Switch(
              value: isDarkMode,
              onChanged: (bool value) {
                context.read<ThemeBloc>().add(
                      ChangeTheme(
                        themeMode: value ? ThemeMode.dark : ThemeMode.light,
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
