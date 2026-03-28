import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

enum DmButtonVariant { filled, outlined, text, tonal }

class DmButton extends StatelessWidget with AdaptiveWidget {
  const DmButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = DmButtonVariant.filled,
    this.platformOverride,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final DmButtonVariant variant;

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
    return switch (variant) {
      DmButtonVariant.filled =>
        FilledButton(onPressed: onPressed, child: child),
      DmButtonVariant.outlined =>
        OutlinedButton(onPressed: onPressed, child: child),
      DmButtonVariant.text => TextButton(onPressed: onPressed, child: child),
      DmButtonVariant.tonal =>
        FilledButton.tonal(onPressed: onPressed, child: child),
    };
  }

  Widget _buildCupertino(BuildContext context) {
    return CupertinoButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
