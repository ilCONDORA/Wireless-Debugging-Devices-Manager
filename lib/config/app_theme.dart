import 'package:flutter/material.dart';

class CondorAppTheme {
  /// Light theme
  static ThemeData get lightTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.light,
        ),
        visualDensity: VisualDensity.compact,
      );

  /// Dark theme
  static ThemeData get darkTheme => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        visualDensity: VisualDensity.compact,
      );
}
