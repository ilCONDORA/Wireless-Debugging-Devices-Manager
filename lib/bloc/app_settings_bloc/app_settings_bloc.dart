import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:wireless_debugging_devices_manager/models/app_settings_model.dart';

part 'app_settings_event.dart';
part 'app_settings_state.dart';

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
