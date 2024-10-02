import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wireless_debugging_devices_manager/bloc/app_settings_bloc/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/bloc/devices_bloc/devices_bloc.dart';
import 'package:wireless_debugging_devices_manager/config/app_theme.dart';
import 'package:wireless_debugging_devices_manager/l10n/l10n.dart';
import 'package:wireless_debugging_devices_manager/screens/home_screen.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';
import 'package:wireless_debugging_devices_manager/services/condor_snackbar_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Hydrated Bloc Storage dynamically.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage
            .webStorageDirectory // Web storage which is not used for this software.
        : kDebugMode
            ? await getApplicationDocumentsDirectory() // Store data in the Documents folder in debug mode.
            : await getApplicationSupportDirectory(), // Store data in the \AppData\Roaming\ilCONDORA folder in Windows and /.local/share in Linux, idk for MacOS.
  );

  /// Set the minimum size of the window.
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(876, 654),
    center: kDebugMode ? false : true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      /// Provides the AppSettingsBloc and DevicesBloc to the widget tree.
      providers: [
        BlocProvider(
          create: (context) => AppSettingsBloc(),
        ),
        BlocProvider(
          create: (context) => DevicesBloc(),
        ),
      ],
      child: BlocBuilder<AppSettingsBloc, AppSettingsState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Wireless Debugging Devices Manager',
            debugShowCheckedModeBanner: false,
            locale: state.appSettingsModel.locale,
            supportedLocales: L10n.supportedLocales,
            localizationsDelegates: L10n.localizationsDelegates,
            theme: CondorAppTheme.lightTheme,
            darkTheme: CondorAppTheme.darkTheme,

            /// The theme is determined by the current settings in the app's state.
            themeMode: state.appSettingsModel.themeMode,
            home: Builder(builder: (context) {
              /// Initialize the service that manages the SnackBar.
              condorSnackBar.init(context);

              /// Initialize the service that manages the localization.
              condorLocalization.init(context);
              return const HomeScreen();
            }),
          );
        },
      ),
    );
  }
}
