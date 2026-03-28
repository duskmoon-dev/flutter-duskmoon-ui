import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmAvatar extends StatelessWidget with AdaptiveWidget {
  const DmAvatar({
    super.key,
    this.child,
    this.backgroundImage,
    this.backgroundColor,
    this.radius,
    this.platformOverride,
  });

  final Widget? child;
  final ImageProvider? backgroundImage;
  final Color? backgroundColor;
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
              backgroundColor ??
              Theme.of(context).colorScheme.primaryContainer,
          radius: radius,
          child: child,
        ),
    };
  }
}
