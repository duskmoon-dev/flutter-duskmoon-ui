import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'dm_theme.dart';
import 'extensions.dart';
import 'text_theme.dart';

/// Bundles a named theme with its light and dark [ThemeData] variants.
@immutable
class DmThemeEntry {
  /// Creates a theme entry with the given [name], [light], and [dark] variants.
  const DmThemeEntry({
    required this.name,
    required this.light,
    required this.dark,
  });

  /// Display name for this theme entry.
  final String name;

  /// Light mode [ThemeData] for this theme.
  final ThemeData light;

  /// Dark mode [ThemeData] for this theme.
  final ThemeData dark;
}

/// Factory for building complete DuskMoon [ThemeData] instances.
///
/// Each static method returns a fully configured Material 3 [ThemeData]
/// with color scheme, text theme, and component theme overrides.
abstract final class DmThemeData {
  /// Returns a light [ThemeData] using the Sunshine color palette.
  static ThemeData sunshine() => _buildThemeData(
        colorScheme: DmColorScheme.sunshine(),
        colorExtension: DmColorExtension.sunshine(),
      );

  /// Returns a dark [ThemeData] using the Moonlight color palette.
  static ThemeData moonlight() => _buildThemeData(
        colorScheme: DmColorScheme.moonlight(),
        colorExtension: DmColorExtension.moonlight(),
      );

  /// Returns a light [ThemeData] using the Forest color palette.
  static ThemeData forest() => _buildThemeData(
        colorScheme: DmColorScheme.forest(),
        colorExtension: DmColorExtension.forest(),
      );

  /// Returns a dark [ThemeData] using the Ocean color palette.
  static ThemeData ocean() => _buildThemeData(
        colorScheme: DmColorScheme.ocean(),
        colorExtension: DmColorExtension.ocean(),
      );

  /// Build [ThemeData] from a [DmTheme] token container.
  static ThemeData fromDmTheme(DmTheme theme) => _buildThemeData(
        colorScheme: theme.colors.colorScheme,
        colorExtension: theme.colors.extension,
      );

  /// Returns all available [DmThemeEntry] instances.
  static List<DmThemeEntry> get themes => [
        DmThemeEntry(
          name: 'duskmoon',
          light: sunshine(),
          dark: moonlight(),
        ),
        DmThemeEntry(
          name: 'ecotone',
          light: forest(),
          dark: ocean(),
        ),
      ];

  static ThemeData _buildThemeData({
    required ColorScheme colorScheme,
    required DmColorExtension colorExtension,
  }) {
    final textTheme = DmTextTheme.textTheme();
    final isLight = colorScheme.brightness == Brightness.light;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      extensions: [colorExtension],
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: colorScheme.surfaceTint,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedIconTheme: IconThemeData(
          color: colorScheme.onSecondaryContainer,
        ),
        unselectedIconTheme: IconThemeData(
          color: colorScheme.onSurfaceVariant,
        ),
        selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        indicatorColor: colorScheme.secondaryContainer,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        indicatorColor: colorScheme.secondaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.onSecondaryContainer);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurface,
            );
          }
          return textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainerLow,
        elevation: isLight ? 1 : 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerLow,
        selectedColor: colorScheme.secondaryContainer,
        labelStyle: textTheme.labelLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
