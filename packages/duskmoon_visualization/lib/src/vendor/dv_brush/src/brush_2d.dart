import 'package:flutter/widgets.dart';

import 'brush.dart';

/// The extent of a 2D brush selection.
class Brush2DExtent {
  /// The horizontal extent.
  final BrushExtent x;

  /// The vertical extent.
  final BrushExtent y;

  /// Creates a Brush2DExtent.
  const Brush2DExtent(this.x, this.y);

  /// Creates an empty extent.
  static const Brush2DExtent empty =
      Brush2DExtent(BrushExtent.empty, BrushExtent.empty);

  /// The left edge of the selection.
  double get left => x.min;

  /// The right edge of the selection.
  double get right => x.max;

  /// The top edge of the selection.
  double get top => y.min;

  /// The bottom edge of the selection.
  double get bottom => y.max;

  /// The width of the selection.
  double get width => x.size;

  /// The height of the selection.
  double get height => y.size;

  /// The area of the selection.
  double get area => width * height;

  /// Whether the selection is empty.
  bool get isEmpty => x.isEmpty && y.isEmpty;

  /// Whether a point is within the selection.
  bool contains(double px, double py) => x.contains(px) && y.contains(py);

  /// Returns the selection as a Rect.
  Rect toRect() => Rect.fromLTRB(left, top, right, bottom);

  /// Creates a Brush2DExtent from a Rect.
  factory Brush2DExtent.fromRect(Rect rect) {
    return Brush2DExtent(
      BrushExtent(rect.left, rect.right),
      BrushExtent(rect.top, rect.bottom),
    );
  }

  /// Returns a normalized extent where starts <= ends.
  Brush2DExtent get normalized => Brush2DExtent(x.normalized, y.normalized);

  /// Clamps the extent to the given bounds.
  Brush2DExtent clamp(Rect bounds) {
    return Brush2DExtent(
      x.clamp(bounds.left, bounds.right),
      y.clamp(bounds.top, bounds.bottom),
    );
  }

  /// Creates a copy with updated values.
  Brush2DExtent copyWith({BrushExtent? x, BrushExtent? y}) {
    return Brush2DExtent(x ?? this.x, y ?? this.y);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Brush2DExtent && other.x == x && other.y == y;
  }

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'Brush2DExtent(x: $x, y: $y)';
}

/// The state of a 2D brush selection.
enum Brush2DState {
  /// No brush selection is active.
  idle,

  /// A brush selection is being created.
  brushing,

  /// A brush selection is being moved.
  moving,

  /// A brush selection is being resized from the top-left.
  resizingTopLeft,

  /// A brush selection is being resized from the top-right.
  resizingTopRight,

  /// A brush selection is being resized from the bottom-left.
  resizingBottomLeft,

  /// A brush selection is being resized from the bottom-right.
  resizingBottomRight,

  /// A brush selection is being resized from the top.
  resizingTop,

  /// A brush selection is being resized from the bottom.
  resizingBottom,

  /// A brush selection is being resized from the left.
  resizingLeft,

  /// A brush selection is being resized from the right.
  resizingRight,
}

/// A 2D rectangular brush widget.
///
/// [Brush2D] allows the user to select a rectangular region by clicking
/// and dragging.
class Brush2D extends StatefulWidget {
  /// The child widget to render inside the brush area.
  final Widget child;

  /// Called when a brush selection is started.
  final void Function(Brush2DExtent extent)? onBrushStart;

  /// Called when the brush selection changes.
  final void Function(Brush2DExtent extent)? onBrush;

  /// Called when a brush selection is ended.
  final void Function(Brush2DExtent extent)? onBrushEnd;

  /// Called when the brush is cleared.
  final void Function()? onBrushClear;

  /// The initial extent of the brush.
  final Brush2DExtent? initialExtent;

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

  /// Creates a Brush2D widget.
  const Brush2D({
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

  @override
  State<Brush2D> createState() => _Brush2DState();
}

class _Brush2DState extends State<Brush2D> {
  Brush2DExtent? extent;
  Brush2DState brushState = Brush2DState.idle;
  Offset? gestureStartPosition;
  Brush2DExtent? gestureStartExtent;

  @override
  void initState() {
    super.initState();
    extent = widget.initialExtent;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bounds = Rect.fromLTWH(
          0,
          0,
          constraints.maxWidth,
          constraints.maxHeight,
        );

        return GestureDetector(
          onDoubleTap: widget.clearOnDoubleTap ? _clearBrush : null,
          onPanStart: (details) => _onPanStart(details, bounds),
          onPanUpdate: (details) => _onPanUpdate(details, bounds),
          onPanEnd: (details) => _onPanEnd(),
          child: Stack(
            children: [
              widget.child,
              if (extent != null) _buildSelection(constraints),
            ],
          ),
        );
      },
    );
  }

