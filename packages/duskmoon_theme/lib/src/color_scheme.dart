import 'package:flutter/material.dart';

import 'generated/moonlight_tokens.g.dart';
import 'generated/sunshine_tokens.g.dart';

/// Factory for building DuskMoon [ColorScheme] instances from generated tokens.
abstract final class DmColorScheme {
  /// Returns a light [ColorScheme] using the Sunshine design tokens.
  static ColorScheme sunshine() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: SunshineTokens.primary,
      onPrimary: SunshineTokens.primaryContent,
      primaryContainer: SunshineTokens.primaryContainer,
      onPrimaryContainer: SunshineTokens.onPrimaryContainer,
      secondary: SunshineTokens.secondary,
      onSecondary: SunshineTokens.secondaryContent,
      secondaryContainer: SunshineTokens.secondaryContainer,
      onSecondaryContainer: SunshineTokens.onSecondaryContainer,
      tertiary: SunshineTokens.tertiary,
      onTertiary: SunshineTokens.tertiaryContent,
      tertiaryContainer: SunshineTokens.tertiaryContainer,
      onTertiaryContainer: SunshineTokens.onTertiaryContainer,
      error: SunshineTokens.error,
      onError: SunshineTokens.errorContent,
      errorContainer: SunshineTokens.errorContainer,
      onErrorContainer: SunshineTokens.onErrorContainer,
      surface: SunshineTokens.surface,
      onSurface: SunshineTokens.onSurface,
      onSurfaceVariant: SunshineTokens.onSurfaceVariant,
      surfaceDim: SunshineTokens.surfaceDim,
      surfaceBright: SunshineTokens.surfaceBright,
      surfaceContainerLowest: SunshineTokens.surfaceContainerLowest,
      surfaceContainerLow: SunshineTokens.surfaceContainerLow,
      surfaceContainer: SunshineTokens.surfaceContainer,
      surfaceContainerHigh: SunshineTokens.surfaceContainerHigh,
      surfaceContainerHighest: SunshineTokens.surfaceContainerHighest,
      outline: SunshineTokens.outline,
      outlineVariant: SunshineTokens.outlineVariant,
      inverseSurface: SunshineTokens.inverseSurface,
      onInverseSurface: SunshineTokens.inverseOnSurface,
      inversePrimary: SunshineTokens.inversePrimary,
      shadow: SunshineTokens.shadow,
      scrim: SunshineTokens.scrim,
    );
  }

  /// Returns a dark [ColorScheme] using the Moonlight design tokens.
  static ColorScheme moonlight() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: MoonlightTokens.primary,
      onPrimary: MoonlightTokens.primaryContent,
      primaryContainer: MoonlightTokens.primaryContainer,
      onPrimaryContainer: MoonlightTokens.onPrimaryContainer,
      secondary: MoonlightTokens.secondary,
      onSecondary: MoonlightTokens.secondaryContent,
      secondaryContainer: MoonlightTokens.secondaryContainer,
      onSecondaryContainer: MoonlightTokens.onSecondaryContainer,
      tertiary: MoonlightTokens.tertiary,
      onTertiary: MoonlightTokens.tertiaryContent,
      tertiaryContainer: MoonlightTokens.tertiaryContainer,
      onTertiaryContainer: MoonlightTokens.onTertiaryContainer,
      error: MoonlightTokens.error,
      onError: MoonlightTokens.errorContent,
      errorContainer: MoonlightTokens.errorContainer,
      onErrorContainer: MoonlightTokens.onErrorContainer,
      surface: MoonlightTokens.surface,
      onSurface: MoonlightTokens.onSurface,
      onSurfaceVariant: MoonlightTokens.onSurfaceVariant,
      surfaceDim: MoonlightTokens.surfaceDim,
      surfaceBright: MoonlightTokens.surfaceBright,
      surfaceContainerLowest: MoonlightTokens.surfaceContainerLowest,
      surfaceContainerLow: MoonlightTokens.surfaceContainerLow,
      surfaceContainer: MoonlightTokens.surfaceContainer,
      surfaceContainerHigh: MoonlightTokens.surfaceContainerHigh,
      surfaceContainerHighest: MoonlightTokens.surfaceContainerHighest,
      outline: MoonlightTokens.outline,
      outlineVariant: MoonlightTokens.outlineVariant,
      inverseSurface: MoonlightTokens.inverseSurface,
      onInverseSurface: MoonlightTokens.inverseOnSurface,
      inversePrimary: MoonlightTokens.inversePrimary,
      shadow: MoonlightTokens.shadow,
      scrim: MoonlightTokens.scrim,
    );
  }
}
