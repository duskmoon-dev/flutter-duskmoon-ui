// Placeholder — implementation in Phase 5
import 'package:flutter/material.dart';

import 'platform_resolver.dart';

class DmPlatformOverride extends InheritedWidget {
  const DmPlatformOverride({
    super.key,
    required this.style,
    required super.child,
  });

  final DmPlatformStyle style;

  static DmPlatformStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DmPlatformOverride>()
        ?.style;
  }

  @override
  bool updateShouldNotify(DmPlatformOverride oldWidget) =>
      style != oldWidget.style;
}
