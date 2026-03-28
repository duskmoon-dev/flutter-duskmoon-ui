import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmIconButton extends StatelessWidget with AdaptiveWidget {
  const DmIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.platformOverride,
  });

  final Widget icon;
  final VoidCallback? onPressed;
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
    };
  }
}
