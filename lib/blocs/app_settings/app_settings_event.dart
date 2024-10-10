part of 'app_settings_bloc.dart';

/// Base event for managing the application's settings.
/// Events are actions that trigger changes in the application's settings.
@immutable
sealed class AppSettingsEvent {}

/// Event triggered to change the application settings.
/// This event is dispatched when the user modifies the settings.
class ChangeAppSettings extends AppSettingsEvent {
  final AppSettingsModel appSettingsModel;

  /// Constructor that initializes the event with the updated [appSettingsModel].
  /// The new settings provided will replace the current ones in the state.
  ChangeAppSettings({required this.appSettingsModel});
}
