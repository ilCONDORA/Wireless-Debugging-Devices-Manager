import 'package:flutter/material.dart';

class CondorAppTheme {
  static ThemeData _baseTheme(Brightness brightness) => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: brightness,
        ),
        visualDensity: VisualDensity.compact,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          centerTitle: true,
          titleTextStyle: TextStyle(fontSize: 30),
          scrolledUnderElevation: 0,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 20),
          bodyMedium: TextStyle(fontSize: 20),
          bodySmall: TextStyle(fontSize: 18),
        ),
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: MaterialStatePropertyAll(
              TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            backgroundColor: MaterialStatePropertyAll(Colors.white),
            foregroundColor: MaterialStatePropertyAll(Colors.black),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            padding: MaterialStatePropertyAll(
              EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 18,
              ),
            ),
          ),
        ),
      );

  /// Light theme
  static ThemeData get lightTheme => _baseTheme(Brightness.light).copyWith(
        scaffoldBackgroundColor: Colors.grey.shade300,
        appBarTheme: _baseTheme(Brightness.light).appBarTheme.copyWith(
              titleTextStyle: _baseTheme(Brightness.light)
                  .appBarTheme
                  .titleTextStyle
                  ?.copyWith(
                    color: Colors.black,
                  ),
            ),
      );

  /// Dark theme
  static ThemeData get darkTheme => _baseTheme(Brightness.dark).copyWith(
        appBarTheme: _baseTheme(Brightness.dark).appBarTheme.copyWith(
              titleTextStyle: _baseTheme(Brightness.dark)
                  .appBarTheme
                  .titleTextStyle
                  ?.copyWith(
                    color: Colors.white,
                  ),
            ),
      );
}
