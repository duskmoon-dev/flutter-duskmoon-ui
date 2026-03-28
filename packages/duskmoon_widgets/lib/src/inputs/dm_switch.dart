import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmSwitch extends StatelessWidget with AdaptiveWidget {
  const DmSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.platformOverride,
  });

  final bool value;
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
    };
  }
}
