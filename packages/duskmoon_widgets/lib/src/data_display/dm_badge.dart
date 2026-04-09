import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/fluent_theme_bridge.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive badge indicator that renders Material or Cupertino styles.
class DmBadge extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive badge.
  const DmBadge({
    super.key,
    this.label,
    this.child,
    this.backgroundColor,
    this.textColor,
    this.platformOverride,
  });

  /// Text content displayed inside the badge.
  final String? label;

  /// The widget that the badge is attached to.
  final Widget? child;

  /// Background color of the badge indicator.
  final Color? backgroundColor;

  /// Color of the badge [label] text.
  final Color? textColor;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => Badge(
          label: label != null ? Text(label!) : null,
          backgroundColor: backgroundColor,
          textColor: textColor,
          child: child,
        ),
      DmPlatformStyle.cupertino => Stack(
          clipBehavior: Clip.none,
          children: [
            if (child != null) child!,
            if (label != null)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color:
                        backgroundColor ?? Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    label!,
                    style: TextStyle(
                      color: textColor ?? Theme.of(context).colorScheme.onError,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      DmPlatformStyle.fluent => _buildFluent(context),
    };
  }

  Widget _buildFluent(BuildContext context) {
    final badge = fluent.InfoBadge(
      source: label != null ? Text(label!) : null,
      color: backgroundColor,
      foregroundColor: textColor,
    );
    if (child == null) {
      return wrapWithFluentTheme(context, badge);
    }
    return wrapWithFluentTheme(
      context,
      Stack(
        clipBehavior: Clip.none,
        children: [
          child!,
          Positioned(right: -4, top: -4, child: badge),
        ],
      ),
    );
  }
}
