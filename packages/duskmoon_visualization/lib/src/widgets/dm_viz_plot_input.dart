import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';

import '../dm_viz_interaction.dart';

class VizChartController extends ChangeNotifier {
  List<DmVizTarget>? _selection;
  Set<String>? _hidden;
  DmVizViewport? _viewport;
  DmVizTooltipEvent? _tooltip;
  DmVizRange? _brush;

  DmVizInteraction _options = const DmVizInteraction();
  VizInteractionState _initial = vizInitial();
  List<String> _series = const [];
  Set<DmVizTarget> _targets = const {};

  bool get hasViewport => _options.viewport != null || _viewport != null;

  VizInteractionState get state => reconcileVizState(
    (
      ids: _options.selection ?? _selection ?? _initial.ids,
      hidden: _options.hiddenSeriesIds ?? _hidden ?? _initial.hidden,
      viewport: _options.viewport ?? _viewport ?? _initial.viewport,
      tooltip: _tooltip,
      brush: _brush,
    ),
    _series.toSet(),
    _targets,
  );

  void configure({
    required DmVizInteraction interaction,
    required Set<DmVizTarget> targets,
    List<String> series = const [],
    Set<String> initialHidden = const {},
    DmVizViewport? initialViewport,
  }) {
    _options = interaction;
    _series = series;
    _targets = targets;
    _initial = reconcileVizState(
      vizInitial(
        ids: interaction.defaultSelection,
        hidden: initialHidden,
        viewport: initialViewport,
      ),
      series.toSet(),
      targets,
    );

    final current = state;
    if (_selection != null)
      _selection = _selection!.where(targets.contains).toList();
    if (_hidden != null) _hidden = _hidden!.intersection(series.toSet());
    _tooltip = current.tooltip;
  }

  void dispatch(VizAction action) {
    final current = state;
    final result = transitionViz(
      current,
      action,
      initial: _initial,
      series: _series,
      mode: _options.selectionMode,
    );
    final next = result.state;
    if (next != current) {
      if (_options.selection == null && current.ids != next.ids)
        _selection = next.ids;
      if (_options.hiddenSeriesIds == null && current.hidden != next.hidden)
        _hidden = next.hidden;
      if (_options.viewport == null && current.viewport != next.viewport) {
        _viewport = action.type == VizActionType.reset ? null : next.viewport;
      }
      _tooltip = next.tooltip;
      _brush = next.brush;
      notifyListeners();
    }
    for (final event in result.events) {
      _options.onEvent?.call(event);
    }
  }
}

typedef VizHit = ({
  DmVizTooltipEvent tooltip,
  Offset position,
  Rect? rect,
  double radius,
});

class VizPlotInput extends StatefulWidget {
  final Rect Function(Size) bounds;
  final List<VizHit> Function(Rect) items;
  final VizChartController controller;
  final Color selectionColor;
  final Color tooltipBackground;
  final Color tooltipText;
  final void Function(Rect bounds, double x, double y, double factor)? zoom;
  final VizHit? Function(Rect bounds, Offset point)? hitTest;
  final void Function(
    Rect bounds,
    Offset start,
    Offset end,
    DmVizTarget? target,
  )?
  onDrag;
  final void Function(double start, double end)? brush;
  final DmVizRange? brushPixels;

  const VizPlotInput({
    super.key,
    required this.bounds,
    required this.items,
    required this.controller,
    required this.selectionColor,
    required this.tooltipBackground,
    required this.tooltipText,
    this.zoom,
    this.hitTest,
    this.onDrag,
    this.brush,
    this.brushPixels,
  });

  @override
  State<VizPlotInput> createState() => _VizPlotInputState();
}

class _VizPlotInputState extends State<VizPlotInput> {
  int _keyboardIndex = 0;
  Offset? _start;
  Offset? _pressed;
  DmVizTarget? _dragTarget;
  Offset? _position;
  double _scale = 1;
  DmVizRange? _preview;

  void _show(VizHit? hit) => widget.controller.dispatch(
    hit == null
        ? vizAction(VizActionType.blur)
        : vizAction(VizActionType.focus, tooltip: hit.tooltip),
  );

