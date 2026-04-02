import 'package:flutter/widgets.dart';

import 'brush.dart';

/// A 1D vertical brush widget.
///
/// [BrushY] allows the user to select a vertical range by clicking
/// and dragging. The selection spans the full width of the widget.
class BrushY extends Brush {
  /// Creates a BrushY widget.
  const BrushY({
    super.key,
    required super.child,
    super.onBrushStart,
    super.onBrush,
    super.onBrushEnd,
    super.onBrushClear,
    super.initialExtent,
    super.overlayColor,
    super.borderColor,
    super.borderWidth,
    super.minSelectionSize,
    super.movable,
    super.resizable,
    super.handleSize,
    super.clearOnDoubleTap,
  });

  @override
  State<BrushY> createState() => _BrushYState();
}

class _BrushYState extends State<BrushY> with BrushStateMixin<BrushY> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;

        return GestureDetector(
          onDoubleTap: widget.clearOnDoubleTap ? clearBrush : null,
          onPanStart: (details) {
            final y = details.localPosition.dy;

            if (extent != null && widget.movable) {
              final normalized = extent!.normalized;

              // Check if starting on resize handles
              if (widget.resizable) {
                if ((y - normalized.start).abs() < widget.handleSize) {
                  startResize(true);
                  return;
                }
                if ((y - normalized.end).abs() < widget.handleSize) {
                  startResize(false);
                  return;
                }
              }

              // Check if starting inside selection (for move)
              if (y >= normalized.start && y <= normalized.end) {
                startMove(details.localPosition);
                return;
              }
            }

            // Start new brush
            startBrush(y);
          },
          onPanUpdate: (details) {
            final y = details.localPosition.dy;

            switch (brushState) {
              case BrushState.brushing:
                updateBrush(y.clamp(0, height));
                break;
              case BrushState.moving:
                if (gestureStartPosition != null) {
                  final delta = y - gestureStartPosition!.dy;
                  updateMove(delta, 0, height);
                }
                break;
              case BrushState.resizingStart:
              case BrushState.resizingEnd:
                updateResize(y, 0, height);
                break;
              case BrushState.idle:
                break;
            }
          },
          onPanEnd: (details) {
            switch (brushState) {
              case BrushState.brushing:
                endBrush();
                break;
              case BrushState.moving:
                endMove();
                break;
              case BrushState.resizingStart:
              case BrushState.resizingEnd:
                endResize();
                break;
              case BrushState.idle:
                break;
            }
          },
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

  Widget _buildSelection(BoxConstraints constraints) {
    final normalized = extent!.normalized;

    return Positioned(
      left: 0,
      top: normalized.start,
      width: constraints.maxWidth,
      height: normalized.size,
      child: Container(
        decoration: BoxDecoration(
          color: widget.overlayColor,
          border: Border(
            top: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
            bottom: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
        ),
        child: widget.resizable
            ? Stack(
                children: [
                  // Top resize handle
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    height: widget.handleSize,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeRow,
                      child: Container(color: const Color(0x00000000)),
                    ),
                  ),
                  // Bottom resize handle
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: widget.handleSize,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeRow,
                      child: Container(color: const Color(0x00000000)),
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}

/// Creates a BrushY widget with the given parameters.
BrushY brushY({
  required Widget child,
  void Function(BrushExtent extent)? onBrushStart,
  void Function(BrushExtent extent)? onBrush,
  void Function(BrushExtent extent)? onBrushEnd,
  void Function()? onBrushClear,
  BrushExtent? initialExtent,
  Color overlayColor = const Color(0x20000000),
  Color borderColor = const Color(0x80000000),
  double borderWidth = 1.0,
  double minSelectionSize = 5.0,
  bool movable = true,
  bool resizable = true,
  double handleSize = 10.0,
  bool clearOnDoubleTap = true,
}) {
  return BrushY(
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
