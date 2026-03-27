// Placeholder — implementation in Phase 5
import 'package:flutter/material.dart';

import 'platform_override.dart';
import 'platform_resolver.dart';

mixin AdaptiveWidget on StatelessWidget {
  DmPlatformStyle? get platformOverride => null;

  DmPlatformStyle resolveStyle(BuildContext context) {
    return resolvePlatformStyle(
      context,
      widgetOverride: platformOverride ?? DmPlatformOverride.maybeOf(context),
    );
  }
}
