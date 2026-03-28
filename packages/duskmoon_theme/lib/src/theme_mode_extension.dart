import 'package:flutter/material.dart';

/// Convenience helpers on [ThemeMode] for serialization and UI display.
extension ThemeModeExtension on ThemeMode {
  /// Parses a [ThemeMode] from its string name, defaulting to [ThemeMode.system].
  static ThemeMode fromString(String? name) {
    return switch (name) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  /// Human-readable display title for this theme mode.
  String get title => switch (this) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };

  /// Filled icon widget representing this theme mode.
  Widget get icon => switch (this) {
        ThemeMode.system => const Icon(Icons.brightness_auto),
        ThemeMode.light => const Icon(Icons.light_mode),
        ThemeMode.dark => const Icon(Icons.dark_mode),
      };

  /// Outlined icon widget representing this theme mode.
  Widget get iconOutlined => switch (this) {
        ThemeMode.system => const Icon(Icons.brightness_auto_outlined),
        ThemeMode.light => const Icon(Icons.light_mode_outlined),
        ThemeMode.dark => const Icon(Icons.dark_mode_outlined),
      };
}
