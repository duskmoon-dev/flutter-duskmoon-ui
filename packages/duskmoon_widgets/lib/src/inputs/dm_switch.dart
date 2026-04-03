import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive toggle switch that renders Material or Cupertino styles.
class DmSwitch extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive switch.
  const DmSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.platformOverride,
  });

  /// Whether the switch is on.
  final bool value;

  /// Called when the switch value changes; `null` disables interaction.
  final ValueChanged<bool>? onChanged;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => Switch(
          value: value,
          onChanged: onChanged,
        ),
      DmPlatformStyle.cupertino => CupertinoSwitch(
          value: value,
          onChanged: onChanged,
        ),
      DmPlatformStyle.fluent => Switch(
          value: value,
          onChanged: onChanged,
        ),
    };
  }
}
