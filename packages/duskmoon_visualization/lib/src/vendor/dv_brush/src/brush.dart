import 'package:flutter/widgets.dart';

/// The extent of a brush selection.
class BrushExtent {
  /// The start value of the selection.
  final double start;

  /// The end value of the selection.
  final double end;

  /// Creates a BrushExtent.
  const BrushExtent(this.start, this.end);

  /// Creates an empty extent.
  static const BrushExtent empty = BrushExtent(0, 0);

  /// The minimum value of the selection.
  double get min => start < end ? start : end;

  /// The maximum value of the selection.
  double get max => start > end ? start : end;

  /// The size of the selection.
  double get size => (end - start).abs();

  /// Whether the selection is empty.
  bool get isEmpty => start == end;

  /// Whether a value is within the selection.
  bool contains(double value) => value >= min && value <= max;

  /// Returns a normalized extent where start <= end.
  BrushExtent get normalized => BrushExtent(min, max);

  /// Clamps the extent to the given bounds.
  BrushExtent clamp(double minBound, double maxBound) {
    return BrushExtent(
      start.clamp(minBound, maxBound),
      end.clamp(minBound, maxBound),
    );
  }

  /// Creates a copy with updated values.
  BrushExtent copyWith({double? start, double? end}) {
    return BrushExtent(start ?? this.start, end ?? this.end);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BrushExtent && other.start == start && other.end == end;
  }

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'BrushExtent($start, $end)';
}

/// The state of a brush selection.
enum BrushState {
  /// No brush selection is active.
  idle,

  /// A brush selection is being created.
  brushing,

  /// A brush selection is being moved.
  moving,

  /// A brush selection is being resized from the start.
  resizingStart,

  /// A brush selection is being resized from the end.
  resizingEnd,
}

/// Base class for brush behavior.
///
/// A brush allows the user to select a region of a chart by clicking
/// and dragging. This is commonly used for zooming, filtering, or
/// highlighting data.
abstract class Brush extends StatefulWidget {
  /// The child widget to render inside the brush area.
  final Widget child;

  /// Called when a brush selection is started.
  final void Function(BrushExtent extent)? onBrushStart;

  /// Called when the brush selection changes.
  final void Function(BrushExtent extent)? onBrush;

  /// Called when a brush selection is ended.
  final void Function(BrushExtent extent)? onBrushEnd;

  /// Called when the brush is cleared.
  final void Function()? onBrushClear;

  /// The initial extent of the brush.
  final BrushExtent? initialExtent;

  /// The color of the brush selection overlay.
  final Color overlayColor;

  /// The color of the brush selection border.
  final Color borderColor;

  /// The width of the brush selection border.
  final double borderWidth;

  /// The minimum size of a brush selection.
  final double minSelectionSize;

  /// Whether the brush selection can be moved.
  final bool movable;

  /// Whether the brush selection can be resized.
  final bool resizable;

  /// The size of the resize handles.
  final double handleSize;

  /// Whether to clear the selection on double-tap.
  final bool clearOnDoubleTap;

  /// Creates a Brush widget.
  const Brush({
    super.key,
    required this.child,
    this.onBrushStart,
    this.onBrush,
    this.onBrushEnd,
    this.onBrushClear,
    this.initialExtent,
    this.overlayColor = const Color(0x20000000),
    this.borderColor = const Color(0x80000000),
    this.borderWidth = 1.0,
    this.minSelectionSize = 5.0,
    this.movable = true,
    this.resizable = true,
    this.handleSize = 10.0,
    this.clearOnDoubleTap = true,
  });
}

/// A mixin that provides common brush state management.
mixin BrushStateMixin<T extends Brush> on State<T> {
  /// The current brush extent.
  BrushExtent? extent;

  /// The current brush state.
  BrushState brushState = BrushState.idle;

  /// The starting position of the current gesture.
  Offset? gestureStartPosition;

  /// The extent at the start of the current gesture.
  BrushExtent? gestureStartExtent;

  @override
  void initState() {
    super.initState();
    extent = widget.initialExtent;
  }

  /// Starts a new brush selection.
  void startBrush(double position) {
    final newExtent = BrushExtent(position, position);
    extent = newExtent;
    brushState = BrushState.brushing;
    widget.onBrushStart?.call(newExtent);
    setState(() {});
  }

  /// Updates the brush selection.
  void updateBrush(double position) {
    if (extent == null) return;

    final newExtent = extent!.copyWith(end: position);
    extent = newExtent;
    widget.onBrush?.call(newExtent);
    setState(() {});
  }

  /// Ends the brush selection.
  void endBrush() {
    if (extent == null) return;

    if (extent!.size < widget.minSelectionSize) {
      clearBrush();
    } else {
      extent = extent!.normalized;
      widget.onBrushEnd?.call(extent!);
      brushState = BrushState.idle;
      setState(() {});
    }
  }

  /// Clears the brush selection.
  void clearBrush() {
    extent = null;
    brushState = BrushState.idle;
    widget.onBrushClear?.call();
    setState(() {});
  }

  /// Starts moving the brush selection.
  void startMove(Offset position) {
    gestureStartPosition = position;
    gestureStartExtent = extent;
    brushState = BrushState.moving;
    setState(() {});
  }

  /// Updates the brush position during a move.
  void updateMove(double delta, double minBound, double maxBound) {
    if (gestureStartExtent == null) return;

    var newStart = gestureStartExtent!.start + delta;
    var newEnd = gestureStartExtent!.end + delta;

    // Clamp to bounds
    if (newStart < minBound) {
      final diff = minBound - newStart;
      newStart = minBound;
      newEnd += diff;
    }
    if (newEnd > maxBound) {
      final diff = newEnd - maxBound;
      newEnd = maxBound;
      newStart -= diff;
    }

    extent = BrushExtent(newStart, newEnd);
    widget.onBrush?.call(extent!);
    setState(() {});
  }

  /// Ends moving the brush selection.
  void endMove() {
    gestureStartPosition = null;
    gestureStartExtent = null;
    brushState = BrushState.idle;
    if (extent != null) {
      widget.onBrushEnd?.call(extent!);
    }
    setState(() {});
  }

  /// Starts resizing the brush selection.
  void startResize(bool isStart) {
    gestureStartExtent = extent;
    brushState = isStart ? BrushState.resizingStart : BrushState.resizingEnd;
    setState(() {});
  }

  /// Updates the brush during a resize.
  void updateResize(double position, double minBound, double maxBound) {
    if (gestureStartExtent == null) return;

    final clampedPosition = position.clamp(minBound, maxBound);

    if (brushState == BrushState.resizingStart) {
      extent = BrushExtent(clampedPosition, gestureStartExtent!.end);
    } else {
      extent = BrushExtent(gestureStartExtent!.start, clampedPosition);
    }

    widget.onBrush?.call(extent!);
    setState(() {});
  }

  /// Ends resizing the brush selection.
  void endResize() {
    gestureStartExtent = null;
    brushState = BrushState.idle;
    if (extent != null) {
      extent = extent!.normalized;
      widget.onBrushEnd?.call(extent!);
    }
    setState(() {});
  }
}