  void _onPanStart(DragStartDetails details, Rect bounds) {
    final pos = details.localPosition;

    if (extent != null && widget.movable) {
      final normalized = extent!.normalized;
      final rect = normalized.toRect();

      // Check resize handles if resizable
      if (widget.resizable) {
        final state = _getResizeState(pos, rect);
        if (state != null) {
          gestureStartExtent = extent;
          brushState = state;
          setState(() {});
          return;
        }
      }

      // Check if inside selection (for move)
      if (rect.contains(pos)) {
        gestureStartPosition = pos;
        gestureStartExtent = extent;
        brushState = Brush2DState.moving;
        setState(() {});
        return;
      }
    }

    // Start new brush
    _startBrush(pos);
  }

  Brush2DState? _getResizeState(Offset pos, Rect rect) {
    final hs = widget.handleSize;

    final nearLeft = (pos.dx - rect.left).abs() < hs;
    final nearRight = (pos.dx - rect.right).abs() < hs;
    final nearTop = (pos.dy - rect.top).abs() < hs;
    final nearBottom = (pos.dy - rect.bottom).abs() < hs;

    if (nearLeft && nearTop) return Brush2DState.resizingTopLeft;
    if (nearRight && nearTop) return Brush2DState.resizingTopRight;
    if (nearLeft && nearBottom) return Brush2DState.resizingBottomLeft;
    if (nearRight && nearBottom) return Brush2DState.resizingBottomRight;
    if (nearTop) return Brush2DState.resizingTop;
    if (nearBottom) return Brush2DState.resizingBottom;
    if (nearLeft) return Brush2DState.resizingLeft;
    if (nearRight) return Brush2DState.resizingRight;

    return null;
  }

  void _onPanUpdate(DragUpdateDetails details, Rect bounds) {
    final pos = details.localPosition;

    switch (brushState) {
      case Brush2DState.brushing:
        _updateBrush(pos, bounds);
        break;
      case Brush2DState.moving:
        _updateMove(pos, bounds);
        break;
      default:
        if (brushState != Brush2DState.idle) {
          _updateResize(pos, bounds);
        }
        break;
    }
  }

  void _onPanEnd() {
    if (brushState == Brush2DState.brushing) {
      _endBrush();
    } else {
      gestureStartPosition = null;
      gestureStartExtent = null;
      brushState = Brush2DState.idle;
      if (extent != null) {
        extent = extent!.normalized;
        widget.onBrushEnd?.call(extent!);
      }
      setState(() {});
    }
  }

  void _startBrush(Offset pos) {
    extent = Brush2DExtent(
      BrushExtent(pos.dx, pos.dx),
      BrushExtent(pos.dy, pos.dy),
    );
    brushState = Brush2DState.brushing;
    widget.onBrushStart?.call(extent!);
    setState(() {});
  }

  void _updateBrush(Offset pos, Rect bounds) {
    if (extent == null) return;

    final clampedPos = Offset(
      pos.dx.clamp(bounds.left, bounds.right),
      pos.dy.clamp(bounds.top, bounds.bottom),
    );

    extent = extent!.copyWith(
      x: extent!.x.copyWith(end: clampedPos.dx),
      y: extent!.y.copyWith(end: clampedPos.dy),
    );
    widget.onBrush?.call(extent!);
    setState(() {});
  }

  void _endBrush() {
    if (extent == null) return;

    if (extent!.width < widget.minSelectionSize ||
        extent!.height < widget.minSelectionSize) {
      _clearBrush();
    } else {
      extent = extent!.normalized;
      widget.onBrushEnd?.call(extent!);
      brushState = Brush2DState.idle;
      setState(() {});
    }
  }

  void _clearBrush() {
    extent = null;
    brushState = Brush2DState.idle;
    widget.onBrushClear?.call();
    setState(() {});
  }

  void _updateMove(Offset pos, Rect bounds) {
    if (gestureStartPosition == null || gestureStartExtent == null) return;

    final delta = pos - gestureStartPosition!;
    var newX = BrushExtent(
      gestureStartExtent!.x.start + delta.dx,
      gestureStartExtent!.x.end + delta.dx,
    );
    var newY = BrushExtent(
      gestureStartExtent!.y.start + delta.dy,
      gestureStartExtent!.y.end + delta.dy,
    );

    // Clamp to bounds
    if (newX.min < bounds.left) {
      final diff = bounds.left - newX.min;
      newX = BrushExtent(newX.start + diff, newX.end + diff);
    }
    if (newX.max > bounds.right) {
      final diff = newX.max - bounds.right;
      newX = BrushExtent(newX.start - diff, newX.end - diff);
    }
    if (newY.min < bounds.top) {
      final diff = bounds.top - newY.min;
      newY = BrushExtent(newY.start + diff, newY.end + diff);
    }
    if (newY.max > bounds.bottom) {
      final diff = newY.max - bounds.bottom;
      newY = BrushExtent(newY.start - diff, newY.end - diff);
    }

    extent = Brush2DExtent(newX, newY);
    widget.onBrush?.call(extent!);
    setState(() {});
  }

