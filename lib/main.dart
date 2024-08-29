import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wireless_debugging_devices_manager/bloc/theme_bloc.dart';
import 'package:wireless_debugging_devices_manager/config/app_theme.dart';
import 'package:wireless_debugging_devices_manager/widgets/condor_switch_theme_mode.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Hydrated Bloc Storage dynamically
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage
            .webStorageDirectory // Web storage whic is not used for this software
        : await getApplicationSupportDirectory(), // Store data in the \AppData\Roaming\ilCONDORA folder in Windows and /.local/share in Linux, idk for MacOS.
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        /// rebuild this widget only when user changes theme
        buildWhen: (previous, current) =>
            previous.themeMode != current.themeMode,
        builder: (context, state) {
          return MaterialApp(
            title: 'Wireless Debugging Devices Manager',
            debugShowCheckedModeBanner: false,
            theme: CondorAppTheme.lightTheme,
            darkTheme: CondorAppTheme.darkTheme,
            themeMode: state.themeMode,
            home: const Scaffold(
              body: CondorSwitchThemeMode(),
            ),
          );
        },
      ),
    );
  }
}
