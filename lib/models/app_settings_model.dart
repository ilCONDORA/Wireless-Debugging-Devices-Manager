import 'package:flutter/material.dart';

/// Model for the application settings.
class AppSettingsModel {
  final ThemeMode themeMode;
  final Locale locale;

  /// Sets the default value for the application theme.
  static const ThemeMode defaultThemeMode = ThemeMode.light;

  /// Sets the default value for the application locale.
  static const Locale defaultLocale = Locale('en');

  /// Constructor for creating an AppSettings instance.
  AppSettingsModel({
    this.themeMode = defaultThemeMode,
    this.locale = defaultLocale,
  });

  /// Create an AppSettings instance from a JSON map.
  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      themeMode:
          ThemeMode.values[json['themeMode'] as int? ?? defaultThemeMode.index],
      locale: Locale(json['locale'] as String? ?? defaultLocale.languageCode),
    );
  }

  /// Converts an AppSettings instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'themeMode': themeMode.index,
      'locale': locale.languageCode,
    };
  }

  /// Creates a copy of the current AppSettingsModel with the option to modify specific properties. If a property is not provided, the current value is retained.
  /// This method is used to create a new instance of AppSettingsModel with modified properties.
  AppSettingsModel copyWith({
    ThemeMode? themeMode,
    Locale? locale,
  }) {
    return AppSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
    );
  }
}
