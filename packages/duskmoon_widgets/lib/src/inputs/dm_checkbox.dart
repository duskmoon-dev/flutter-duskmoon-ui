import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive checkbox that renders Material or Cupertino styles.
class DmCheckbox extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive checkbox.
  const DmCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.platformOverride,
  });

  /// Whether the checkbox is checked.
  final bool value;

  /// Called when the checkbox value changes; `null` disables interaction.
  final ValueChanged<bool?>? onChanged;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => Checkbox(
          value: value,
          onChanged: onChanged,
        ),
      DmPlatformStyle.cupertino => CupertinoCheckbox(
          value: value,
          onChanged: onChanged,
        ),
    };
  }
}
