import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/fluent_theme_bridge.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive card container that renders Material or Cupertino styles.
class DmCard extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive card.
  const DmCard({
    super.key,
    this.child,
    this.elevation,
    this.margin,
    this.padding,
    this.platformOverride,
  });

  /// The widget below this card in the tree.
  final Widget? child;

  /// Shadow elevation depth.
  final double? elevation;

  /// Outer margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Inner padding applied to [child].
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
      DmPlatformStyle.fluent => wrapWithFluentTheme(
          context,
          fluent.Card(
            padding: padding ?? const EdgeInsets.all(12),
            margin: margin ?? EdgeInsets.zero,
            child: child ?? const SizedBox.shrink(),
          ),
        ),
    };
  }
}
