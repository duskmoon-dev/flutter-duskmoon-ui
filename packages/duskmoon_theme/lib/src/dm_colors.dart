import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'extensions.dart';

/// Typed color token bag — color scheme and extension tokens in one place.
///
/// Split into [colorScheme] (maps to Flutter [ColorScheme]) and
/// [extension] (non-ColorScheme tokens via [DmColorExtension]).
@immutable
class DmColors {
  /// Creates a [DmColors] with the given [colorScheme] and [extension].
  const DmColors({
    required this.colorScheme,
    required this.extension,
  });

  /// The Flutter [ColorScheme] for this token set.
  final ColorScheme colorScheme;

  /// The DuskMoon semantic color extension tokens.
  final DmColorExtension extension;

  /// Returns the Sunshine (light) color tokens.
  factory DmColors.sunshine() => DmColors(
        colorScheme: DmColorScheme.sunshine(),
        extension: DmColorExtension.sunshine(),
      );

  /// Returns the Moonlight (dark) color tokens.
  factory DmColors.moonlight() => DmColors(
        colorScheme: DmColorScheme.moonlight(),
        extension: DmColorExtension.moonlight(),
      );
}
