import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/fluent_theme_bridge.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive chip that renders as a [FilterChip] or plain [Chip].
class DmChip extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive chip.
  const DmChip({
    super.key,
    required this.label,
    this.avatar,
    this.onDeleted,
    this.selected = false,
    this.onSelected,
    this.platformOverride,
  });

  /// The primary content of the chip.
  final Widget label;

  /// Optional leading avatar widget.
  final Widget? avatar;

  /// Callback invoked when the delete icon is tapped.
  final VoidCallback? onDeleted;

  /// Whether the chip is in a selected state.
  final bool selected;

  /// Called when the chip selection state changes; enables filter mode.
  final ValueChanged<bool>? onSelected;

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
    if (onSelected != null) {
      return FilterChip(
        label: label,
        avatar: avatar,
        selected: selected,
        onSelected: onSelected,
      );
    }
    return Chip(label: label, avatar: avatar, onDeleted: onDeleted);
  }

  Widget _buildCupertino(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selected && onSelected != null;
    return GestureDetector(
      onTap: onSelected != null ? () => onSelected!(!selected) : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.15)
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (avatar != null) ...[avatar!, const SizedBox(width: 6)],
            DefaultTextStyle(
              style: TextStyle(
                fontSize: 14,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
              child: label,
            ),
            if (onDeleted != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDeleted,
                child: Icon(
                  CupertinoIcons.xmark_circle_fill,
                  size: 16,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFluent(BuildContext context) {
    final chip = onSelected != null
        ? fluent.ToggleButton(
            checked: selected,
            onChanged: (v) => onSelected!(v),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (avatar != null) ...[avatar!, const SizedBox(width: 4)],
                label,
              ],
            ),
          )
        : fluent.Button(
            onPressed: onDeleted,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (avatar != null) ...[avatar!, const SizedBox(width: 4)],
                label,
                if (onDeleted != null) ...[
                  const SizedBox(width: 4),
                  const Icon(fluent.FluentIcons.chrome_close, size: 12),
                ],
              ],
            ),
          );
    return wrapWithFluentTheme(context, chip);
  }
}