  void _activate(VizHit hit) => widget.controller.dispatch(
    vizAction(VizActionType.activate, target: hit.tooltip.target),
  );

  VizHit? _hit(List<VizHit> items, Offset point) {
    VizHit? hit;
    var best = double.infinity;
    for (final item in items) {
      final rect = item.rect;
      if (rect != null) {
        final tapArea = rect.inflate(
          rect.width == 0 || rect.height == 0 ? 4 : 0,
        );
        if (tapArea.contains(point)) {
          hit = item;
          best = 0;
        }
      } else {
        final distance = (item.position - point).distance;
        if (distance <= item.radius && distance < best) {
          best = distance;
          hit = item;
        }
      }
    }
    return hit;
  }

  void _endGesture(Rect bounds) {
    final start = _start;
    final end = _position;
    final factor = _scale;
    final target = _dragTarget;
    _dragTarget = null;
    _pressed = null;
    _start = null;
    _position = null;
    if (_preview != null) setState(() => _preview = null);
    if (start == null || end == null) return;
    if ((factor - 1).abs() > .03 && widget.zoom != null) {
      widget.zoom!(
        bounds,
        (end.dx - bounds.left) / bounds.width,
        (end.dy - bounds.top) / bounds.height,
        1 / factor,
      );
    } else if ((start.dx - end.dx).abs() > 5 && widget.brush != null) {
      widget.brush!(
        (start.dx - bounds.left) / bounds.width,
        ((end.dx - bounds.left) / bounds.width).clamp(0, 1),
      );
    } else if ((start - end).distance > 5) {
      widget.onDrag?.call(bounds, start, end, target);
    }
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final bounds = widget.bounds(constraints.biggest);
      if (bounds.isEmpty) return const SizedBox.shrink();
      final items = widget.items(bounds);
      final state = widget.controller.state;
      final current = items
          .where((item) => item.tooltip.target == state.tooltip?.target)
          .firstOrNull;
      final range = widget.brushPixels;
      final span =
          _preview ??
          (range == null
              ? null
              : (
                  bounds.left + range.$1.clamp(0, 1) * bounds.width,
                  bounds.left + range.$2.clamp(0, 1) * bounds.width,
                ));
      final tooltip = current?.tooltip;
      final theme = DefaultTextStyle.of(context).style;
      final scaleEnabled =
          widget.zoom != null || widget.brush != null || widget.onDrag != null;
      VizHit? hitAt(Offset point) => widget.hitTest == null
          ? _hit(items, point)
          : widget.hitTest!(bounds, point);
      void zoom(double x, double y, double factor) =>
          widget.zoom?.call(bounds, x, y, factor);

      void inspect(int step) {
        if (items.isEmpty) return;
        _keyboardIndex = (_keyboardIndex + step) % items.length;
        _show(items[_keyboardIndex]);
      }

      void move(Offset direction, {bool moveNode = false}) {
        final hit = !moveNode || items.isEmpty
            ? null
            : items[_keyboardIndex % items.length];
        if (moveNode && hit?.tooltip.target.kind != DmVizTargetKind.node)
          return;
        final start = hit?.position ?? bounds.center;
        final delta = Offset(
          direction.dx * bounds.width / 10,
          direction.dy * bounds.height / 10,
        );
        widget.onDrag?.call(
          bounds,
          start,
          start + (moveNode ? delta : -delta),
          hit?.tooltip.target,
        );
      }

      void extendRange(int direction) {
        final pivot = items.isEmpty
            ? bounds.center.dx
            : items[_keyboardIndex % items.length].position.dx;
        final start = span?.$1 ?? pivot;
        final end = ((span?.$2 ?? pivot) + bounds.width / 10 * direction).clamp(
          bounds.left,
          bounds.right,
        );
        if (start != end)
          widget.brush?.call(
            (start - bounds.left) / bounds.width,
            (end - bounds.left) / bounds.width,
          );
      }

      final arrows = <LogicalKeyboardKey, Offset>{
        LogicalKeyboardKey.arrowLeft: const Offset(-1, 0),
        LogicalKeyboardKey.arrowRight: const Offset(1, 0),
        LogicalKeyboardKey.arrowUp: const Offset(0, -1),
        LogicalKeyboardKey.arrowDown: const Offset(0, 1),
      };
      return Focus(
        onFocusChange: (focused) {
          if (focused && items.isNotEmpty) {
            _show(items[_keyboardIndex % items.length]);
          } else {
            _show(null);
          }
        },
        onKeyEvent: (node, event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          final key = event.logicalKey;
          final direction = arrows[key];
          final keyboard = HardwareKeyboard.instance;
          if (direction != null &&
              keyboard.isShiftPressed &&
              direction.dx != 0 &&
              widget.brush != null) {
            extendRange(direction.dx.toInt());
          } else if (direction != null &&
              widget.onDrag != null &&
              (keyboard.isShiftPressed || keyboard.isAltPressed)) {
            move(direction, moveNode: keyboard.isAltPressed);
          } else if (key == LogicalKeyboardKey.escape) {
            widget.controller.dispatch(vizAction(VizActionType.clearSelection));
          } else if (key == LogicalKeyboardKey.arrowLeft ||
              key == LogicalKeyboardKey.arrowUp) {
            inspect(-1);
          } else if (key == LogicalKeyboardKey.arrowRight ||
              key == LogicalKeyboardKey.arrowDown) {
            inspect(1);
          } else if ((key == LogicalKeyboardKey.enter ||
                  key == LogicalKeyboardKey.space) &&
              items.isNotEmpty) {
            _activate(items[_keyboardIndex % items.length]);
          } else if (widget.zoom != null &&
              (key == LogicalKeyboardKey.equal ||
                  key == LogicalKeyboardKey.minus)) {
            zoom(.5, .5, key == LogicalKeyboardKey.minus ? 1.2 : 1 / 1.2);
          } else {
            return KeyEventResult.ignored;
          }
          return KeyEventResult.handled;
        },
        child: Semantics(
          container: true,
          label: 'Chart data',
          liveRegion: true,
          value: tooltip?.display,
          customSemanticsActions: {
            if (widget.brush != null) ...{
              const CustomSemanticsAction(label: 'Expand range left'): () =>
                  extendRange(-1),
              const CustomSemanticsAction(label: 'Expand range right'): () =>
                  extendRange(1),
            },
            if (widget.onDrag != null) ...{
              const CustomSemanticsAction(label: 'Pan left'): () =>
                  move(const Offset(-1, 0)),
              const CustomSemanticsAction(label: 'Pan right'): () =>
                  move(const Offset(1, 0)),
              const CustomSemanticsAction(label: 'Pan up'): () =>
                  move(const Offset(0, -1)),
              const CustomSemanticsAction(label: 'Pan down'): () =>
                  move(const Offset(0, 1)),
              if (items.isNotEmpty &&
                  items[_keyboardIndex % items.length].tooltip.target.kind ==
                      DmVizTargetKind.node) ...{
                const CustomSemanticsAction(label: 'Move node left'): () =>
                    move(const Offset(-1, 0), moveNode: true),
                const CustomSemanticsAction(label: 'Move node right'): () =>
                    move(const Offset(1, 0), moveNode: true),
                const CustomSemanticsAction(label: 'Move node up'): () =>
                    move(const Offset(0, -1), moveNode: true),
                const CustomSemanticsAction(label: 'Move node down'): () =>
                    move(const Offset(0, 1), moveNode: true),
              },
            },
          },
          increasedValue: tooltip == null
              ? null
              : items[(_keyboardIndex + 1) % items.length].tooltip.display,
          decreasedValue: tooltip == null
              ? null
              : items[(_keyboardIndex - 1) % items.length].tooltip.display,
          onTap: items.isEmpty
              ? null
              : () {
                  final item = items[_keyboardIndex % items.length];
                  _activate(item);
                  _show(item);
                },
          onIncrease: items.isEmpty ? null : () => inspect(1),
          onDecrease: items.isEmpty ? null : () => inspect(-1),
          child: Listener(
            onPointerDown: (event) {
              if (!bounds.inflate(1).contains(event.localPosition) ||
                  _start != null)
                return;
              _pressed = event.localPosition;
              _dragTarget = widget.onDrag == null
                  ? null
                  : hitAt(event.localPosition)?.tooltip.target;
            },
            onPointerCancel: (_) {
              _start = null;
              _position = null;
              _pressed = null;
              _dragTarget = null;
              if (_preview != null) setState(() => _preview = null);
              widget.controller.dispatch(vizAction(VizActionType.cancel));
            },
            onPointerSignal: (event) {
              if (event is! PointerScrollEvent ||
                  widget.zoom == null ||
                  !bounds.contains(event.localPosition))
                return;
              GestureBinding.instance.pointerSignalResolver.register(event, (
                _,
              ) {
                zoom(
                  (event.localPosition.dx - bounds.left) / bounds.width,
                  (event.localPosition.dy - bounds.top) / bounds.height,
                  math.exp(event.scrollDelta.dy.clamp(-300, 300) * .002),
                );
              });
            },
            child: MouseRegion(
              onHover: (event) => _show(
                bounds.contains(event.localPosition)
                    ? hitAt(event.localPosition)
                    : null,
              ),
              onExit: (_) => _show(null),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                onTapUp: (details) {
                  if (!bounds.inflate(1).contains(details.localPosition))
                    return;
                  final hit = hitAt(details.localPosition);
                  if (hit != null) {
                    _activate(hit);
                    _show(hit);
                  }
                },
                onScaleStart: !scaleEnabled
                    ? null
                    : (details) {
                        if (!bounds.contains(details.localFocalPoint)) return;
                        _start = _pressed ?? details.localFocalPoint;
                        _position = _start;
                        _scale = 1;
                      },
                onScaleUpdate: !scaleEnabled
                    ? null
                    : (details) {
                        final start = _start;
                        if (start == null) return;
                        _position = details.localFocalPoint;
                        _scale = details.scale;
                        if (widget.brush != null &&
                            details.pointerCount == 1 &&
                            (start.dx - details.localFocalPoint.dx).abs() > 5) {
                          setState(
                            () => _preview = (
                              start.dx,
                              details.localFocalPoint.dx.clamp(
                                bounds.left,
                                bounds.right,
                              ),
                            ),
                          );
                        }
                      },
                onScaleEnd: !scaleEnabled ? null : (_) => _endGesture(bounds),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (span != null)
                      Positioned.fromRect(
                        rect: Rect.fromLTRB(
                          math.min(span.$1, span.$2),
                          bounds.top,
                          math.max(span.$1, span.$2),
                          bounds.bottom,
                        ),
                        child: IgnorePointer(
                          child: ColoredBox(
                            color: widget.selectionColor.withValues(alpha: .16),
                          ),
                        ),
                      ),
                    for (final item in items.where(
                      (item) => state.ids.contains(item.tooltip.target),
                    ))
                      Positioned.fromRect(
                        rect:
                            item.rect?.inflate(2) ??
                            Rect.fromCircle(center: item.position, radius: 7),
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: widget.selectionColor,
                                width: 2,
                              ),
                              shape: item.rect == null
                                  ? BoxShape.circle
                                  : BoxShape.rectangle,
                            ),
                          ),
                        ),
                      ),
                    if (tooltip != null && current != null)
                      Positioned(
                        left: (current.position.dx + 8).clamp(
                          bounds.left,
                          math.max(bounds.left, bounds.right - 150),
                        ),
                        top: (current.position.dy + 8).clamp(
                          bounds.top,
                          math.max(bounds.top, bounds.bottom - 32),
                        ),
                        child: IgnorePointer(
                          child: ExcludeSemantics(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: widget.tooltipBackground,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                child: Text(
                                  tooltip.display,
                                  style: theme.copyWith(
                                    color: widget.tooltipText,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

class VizActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool? selected;
  final Widget? swatch;
  const VizActionButton(
    this.label, {
    super.key,
    required this.onPressed,
    this.selected,
    this.swatch,
  });

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    selected: selected,
    onTap: onPressed,
    child: FocusableActionDetector(
      mouseCursor: SystemMouseCursors.click,
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            onPressed();
            return null;
          },
        ),
      },
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (swatch case final icon?) ...[icon, const SizedBox(width: 4)],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: selected == false
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
