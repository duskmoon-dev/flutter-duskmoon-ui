import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

/// Visual style variants for [DmButton].
enum DmButtonVariant {
  /// A solid filled button.
  filled,

  /// A button with an outline border.
  outlined,

  /// A plain text-only button.
  text,

  /// A tonally filled button using secondary container colors.
  tonal,
}

/// An adaptive button that renders Material or Cupertino styles.
class DmButton extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive button with the given [variant].
  const DmButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = DmButtonVariant.filled,
    this.platformOverride,
  });

  /// Callback invoked when the button is tapped, or `null` to disable.
  final VoidCallback? onPressed;

  /// The button's content, typically a [Text] widget.
  final Widget child;

  /// The visual variant of the button.
  final DmButtonVariant variant;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => _buildMaterial(context),
      DmPlatformStyle.cupertino => _buildCupertino(context),
      DmPlatformStyle.fluent => _buildMaterial(context),
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
