import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmFab extends StatelessWidget with AdaptiveWidget {
  const DmFab({
    super.key,
    required this.onPressed,
    this.child,
    this.icon,
    this.label,
    this.platformOverride,
  });

  final VoidCallback? onPressed;
  final Widget? child;
  final Widget? icon;
  final Widget? label;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => _buildMaterial(context),
      DmPlatformStyle.cupertino => _buildCupertino(context),
    };
  }

  Widget _buildMaterial(BuildContext context) {
    if (label != null && icon != null) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        icon: icon,
        label: label!,
      );
    }
    return FloatingActionButton(
      onPressed: onPressed,
      child: child ?? icon,
    );
  }

  Widget _buildCupertino(BuildContext context) {
    return CupertinoButton.filled(
      padding: const EdgeInsets.all(16),
      borderRadius: BorderRadius.circular(28),
      onPressed: onPressed,
      child: child ??
          icon ??
          (label != null
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) icon!,
                    if (label != null) label!,
                  ],
                )
              : const SizedBox.shrink()),
    );
  }
}
