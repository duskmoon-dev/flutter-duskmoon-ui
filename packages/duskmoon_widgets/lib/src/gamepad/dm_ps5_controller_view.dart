import 'package:flutter/material.dart';

import 'dm_controller_view.dart';

class DmPs5ControllerView extends StatelessWidget {
  const DmPs5ControllerView({
    super.key,
    this.width = 420,
    this.pressedButtons = const {},
    this.onPressedChanged,
    this.leftStick = Offset.zero,
    this.rightStick = Offset.zero,
    this.leftTrigger = 0,
    this.rightTrigger = 0,
    this.onLeftStickChanged,
    this.onRightStickChanged,
    this.onLeftTriggerChanged,
    this.onRightTriggerChanged,
    this.showTriggerIndicators = true,
  });
  final double width;
  final Set<DmControllerButton> pressedButtons;
  final DmControllerButtonChanged? onPressedChanged;

  /// Normalized stick positions: right is +X, down is +Y; radius is at most 1.
  final Offset leftStick;
  final Offset rightStick;

  /// Trigger travel in the range 0–1.
  final double leftTrigger;
  final double rightTrigger;

  /// Show side trigger meters for Xbox and DualSense; ignored for Switch Pro.
  final bool showTriggerIndicators;
  final ValueChanged<Offset>? onLeftStickChanged;
  final ValueChanged<Offset>? onRightStickChanged;
  final ValueChanged<double>? onLeftTriggerChanged;
  final ValueChanged<double>? onRightTriggerChanged;

  @override
  Widget build(BuildContext context) => DmControllerView(
        style: DmControllerStyle.dualSense,
        width: width,
        pressedButtons: pressedButtons,
        onPressedChanged: onPressedChanged,
        leftStick: leftStick,
        rightStick: rightStick,
        leftTrigger: leftTrigger,
        rightTrigger: rightTrigger,
        onLeftStickChanged: onLeftStickChanged,
        onRightStickChanged: onRightStickChanged,
        onLeftTriggerChanged: onLeftTriggerChanged,
        onRightTriggerChanged: onRightTriggerChanged,
        showTriggerIndicators: showTriggerIndicators,
      );
}
