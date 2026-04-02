import 'package:flutter/gestures.dart';

/// A data class representing a pointer event with chart coordinates.
///
/// This class extends Flutter's pointer event information with
/// chart-specific coordinate data for easier integration with
/// data visualization components.
class ChartPointerEvent {
  /// The position of the pointer in the widget's local coordinate space.
  final Offset localPosition;

  /// The position of the pointer in chart data coordinates.
  /// This is the position after any coordinate transformation.
  final Offset chartPosition;

  /// The position of the pointer in the global coordinate space.
  final Offset globalPosition;

  /// Bit field using the constants such as [kPrimaryMouseButton],
  /// [kSecondaryMouseButton], etc.
  final int buttons;

  /// The pressure of the pointer (0.0 to 1.0).
  final double pressure;

  /// The distance the pointer has moved since the last event.
  final Offset delta;

  /// The scroll delta for scroll events.
  final Offset scrollDelta;

  /// The timestamp of the event.
  final Duration timestamp;

  /// The kind of pointer device.
  final PointerDeviceKind kind;

  /// Creates a ChartPointerEvent.
  const ChartPointerEvent({
    required this.localPosition,
    required this.chartPosition,
    required this.globalPosition,
    this.buttons = 0,
    this.pressure = 1.0,
    this.delta = Offset.zero,
    this.scrollDelta = Offset.zero,
    this.timestamp = Duration.zero,
    this.kind = PointerDeviceKind.mouse,
  });

  /// Creates a ChartPointerEvent from a Flutter PointerEvent.
  factory ChartPointerEvent.fromPointerEvent(
    PointerEvent event, {
    Offset Function(Offset)? transformPosition,
  }) {
    final chartPosition = transformPosition != null
        ? transformPosition(event.localPosition)
        : event.localPosition;

    return ChartPointerEvent(
      localPosition: event.localPosition,
      chartPosition: chartPosition,
      globalPosition: event.position,
      buttons: event.buttons,
      pressure: event.pressure,
      delta: event is PointerMoveEvent ? event.delta : Offset.zero,
      scrollDelta:
          event is PointerScrollEvent ? event.scrollDelta : Offset.zero,
      timestamp: event.timeStamp,
      kind: event.kind,
    );
  }

  /// The x coordinate in chart data space.
  double get x => chartPosition.dx;

  /// The y coordinate in chart data space.
  double get y => chartPosition.dy;

  /// The x coordinate in local widget space.
  double get localX => localPosition.dx;

  /// The y coordinate in local widget space.
  double get localY => localPosition.dy;

  /// Whether the primary button (usually left mouse button) is pressed.
  bool get isPrimaryButtonPressed =>
      buttons & kPrimaryMouseButton == kPrimaryMouseButton;

  /// Whether the secondary button (usually right mouse button) is pressed.
  bool get isSecondaryButtonPressed =>
      buttons & kSecondaryMouseButton == kSecondaryMouseButton;

  /// Whether the tertiary button (usually middle mouse button) is pressed.
  bool get isTertiaryButtonPressed =>
      buttons & kMiddleMouseButton == kMiddleMouseButton;

  /// Whether this is a touch event.
  bool get isTouch => kind == PointerDeviceKind.touch;

  /// Whether this is a mouse event.
  bool get isMouse => kind == PointerDeviceKind.mouse;

  /// Whether this is a stylus event.
  bool get isStylus =>
      kind == PointerDeviceKind.stylus ||
      kind == PointerDeviceKind.invertedStylus;

  /// Creates a copy with updated values.
  ChartPointerEvent copyWith({
    Offset? localPosition,
    Offset? chartPosition,
    Offset? globalPosition,
    int? buttons,
    double? pressure,
    Offset? delta,
    Offset? scrollDelta,
    Duration? timestamp,
    PointerDeviceKind? kind,
  }) {
    return ChartPointerEvent(
      localPosition: localPosition ?? this.localPosition,
      chartPosition: chartPosition ?? this.chartPosition,
      globalPosition: globalPosition ?? this.globalPosition,
      buttons: buttons ?? this.buttons,
      pressure: pressure ?? this.pressure,
      delta: delta ?? this.delta,
      scrollDelta: scrollDelta ?? this.scrollDelta,
      timestamp: timestamp ?? this.timestamp,
      kind: kind ?? this.kind,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChartPointerEvent &&
        other.localPosition == localPosition &&
        other.chartPosition == chartPosition &&
        other.globalPosition == globalPosition &&
        other.buttons == buttons &&
        other.pressure == pressure &&
        other.delta == delta &&
        other.scrollDelta == scrollDelta &&
        other.timestamp == timestamp &&
        other.kind == kind;
  }

  @override
  int get hashCode => Object.hash(
        localPosition,
        chartPosition,
        globalPosition,
        buttons,
        pressure,
        delta,
        scrollDelta,
        timestamp,
        kind,
      );

  @override
  String toString() {
    return 'ChartPointerEvent('
        'local: $localPosition, '
        'chart: $chartPosition, '
        'buttons: $buttons, '
        'kind: $kind)';
  }
}
