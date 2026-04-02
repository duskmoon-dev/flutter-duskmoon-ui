import 'package:flutter/widgets.dart';

import 'brush.dart';

/// A 1D horizontal brush widget.
///
/// [BrushX] allows the user to select a horizontal range by clicking
/// and dragging. The selection spans the full height of the widget.
class BrushX extends Brush {
  /// Creates a BrushX widget.
  const BrushX({
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
  State<BrushX> createState() => _BrushXState();
}

class _BrushXState extends State<BrushX> with BrushStateMixin<BrushX> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        return GestureDetector(
          onDoubleTap: widget.clearOnDoubleTap ? clearBrush : null,
          onPanStart: (details) {
            final x = details.localPosition.dx;

            if (extent != null && widget.movable) {
              final normalized = extent!.normalized;

              // Check if starting on resize handles
              if (widget.resizable) {
                if ((x - normalized.start).abs() < widget.handleSize) {
                  startResize(true);
                  return;
                }
                if ((x - normalized.end).abs() < widget.handleSize) {
                  startResize(false);
                  return;
                }
              }

              // Check if starting inside selection (for move)
              if (x >= normalized.start && x <= normalized.end) {
                startMove(details.localPosition);
                return;
              }
            }

            // Start new brush
            startBrush(x);
          },
          onPanUpdate: (details) {
            final x = details.localPosition.dx;

            switch (brushState) {
              case BrushState.brushing:
                updateBrush(x.clamp(0, width));
                break;
              case BrushState.moving:
                if (gestureStartPosition != null) {
                  final delta = x - gestureStartPosition!.dx;
                  updateMove(delta, 0, width);
                }
                break;
              case BrushState.resizingStart:
              case BrushState.resizingEnd:
                updateResize(x, 0, width);
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
      left: normalized.start,
      top: 0,
      width: normalized.size,
      height: constraints.maxHeight,
      child: Container(
        decoration: BoxDecoration(
          color: widget.overlayColor,
          border: Border(
            left: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
            right: BorderSide(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
        ),
        child: widget.resizable
            ? Stack(
                children: [
                  // Left resize handle
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: widget.handleSize,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
                      child: Container(color: const Color(0x00000000)),
                    ),
                  ),
                  // Right resize handle
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: widget.handleSize,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
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

/// Creates a BrushX widget with the given parameters.
BrushX brushX({
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
  return BrushX(
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
