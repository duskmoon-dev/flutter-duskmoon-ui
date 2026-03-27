// Placeholder — implementation in Phase 5
import 'package:flutter/material.dart';

enum DmPlatformStyle { material, cupertino }

DmPlatformStyle resolvePlatformStyle(BuildContext context, {
  DmPlatformStyle? widgetOverride,
}) {
  if (widgetOverride != null) return widgetOverride;
  final platform = Theme.of(context).platform;
  return switch (platform) {
    TargetPlatform.iOS || TargetPlatform.macOS => DmPlatformStyle.cupertino,
    _ => DmPlatformStyle.material,
  };
}
