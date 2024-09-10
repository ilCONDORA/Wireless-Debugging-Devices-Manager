part of 'app_settings_bloc.dart';

/// Base state for managing the application's settings.
/// It holds an instance of `AppSettingsModel`, which contains the current settings.
@immutable
sealed class AppSettingsState {
  final AppSettingsModel appSettingsModel;

  /// Constructor that initializes the state with the provided [appSettingsModel].
  const AppSettingsState(this.appSettingsModel);
}

/// Represents the initial state of the application settings.
/// This state is used when the app is first launched or when the settings are not yet loaded.
class AppSettingsInitial extends AppSettingsState {
  /// Creates an initial state with default settings using the `AppSettingsModel` default constructor.
  AppSettingsInitial() : super(AppSettingsModel());
}

/// Represents a state where the application settings have changed.
/// This state is emitted when the user updates any of the settings.
class AppSettingsChanged extends AppSettingsState {
  /// Constructor that accepts a new [appSettingsModel] to represent the updated settings.
  const AppSettingsChanged(super.appSettingsModel);
}
