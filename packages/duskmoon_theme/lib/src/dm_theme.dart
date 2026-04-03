import 'package:flutter/foundation.dart';

import 'dm_colors.dart';

/// Platform-agnostic DuskMoon design-token container.
///
/// Holds [DmColors] only. Does not produce [ThemeData].
/// Use [DmThemeData.fromDmTheme] to convert to a Flutter [ThemeData].
@immutable
class DmTheme {
  /// Creates a [DmTheme] with the given [name] and [colors].
  // ignore: prefer_const_constructors_in_immutables
  DmTheme({
    required this.name,
    required this.colors,
  });

  /// Display name of this theme ("sunshine" | "moonlight").
  final String name;

  /// Resolved color tokens for this theme.
  final DmColors colors;

  /// Sunshine (light) token set.
  static final DmTheme sunshine = DmTheme(
    name: 'sunshine',
    colors: DmColors.sunshine(),
  );

  /// Moonlight (dark) token set.
  static final DmTheme moonlight = DmTheme(
    name: 'moonlight',
    colors: DmColors.moonlight(),
  );

  /// All available themes.
  static final List<DmTheme> all = List.unmodifiable([sunshine, moonlight]);
}
