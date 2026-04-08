import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/fluent_theme_bridge.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive icon button that renders Material, Cupertino, or Fluent styles.
class DmIconButton extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive icon button.
  const DmIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.platformOverride,
  });

  /// The icon widget to display.
  final Widget icon;

  /// Callback invoked when the button is tapped, or `null` to disable.
  final VoidCallback? onPressed;

  /// Optional tooltip text shown on long press.
  final String? tooltip;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => IconButton(
          icon: icon,
          onPressed: onPressed,
          tooltip: tooltip,
        ),
      DmPlatformStyle.cupertino => CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: icon,
        ),
      DmPlatformStyle.fluent => wrapWithFluentTheme(
          context,
          fluent.IconButton(
            icon: icon,
            onPressed: onPressed,
          ),
        ),
    };
  }
}
