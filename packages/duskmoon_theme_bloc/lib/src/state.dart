import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Immutable state holding the current theme name and mode.
class DmThemeState extends Equatable {
  /// Creates a [DmThemeState] with the given [themeName] and [themeMode].
  const DmThemeState({
    required this.themeName,
    this.themeMode = ThemeMode.system,
  });

  /// The name of the currently selected theme.
  final String themeName;

  /// The current theme mode (light, dark, or system).
  final ThemeMode themeMode;

  /// Resolves the [DmThemeEntry] matching [themeName].
  DmThemeEntry get entry => DmThemeData.themes.firstWhere(
        (t) => t.name == themeName,
        orElse: () => DmThemeData.themes.first,
      );

  /// Returns the [ThemeData] for the given [platformBrightness].
  ThemeData resolveTheme(Brightness platformBrightness) {
    final e = entry;
    return switch (themeMode) {
      ThemeMode.light => e.light,
      ThemeMode.dark => e.dark,
      ThemeMode.system =>
        platformBrightness == Brightness.dark ? e.dark : e.light,
    };
  }

  /// Returns a copy with the given fields replaced.
  DmThemeState copyWith({String? themeName, ThemeMode? themeMode}) {
    return DmThemeState(
      themeName: themeName ?? this.themeName,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [themeName, themeMode];
}
