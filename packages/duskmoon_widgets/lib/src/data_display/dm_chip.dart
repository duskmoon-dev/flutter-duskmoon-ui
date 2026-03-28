import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmChip extends StatelessWidget with AdaptiveWidget {
  const DmChip({
    super.key,
    required this.label,
    this.avatar,
    this.onDeleted,
    this.selected = false,
    this.onSelected,
    this.platformOverride,
  });

  final Widget label;
  final Widget? avatar;
  final VoidCallback? onDeleted;
  final bool selected;
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
