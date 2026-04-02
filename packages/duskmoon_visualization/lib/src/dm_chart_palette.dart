import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';

/// Theme-derived defaults for DuskMoon visualization wrappers.
class DmChartPalette {
  final Color background;
  final Color grid;
  final Color axis;
  final Color primary;
  final Color secondary;
  final Color positive;
  final Color positiveOnColor;
  final Color warning;
  final Color warningOnColor;
  final Color heatmapBorder;

  const DmChartPalette({
    required this.background,
    required this.grid,
    required this.axis,
    required this.primary,
    required this.secondary,
    required this.positive,
    required this.positiveOnColor,
    required this.warning,
    required this.warningOnColor,
    required this.heatmapBorder,
  });

  factory DmChartPalette.fromTheme(ThemeData theme) {
    final colorScheme = theme.colorScheme;
    final dmColors = theme.extension<DmColorExtension>();

    return DmChartPalette(
      background: colorScheme.surfaceContainerLowest,
      grid: colorScheme.outlineVariant,
      axis: colorScheme.outline,
      primary: colorScheme.primary,
      secondary: dmColors?.accent ?? colorScheme.tertiary,
      positive: dmColors?.success ?? colorScheme.secondary,
      positiveOnColor: dmColors?.successContent ?? colorScheme.onSecondary,
      warning: dmColors?.warning ?? colorScheme.error,
      warningOnColor: dmColors?.warningContent ?? colorScheme.onError,
      heatmapBorder: colorScheme.surface,
    );
  }
}
