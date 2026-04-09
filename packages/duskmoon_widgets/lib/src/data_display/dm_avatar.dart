import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/fluent_theme_bridge.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive circular avatar that renders Material or Cupertino styles.
class DmAvatar extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive avatar.
  const DmAvatar({
    super.key,
    this.child,
    this.backgroundImage,
    this.backgroundColor,
    this.radius,
    this.platformOverride,
  });

  /// The widget displayed inside the avatar (e.g. initials).
  final Widget? child;

  /// Background image of the avatar.
  final ImageProvider? backgroundImage;

  /// Background color when no image is provided.
  final Color? backgroundColor;

  /// Radius of the avatar circle.
  final double? radius;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => CircleAvatar(
          backgroundImage: backgroundImage,
          backgroundColor: backgroundColor,
          radius: radius,
          child: child,
        ),
      DmPlatformStyle.cupertino => CircleAvatar(
          backgroundImage: backgroundImage,
          backgroundColor:
              backgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
          radius: radius,
          child: child,
        ),
      DmPlatformStyle.fluent => _buildFluent(context),
    };
  }

  Widget _buildFluent(BuildContext context) {
    return wrapWithFluentTheme(
      context,
      Builder(builder: (context) {
        final fluentTheme = fluent.FluentTheme.of(context);
        return CircleAvatar(
          backgroundImage: backgroundImage,
          backgroundColor: backgroundColor ?? fluentTheme.accentColor,
          radius: radius,
          child: child,
        );
      }),
    );
  }
}
