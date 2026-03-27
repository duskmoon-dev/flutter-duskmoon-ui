import 'package:flutter/material.dart';

extension ThemeModeExtension on ThemeMode {
  static ThemeMode fromString(String? name) {
    return switch (name) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  String get title => switch (this) {
        ThemeMode.system => 'System',
        ThemeMode.light => 'Light',
        ThemeMode.dark => 'Dark',
      };

  Widget get icon => switch (this) {
        ThemeMode.system => const Icon(Icons.brightness_auto),
        ThemeMode.light => const Icon(Icons.light_mode),
        ThemeMode.dark => const Icon(Icons.dark_mode),
      };

  Widget get iconOutlined => switch (this) {
        ThemeMode.system => const Icon(Icons.brightness_auto_outlined),
        ThemeMode.light => const Icon(Icons.light_mode_outlined),
        ThemeMode.dark => const Icon(Icons.dark_mode_outlined),
      };
}
