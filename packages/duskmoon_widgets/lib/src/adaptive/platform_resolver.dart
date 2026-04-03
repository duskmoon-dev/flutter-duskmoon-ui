import 'package:flutter/material.dart';

import 'dm_platform_style.dart';
export 'dm_platform_style.dart';

/// Resolves the [DmPlatformStyle] for the current context.
///
/// Priority: [widgetOverride] > theme platform.
/// L2 (DmPlatformOverride) and L3 (DuskmoonApp) will be added in a later task.
DmPlatformStyle resolvePlatformStyle(
  BuildContext context, {
  DmPlatformStyle? widgetOverride,
}) {
  if (widgetOverride != null) return widgetOverride;
  return _defaultStyle(Theme.of(context).platform);
}

DmPlatformStyle _defaultStyle(TargetPlatform platform) =>
    switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => DmPlatformStyle.cupertino,
      TargetPlatform.windows => DmPlatformStyle.fluent,
      _ => DmPlatformStyle.material,
    };
