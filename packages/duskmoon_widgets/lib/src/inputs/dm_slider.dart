import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive slider that renders Material or Cupertino styles.
class DmSlider extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive slider.
  const DmSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    this.platformOverride,
  });

  /// The current value of the slider.
  final double value;

  /// Called when the slider value changes; `null` disables interaction.
  final ValueChanged<double>? onChanged;

  /// The minimum selectable value.
  final double min;

  /// The maximum selectable value.
  final double max;

  /// Number of discrete divisions between [min] and [max].
  final int? divisions;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: divisions,
        ),
      DmPlatformStyle.cupertino => CupertinoSlider(
          value: value,
          onChanged: onChanged ?? (_) {},
          min: min,
          max: max,
          divisions: divisions,
        ),
      DmPlatformStyle.fluent => Slider(
          value: value,
          onChanged: onChanged,
          min: min,
          max: max,
          divisions: divisions,
        ),
    };
  }
}
