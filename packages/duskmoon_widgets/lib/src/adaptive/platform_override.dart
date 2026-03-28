import 'package:flutter/material.dart';

import 'platform_resolver.dart';

/// An [InheritedWidget] that overrides the platform style for its subtree.
///
/// Wrap a widget tree with [DmPlatformOverride] to force all adaptive
/// widgets below it to render in the given [style].
class DmPlatformOverride extends InheritedWidget {
  /// Creates a platform override with the given [style].
  const DmPlatformOverride({
    super.key,
    required this.style,
    required super.child,
  });

  /// The platform style applied to descendant adaptive widgets.
  final DmPlatformStyle style;

  /// Returns the [DmPlatformStyle] from the nearest ancestor, or `null`.
  static DmPlatformStyle? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DmPlatformOverride>()
        ?.style;
  }

  @override
  bool updateShouldNotify(DmPlatformOverride oldWidget) =>
      style != oldWidget.style;
}
