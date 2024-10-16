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
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            textStyle: const WidgetStatePropertyAll(
              TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            backgroundColor: WidgetStateColor.resolveWith(
              (states) => states.contains(WidgetState.disabled)
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white,
            ),
            foregroundColor: const WidgetStatePropertyAll(Colors.black),
            shape: const WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
            ),
            padding: const WidgetStatePropertyAll(
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
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade900, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade600, width: 1.5),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade600, width: 1.5),
          ),
          labelStyle: const TextStyle(color: Colors.black, fontSize: 26),
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
