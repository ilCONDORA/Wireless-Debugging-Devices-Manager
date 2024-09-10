import 'package:flutter/material.dart';

/// Model for the application settings.
class AppSettingsModel {
  final ThemeMode themeMode;

  /// Sets the default value for the application theme.
  static const ThemeMode defaultThemeMode = ThemeMode.light;

  /// Constructor for creating an AppSettings instance.
  AppSettingsModel({this.themeMode = defaultThemeMode});

  /// Create an AppSettings instance from a JSON map.
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      themeMode:
          ThemeMode.values[json['themeMode'] as int? ?? defaultThemeMode.index],
    );
  }

  /// Converts an AppSettings instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
    };
  }

  /// Creates a copy of the current AppSettingsModel with the option to modify specific properties. If a property is not provided, the current value is retained.
  /// This method is used to create a new instance of AppSettingsModel with modified properties.
  AppSettingsModel copyWith({ThemeMode? themeMode}) {
    return AppSettingsModel(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
