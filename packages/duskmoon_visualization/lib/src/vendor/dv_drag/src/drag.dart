import 'package:flutter/widgets.dart';

/// Data class representing drag state.
class DragState {
  /// The starting position of the drag.
  final Offset startPosition;

  /// The current position of the drag.
  final Offset currentPosition;

  /// The delta from the last position.
  final Offset delta;

  /// Whether the drag is active.
  final bool isDragging;

  /// Creates a DragState.
  const DragState({
    required this.startPosition,
    required this.currentPosition,
    required this.delta,
    this.isDragging = false,
  });

  /// Initial drag state.
  static const DragState initial = DragState(
    startPosition: Offset.zero,
    currentPosition: Offset.zero,
    delta: Offset.zero,
    isDragging: false,
  );

  /// The total distance dragged.
  Offset get totalDelta => currentPosition - startPosition;

  /// Creates a copy with updated values.
  DragState copyWith({
    Offset? startPosition,
    Offset? currentPosition,
    Offset? delta,
    bool? isDragging,
  }) {
    return DragState(
      startPosition: startPosition ?? this.startPosition,
      currentPosition: currentPosition ?? this.currentPosition,
      delta: delta ?? this.delta,
      isDragging: isDragging ?? this.isDragging,
    );
  }

  @override
  String toString() {
    return 'DragState(start: $startPosition, current: $currentPosition, '
        'delta: $delta, isDragging: $isDragging)';
  }
}

/// A mixin that provides drag behavior for StatefulWidget states.
///
/// This mixin can be added to widget states to enable drag functionality
/// with customizable callbacks and constraints.
mixin DragBehavior<T extends StatefulWidget> on State<T> {
  /// The current drag state.
  DragState dragState = DragState.initial;

  /// Called when a drag operation starts.
  void onDragStart(Offset position) {
    dragState = DragState(
      startPosition: position,
      currentPosition: position,
      delta: Offset.zero,
      isDragging: true,
    );
    setState(() {});
  }

  /// Called when the drag position updates.
  void onDragUpdate(Offset position, Offset delta) {
    dragState = dragState.copyWith(
      currentPosition: position,
      delta: delta,
    );
    setState(() {});
  }

  /// Called when a drag operation ends.
  void onDragEnd() {
    dragState = dragState.copyWith(
      isDragging: false,
      delta: Offset.zero,
    );
    setState(() {});
  }

  /// Called when a drag operation is cancelled.
  void onDragCancel() {
    dragState = DragState.initial;
    setState(() {});
  }

  /// Wraps a child widget with drag gesture detection.
  Widget wrapWithDragDetection(
    Widget child, {
    bool enabled = true,
  }) {
    if (!enabled) return child;

    return GestureDetector(
      onPanStart: (details) => onDragStart(details.localPosition),
      onPanUpdate: (details) => onDragUpdate(
        details.localPosition,
        details.delta,
      ),
      onPanEnd: (details) => onDragEnd(),
      onPanCancel: () => onDragCancel(),
      child: child,
    );
  }
}

/// A controller for managing drag state externally.
class DragController extends ChangeNotifier {
  DragState _state = DragState.initial;

  /// The current drag state.
  DragState get state => _state;

  /// Whether a drag is currently active.
  bool get isDragging => _state.isDragging;

  /// Starts a drag operation.
  void start(Offset position) {
    _state = DragState(
      startPosition: position,
      currentPosition: position,
      delta: Offset.zero,
      isDragging: true,
    );
    notifyListeners();
  }

  /// Updates the drag position.
  void update(Offset position, Offset delta) {
    _state = _state.copyWith(
      currentPosition: position,
      delta: delta,
    );
    notifyListeners();
  }

  /// Ends the drag operation.
  void end() {
    _state = _state.copyWith(
      isDragging: false,
      delta: Offset.zero,
    );
    notifyListeners();
  }

  /// Cancels the drag operation.
  void cancel() {
    _state = DragState.initial;
    notifyListeners();
  }
}

/// Constraints for drag operations.
class DragConstraints {
  /// The minimum x position.
  final double? minX;

  /// The maximum x position.
  final double? maxX;

  /// The minimum y position.
  final double? minY;

  /// The maximum y position.
  final double? maxY;

  /// Creates DragConstraints.
  const DragConstraints({
    this.minX,
    this.maxX,
    this.minY,
    this.maxY,
  });

  /// No constraints.
  static const DragConstraints none = DragConstraints();

  /// Creates constraints from a Rect.
  factory DragConstraints.fromRect(Rect rect) {
    return DragConstraints(
      minX: rect.left,
      maxX: rect.right,
      minY: rect.top,
      maxY: rect.bottom,
    );
  }

  /// Constrains a position to the bounds.
  Offset constrain(Offset position) {
    return Offset(
      position.dx.clamp(
        minX ?? double.negativeInfinity,
        maxX ?? double.infinity,
      ),
      position.dy.clamp(
        minY ?? double.negativeInfinity,
        maxY ?? double.infinity,
      ),
    );
  }

  /// Whether a position is within the constraints.
  bool contains(Offset position) {
    final constrained = constrain(position);
    return constrained == position;
  }
}

/// Direction of allowed drag movement.
enum DragDirection {
  /// Allow horizontal drag only.
  horizontal,

  /// Allow vertical drag only.
  vertical,

  /// Allow drag in both directions.
  both,
}

/// Extension to apply direction constraints to offsets.
extension DragDirectionExtension on DragDirection {
  /// Constrains an offset to the allowed direction.
  Offset constrainDelta(Offset delta) {
    switch (this) {
      case DragDirection.horizontal:
        return Offset(delta.dx, 0);
      case DragDirection.vertical:
        return Offset(0, delta.dy);
      case DragDirection.both:
        return delta;
    }
  }
}
