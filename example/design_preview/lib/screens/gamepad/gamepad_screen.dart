import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

import '../../destination.dart';
import '../../showcase_scaffold.dart';

class GamepadScreen extends StatelessWidget {
  const GamepadScreen({super.key});

  static const name = 'Gamepads';
  static const path = 'gamepads';

  @override
  Widget build(BuildContext context) => ShowcaseScaffold(
        selectedIndex: Destinations.indexOf(const Key('Widgets')),
        appBar: DmAppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          leading: const BackButton(),
          title: const Text('Gamepads'),
          actions: const [PlatformSwitchAction()],
        ),
        body: (_) => ListView(
          key: const ValueKey('gamepads-list'),
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Drag either stick in any direction; release to center. '
              'Hold Xbox/PS5 triggers to increase travel and release to decrease. '
              'Full travel takes one second each way; press again to reverse.',
            ),
            const SizedBox(height: 16),
            for (final style in DmControllerStyle.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _GamepadDemo(
                    key: ValueKey('gamepad-${style.name}'), style: style),
              ),
          ],
        ),
      );
}

class _GamepadDemo extends StatefulWidget {
  const _GamepadDemo({super.key, required this.style});
  final DmControllerStyle style;

  @override
  State<_GamepadDemo> createState() => _GamepadDemoState();
}

class _GamepadDemoState extends State<_GamepadDemo> {
  Offset _leftStick = Offset.zero;
  Offset _rightStick = Offset.zero;
  double _leftTrigger = 0;
  double _rightTrigger = 0;
  bool _showTriggerIndicators = true;
  String _lastButton = 'No button events';

  void _leftStickChanged(Offset value) => setState(() => _leftStick = value);
  void _rightStickChanged(Offset value) => setState(() => _rightStick = value);
  void _leftTriggerChanged(double value) =>
      setState(() => _leftTrigger = value);
  void _rightTriggerChanged(double value) =>
      setState(() => _rightTrigger = value);
  void _pressedChanged(DmControllerButton button, bool pressed) =>
      setState(() => _lastButton = '${button.name} ${pressed ? 'down' : 'up'}');

  Widget _controller() => switch (widget.style) {
        DmControllerStyle.xbox => DmXboxControllerView(
            width: 540,
            showTriggerIndicators: _showTriggerIndicators,
            onLeftStickChanged: _leftStickChanged,
            onRightStickChanged: _rightStickChanged,
            onLeftTriggerChanged: _leftTriggerChanged,
            onRightTriggerChanged: _rightTriggerChanged,
            onPressedChanged: _pressedChanged,
          ),
        DmControllerStyle.dualSense => DmPs5ControllerView(
            width: 540,
            showTriggerIndicators: _showTriggerIndicators,
            onLeftStickChanged: _leftStickChanged,
            onRightStickChanged: _rightStickChanged,
            onLeftTriggerChanged: _leftTriggerChanged,
            onRightTriggerChanged: _rightTriggerChanged,
            onPressedChanged: _pressedChanged,
          ),
        DmControllerStyle.switchPro => DmSwitchProControllerView(
            width: 540,
            onLeftStickChanged: _leftStickChanged,
            onRightStickChanged: _rightStickChanged,
            onLeftTriggerChanged: _leftTriggerChanged,
            onRightTriggerChanged: _rightTriggerChanged,
            onPressedChanged: _pressedChanged,
          ),
      };

  String _stickText(String label, Offset value) =>
      '$label stick: X ${value.dx.toStringAsFixed(2)}  Y ${value.dy.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) => DmCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  switch (widget.style) {
                    DmControllerStyle.xbox => 'Xbox',
                    DmControllerStyle.dualSense => 'PlayStation 5',
                    DmControllerStyle.switchPro => 'Nintendo Switch Pro',
                  },
                  style: Theme.of(context).textTheme.titleLarge),
              if (widget.style != DmControllerStyle.switchPro)
                Row(children: [
                  const Flexible(child: Text('Trigger indicators')),
                  const SizedBox(width: 8),
                  Semantics(
                    label: 'Show ${widget.style.name} trigger indicators',
                    child: DmSwitch(
                      key: ValueKey(
                          '${widget.style.name}-trigger-indicators-toggle'),
                      value: _showTriggerIndicators,
                      onChanged: (value) =>
                          setState(() => _showTriggerIndicators = value),
                    ),
                  ),
                ])
              else
                const Text('ZL/ZR are digital buttons (0 or 100%).'),
              const SizedBox(height: 8),
              Align(child: _controller()),
              Text(_stickText('Left', _leftStick)),
              Text(_stickText('Right', _rightStick)),
              Text(
                  'Triggers: L ${(_leftTrigger * 100).round()}%  R ${(_rightTrigger * 100).round()}%'),
              Text(_lastButton),
            ],
          ),
        ),
      );
}
