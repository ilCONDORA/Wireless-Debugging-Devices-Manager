# WDDM Documentation

# OVERVIEW

## Name of the project

The name of the project is Wireless Debug Devices Manager, WDDM for short.

## General description

The project is essentially a hub where you can add Android devices and from there connect, disconnect, and mirror the screen using their IP address. The application is in English and Italian, with light and dark themes. There's also a button to shut down the PC's ADB server.

## Technologies used

The basic technologies used are Flutter and Dart, along with the following packages:

- [bloc](https://pub.dev/packages/bloc), [meta](https://pub.dev/packages/meta) e [flutter_bloc](https://pub.dev/packages/flutter_bloc). Basic packages for state management using the BLoC methodology.
- [hydrated_bloc](https://pub.dev/packages/hydrated_bloc) e [path_provider](https://pub.dev/packages/path_provider). Packages for data persistence when the app is closed.
- [intl](https://pub.dev/packages/intl) e flutter_localizations. Packages for app internationalization; the flutter_localizations package is already present in the SDK and needs to be called.
- [window_manager](https://pub.dev/packages/window_manager). Package for setting the minimum window size and for getting the window size and position, which will be saved thanks to hydrated_bloc.
- [reorderables](https://pub.dev/packages/reorderables). Package that allows the user to reorder device cards.
- [url_launcher](https://pub.dev/packages/url_launcher). Package used to open the browser and redirect to the website where you can donate money to support the developer.

Additionally, two other packages were used to create the app icon and rename the app:

- [icons_launcher](https://pub.dev/packages/icons_launcher). Package used for creating app icons.
- [package_rename](https://pub.dev/packages/package_rename). Package for renaming the application.

# Installation

To use the application, it's mandatory to install and add the ADB application to the PATH; it's automatically downloaded when installing Android Studio. Installing and adding [scrcpy](https://github.com/Genymobile/scrcpy) to the PATH is optional.
In the release section of GitHub, [link to the repo](https://github.com/ilCONDORA/Wireless-Debugging-Devices-Manager), you can download a .zip file for Windows, macOS, and Linux desktops.

# Project Architecture

## Folder and file structure

```
📂 lib
├── 📂 blocs
│   ├── 📂 app_settings
│   │   ├── 📄 app_settings_bloc.dart
│   │   ├── 📄 app_settings_event.dart
│   │   └── 📄 app_settings_state.dart
│   └── 📂 devices
│       ├── 📄 devices_bloc.dart
│       ├── 📄 devices_event.dart
│       └── 📄 devices_state.dart
├── 📂 config
│   └── 📄 app_theme.dart
├── 📂 cubits
│   ├── 📂 expandable_device_card
│   │   ├── 📄 expandable_device_card_cubit.dart
│   │   └── 📄 expandable_device_card_state.dart
│   ├── 📂 selected_new_device
│   │   ├── 📄 selected_new_device_cubit.dart
│   │   └── 📄 selected_new_device_state.dart
│   └── 📂 spinning_circle
│       ├── 📄 spinning_circle_cubit.dart
│       └── 📄 spinning_circle_state.dart
├── 📂 l10n
│   ├── 📄 app_en.arb
│   ├── 📄 app_it.arb
│   └── 📄 l10n.dart
├── 📂 models
│   ├── 📄 app_settings_model.dart
│   └── 📄 device_model.dart
├── 📂 screens
│   └── 📄 home_screen.dart
├── 📂 services
│   ├── 📄 adb_commands.dart
│   ├── 📄 condor_localization_service.dart
│   └── 📄 condor_snackbar_service.dart
├── 📂 widgets
│   ├── 📄 condor_add_device_dialog.dart
│   ├── 📄 condor_buttons_row.dart
│   ├── 📄 condor_dropdown_menu_locale.dart
│   ├── 📄 condor_expandable_card.dart
│   ├── 📄 condor_expanded_icon.dart
│   ├── 📄 condor_switch_theme_mode.dart
│   ├── 📄 deprecated_condor_device_card.dart
│   └── 📄 deprecated_condor_snackbar_message.dart
└── 📄 main.dart
```

## Persistence Management

As mentioned earlier, persistence comes from the hydrated_bloc package; hydrated_bloc uses Hive as a database to maintain data.
In main.dart, we see how hydrated_bloc is set up, and subsequently, we see how it stores data.

main.dart:

```dart
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Hydrated Bloc Storage dynamically.
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getStorageDirectory(),
  );

  runApp(const MainApp());
}
```

app_settings_bloc.dart:

```dart
/// Manages the state of the application settings using the BLoC pattern.
/// Utilizes HydratedBloc to automatically persist and restore the state.
class AppSettingsBloc extends HydratedBloc<AppSettingsEvent, AppSettingsState> {
  /// Initializes the bloc with the initial state of the app settings.
  AppSettingsBloc() : super(AppSettingsInitial()) {
    // Handles the ChangeAppSettings event and emits a new state with the updated settings model.
    on<ChangeAppSettings>((event, emit) {
      emit(AppSettingsChanged(event.appSettingsModel));
    });
  }

  /// Converts a JSON object into an instance of [AppSettingsState].
  ///
  /// Called by `HydratedBloc` when reopening the app to restore the saved state
  /// from a persisted instance. If the JSON is valid, it returns the state
  /// [AppSettingsChanged] with the new settings. If the conversion
  /// fails (e.g., due to corrupted or invalid data), it returns the initial state
  /// [AppSettingsInitial], which means there is no valid data
  /// to restore.
  @override
  AppSettingsState? fromJson(Map<String, dynamic> json) {
    try {
      final appSettingsModel = AppSettingsModel.fromJson(json);
      return AppSettingsChanged(appSettingsModel);
    } catch (_) {
      return AppSettingsInitial();
    }
  }

  /// Converts the current [AppSettingsState] into a JSON object for persistence.
  ///
  /// This function is called by `HydratedBloc` to save the current state
  /// when there are changes. If the state is [AppSettingsChanged], it serializes
  /// the settings model into JSON and saves it. If the state is the initial state
  /// [AppSettingsInitial], it returns `null`, which indicates that there is no state
  /// to persist (e.g., the default state of the app).
  @override
  Map<String, dynamic>? toJson(AppSettingsState state) {
    if (state is AppSettingsChanged) {
      return state.appSettingsModel.toJson();
    }
    return null;
  }
}
```

In the methods fromJson and toJson we use the methods fromJson and toJson from app_settings_model.dart:

```dart
/// Create an AppSettings instance from a JSON map.
factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
  return AppSettingsModel(
    themeMode:
        ThemeMode.values[json['themeMode'] as int? ?? defaultThemeMode.index],
    locale: Locale(json['locale'] as String? ?? defaultLocale.languageCode),
    windowSize: Size(
      json['windowSize']['width'] as double? ?? defaultWindowSize.width,
      json['windowSize']['height'] as double? ?? defaultWindowSize.height,
    ),
    windowPosition: Offset(
      json['windowPosition']['x'] as double? ?? defaultWindowPosition.dx,
      json['windowPosition']['y'] as double? ?? defaultWindowPosition.dy,
    ),
  );
}

/// Converts an AppSettings instance to a JSON map.
Map<String, dynamic> toJson() {
  return {
    'themeMode': themeMode.index,
    'locale': locale.languageCode,
    'windowSize': {
      'width': windowSize.width,
      'height': windowSize.height,
    },
    'windowPosition': {
      'x': windowPosition.dx,
      'y': windowPosition.dy,
    },
  };
}
```

# Features

As mentioned before, the features are:

- Connecting to the device via complete IP address.
- Disconnecting from the device via complete IP address.
- Reassigning the device's tcpip port via wired connection using the serial number.
- Mirroring and controlling the device screen using scrcpy installed by the user.
- Shutting down the PC's ADB server.
- Adding a device by connecting it to the PC with a cable.
- Expandable and collapsible device card.
- Deleting a device.
- Changing the application theme.
- Changing the application language, normally available in English and Italian.

# Detailed explanation of each feature

## Global Snackbar

There's a global snackbar that receives a message and a success state that determines the color of the snackbar.

```dart
/// Service to show a SnackBar with a message and a different background color depending on the result [isSuccess].
class CondorSnackBarService {
  static final CondorSnackBarService _instance =
      CondorSnackBarService._internal();
  factory CondorSnackBarService() => _instance;
  CondorSnackBarService._internal();

  late BuildContext _context;

  /// Initialize the service by getting the context so that it's passed to the [show] method.
  void init(BuildContext context) {
    _context = context;
  }

  void show({required String message, required bool isSuccess}) {
    if (!_context.mounted) return;

    /// Close any open snackbar.
    ScaffoldMessenger.of(_context).clearSnackBars();

    /// Show snackbar with message and with color of success or error.
    ScaffoldMessenger.of(_context).showSnackBar(
      SnackBar(
        content: SelectableText(
          message,
        ),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(_context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}

/// Global instance for easy access.
final condorSnackBar = CondorSnackBarService();
```

In main.dart, we initialize the service:

```dart
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
```

## Changing application language

In main.dart, we initialize the service:

```dart
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
```

In the l10n.dart file, we manage the supported Locales and delegates.

```dart
class L10n {
  static final supportedLocales = [
    const Locale('en'),
    const Locale('it'),
  ];

  static const localizationsDelegates = [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
```

And we have a file that creates a global instance of the internationalization service.

```dart
/// Service for localization.
///
/// It provides access to the localized strings in the application.
class CondorLocalizationService {
  static final CondorLocalizationService _instance = CondorLocalizationService._internal();
  factory CondorLocalizationService() => _instance;
  CondorLocalizationService._internal();

  late BuildContext _context;

  void init(BuildContext context) {
    _context = context;
  }

  AppLocalizations get l10n => AppLocalizations.of(_context)!;
}

/// Global instance for easy access to the localized strings in the application.
final condorLocalization = CondorLocalizationService();
```

To change the language, there's a dropdown menu in the row of main buttons, and it uses the bloc event call.

```dart
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

```

To use the strings in various files, just put the call to the global instance plus the string registered in the arb in the Text widget: `condorLocalization.l10n.<string in arb>`.

## Connecting and Disconnecting device

In the device card, there are buttons to attempt to connect and disconnect from the device via the complete IP address. The buttons are two StatelessWidget classes, and their constructor requires a device. As a return, we have a BlocProvider and BlocBuilder that use SpinningCircleCubit to show CircularProgressIndicator. The button is pressable or not depending on the device's connection state, which is registered.

```dart
class DisconnectButton extends StatelessWidget {
  const DisconnectButton({
    super.key,
    required this.device,
  });

  final DeviceModel device;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      /// SpinningCircleCubit manages the state of the spinning circle.
      create: (context) => SpinningCircleCubit(),
      child: BlocBuilder<SpinningCircleCubit, SpinningCircleState>(
        builder: (context, state) {
          return Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Visibility(
                  /// Only show the loading indicator if the state is SpinningCircleSpinning.
                  visible: state is SpinningCircleSpinning,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              ElevatedButton(
                onPressed: device.isConnected
                    ? () async {
                        /// Create a reference to the SpinningCircleCubit so that the context can be accessed easily.
                        final spinningCircleCubit =
                            context.read<SpinningCircleCubit>();

                        /// Invoke the startSpinning method, which will emit the SpinningCircleSpinning state.
                        spinningCircleCubit.startSpinning();

                        await condorAdbCommands
                            .disconnectFromDevice(
                                completeIpAddress: device.completeIpAddress)
                            .then(
                          (_) {
                            if (context.mounted) {
                              context.read<DevicesBloc>().add(
                                    UpdateDeviceConnectionStatus(
                                        serialNumber: device.serialNumber,
                                        isConnected: false),
                                  );
                            }
                          },
                        );

                        /// Invoke the stopSpinning method, which will emit the SpinningCircleStopped state.
                        spinningCircleCubit.stopSpinning();
                      }
                    : null,
                child: Text(condorLocalization.l10n.disconnectDeviceButton),
              ),
            ],
          );
        },
      ),
    );
  }
}
```

When pressed, the CircularProgressIndicator starts spinning and the disconnectFromDevice function from condorAdbCommands is initiated.

```dart
  /// Method to disconnect from a device based on its IP address.
  ///
  /// It doesn't return a boolean like the connectToDevice method because it always returns true anyway.
  /// It shows a snackbar with the result of the command execution.
  Future<void> disconnectFromDevice({required String completeIpAddress}) async {
    final List<String> arguments = ['disconnect', completeIpAddress];

    var result = await Process.run(executable, arguments);

    printCommandDetails(commandArguments: arguments, result: result);

    switch (result.exitCode) {
      case 0:
        condorSnackBar.show(
          message: condorLocalization.l10n
              .disconnectFromDeviceSuccess(completeIpAddress),
          isSuccess: true,
        );
        break;
      case 1:
        condorSnackBar.show(
          message: condorLocalization.l10n
              .disconnectFromDeviceError(completeIpAddress),
          isSuccess: false,
        );
        break;
      default:
        condorSnackBar.show(
          message: condorLocalization.l10n
              .disconnectFromDeviceUnknownError(completeIpAddress),
          isSuccess: false,
        );
        break;
    }
  }
```

A global snackbar is then displayed with the message and a specific color that depends on the success status. When finished, it proceeds to the .then where it will trigger the function that allows the new connection status to be saved from the devices_bloc.dart file.

```dart
  /// Handles the UpdateDeviceConnectionStatus event by updating the connection status of a specific device.
  /// Emits a new state with the updated device information.
  void _onUpdateDeviceConnectionStatus(
      UpdateDeviceConnectionStatus event, Emitter<DevicesState> emit) {
    final updatedDevices = state.devices.map((device) {
      if (device.serialNumber == event.serialNumber) {
        return device.copyWith(isConnected: event.isConnected);
      }
      return device;
    }).toList();
    emit(DevicesChanged(updatedDevices));
  }
```

## Reassigning tcpip port

In the device card, there's a button for reassigning the tcpip port, which must be done with the device connected to the PC via cable. When pressed, a dialog will be displayed.

```dart
ElevatedButton(
  onPressed: singleDevice.isConnected
      ? null
      : () {
          _showTcpipDialog(context, singleDevice);
        },
  child: Text(condorLocalization.l10n.runTcpipButton),
),
```

Pass the context and device information. The port will be extracted from the full IP address; if it doesn't exist, the default 5555 will be used.

```dart
/// Shows a dialog for running tcpip command on the device.
///
/// This function extracts the current port from the device's IP address,
/// allows the user to edit it, and then runs the tcpip command with the new port.
Future<void> _showTcpipDialog(
    BuildContext context, DeviceModel device) async {
  // Regular expression to extract the port number from the IP address
  final portRegex = RegExp(r':(\d+)$');

  // Attempt to match the regex against the device's IP address
  final match = portRegex.firstMatch(device.completeIpAddress);

  // If a match is found, use the captured group (port number), otherwise use '5555' as default
  final initialPort = match != null ? match.group(1) : '5555';

  final controller = TextEditingController(text: initialPort);

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(condorLocalization.l10n.runTcpipDialogTitle),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: initialPort),
          keyboardType: TextInputType.number,
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: <Widget>[
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red),
            ),
            child: Text(condorLocalization.l10n.cancelButton),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.green),
            ),
            child: Text(condorLocalization.l10n.runTcpipButton),
            onPressed: () async {
              final int port = int.tryParse(controller.text) ?? 5555;
              final isSuccess = await condorAdbCommands.runTcpip(
                serialNumber: device.serialNumber,
                tcpipPort: port,
              );
              if (isSuccess && context.mounted) {
                final newIpAddress = device.completeIpAddress
                    .replaceFirst(RegExp(r':\d+$'), ':$port');
                context.read<DevicesBloc>().add(
                      UpdateDeviceIpAddress(
                        serialNumber: device.serialNumber,
                        newCompleteIpAddress: newIpAddress,
                      ),
                    );
              }
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
```

The runTcpip function from condorAdbCommands is then executed.

```dart
/// Method to run the 'adb tcpip' command to open a port for a connection with a device.
///
/// The parameters [serialNumber] and [tcpipPort] are required, duh.
/// It shows a snackbar with the result of the command execution.
Future<bool> runTcpip(
    {required String serialNumber, required int tcpipPort}) async {
  final List<String> arguments = ['-s', serialNumber, 'tcpip', '$tcpipPort'];

  var result = await Process.run(executable, arguments);

  printCommandDetails(commandArguments: arguments, result: result);

  switch (result.exitCode) {
    case 0:
      condorSnackBar.show(
        message:
            condorLocalization.l10n.runTcpipSuccess(serialNumber, tcpipPort),
        isSuccess: true,
      );
      return true;
    case 1:
      condorSnackBar.show(
        message: condorLocalization.l10n.runTcpipError(serialNumber),
        isSuccess: false,
      );
      return false;
    default:
      condorSnackBar.show(
        message: condorLocalization.l10n.runTcpipUnknownError(serialNumber),
        isSuccess: false,
      );
      return false;
  }
}
```

A global snackbar is then displayed with the message and a specific color that depends on the success status. When finished, it might trigger the function that allows the new tcpip port to be saved.

```dart
/// Handles the UpdateDeviceIpAddress event by updating the IP address of a specific device.
/// Emits a new state with the updated device information.
void _onUpdateDeviceIpAddress(
    UpdateDeviceIpAddress event, Emitter<DevicesState> emit) {
  final updatedDevices = state.devices.map((device) {
    if (device.serialNumber == event.serialNumber) {
      return device.copyWith(completeIpAddress: event.newCompleteIpAddress);
    }
    return device;
  }).toList();
  emit(DevicesChanged(updatedDevices));
}
```

## Device screen mirroring

In the device card, there's a button for mirroring the device screen. When pressed, the scrcpy program will be used to perform mirroring and control of the device.

```dart
ElevatedButton(
  onPressed: singleDevice.isConnected
      ? () {
          condorAdbCommands.mirrorScreen(
              completeIPAddress: singleDevice.completeIpAddress);
        }
      : null,
  child: Text(condorLocalization.l10n.mirrorScreenButton),
),
```

```dart
/// Method to display screen of a connected device based on its IP address.
/// Powered by scrcpy.
Future<void> mirrorScreen({required String completeIPAddress}) async {
  final List<String> arguments = ['-s', completeIPAddress];

  try {
    await Process.run('scrcpy', arguments);
  } catch (e) {
    condorSnackBar.show(
      message: condorLocalization.l10n.mirrorScreenPathError,
      isSuccess: false,
    );
  }
}
```

## Shutting down ADB server

In the row of buttons, there's a button to shut down the server.

```dart
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
```

When clicked, a very simple function is executed that runs the `adb kill-server` command, and then in the .then, the connection status of all devices is updated and set to false.

```dart
/// Handles the DisconnectAllDevices event by setting all devices' connection status to false.
/// Emits a new state with all devices disconnected.
void _onDisconnectAllDevices(
    DisconnectAllDevices event, Emitter<DevicesState> emit) {
  final updatedDevices = state.devices
      .map((device) => device.copyWith(isConnected: false))
      .toList();
  emit(DevicesChanged(updatedDevices));
}
```

## Adding a new device

In the row of buttons, there's a button to add a new device

```dart
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
```

Since the code is very long, I'll explain it in words.
Clicking the button will open a dialog that will present the list of devices connected to the PC via cable. The following data will be taken from the device: IP, serial number, model, manufacturer, and Android version. Each device in the list indicates whether it's already present in the registered devices or not. Once the device to be added is selected, press the continue button, then enter the name to apply to the device and the tcpip port.

## Expandable and collapsible device card

Devices are represented by expandable and collapsible cards. This is also very long, so I'll explain it in words.
We use the ExpandableDeviceCardCubit to manage the card's state and use AnimatedCrossFade to manage the view of different children. The main idea was to use AnimatedSize, but AnimatedSize has a bug that has existed for more than 6 years. The bug consists of the lack of rendering of the animation in size reduction, meaning that the reduction animation exists and works in the background, but the user sees an instant effect instead of the working animation.
Anyway, AnimatedCrossFade will animate the show of different children, firstChild and secondChild, and the change occurs using the cubit as follows:

```dart
crossFadeState: stateOfExpandableCard
        is ExpandableDeviceCardExpanded
    ? CrossFadeState.showSecond
    : CrossFadeState.showFirst,
```

This way, when you click the button to expand the card, it will adapt with the animation.

## Deleting a device

This button is present when you enlarge the device card and is available when the device is not connected.

```dart
IconButton(
  onPressed: singleDevice.isConnected
      ? null
      : () {
          context.read<DevicesBloc>().add(
              RemoveDevice(serialNumber: singleDevice.serialNumber));
        },
  icon: Icon(
    Icons.delete,
    color: singleDevice.isConnected ? Colors.grey : Colors.red.shade600,
    size: 44,
  ),
),
```

The function in device_bloc.dart will be used to remove the device according to its serial number.

```dart
/// Handles the RemoveDevice event by removing a specific device from the list.
/// Emits a new state with the updated list of devices.
void _onRemoveDevice(RemoveDevice event, Emitter<DevicesState> emit) {
  final updatedDevices = state.devices
      .where((device) => device.serialNumber != event.serialNumber)
      .toList();
  emit(DevicesChanged(updatedDevices));
}
```

## Changing application theme

In the row of main buttons, there's a switch that allows changing the application theme.

```dart
/// CondorSwitchThemeMode is a stateless widget that allows users to toggle between light and dark modes.
/// It listens to the AppSettingsBloc to check the current theme mode and updates the UI accordingly.
class CondorSwitchThemeMode extends StatelessWidget {
  const CondorSwitchThemeMode({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppSettingsBloc, AppSettingsState>(
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
```

The icon and text of the switch are dynamic according to the theme, and when we activate the switch, we call the function in the bloc.