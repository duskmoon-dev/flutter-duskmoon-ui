import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
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
}
