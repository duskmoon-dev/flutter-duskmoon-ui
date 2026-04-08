import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

/// Wraps [child] in a [fluent.FluentTheme] derived from the nearest
/// Material [Theme], so that fluent_ui widgets render correctly without
/// requiring the consumer to set up a FluentTheme ancestor.
Widget wrapWithFluentTheme(BuildContext context, Widget child) {
  final colorScheme = Theme.of(context).colorScheme;
  final brightness = Theme.of(context).brightness;

  final fluentTheme = fluent.FluentThemeData(
    brightness: brightness,
    accentColor: fluent.AccentColor.swatch({
      'normal': colorScheme.primary,
    }),
    scaffoldBackgroundColor: colorScheme.surface,
  );

  return fluent.FluentTheme(
    data: fluentTheme,
    child: child,
  );
}
