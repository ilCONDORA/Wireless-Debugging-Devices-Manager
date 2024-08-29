part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {
  final ThemeMode themeMode;
  
  const ThemeState(this.themeMode);
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(ThemeMode.dark);
}

class ThemeChanged extends ThemeState {
  const ThemeChanged(super.themeMode);
}