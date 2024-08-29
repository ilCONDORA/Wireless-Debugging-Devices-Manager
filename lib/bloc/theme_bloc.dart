import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeInitial()) {
    on<ChangeTheme>((event, emit) {
      emit(ThemeChanged(event.themeMode));
    });
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final themeMode = ThemeMode.values[json['themeMode'] as int];
    return ThemeChanged(themeMode);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    if (state is ThemeChanged) {
      return {'themeMode': state.themeMode.index};
    }
    return null;
  }
}