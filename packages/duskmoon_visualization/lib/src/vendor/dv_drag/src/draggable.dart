import 'package:flutter/widgets.dart';

import 'drag.dart';

/// A widget that wraps its child with drag behavior.
///
/// [Draggable] provides a convenient way to make any widget draggable
/// with customizable callbacks and constraints.
class DraggableWidget extends StatefulWidget {
  /// The child widget to make draggable.
  final Widget child;

  /// Called when a drag operation starts.
  final void Function(DragState state)? onDragStart;

  /// Called when the drag position updates.
  final void Function(DragState state)? onDragUpdate;

  /// Called when a drag operation ends.
  final void Function(DragState state)? onDragEnd;

  /// Called when a drag operation is cancelled.
  final void Function()? onDragCancel;

  /// Whether drag is enabled.
  final bool enabled;

  /// The direction of allowed drag movement.
  final DragDirection direction;

  /// Constraints for the drag operation.
  final DragConstraints? constraints;

  /// The hit test behavior for the gesture detector.
  final HitTestBehavior behavior;

  /// Optional feedback widget to show during drag.
  final Widget Function(BuildContext context, DragState state)? feedbackBuilder;

  /// Creates a DraggableWidget.
  const DraggableWidget({
    super.key,
    required this.child,
    this.onDragStart,
    this.onDragUpdate,
    this.onDragEnd,
    this.onDragCancel,
    this.enabled = true,
    this.direction = DragDirection.both,
    this.constraints,
    this.behavior = HitTestBehavior.deferToChild,
    this.feedbackBuilder,
  });

  @override
  State<DraggableWidget> createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget>
    with DragBehavior<DraggableWidget> {
  @override
  void onDragStart(Offset position) {
    super.onDragStart(position);
    widget.onDragStart?.call(dragState);
  }

  @override
  void onDragUpdate(Offset position, Offset delta) {
    // Apply direction constraints
    final constrainedDelta = widget.direction.constrainDelta(delta);

    // Calculate new position
    var newPosition = dragState.currentPosition + constrainedDelta;

    // Apply bounds constraints
    if (widget.constraints != null) {
      newPosition = widget.constraints!.constrain(newPosition);
    }

    super.onDragUpdate(newPosition, constrainedDelta);
    widget.onDragUpdate?.call(dragState);
  }

  @override
  void onDragEnd() {
    widget.onDragEnd?.call(dragState);
    super.onDragEnd();
  }

  @override
  void onDragCancel() {
    widget.onDragCancel?.call();
    super.onDragCancel();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final detector = GestureDetector(
      behavior: widget.behavior,
      onPanStart: (details) => onDragStart(details.localPosition),
      onPanUpdate: (details) => onDragUpdate(
        details.localPosition,
        details.delta,
      ),
      onPanEnd: (details) => onDragEnd(),
      onPanCancel: () => onDragCancel(),
      child: widget.child,
    );

    if (widget.feedbackBuilder != null && dragState.isDragging) {
      return Stack(
        children: [
          detector,
          Positioned(
            left: dragState.currentPosition.dx,
            top: dragState.currentPosition.dy,
            child: widget.feedbackBuilder!(context, dragState),
          ),
        ],
      );
    }

    return detector;
  }
}

/// A widget that can be positioned by dragging.
///
/// Unlike [DraggableWidget] which reports drag state through callbacks,
/// [PositionedDraggable] actually moves its child based on drag gestures.
class PositionedDraggable extends StatefulWidget {
  /// The child widget.
  final Widget child;

  /// The initial position.
  final Offset initialPosition;

  /// Called when the position changes.
  final void Function(Offset position)? onPositionChanged;

  /// Whether drag is enabled.
  final bool enabled;

  /// The direction of allowed drag movement.
  final DragDirection direction;

  /// Constraints for the drag operation.
  final DragConstraints? constraints;

  /// Creates a PositionedDraggable widget.
  const PositionedDraggable({
    super.key,
    required this.child,
    this.initialPosition = Offset.zero,
    this.onPositionChanged,
    this.enabled = true,
    this.direction = DragDirection.both,
    this.constraints,
  });

  @override
  State<PositionedDraggable> createState() => _PositionedDraggableState();
}

class _PositionedDraggableState extends State<PositionedDraggable> {
  late Offset position;

  @override
  void initState() {
    super.initState();
    position = widget.initialPosition;
  }

  @override
  void didUpdateWidget(PositionedDraggable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialPosition != oldWidget.initialPosition) {
      position = widget.initialPosition;
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled) return;

    final delta = widget.direction.constrainDelta(details.delta);
    var newPosition = position + delta;

    if (widget.constraints != null) {
      newPosition = widget.constraints!.constrain(newPosition);
    }

    setState(() {
      position = newPosition;
    });

    widget.onPositionChanged?.call(position);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        onPanUpdate: _handleDragUpdate,
        child: widget.child,
      ),
    );
  }
}

/// Creates a DraggableWidget with the given parameters.
DraggableWidget draggableWidget({
  required Widget child,
  void Function(DragState state)? onDragStart,
  void Function(DragState state)? onDragUpdate,
  void Function(DragState state)? onDragEnd,
  void Function()? onDragCancel,
  bool enabled = true,
  DragDirection direction = DragDirection.both,
  DragConstraints? constraints,
  HitTestBehavior behavior = HitTestBehavior.deferToChild,
  Widget Function(BuildContext context, DragState state)? feedbackBuilder,
}) {
  return DraggableWidget(
    onDragStart: onDragStart,
    onDragUpdate: onDragUpdate,
    onDragEnd: onDragEnd,
    onDragCancel: onDragCancel,
    enabled: enabled,
    direction: direction,
    constraints: constraints,
    behavior: behavior,
    feedbackBuilder: feedbackBuilder,
    child: child,
  );
}
