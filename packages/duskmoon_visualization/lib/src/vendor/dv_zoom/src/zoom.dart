import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'zoom_transform.dart';

/// A widget that provides zoom and pan behavior using GestureDetector.
///
/// [Zoom] wraps its child and handles zoom/pan gestures, transforming
/// the child widget according to user interactions.
class Zoom extends StatefulWidget {
  /// The child widget to zoom and pan.
  final Widget child;

  /// Called when the zoom transform changes.
  final void Function(ZoomTransform transform)? onZoomChange;

  /// Called when zoom starts.
  final void Function(ZoomTransform transform)? onZoomStart;

  /// Called when zoom ends.
  final void Function(ZoomTransform transform)? onZoomEnd;

  /// The initial transform.
  final ZoomTransform? initialTransform;

  /// The minimum scale factor.
  final double minScale;

  /// The maximum scale factor.
  final double maxScale;

  /// Whether panning is enabled.
  final bool panEnabled;

  /// Whether zooming is enabled.
  final bool zoomEnabled;

  /// Whether double-tap to zoom is enabled.
  final bool doubleTapZoomEnabled;

  /// The scale factor for double-tap zoom.
  final double doubleTapZoomScale;

  /// Whether mouse wheel zoom is enabled.
  final bool wheelZoomEnabled;

  /// The scale factor for mouse wheel zoom.
  final double wheelZoomFactor;

  /// Whether to constrain panning to bounds.
  final bool constrainPan;

  /// The bounds for panning constraints.
  final Rect? panBounds;

  /// Creates a Zoom widget.
  const Zoom({
    super.key,
    required this.child,
    this.onZoomChange,
    this.onZoomStart,
    this.onZoomEnd,
    this.initialTransform,
    this.minScale = 0.1,
    this.maxScale = 10.0,
    this.panEnabled = true,
    this.zoomEnabled = true,
    this.doubleTapZoomEnabled = true,
    this.doubleTapZoomScale = 2.0,
    this.wheelZoomEnabled = true,
    this.wheelZoomFactor = 0.1,
    this.constrainPan = false,
    this.panBounds,
  });

  @override
  State<Zoom> createState() => _ZoomState();
}

class _ZoomState extends State<Zoom> {
  late ZoomTransform _transform;
  int _pointerCount = 0;
  Offset? _lastFocalPoint;
  double? _lastScale;

  @override
  void initState() {
    super.initState();
    _transform = widget.initialTransform ?? ZoomTransform.identity;
  }

