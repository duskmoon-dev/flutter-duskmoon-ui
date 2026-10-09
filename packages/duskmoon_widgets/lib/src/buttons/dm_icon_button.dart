import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:duskmoon_theme/duskmoon_theme.dart';
import '../adaptive/fluent_theme_bridge.dart';

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

  /// Optional tooltip text and accessible name, shown on hover or long press.
  final String? tooltip;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    final style = resolveStyle(context);
    final button = switch (style) {
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
      DmPlatformStyle.fluent => fluent.IconButton(
          icon: icon,
          onPressed: onPressed,
        ),
    };

    return switch (style) {
      DmPlatformStyle.cupertino when tooltip != null => MergeSemantics(
          child: Semantics(
            label: tooltip,
            enabled: onPressed != null,
            child: Tooltip(
              message: tooltip!,
              excludeFromSemantics: true,
              child: button,
            ),
          ),
        ),
      DmPlatformStyle.fluent => wrapWithFluentTheme(
          context,
          tooltip == null
              ? button
              : MergeSemantics(
                  child: fluent.Tooltip(message: tooltip, child: button),
                ),
        ),
      _ => button,
    };
  }
}
