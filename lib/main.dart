import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wireless_debugging_devices_manager/blocs/app_settings/app_settings_bloc.dart';
import 'package:wireless_debugging_devices_manager/blocs/devices/devices_bloc.dart';
import 'package:wireless_debugging_devices_manager/config/app_theme.dart';
import 'package:wireless_debugging_devices_manager/l10n/l10n.dart';
import 'package:wireless_debugging_devices_manager/screens/home_screen.dart';
import 'package:wireless_debugging_devices_manager/services/condor_localization_service.dart';
import 'package:wireless_debugging_devices_manager/services/condor_snackbar_service.dart';

Future<Directory> getStorageDirectory() async {
  if (kIsWeb) {
    return HydratedStorage
        .webStorageDirectory; // Web storage which is not used for this software.
  } else if (kDebugMode) {
    // Store data in the Documents folder in debug mode.
    final documentsDir = await getApplicationDocumentsDirectory();
    final debugFolder = Directory(
        '${documentsDir.path}/REMEMBER TO DELETE -- DEBUG STORAGE for WDDM by ilCONDORA');

    // Create the folder if it doesn't exist
    if (!await debugFolder.exists()) {
      await debugFolder.create();
    }

    return debugFolder;
  } else {
    // Store data in the \AppData\Roaming\ilCONDORA folder in Windows and /.local/share in Linux, idk for MacOS in release.
    final supportDir = await getApplicationSupportDirectory();
    return supportDir;
  }
}

/// The main entry point for the application.
///
/// This function initializes the app, sets up Hydrated Bloc storage,
/// configures the window manager, and runs the app.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Hydrated Bloc Storage dynamically.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getStorageDirectory(),
  );

  /// Set the minimum size of the window.
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(876, 654),
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MainApp());
}

/// The root widget of the application.
///
/// This widget sets up the BLoC providers and the WindowManagerWrapper.
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
      child: const WindowManagerWrapper(),
    );
  }
}

/// A wrapper widget that manages window-related functionality.
///
/// This widget listens for window events and manages the saving and loading
/// of window size and position.
class WindowManagerWrapper extends StatefulWidget {
  const WindowManagerWrapper({super.key});

  @override
  State<WindowManagerWrapper> createState() => _WindowManagerWrapperState();
}

class _WindowManagerWrapperState extends State<WindowManagerWrapper>
    with WindowListener {
  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _loadSavedWindowSettings();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  /// Saves the current window size and position when the window is resized.
  @override
  void onWindowResized() {
    saveWindowSizeAndPosition();
  }

  /// Saves the current window size and position when the window is moved.
  @override
  void onWindowMoved() {
    saveWindowSizeAndPosition();
  }

  /// Saves the current window size and position to the app settings.
  ///
  /// This method retrieves the current window size and position,
  /// updates the app settings, and dispatches an event to save the changes.
  Future<void> saveWindowSizeAndPosition() async {
    Size size = await windowManager.getSize();
    Offset position = await windowManager.getPosition();

    if (mounted) {
      final appSettingsBloc = context.read<AppSettingsBloc>();
      final currentSettings = appSettingsBloc.state.appSettingsModel;
      final updatedSettings = currentSettings.copyWith(
        windowSize: size,
        windowPosition: position,
      );
      appSettingsBloc.add(ChangeAppSettings(appSettingsModel: updatedSettings));
    }
  }

  /// Loads the saved window settings and applies them to the current window.
  ///
  /// This method retrieves the saved window size and position from the app settings
  /// and sets them for the current window.
  Future<void> _loadSavedWindowSettings() async {
    final appSettingsBloc = context.read<AppSettingsBloc>();
    final savedSettings = appSettingsBloc.state.appSettingsModel;

    await windowManager.setSize(savedSettings.windowSize);
    await windowManager.setPosition(savedSettings.windowPosition);
  }

  @override
  Widget build(BuildContext context) {
    return const TrueApp();
  }
}

/// The main application widget.
///
/// This widget sets up the MaterialApp with the appropriate theme,
/// localization, and home screen.
class TrueApp extends StatelessWidget {
  const TrueApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
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
    );
  }
}