  @override
  void didUpdateWidget(Zoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTransform != oldWidget.initialTransform &&
        widget.initialTransform != null) {
      _transform = widget.initialTransform!;
    }
  }

  void _updateTransform(ZoomTransform newTransform) {
    // Apply scale constraints
    final scale = newTransform.scale.clamp(widget.minScale, widget.maxScale);
    newTransform = newTransform.copyWith(scale: scale);

    // Apply pan constraints if enabled
    if (widget.constrainPan && widget.panBounds != null) {
      final bounds = widget.panBounds!;
      newTransform = newTransform.copyWith(
        translateX: newTransform.translateX.clamp(bounds.left, bounds.right),
        translateY: newTransform.translateY.clamp(bounds.top, bounds.bottom),
      );
    }

    if (newTransform != _transform) {
      setState(() {
        _transform = newTransform;
      });
      widget.onZoomChange?.call(_transform);
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _lastFocalPoint = details.localFocalPoint;
    _lastScale = _transform.scale;
    widget.onZoomStart?.call(_transform);
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    if (_lastFocalPoint == null || _lastScale == null) return;

    var newTransform = _transform;

    // Handle zoom
    if (widget.zoomEnabled && details.scale != 1.0) {
      final newScale = _lastScale! * details.scale;
      final focalPoint = details.localFocalPoint;

      // Calculate the new translation to keep the focal point stable
      final scaleDiff = newScale / _transform.scale;
      final newTranslateX =
          focalPoint.dx - (focalPoint.dx - _transform.translateX) * scaleDiff;
      final newTranslateY =
          focalPoint.dy - (focalPoint.dy - _transform.translateY) * scaleDiff;

      newTransform = newTransform.copyWith(
        scale: newScale,
        translateX: newTranslateX,
        translateY: newTranslateY,
      );
    }

    // Handle pan
    if (widget.panEnabled && _pointerCount <= 1) {
      final delta = details.localFocalPoint - _lastFocalPoint!;
      newTransform = newTransform.copyWith(
        translateX: newTransform.translateX + delta.dx,
        translateY: newTransform.translateY + delta.dy,
      );
      _lastFocalPoint = details.localFocalPoint;
    }

    _updateTransform(newTransform);
  }

  void _handleScaleEnd(ScaleEndDetails details) {
    _lastFocalPoint = null;
    _lastScale = null;
    widget.onZoomEnd?.call(_transform);
  }

  void _handleDoubleTap() {
    if (!widget.doubleTapZoomEnabled) return;

    final newScale = _transform.scale == 1.0 ? widget.doubleTapZoomScale : 1.0;

    _updateTransform(ZoomTransform(
      scale: newScale,
      translateX: 0,
      translateY: 0,
    ));
  }

  void _handlePointerSignal(PointerSignalEvent event) {
    if (!widget.wheelZoomEnabled) return;
    if (event is! PointerScrollEvent) return;

    final scrollDelta = event.scrollDelta.dy;
    final scaleFactor = scrollDelta > 0
        ? 1 - widget.wheelZoomFactor
        : 1 + widget.wheelZoomFactor;

    final newScale = _transform.scale * scaleFactor;
    final focalPoint = event.localPosition;

    // Calculate new translation to zoom towards the focal point
    final scaleDiff = newScale / _transform.scale;
    final newTranslateX =
        focalPoint.dx - (focalPoint.dx - _transform.translateX) * scaleDiff;
    final newTranslateY =
        focalPoint.dy - (focalPoint.dy - _transform.translateY) * scaleDiff;

    _updateTransform(ZoomTransform(
      scale: newScale,
      translateX: newTranslateX,
      translateY: newTranslateY,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _pointerCount++,
      onPointerUp: (_) => _pointerCount--,
      onPointerCancel: (_) => _pointerCount--,
      onPointerSignal: _handlePointerSignal,
      child: GestureDetector(
        onScaleStart: _handleScaleStart,
        onScaleUpdate: _handleScaleUpdate,
        onScaleEnd: _handleScaleEnd,
        onDoubleTap: widget.doubleTapZoomEnabled ? _handleDoubleTap : null,
        child: ClipRect(
          child: Transform(
            transform: _transform.toMatrix4(),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// A controller for managing zoom state externally.
class ZoomController extends ChangeNotifier {
  ZoomTransform _transform;

  /// The minimum scale factor.
  final double minScale;

  /// The maximum scale factor.
  final double maxScale;

  /// Creates a ZoomController.
  ZoomController({
    ZoomTransform? initialTransform,
    this.minScale = 0.1,
    this.maxScale = 10.0,
  }) : _transform = initialTransform ?? ZoomTransform.identity;

  /// The current transform.
  ZoomTransform get transform => _transform;

  /// The current scale.
  double get scale => _transform.scale;

  /// The current translation.
  Offset get translate => _transform.translate;

  /// Sets the transform.
  void setTransform(ZoomTransform transform) {
    final clampedScale = transform.scale.clamp(minScale, maxScale);
    _transform = transform.copyWith(scale: clampedScale);
    notifyListeners();
  }

  /// Zooms to a specific scale.
  void zoomTo(double scale, [Offset? focalPoint]) {
    final clampedScale = scale.clamp(minScale, maxScale);

    if (focalPoint != null) {
      final scaleDiff = clampedScale / _transform.scale;
      _transform = ZoomTransform(
        scale: clampedScale,
        translateX:
            focalPoint.dx - (focalPoint.dx - _transform.translateX) * scaleDiff,
        translateY:
            focalPoint.dy - (focalPoint.dy - _transform.translateY) * scaleDiff,
      );
    } else {
      _transform = _transform.copyWith(scale: clampedScale);
    }

    notifyListeners();
  }

  /// Zooms in by the given factor.
  void zoomIn([double factor = 1.2, Offset? focalPoint]) {
    zoomTo(_transform.scale * factor, focalPoint);
  }

  /// Zooms out by the given factor.
  void zoomOut([double factor = 1.2, Offset? focalPoint]) {
    zoomTo(_transform.scale / factor, focalPoint);
  }

  /// Pans by the given offset.
  void panBy(Offset delta) {
    _transform = _transform.copyWith(
      translateX: _transform.translateX + delta.dx,
      translateY: _transform.translateY + delta.dy,
    );
    notifyListeners();
  }

  /// Pans to the given position.
  void panTo(Offset position) {
    _transform = _transform.copyWith(
      translateX: position.dx,
      translateY: position.dy,
    );
    notifyListeners();
  }

  /// Resets to the identity transform.
  void reset() {
    _transform = ZoomTransform.identity;
    notifyListeners();
  }
}

/// Creates a Zoom widget with the given parameters.
Zoom zoom({
  required Widget child,
  void Function(ZoomTransform transform)? onZoomChange,
  void Function(ZoomTransform transform)? onZoomStart,
  void Function(ZoomTransform transform)? onZoomEnd,
  ZoomTransform? initialTransform,
  double minScale = 0.1,
  double maxScale = 10.0,
  bool panEnabled = true,
  bool zoomEnabled = true,
  bool doubleTapZoomEnabled = true,
  double doubleTapZoomScale = 2.0,
  bool wheelZoomEnabled = true,
  double wheelZoomFactor = 0.1,
  bool constrainPan = false,
  Rect? panBounds,
}) {
  return Zoom(
    onZoomChange: onZoomChange,
    onZoomStart: onZoomStart,
    onZoomEnd: onZoomEnd,
    initialTransform: initialTransform,
    minScale: minScale,
    maxScale: maxScale,
    panEnabled: panEnabled,
    zoomEnabled: zoomEnabled,
    doubleTapZoomEnabled: doubleTapZoomEnabled,
    doubleTapZoomScale: doubleTapZoomScale,
    wheelZoomEnabled: wheelZoomEnabled,
    wheelZoomFactor: wheelZoomFactor,
    constrainPan: constrainPan,
    panBounds: panBounds,
    child: child,
  );
}
