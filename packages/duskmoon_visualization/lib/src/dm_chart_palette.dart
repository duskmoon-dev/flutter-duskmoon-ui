import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';

import 'dm_viz_series.dart';

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
  final Color? plotBackground;
  final Color? text;
  final Color? mutedText;
  final Color? tooltipBackground;
  final Color? tooltipText;
  final Color? crosshair;
  final Color? selection;
  final Color? missing;

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
    this.plotBackground,
    this.text,
    this.mutedText,
    this.tooltipBackground,
    this.tooltipText,
    this.crosshair,
    this.selection,
    this.missing,
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

typedef VizChartStyle = ({
  Color background,
  Color plot,
  Color grid,
  Color axis,
  Color text,
  TextStyle labelStyle,
  TextStyle bodyStyle,
  TextStyle? titleStyle,
  Color missing,
  Color selectionColor,
  Color tooltipBackground,
  Color tooltipText,
  List<Color> series,
  List<Color> heatmap,
});

VizChartStyle resolveVizChartStyle(
  BuildContext context,
  DmChartPalette? palette,
  DmVizOptions options,
) {
  final theme = Theme.of(context);
  final scheme = theme.colorScheme;
  return (
    background: palette?.background ?? scheme.surface,
    plot: palette?.plotBackground ?? scheme.surfaceContainerLow,
    grid: palette?.grid ?? scheme.outlineVariant,
    axis: palette?.axis ?? scheme.outline,
    text: palette?.text ?? scheme.onSurface,
    labelStyle: (theme.textTheme.labelSmall ?? const TextStyle(fontSize: 12))
        .copyWith(color: palette?.mutedText ?? scheme.onSurfaceVariant),
    titleStyle: theme.textTheme.titleSmall,
    bodyStyle: theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 14),
    selectionColor: palette?.selection ?? scheme.primary,
    tooltipBackground: palette?.tooltipBackground ?? scheme.inverseSurface,
    tooltipText: palette?.tooltipText ?? scheme.onInverseSurface,
    missing: options.missingColor ??
        palette?.missing ??
        scheme.surfaceContainerHighest,
    series: options.seriesColors ??
        [
          palette?.primary ?? scheme.primary,
          palette?.secondary ?? scheme.secondary,
          scheme.tertiary,
          scheme.primaryContainer,
          scheme.secondaryContainer,
          scheme.tertiaryContainer,
        ],
    heatmap: options.heatmapColors ??
        [scheme.surfaceContainerHighest, scheme.primary],
  );
}
