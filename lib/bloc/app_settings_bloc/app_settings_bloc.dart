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

  /// Converts a JSON object into an [AppSettingsState] object.
  /// If the JSON is valid, it returns an [AppSettingsChanged] state with the
  /// new settings. If the conversion fails, it returns the initial state.
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
  /// If the state is [AppSettingsChanged], it serializes the settings model to JSON.
  /// If the state is the initial state, it returns null (no state to persist).
  @override
  Map<String, dynamic>? toJson(AppSettingsState state) {
    if (state is AppSettingsChanged) {
      return state.appSettingsModel.toJson();
    }
    return null;
  }
}
