import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

part 'controller_shell_painter.dart';
part 'controller_symbols.dart';

/// Canonical logical controls; model-specific face button labels differ.
enum DmControllerButton {
  south,
  east,
  west,
  north,
  dpadUp,
  dpadDown,
  dpadLeft,
  dpadRight,
  leftBumper,
  rightBumper,
  leftTrigger,
  rightTrigger,
  leftStick,
  rightStick,
  select,
  start,
  home,
  capture,
  touchpad,
}

enum DmControllerStyle { xbox, dualSense, switchPro }

typedef DmControllerButtonChanged = void Function(
    DmControllerButton button, bool pressed);

/// Controller layout with continuous stick and trigger input.
///
/// [pressedButtons] can be updated from real input. All input conversion must be
/// performed by an adapter outside this UI package.
class DmControllerView extends StatefulWidget {
  const DmControllerView({
    super.key,
    required this.style,
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
    this.width = 420,
  });

  final DmControllerStyle style;
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
  final double width;

  @override
  State<DmControllerView> createState() => _ControllerViewState();
}

class _ControllerViewState extends State<DmControllerView>
    with TickerProviderStateMixin {
  final Set<DmControllerButton> _pointerPressed = {};

  final _pointers = <DmControllerButton, Set<int>>{};
  final _origins = <DmControllerButton, Offset>{};
  final _stickValues = <DmControllerButton, Offset>{};
  final _triggerValues = <DmControllerButton, double>{};

  late final Map<DmControllerButton, AnimationController> _triggerAnimations;

  @override
  void initState() {
    super.initState();
    _triggerAnimations = {
      for (final id in [
        DmControllerButton.leftTrigger,
        DmControllerButton.rightTrigger,
      ])
        id: AnimationController(
          vsync: this,
          duration: const Duration(seconds: 1),
        ),
    };
    for (final entry in _triggerAnimations.entries) {
      entry.value.addListener(() => _setTrigger(entry.key, entry.value.value));
      entry.value.addStatusListener((status) {
        if (status == AnimationStatus.dismissed &&
            !(_pointers[entry.key]?.isNotEmpty ?? false)) {
          setState(() => _triggerValues.remove(entry.key));
        }
      });
    }
  }

  @override
  void dispose() {
    for (final animation in _triggerAnimations.values) {
      animation.dispose();
    }
    super.dispose();
  }

  void _setTrigger(DmControllerButton id, double value) {
    setState(() => _triggerValues[id] = value);
    (id == DmControllerButton.leftTrigger
            ? widget.onLeftTriggerChanged
            : widget.onRightTriggerChanged)
        ?.call(value);
  }

  void _driveTrigger(DmControllerButton id, bool down) {
    if (widget.style == DmControllerStyle.switchPro) {
      _setTrigger(id, down ? 1 : 0);
      if (!down) _triggerValues.remove(id);
      return;
    }
    final animation = _triggerAnimations[id]!;
    if (down) {
      animation.value = _triggerValue(id);
      animation.forward();
    } else {
      animation.reverse();
    }
  }

  bool _isStick(DmControllerButton id) =>
      id == DmControllerButton.leftStick || id == DmControllerButton.rightStick;
  bool _isTrigger(DmControllerButton id) =>
      id == DmControllerButton.leftTrigger ||
      id == DmControllerButton.rightTrigger;

  Offset _normalize(Offset value) {
    if (!value.dx.isFinite || !value.dy.isFinite) return Offset.zero;
    return value.distance > 1 ? value / value.distance : value;
  }

  double _fraction(double value) => value.isFinite ? value.clamp(0.0, 1.0) : 0;

  Offset _stickValue(DmControllerButton id) => _normalize(
        _stickValues[id] ??
            (id == DmControllerButton.leftStick
                ? widget.leftStick
                : widget.rightStick),
      );

  double _triggerValue(DmControllerButton id) => _fraction(
        _triggerValues[id] ??
            (id == DmControllerButton.leftTrigger
                ? widget.leftTrigger
                : widget.rightTrigger),
      );

  void _analog(DmControllerButton id, Offset delta) {
    if (_isStick(id)) {
      final value = _normalize(delta / 24);
      setState(() => _stickValues[id] = value);
      (id == DmControllerButton.leftStick
              ? widget.onLeftStickChanged
              : widget.onRightStickChanged)
          ?.call(value);
    }
  }

  void _down(DmControllerButton id, PointerDownEvent event) {
    final pointers = _pointers.putIfAbsent(id, () => <int>{});
    // Each analog control has one owner; other controls remain independent.
    if ((_isStick(id) || _isTrigger(id)) && pointers.isNotEmpty) return;
    pointers.add(event.pointer);
    _origins[id] = event.localPosition;
    _setPressed(id, true);
    if (_isStick(id)) _analog(id, Offset.zero);
    if (_isTrigger(id)) _driveTrigger(id, true);
  }

  void _move(DmControllerButton id, PointerMoveEvent event) {
    if (!(_pointers[id]?.contains(event.pointer) ?? false)) return;
    _analog(id, event.localPosition - _origins[id]!);
  }

  void _up(DmControllerButton id, PointerEvent event) {
    final pointers = _pointers[id];
    if (pointers == null || !pointers.remove(event.pointer)) return;
    if (pointers.isNotEmpty) return;
    if (_isStick(id)) {
      _analog(id, Offset.zero);
      _stickValues.remove(id);
    }
    if (_isTrigger(id)) _driveTrigger(id, false);
    _origins.remove(id);
    _setPressed(id, false);
  }

  bool _pressed(DmControllerButton button) =>
      widget.pressedButtons.contains(button) ||
      _pointerPressed.contains(button);

  void _setPressed(DmControllerButton button, bool pressed) {
    if (pressed == _pointerPressed.contains(button)) return;
    setState(
      () => pressed
          ? _pointerPressed.add(button)
          : _pointerPressed.remove(button),
    );
    widget.onPressedChanged?.call(button, pressed);
  }

  Color get _accent => switch (widget.style) {
        DmControllerStyle.xbox => const Color(0xff8bc478),
        DmControllerStyle.dualSense => const Color(0xff82abed),
        DmControllerStyle.switchPro => const Color(0xff81b8ad),
      };

  Widget _control(
    DmControllerButton id,
    Offset center,
    Size size, {
    required Widget child,
    double radius = 100,
    bool flush = false,
    Color base = const Color(0xff25292e),
  }) {
    final active = _pressed(id) || (_isTrigger(id) && _triggerValue(id) > 0);
    return Positioned.fromRect(
      rect: Rect.fromCenter(
        center: center,
        width: size.width,
        height: size.height,
      ),
      child: Semantics(
        label: '${widget.style.name} ${id.name}',
        button: true,
        value: _isStick(id)
            ? '${_stickValue(id).dx.toStringAsFixed(2)}, ${_stickValue(id).dy.toStringAsFixed(2)}'
            : _isTrigger(id)
                ? '${(_triggerValue(id) * 100).round()}%'
                : active
                    ? 'pressed'
                    : 'released',
        child: Listener(
          key: ValueKey('${widget.style.name}-${id.name}'),
          behavior: HitTestBehavior.opaque,
          onPointerDown: (event) => _down(id, event),
          onPointerMove: (event) => _move(id, event),
          onPointerUp: (event) => _up(id, event),
          onPointerCancel: (event) => _up(id, event),
          child: RawGestureDetector(
            behavior: HitTestBehavior.opaque,
            gestures: {
              if (_isStick(id) || _isTrigger(id))
                EagerGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                    EagerGestureRecognizer>(EagerGestureRecognizer.new, (_) {}),
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 90),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active
                    ? Color.alphaBlend(_accent.withValues(alpha: .3), base)
                    : flush
                        ? const Color(0x0025292e)
                        : base,
                borderRadius: BorderRadius.circular(radius),
                border: flush && !active
                    ? null
                    : Border.all(
                        color: active ? _accent : const Color(0xff50555c),
                        width: active ? 1.8 : 1,
                      ),
                boxShadow: flush
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: active ? .15 : .4,
                          ),
                          blurRadius: active ? 2 : 4,
                          offset: Offset(0, active ? 1 : 3),
                        ),
                        if (active)
                          BoxShadow(
                            color: _accent.withValues(alpha: .18),
                            blurRadius: 10,
                          ),
                      ],
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _triggerIndicator(bool left) {
    final id =
        left ? DmControllerButton.leftTrigger : DmControllerButton.rightTrigger;
    final value = _triggerValue(id);
    final label = widget.style == DmControllerStyle.dualSense
        ? (left ? 'L2' : 'R2')
        : (left ? 'LT' : 'RT');
    return Positioned(
      left: left ? 0 : null,
      right: left ? null : 0,
      top: 110,
      width: 40,
      height: 142,
      child: IgnorePointer(
        child: Semantics(
          label: '$label trigger travel',
          value: '${(value * 100).round()}%',
          child: ExcludeSemantics(
            child: Column(
              key: ValueKey('${widget.style.name}-${id.name}-indicator'),
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12),
                  textScaler: TextScaler.noScaling,
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: Container(
                    width: 16,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: _accent.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _accent.withValues(alpha: .5)),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FractionallySizedBox(
                        key: ValueKey(
                          '${widget.style.name}-${id.name}-indicator-fill',
                        ),
                        heightFactor: value,
                        widthFactor: 1,
                        child: ColoredBox(color: _accent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${(value * 100).round()}%',
                  style: const TextStyle(fontSize: 11),
                  textScaler: TextScaler.noScaling,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _text(
    String text, {
    double size = 13,
    Color color = const Color(0xffd7dbe0),
  }) =>
      Text(
        text,
        textScaler: TextScaler.noScaling,
        style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: FontWeight.w600,
          height: 1,
        ),
      );

  Widget _symbol(
    _Symbol symbol, {
    Color color = const Color(0xffc5cad1),
    double size = 18,
  }) =>
      CustomPaint(
        size: Size.square(size),
        painter: _SymbolPainter(symbol, color),
      );

  Widget _stick(DmControllerButton id, Offset center) => _control(
        id,
        center,
        const Size.square(76),
        base: const Color(0xff16191d),
        child: Transform.translate(
          key: ValueKey('${widget.style.name}-${id.name}-cap'),
          offset: _stickValue(id) * 18,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xff454a50), Color(0xff25292e)],
              ),
              border: Border.all(color: const Color(0xff5a6067), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x90000000),
                  offset: Offset(0, 3),
                  blurRadius: 3,
                ),
              ],
            ),
            child: Center(
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff30343a),
                  border: Border.all(color: const Color(0xff41464d)),
                ),
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final isPs = style == DmControllerStyle.dualSense;
    final isXbox = style == DmControllerStyle.xbox;
    final (leftStick, rightStick, dpad, face) = switch (style) {
      DmControllerStyle.xbox => (
          const Offset(160, 164),
          const Offset(387, 245),
          const Offset(211, 246),
          const Offset(447, 163),
        ),
      DmControllerStyle.dualSense => (
          const Offset(235, 235),
          const Offset(365, 235),
          const Offset(153, 171),
          const Offset(447, 171),
        ),
      DmControllerStyle.switchPro => (
          const Offset(160, 162),
          const Offset(388, 244),
          const Offset(211, 246),
          const Offset(447, 161),
        ),
    };
    final labels = switch (style) {
      DmControllerStyle.xbox => ('A', 'B', 'X', 'Y'),
      DmControllerStyle.dualSense => ('', '', '', ''),
      DmControllerStyle.switchPro => ('B', 'A', 'Y', 'X'),
    };
    const faceColors = [
      Color(0xff82c66b),
      Color(0xffdf767c),
      Color(0xff7baad7),
      Color(0xffe4ca78),
    ];
    final faces = [
      DmControllerButton.south,
      DmControllerButton.east,
      DmControllerButton.west,
      DmControllerButton.north,
    ];
    const faceOffsets = [
      Offset(0, 37),
      Offset(37, 0),
      Offset(-37, 0),
      Offset(0, -37),
    ];
    final faceLabels = [labels.$1, labels.$2, labels.$3, labels.$4];
    const faceSymbols = [
      _Symbol.cross,
      _Symbol.circle,
      _Symbol.square,
      _Symbol.triangle,
    ];

    return SizedBox(
      width: widget.width,
      child: AspectRatio(
        aspectRatio: 600 / 380,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 600,
            height: 380,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _ControllerShellPainter(style)),
                ),
                if (widget.showTriggerIndicators &&
                    style != DmControllerStyle.switchPro)
                  for (final left in [true, false]) _triggerIndicator(left),
                // Shoulders sit behind the top edge, rather than floating above it.
                for (final left in [true, false]) ...[
                  _control(
                    left
                        ? DmControllerButton.leftTrigger
                        : DmControllerButton.rightTrigger,
                    Offset(left ? 145 : 455, 62),
                    const Size(82, 26),
                    radius: 10,
                    base: const Color(0xff191d22),
                    child: SizedBox.expand(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            left: 5,
                            right: 5,
                            bottom: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: _triggerValue(
                                  left
                                      ? DmControllerButton.leftTrigger
                                      : DmControllerButton.rightTrigger,
                                ),
                                child: Container(height: 3, color: _accent),
                              ),
                            ),
                          ),
                          _text(
                            left
                                ? (isPs
                                    ? 'L2'
                                    : isXbox
                                        ? 'LT'
                                        : 'ZL')
                                : (isPs
                                    ? 'R2'
                                    : isXbox
                                        ? 'RT'
                                        : 'ZR'),
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  _control(
                    left
                        ? DmControllerButton.leftBumper
                        : DmControllerButton.rightBumper,
                    Offset(left ? 146 : 454, 87),
                    const Size(100, 23),
                    radius: 8,
                    base: const Color(0xff30353c),
                    child: _text(
                      left
                          ? (isPs
                              ? 'L1'
                              : isXbox
                                  ? 'LB'
                                  : 'L')
                          : (isPs
                              ? 'R1'
                              : isXbox
                                  ? 'RB'
                                  : 'R'),
                      size: 12,
                    ),
                  ),
                ],
                if (isPs)
                  _control(
                    DmControllerButton.touchpad,
                    const Offset(300, 132),
                    const Size(164, 70),
                    radius: 13,
                    base: const Color(0xffdadde3),
                    child: const CustomPaint(
                      size: Size(150, 56),
                      painter: _TouchpadPainter(),
                    ),
                  ),
                Positioned.fromRect(
                  rect: Rect.fromCenter(center: dpad, width: 90, height: 90),
                  child: const CustomPaint(painter: _DpadPainter()),
                ),
                for (final (id, offset, symbol, size) in [
                  (
                    DmControllerButton.dpadUp,
                    const Offset(0, -26),
                    _Symbol.up,
                    const Size(28, 30),
                  ),
                  (
                    DmControllerButton.dpadDown,
                    const Offset(0, 26),
                    _Symbol.down,
                    const Size(28, 30),
                  ),
                  (
                    DmControllerButton.dpadLeft,
                    const Offset(-26, 0),
                    _Symbol.left,
                    const Size(30, 28),
                  ),
                  (
                    DmControllerButton.dpadRight,
                    const Offset(26, 0),
                    _Symbol.right,
                    const Size(30, 28),
                  ),
                ])
                  _control(
                    id,
                    dpad + offset,
                    size,
                    radius: 5,
                    flush: true,
                    child: _symbol(
                      symbol,
                      size: 10,
                      color: const Color(0xff8d949d),
                    ),
                  ),
                for (var i = 0; i < faces.length; i++)
                  _control(
                    faces[i],
                    face + faceOffsets[i],
                    const Size.square(32),
                    base: isPs
                        ? const Color(0xff343a43)
                        : const Color(0xff202429),
                    child: isPs
                        ? _symbol(faceSymbols[i], size: 15)
                        : _text(
                            faceLabels[i],
                            size: 18,
                            color: isXbox
                                ? faceColors[i]
                                : const Color(0xffe2e5e9),
                          ),
                  ),
                _stick(DmControllerButton.leftStick, leftStick),
                _stick(DmControllerButton.rightStick, rightStick),
                if (isPs) ...[
                  _control(
                    DmControllerButton.select,
                    const Offset(202, 125),
                    const Size(17, 29),
                    radius: 7,
                    child: _symbol(_Symbol.view, size: 10),
                  ),
                  _control(
                    DmControllerButton.start,
                    const Offset(398, 125),
                    const Size(17, 29),
                    radius: 7,
                    child: _symbol(_Symbol.menu, size: 10),
                  ),
                  _control(
                    DmControllerButton.home,
                    const Offset(300, 240),
                    const Size(26, 24),
                    radius: 6,
                    child: _text('PS', size: 11),
                  ),
                  _control(
                    DmControllerButton.capture,
                    const Offset(300, 277),
                    const Size(26, 9),
                    radius: 4,
                    child: Container(
                      width: 12,
                      height: 2,
                      color: const Color(0xff8d949d),
                    ),
                  ),
                ] else if (isXbox) ...[
                  _control(
                    DmControllerButton.home,
                    const Offset(300, 129),
                    const Size.square(30),
                    child: _symbol(
                      _Symbol.xbox,
                      size: 19,
                      color: const Color(0xffeceef1),
                    ),
                  ),
                  _control(
                    DmControllerButton.select,
                    const Offset(262, 174),
                    const Size.square(23),
                    child: _symbol(_Symbol.view, size: 12),
                  ),
                  _control(
                    DmControllerButton.start,
                    const Offset(338, 174),
                    const Size.square(23),
                    child: _symbol(_Symbol.menu, size: 12),
                  ),
                  _control(
                    DmControllerButton.capture,
                    const Offset(300, 211),
                    const Size.square(20),
                    child: _symbol(_Symbol.share, size: 11),
                  ),
                ] else ...[
                  _control(
                    DmControllerButton.select,
                    const Offset(254, 145),
                    const Size.square(23),
                    child: _symbol(_Symbol.minus, size: 12),
                  ),
                  _control(
                    DmControllerButton.start,
                    const Offset(346, 145),
                    const Size.square(23),
                    child: _symbol(_Symbol.plus, size: 12),
                  ),
                  _control(
                    DmControllerButton.capture,
                    const Offset(267, 202),
                    const Size.square(21),
                    radius: 4,
                    child: _symbol(_Symbol.capture, size: 12),
                  ),
                  _control(
                    DmControllerButton.home,
                    const Offset(333, 202),
                    const Size.square(24),
                    child: _symbol(_Symbol.home, size: 13),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
