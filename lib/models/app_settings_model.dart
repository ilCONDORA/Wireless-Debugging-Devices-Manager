import 'package:flutter/material.dart';

/// Model for the application settings.
class AppSettingsModel {
  final ThemeMode themeMode;
  final Locale locale;
  final Size windowSize;
  final Offset windowPosition;

  /// Sets the default value for the application theme.
  static const ThemeMode defaultThemeMode = ThemeMode.light;

  /// Sets the default value for the application locale.
  static const Locale defaultLocale = Locale('en');

  /// Sets the default value for the application window size.
  static const Size defaultWindowSize = Size(876, 654);

  /// Sets the default value for the application window position.
  static const Offset defaultWindowPosition = Offset(0, 0);

  /// Constructor for creating an AppSettings instance.
  AppSettingsModel({
    this.themeMode = defaultThemeMode,
    this.locale = defaultLocale,
    this.windowSize = defaultWindowSize,
    this.windowPosition = defaultWindowPosition,
  });

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

  /// Creates a copy of the current AppSettingsModel with the option to modify specific properties. If a property is not provided, the current value is retained.
  /// This method is used to create a new instance of AppSettingsModel with modified properties.
  AppSettingsModel copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    Size? windowSize,
    Offset? windowPosition,
  }) {
    return AppSettingsModel(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      windowSize: windowSize ?? this.windowSize,
      windowPosition: windowPosition ?? this.windowPosition,
    );
  }

  @override
  String toString() => '''
AppSettingsModel: {
    themeMode: $themeMode,
    locale: $locale,
    windowSize: $windowSize,
    windowPosition: $windowPosition
  }
''';
}
