import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

/// Localization delegates required for Fluent UI widgets.
///
/// Add this to [MaterialApp.localizationsDelegates] when using Fluent-style
/// adaptive widgets that open overlays (e.g. [DmDropdown] with ComboBox):
///
/// ```dart
/// MaterialApp(
///   localizationsDelegates: dmFluentLocalizationsDelegates,
///   // ...
/// );
/// ```
const List<LocalizationsDelegate<dynamic>> dmFluentLocalizationsDelegates = [
  fluent.FluentLocalizations.delegate,
];

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

  return Localizations.override(
    context: context,
    delegates: const [
      fluent.FluentLocalizations.delegate,
    ],
    child: fluent.FluentTheme(
      data: fluentTheme,
      child: child,
    ),
  );
}
