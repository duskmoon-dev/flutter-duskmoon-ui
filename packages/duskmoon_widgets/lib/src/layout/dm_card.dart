import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmCard extends StatelessWidget with AdaptiveWidget {
  const DmCard({
    super.key,
    this.child,
    this.elevation,
    this.margin,
    this.padding,
    this.platformOverride,
  });

  final Widget? child;
  final double? elevation;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    final content =
        padding != null ? Padding(padding: padding!, child: child) : child;
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => Card(
          elevation: elevation,
          margin: margin,
          child: content,
        ),
      DmPlatformStyle.cupertino => Container(
          margin: margin ?? const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withValues(alpha: 0.1),
                blurRadius: elevation ?? 1,
                offset: Offset(0, (elevation ?? 1) / 2),
              ),
            ],
          ),
          child: content,
        ),
    };
  }
}
