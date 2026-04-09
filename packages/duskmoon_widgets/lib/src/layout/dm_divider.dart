import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/fluent_theme_bridge.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive horizontal divider that renders Material or Cupertino styles.
class DmDivider extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive divider.
  const DmDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.platformOverride,
  });

  /// Total vertical space occupied by the divider.
  final double? height;

  /// Thickness of the divider line.
  final double? thickness;

  /// Leading indent from the start edge.
  final double? indent;

  /// Trailing indent from the end edge.
  final double? endIndent;

  /// Color of the divider line.
  final Color? color;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => Divider(
          height: height,
          thickness: thickness,
          indent: indent,
          endIndent: endIndent,
          color: color,
        ),
      DmPlatformStyle.cupertino => Container(
          height: height ?? 16,
          alignment: Alignment.center,
          child: Container(
            height: thickness ?? 0.5,
            margin: EdgeInsetsDirectional.only(
              start: indent ?? 0,
              end: endIndent ?? 0,
            ),
            color: color ?? Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
      DmPlatformStyle.fluent => wrapWithFluentTheme(
          context,
          Padding(
            padding: EdgeInsetsDirectional.only(
              start: indent ?? 0,
              end: endIndent ?? 0,
            ),
            child: SizedBox(
              height: height ?? 16,
              child: Center(
                child: fluent.Divider(
                  style: fluent.DividerThemeData(
                    thickness: thickness,
                    decoration:
                        color != null ? BoxDecoration(color: color) : null,
                  ),
                ),
              ),
            ),
          ),
        ),
    };
  }
}
