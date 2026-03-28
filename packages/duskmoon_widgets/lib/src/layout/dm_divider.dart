import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmDivider extends StatelessWidget with AdaptiveWidget {
  const DmDivider({
    super.key,
    this.height,
    this.thickness,
    this.indent,
    this.endIndent,
    this.color,
    this.platformOverride,
  });

  final double? height;
  final double? thickness;
  final double? indent;
  final double? endIndent;
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
    };
  }
}
