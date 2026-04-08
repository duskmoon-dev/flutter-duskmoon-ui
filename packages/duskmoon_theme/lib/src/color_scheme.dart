import 'package:flutter/material.dart';

import 'generated/forest_tokens.g.dart';
import 'generated/moonlight_tokens.g.dart';
import 'generated/ocean_tokens.g.dart';
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

  /// Returns a light [ColorScheme] using the Forest design tokens.
  static ColorScheme forest() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: ForestTokens.primary,
      onPrimary: ForestTokens.primaryContent,
      primaryContainer: ForestTokens.primaryContainer,
      onPrimaryContainer: ForestTokens.onPrimaryContainer,
      secondary: ForestTokens.secondary,
      onSecondary: ForestTokens.secondaryContent,
      secondaryContainer: ForestTokens.secondaryContainer,
      onSecondaryContainer: ForestTokens.onSecondaryContainer,
      tertiary: ForestTokens.tertiary,
      onTertiary: ForestTokens.tertiaryContent,
      tertiaryContainer: ForestTokens.tertiaryContainer,
      onTertiaryContainer: ForestTokens.onTertiaryContainer,
      error: ForestTokens.error,
      onError: ForestTokens.errorContent,
      errorContainer: ForestTokens.errorContainer,
      onErrorContainer: ForestTokens.onErrorContainer,
      surface: ForestTokens.surface,
      onSurface: ForestTokens.onSurface,
      onSurfaceVariant: ForestTokens.onSurfaceVariant,
      surfaceDim: ForestTokens.surfaceDim,
      surfaceBright: ForestTokens.surfaceBright,
      surfaceContainerLowest: ForestTokens.surfaceContainerLowest,
      surfaceContainerLow: ForestTokens.surfaceContainerLow,
      surfaceContainer: ForestTokens.surfaceContainer,
      surfaceContainerHigh: ForestTokens.surfaceContainerHigh,
      surfaceContainerHighest: ForestTokens.surfaceContainerHighest,
      outline: ForestTokens.outline,
      outlineVariant: ForestTokens.outlineVariant,
      inverseSurface: ForestTokens.inverseSurface,
      onInverseSurface: ForestTokens.inverseOnSurface,
      inversePrimary: ForestTokens.inversePrimary,
      shadow: ForestTokens.shadow,
      scrim: ForestTokens.scrim,
    );
  }

  /// Returns a dark [ColorScheme] using the Ocean design tokens.
  static ColorScheme ocean() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: OceanTokens.primary,
      onPrimary: OceanTokens.primaryContent,
      primaryContainer: OceanTokens.primaryContainer,
      onPrimaryContainer: OceanTokens.onPrimaryContainer,
      secondary: OceanTokens.secondary,
      onSecondary: OceanTokens.secondaryContent,
      secondaryContainer: OceanTokens.secondaryContainer,
      onSecondaryContainer: OceanTokens.onSecondaryContainer,
      tertiary: OceanTokens.tertiary,
      onTertiary: OceanTokens.tertiaryContent,
      tertiaryContainer: OceanTokens.tertiaryContainer,
      onTertiaryContainer: OceanTokens.onTertiaryContainer,
      error: OceanTokens.error,
      onError: OceanTokens.errorContent,
      errorContainer: OceanTokens.errorContainer,
      onErrorContainer: OceanTokens.onErrorContainer,
      surface: OceanTokens.surface,
      onSurface: OceanTokens.onSurface,
      onSurfaceVariant: OceanTokens.onSurfaceVariant,
      surfaceDim: OceanTokens.surfaceDim,
      surfaceBright: OceanTokens.surfaceBright,
      surfaceContainerLowest: OceanTokens.surfaceContainerLowest,
      surfaceContainerLow: OceanTokens.surfaceContainerLow,
      surfaceContainer: OceanTokens.surfaceContainer,
      surfaceContainerHigh: OceanTokens.surfaceContainerHigh,
      surfaceContainerHighest: OceanTokens.surfaceContainerHighest,
      outline: OceanTokens.outline,
      outlineVariant: OceanTokens.outlineVariant,
      inverseSurface: OceanTokens.inverseSurface,
      onInverseSurface: OceanTokens.inverseOnSurface,
      inversePrimary: OceanTokens.inversePrimary,
      shadow: OceanTokens.shadow,
      scrim: OceanTokens.scrim,
    );
  }
}
