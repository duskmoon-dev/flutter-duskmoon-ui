import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'pointer_event.dart';

/// A mixin that provides event handling capabilities for chart widgets.
///
/// This mixin can be added to StatefulWidget states to handle
/// pointer events with chart-specific coordinate transformations.
mixin ChartEventHandler<T extends StatefulWidget> on State<T> {
  /// Called when a pointer enters the chart area.
  void onPointerEnter(ChartPointerEvent event) {}

  /// Called when a pointer exits the chart area.
  void onPointerExit(ChartPointerEvent event) {}

  /// Called when a pointer moves within the chart area.
  void onPointerMove(ChartPointerEvent event) {}

  /// Called when a pointer is pressed down.
  void onPointerDown(ChartPointerEvent event) {}

  /// Called when a pointer is released.
  void onPointerUp(ChartPointerEvent event) {}

  /// Called when a pointer is cancelled.
  void onPointerCancel(ChartPointerEvent event) {}

  /// Called when a scroll/wheel event occurs.
  void onPointerScroll(ChartPointerEvent event) {}

  /// Transforms a local position to chart coordinates.
  /// Override this to provide custom coordinate transformation.
  Offset transformPosition(Offset localPosition) => localPosition;

  /// Creates a ChartPointerEvent from a PointerEvent.
  ChartPointerEvent createChartEvent(PointerEvent event) {
    final chartPosition = transformPosition(event.localPosition);
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

  /// Wraps a child widget with event listeners.
  Widget wrapWithEventListeners(Widget child) {
    return Listener(
      onPointerDown: (event) => onPointerDown(createChartEvent(event)),
      onPointerUp: (event) => onPointerUp(createChartEvent(event)),
      onPointerMove: (event) => onPointerMove(createChartEvent(event)),
      onPointerCancel: (event) => onPointerCancel(createChartEvent(event)),
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          onPointerScroll(createChartEvent(event));
        }
      },
      child: MouseRegion(
        onEnter: (event) => onPointerEnter(createChartEvent(event)),
        onExit: (event) => onPointerExit(createChartEvent(event)),
        child: child,
      ),
    );
  }
}

/// A widget that provides event handling for chart interactions.
///
/// This widget wraps its child and provides callbacks for various
/// pointer events with chart coordinate information.
class ChartEventListener extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Called when a pointer enters the chart area.
  final void Function(ChartPointerEvent event)? onPointerEnter;

  /// Called when a pointer exits the chart area.
  final void Function(ChartPointerEvent event)? onPointerExit;

  /// Called when a pointer moves within the chart area.
  final void Function(ChartPointerEvent event)? onPointerMove;

  /// Called when a pointer is pressed down.
  final void Function(ChartPointerEvent event)? onPointerDown;

  /// Called when a pointer is released.
  final void Function(ChartPointerEvent event)? onPointerUp;

  /// Called when a pointer is cancelled.
  final void Function(ChartPointerEvent event)? onPointerCancel;

  /// Called when a scroll/wheel event occurs.
  final void Function(ChartPointerEvent event)? onPointerScroll;

  /// Optional transformation function for converting local coordinates
  /// to chart coordinates.
  final Offset Function(Offset localPosition)? transformPosition;

  /// Creates a ChartEventListener widget.
  const ChartEventListener({
    super.key,
    required this.child,
    this.onPointerEnter,
    this.onPointerExit,
    this.onPointerMove,
    this.onPointerDown,
    this.onPointerUp,
    this.onPointerCancel,
    this.onPointerScroll,
    this.transformPosition,
  });

  ChartPointerEvent _createChartEvent(PointerEvent event) {
    final chartPosition = transformPosition != null
        ? transformPosition!(event.localPosition)
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

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: onPointerDown != null
          ? (event) => onPointerDown!(_createChartEvent(event))
          : null,
      onPointerUp: onPointerUp != null
          ? (event) => onPointerUp!(_createChartEvent(event))
          : null,
      onPointerMove: onPointerMove != null
          ? (event) => onPointerMove!(_createChartEvent(event))
          : null,
      onPointerCancel: onPointerCancel != null
          ? (event) => onPointerCancel!(_createChartEvent(event))
          : null,
      onPointerSignal: onPointerScroll != null
          ? (event) {
              if (event is PointerScrollEvent) {
                onPointerScroll!(_createChartEvent(event));
              }
            }
          : null,
      child: MouseRegion(
        onEnter: onPointerEnter != null
            ? (event) => onPointerEnter!(_createChartEvent(event))
            : null,
        onExit: onPointerExit != null
            ? (event) => onPointerExit!(_createChartEvent(event))
            : null,
        child: child,
      ),
    );
  }
}
