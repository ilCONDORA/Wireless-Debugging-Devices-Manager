import 'package:flutter/material.dart';

class CondorAppTheme {
  static ThemeData _baseTheme() => ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
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
            textStyle: WidgetStatePropertyAll(
              TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            foregroundColor: WidgetStatePropertyAll(Colors.black),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            padding: WidgetStatePropertyAll(
              EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 18,
              ),
            ),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          actionBackgroundColor: Colors.amber,
          actionTextColor: Colors.black,
          contentTextStyle: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      );

  /// Light theme
  static ThemeData get lightTheme => _baseTheme().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade300,
        appBarTheme: _baseTheme().appBarTheme.copyWith(
              titleTextStyle: _baseTheme().appBarTheme.titleTextStyle?.copyWith(
                    color: Colors.black,
                  ),
            ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStatePropertyAll(Colors.grey.shade600),
        ),
      );

  /// Dark theme
  static ThemeData get darkTheme => _baseTheme().copyWith(
        scaffoldBackgroundColor: Colors.grey.shade900,
        appBarTheme: _baseTheme().appBarTheme.copyWith(
              titleTextStyle: _baseTheme().appBarTheme.titleTextStyle?.copyWith(
                    color: Colors.white,
                  ),
            ),
        scrollbarTheme: const ScrollbarThemeData(
          thumbColor: WidgetStatePropertyAll(Colors.white),
        ),
      );
}
