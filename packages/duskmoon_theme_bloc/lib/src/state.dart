import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class DmThemeState extends Equatable {
  const DmThemeState({
    required this.themeName,
    this.themeMode = ThemeMode.system,
  });

  final String themeName;
  final ThemeMode themeMode;

  DmThemeEntry get entry => DmThemeData.themes.firstWhere(
        (t) => t.name == themeName,
        orElse: () => DmThemeData.themes.first,
      );

  ThemeData resolveTheme(Brightness platformBrightness) {
    final e = entry;
    return switch (themeMode) {
      ThemeMode.light => e.light,
      ThemeMode.dark => e.dark,
      ThemeMode.system =>
        platformBrightness == Brightness.dark ? e.dark : e.light,
    };
  }

  DmThemeState copyWith({String? themeName, ThemeMode? themeMode}) {
    return DmThemeState(
      themeName: themeName ?? this.themeName,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [themeName, themeMode];
}
