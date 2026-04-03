import 'package:flutter/material.dart';

import 'platform_resolver.dart';

/// Mixin that gives a [StatelessWidget] platform-adaptive rendering.
///
/// Widgets using this mixin call [resolveStyle] to determine whether to
/// build Material, Cupertino, or Fluent UI.
mixin AdaptiveWidget on StatelessWidget {
  /// Optional per-widget platform override; takes highest priority.
  DmPlatformStyle? get platformOverride => null;

  /// Resolves the active [DmPlatformStyle] for this widget.
  ///
  /// Priority: [platformOverride] > [DmPlatformOverride] > [DuskmoonApp] > theme platform.
  DmPlatformStyle resolveStyle(BuildContext context) {
    return resolvePlatformStyle(context, widgetOverride: platformOverride);
  }
}
