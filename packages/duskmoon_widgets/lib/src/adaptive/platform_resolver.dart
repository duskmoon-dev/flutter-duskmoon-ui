import 'package:flutter/material.dart';

import 'dm_platform_style.dart';
import 'duskmoon_app.dart';
import 'platform_override.dart';

export 'dm_platform_style.dart';

/// Resolves the [DmPlatformStyle] for the current context.
///
/// Resolution order:
/// 1. [widgetOverride] (per-widget parameter)
/// 2. Nearest [DmPlatformOverride] ancestor (subtree override)
/// 3. Nearest [DuskmoonApp] ancestor (app-level override)
/// 4. Platform default from [Theme.of(context).platform]
DmPlatformStyle resolvePlatformStyle(
  BuildContext context, {
  DmPlatformStyle? widgetOverride,
}) {
  if (widgetOverride != null) return widgetOverride;

  final subtreeOverride = DmPlatformOverride.maybeOf(context);
  if (subtreeOverride != null) return subtreeOverride;

  final appStyle = DuskmoonApp.maybeStyleOf(context);
  if (appStyle != null) return appStyle;

  return _defaultStyle(Theme.of(context).platform);
}

DmPlatformStyle _defaultStyle(TargetPlatform platform) =>
    switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => DmPlatformStyle.cupertino,
      TargetPlatform.windows => DmPlatformStyle.fluent,
      _ => DmPlatformStyle.material,
    };