  void _updateResize(Offset pos, Rect bounds) {
    if (gestureStartExtent == null) return;

    final clampedPos = Offset(
      pos.dx.clamp(bounds.left, bounds.right),
      pos.dy.clamp(bounds.top, bounds.bottom),
    );

    var newX = gestureStartExtent!.x;
    var newY = gestureStartExtent!.y;

    switch (brushState) {
      case Brush2DState.resizingTopLeft:
        newX = BrushExtent(clampedPos.dx, gestureStartExtent!.x.end);
        newY = BrushExtent(clampedPos.dy, gestureStartExtent!.y.end);
        break;
      case Brush2DState.resizingTopRight:
        newX = BrushExtent(gestureStartExtent!.x.start, clampedPos.dx);
        newY = BrushExtent(clampedPos.dy, gestureStartExtent!.y.end);
        break;
      case Brush2DState.resizingBottomLeft:
        newX = BrushExtent(clampedPos.dx, gestureStartExtent!.x.end);
        newY = BrushExtent(gestureStartExtent!.y.start, clampedPos.dy);
        break;
      case Brush2DState.resizingBottomRight:
        newX = BrushExtent(gestureStartExtent!.x.start, clampedPos.dx);
        newY = BrushExtent(gestureStartExtent!.y.start, clampedPos.dy);
        break;
      case Brush2DState.resizingTop:
        newY = BrushExtent(clampedPos.dy, gestureStartExtent!.y.end);
        break;
      case Brush2DState.resizingBottom:
        newY = BrushExtent(gestureStartExtent!.y.start, clampedPos.dy);
        break;
      case Brush2DState.resizingLeft:
        newX = BrushExtent(clampedPos.dx, gestureStartExtent!.x.end);
        break;
      case Brush2DState.resizingRight:
        newX = BrushExtent(gestureStartExtent!.x.start, clampedPos.dx);
        break;
      default:
        break;
    }

    extent = Brush2DExtent(newX, newY);
    widget.onBrush?.call(extent!);
    setState(() {});
  }

  Widget _buildSelection(BoxConstraints constraints) {
    final normalized = extent!.normalized;

    return Positioned(
      left: normalized.left,
      top: normalized.top,
      width: normalized.width,
      height: normalized.height,
      child: Container(
        decoration: BoxDecoration(
          color: widget.overlayColor,
          border: Border.all(
            color: widget.borderColor,
            width: widget.borderWidth,
          ),
        ),
        child: widget.resizable ? _buildResizeHandles() : null,
      ),
    );
  }

  Widget _buildResizeHandles() {
    const handleColor = Color(0x00000000);

    return Stack(
      children: [
        // Corner handles
        Positioned(
          left: 0,
          top: 0,
          width: widget.handleSize,
          height: widget.handleSize,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeUpLeft,
            child: Container(color: handleColor),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          width: widget.handleSize,
          height: widget.handleSize,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeUpRight,
            child: Container(color: handleColor),
          ),
        ),
        Positioned(
          left: 0,
          bottom: 0,
          width: widget.handleSize,
          height: widget.handleSize,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeDownLeft,
            child: Container(color: handleColor),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          width: widget.handleSize,
          height: widget.handleSize,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeDownRight,
            child: Container(color: handleColor),
          ),
        ),
        // Edge handles
        Positioned(
          left: widget.handleSize,
          right: widget.handleSize,
          top: 0,
          height: widget.handleSize,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeUp,
            child: Container(color: handleColor),
          ),
        ),
        Positioned(
          left: widget.handleSize,
          right: widget.handleSize,
          bottom: 0,
          height: widget.handleSize,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeDown,
            child: Container(color: handleColor),
          ),
        ),
        Positioned(
          left: 0,
          top: widget.handleSize,
          bottom: widget.handleSize,
          width: widget.handleSize,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeLeft,
            child: Container(color: handleColor),
          ),
        ),
        Positioned(
          right: 0,
          top: widget.handleSize,
          bottom: widget.handleSize,
          width: widget.handleSize,
          child: MouseRegion(
            cursor: SystemMouseCursors.resizeRight,
            child: Container(color: handleColor),
          ),
        ),
      ],
    );
  }
}

/// Creates a Brush2D widget with the given parameters.
Brush2D brush2D({
  required Widget child,
  void Function(Brush2DExtent extent)? onBrushStart,
  void Function(Brush2DExtent extent)? onBrush,
  void Function(Brush2DExtent extent)? onBrushEnd,
  void Function()? onBrushClear,
  Brush2DExtent? initialExtent,
  Color overlayColor = const Color(0x20000000),
  Color borderColor = const Color(0x80000000),
  double borderWidth = 1.0,
  double minSelectionSize = 5.0,
  bool movable = true,
  bool resizable = true,
  double handleSize = 10.0,
  bool clearOnDoubleTap = true,
}) {
  return Brush2D(
    onBrushStart: onBrushStart,
    onBrush: onBrush,
    onBrushEnd: onBrushEnd,
    onBrushClear: onBrushClear,
    initialExtent: initialExtent,
    overlayColor: overlayColor,
    borderColor: borderColor,
    borderWidth: borderWidth,
    minSelectionSize: minSelectionSize,
    movable: movable,
    resizable: resizable,
    handleSize: handleSize,
    clearOnDoubleTap: clearOnDoubleTap,
    child: child,
  );
}
