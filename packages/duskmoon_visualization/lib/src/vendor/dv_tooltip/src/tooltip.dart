import 'package:flutter/widgets.dart';

/// The position of a tooltip relative to its target.
enum TooltipPosition {
  /// Above the target.
  top,

  /// Below the target.
  bottom,

  /// To the left of the target.
  left,

  /// To the right of the target.
  right,

  /// Automatically determined based on available space.
  auto,
}

/// A tooltip widget for displaying information about chart data points.
///
/// The [ChartTooltip] widget provides a customizable tooltip that can be
/// positioned relative to a target point and styled to match the chart's
/// design.
class ChartTooltip extends StatelessWidget {
  /// The content to display in the tooltip.
  final Widget child;

  /// The position of the tooltip relative to the target.
  final Offset targetPosition;

  /// The preferred position of the tooltip.
  final TooltipPosition position;

  /// The offset from the target position.
  final Offset offset;

  /// The background color of the tooltip.
  final Color? backgroundColor;

  /// The border radius of the tooltip.
  final BorderRadius borderRadius;

  /// The padding inside the tooltip.
  final EdgeInsets padding;

  /// The box shadow for the tooltip.
  final List<BoxShadow>? boxShadow;

  /// The border for the tooltip.
  final Border? border;

  /// The maximum width of the tooltip.
  final double? maxWidth;

  /// Whether to show the tooltip arrow.
  final bool showArrow;

  /// The size of the arrow.
  final double arrowSize;

  /// Creates a ChartTooltip widget.
  const ChartTooltip({
    super.key,
    required this.child,
    required this.targetPosition,
    this.position = TooltipPosition.top,
    this.offset = const Offset(0, 8),
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    this.boxShadow,
    this.border,
    this.maxWidth,
    this.showArrow = true,
    this.arrowSize = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _calculateLeft(),
      top: _calculateTop(),
      child: Container(
        constraints:
            maxWidth != null ? BoxConstraints(maxWidth: maxWidth!) : null,
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFF2D2D2D),
          borderRadius: borderRadius,
          border: border,
          boxShadow: boxShadow ??
              const [
                BoxShadow(
                  color: Color(0x40000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
        ),
        padding: padding,
        child: child,
      ),
    );
  }

  double _calculateLeft() {
    switch (position) {
      case TooltipPosition.left:
        return targetPosition.dx - offset.dx;
      case TooltipPosition.right:
        return targetPosition.dx + offset.dx;
      case TooltipPosition.top:
      case TooltipPosition.bottom:
      case TooltipPosition.auto:
        return targetPosition.dx;
    }
  }

  double _calculateTop() {
    switch (position) {
      case TooltipPosition.top:
        return targetPosition.dy - offset.dy;
      case TooltipPosition.bottom:
        return targetPosition.dy + offset.dy;
      case TooltipPosition.left:
      case TooltipPosition.right:
      case TooltipPosition.auto:
        return targetPosition.dy;
    }
  }
}

/// A controller for managing tooltip visibility and position.
class TooltipController extends ChangeNotifier {
  Offset? _position;
  dynamic _data;
  bool _isVisible = false;

  /// The current position of the tooltip target.
  Offset? get position => _position;

  /// The data associated with the current tooltip.
  dynamic get data => _data;

  /// Whether the tooltip is currently visible.
  bool get isVisible => _isVisible;

  /// Shows the tooltip at the given position with the given data.
  void show(Offset position, dynamic data) {
    _position = position;
    _data = data;
    _isVisible = true;
    notifyListeners();
  }

  /// Updates the tooltip position without changing visibility or data.
  void updatePosition(Offset position) {
    _position = position;
    notifyListeners();
  }

  /// Hides the tooltip.
  void hide() {
    _isVisible = false;
    notifyListeners();
  }

  /// Clears all tooltip data.
  void clear() {
    _position = null;
    _data = null;
    _isVisible = false;
    notifyListeners();
  }
}

/// A widget that manages a tooltip overlay for a chart.
///
/// This widget provides a convenient way to show/hide tooltips
/// based on user interactions.
class TooltipOverlay extends StatefulWidget {
  /// The child widget (usually a chart).
  final Widget child;

  /// The controller for managing tooltip state.
  final TooltipController controller;

  /// The builder function for creating tooltip content.
  final Widget Function(BuildContext context, dynamic data) tooltipBuilder;

  /// The preferred position of the tooltip.
  final TooltipPosition position;

  /// The offset from the target position.
  final Offset offset;

  /// The background color of the tooltip.
  final Color? backgroundColor;

  /// The border radius of the tooltip.
  final BorderRadius borderRadius;

  /// The padding inside the tooltip.
  final EdgeInsets padding;

  /// Creates a TooltipOverlay widget.
  const TooltipOverlay({
    super.key,
    required this.child,
    required this.controller,
    required this.tooltipBuilder,
    this.position = TooltipPosition.top,
    this.offset = const Offset(0, 8),
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  });

  @override
  State<TooltipOverlay> createState() => _TooltipOverlayState();
}

class _TooltipOverlayState extends State<TooltipOverlay> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(TooltipOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (widget.controller.isVisible && widget.controller.position != null)
          ChartTooltip(
            targetPosition: widget.controller.position!,
            position: widget.position,
            offset: widget.offset,
            backgroundColor: widget.backgroundColor,
            borderRadius: widget.borderRadius,
            padding: widget.padding,
            child: widget.tooltipBuilder(context, widget.controller.data),
          ),
      ],
    );
  }
}
