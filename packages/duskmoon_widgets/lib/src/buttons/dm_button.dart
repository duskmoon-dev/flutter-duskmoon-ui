import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:duskmoon_theme/duskmoon_theme.dart';
import '../adaptive/fluent_theme_bridge.dart';

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

/// An adaptive button that renders Material, Cupertino, or Fluent styles.
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
      DmPlatformStyle.fluent => _buildFluent(context),
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
    const size = CupertinoButtonSize.medium;
    return switch (variant) {
      DmButtonVariant.filled => CupertinoButton.filled(
          sizeStyle: size, onPressed: onPressed, child: child),
      DmButtonVariant.outlined => _buildCupertinoOutlined(context, size),
      DmButtonVariant.text =>
        CupertinoButton(sizeStyle: size, onPressed: onPressed, child: child),
      DmButtonVariant.tonal => CupertinoButton.tinted(
          sizeStyle: size, onPressed: onPressed, child: child),
    };
  }

  Widget _buildCupertinoOutlined(
      BuildContext context, CupertinoButtonSize size) {
    final theme = CupertinoTheme.of(context);
    final color = onPressed != null
        ? theme.primaryColor
        : CupertinoColors.quaternarySystemFill;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: const BorderRadius.all(Radius.circular(8)),
      ),
      child:
          CupertinoButton(sizeStyle: size, onPressed: onPressed, child: child),
    );
  }

  Widget _buildFluent(BuildContext context) {
    final button = switch (variant) {
      DmButtonVariant.filled =>
        fluent.FilledButton(onPressed: onPressed, child: child),
      DmButtonVariant.outlined =>
        fluent.OutlinedButton(onPressed: onPressed, child: child),
      DmButtonVariant.text =>
        fluent.HyperlinkButton(onPressed: onPressed, child: child),
      DmButtonVariant.tonal =>
        fluent.Button(onPressed: onPressed, child: child),
    };
    return wrapWithFluentTheme(context, button);
  }
}
