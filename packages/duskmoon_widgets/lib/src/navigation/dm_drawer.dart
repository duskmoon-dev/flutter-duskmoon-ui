import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive side drawer that renders Material [Drawer] or Cupertino panel.
class DmDrawer extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive drawer.
  const DmDrawer({
    super.key,
    this.child,
    this.width,
    this.platformOverride,
  });

  /// The content displayed inside the drawer.
  final Widget? child;

  /// Optional fixed width of the drawer.
  final double? width;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => Drawer(width: width, child: child),
      DmPlatformStyle.cupertino => SafeArea(
          child: Container(
            width: width ?? 304,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 0.5,
                ),
              ),
            ),
            child: child,
          ),
        ),
      DmPlatformStyle.fluent => Drawer(width: width, child: child),
    };
  }
}
