import 'package:flutter/material.dart';

/// The two platform rendering styles supported by adaptive widgets.
enum DmPlatformStyle {
  /// Google Material Design rendering.
  material,

  /// Apple Cupertino rendering.
  cupertino,
}

/// Resolves the [DmPlatformStyle] to use for the current context.
///
/// If [widgetOverride] is provided it takes precedence; otherwise the
/// style is inferred from the theme's [TargetPlatform].
DmPlatformStyle resolvePlatformStyle(
  BuildContext context, {
  DmPlatformStyle? widgetOverride,
}) {
  if (widgetOverride != null) return widgetOverride;
  final platform = Theme.of(context).platform;
  return switch (platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => DmPlatformStyle.cupertino,
    _ => DmPlatformStyle.material,
  };
}
