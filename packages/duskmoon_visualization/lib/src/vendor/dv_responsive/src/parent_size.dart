import 'package:flutter/widgets.dart';

/// A widget that reports its parent's size to its child.
///
/// [ParentSize] uses LayoutBuilder to determine the available space
/// and provides this information to its builder function.
class ParentSize extends StatelessWidget {
  /// The builder function that creates the child widget.
  final Widget Function(BuildContext context, Size size) builder;

  /// Whether to debounce size changes.
  final bool debounce;

  /// The debounce duration in milliseconds.
  final int debounceDuration;

  /// Creates a ParentSize widget.
  const ParentSize({
    super.key,
    required this.builder,
    this.debounce = false,
    this.debounceDuration = 100,
  });

  @override
  Widget build(BuildContext context) {
    if (debounce) {
      return _DebouncedParentSize(
        duration: debounceDuration,
        builder: builder,
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 0,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 0,
        );
        return builder(context, size);
      },
    );
  }
}

class _DebouncedParentSize extends StatefulWidget {
  final Widget Function(BuildContext context, Size size) builder;
  final int duration;

  const _DebouncedParentSize({
    required this.builder,
    required this.duration,
  });

  @override
  State<_DebouncedParentSize> createState() => _DebouncedParentSizeState();
}

class _DebouncedParentSizeState extends State<_DebouncedParentSize> {
  Size? _lastSize;
  Size? _currentSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(
          constraints.maxWidth.isFinite ? constraints.maxWidth : 0,
          constraints.maxHeight.isFinite ? constraints.maxHeight : 0,
        );

        if (_lastSize != size) {
          _currentSize = size;
          _debounceUpdate();
        }

        final effectiveSize = _lastSize ?? size;
        return widget.builder(context, effectiveSize);
      },
    );
  }

  void _debounceUpdate() {
    Future.delayed(Duration(milliseconds: widget.duration), () {
      if (mounted && _currentSize != _lastSize) {
        setState(() {
          _lastSize = _currentSize;
        });
      }
    });
  }
}

/// A widget that notifies when its size changes.
///
/// [SizeNotifier] calls the [onSizeChange] callback whenever
/// the widget's size changes.
class SizeNotifier extends StatefulWidget {
  /// The child widget.
  final Widget child;

  /// Called when the size changes.
  final void Function(Size size) onSizeChange;

  /// Creates a SizeNotifier widget.
  const SizeNotifier({
    super.key,
    required this.child,
    required this.onSizeChange,
  });

  @override
  State<SizeNotifier> createState() => _SizeNotifierState();
}

class _SizeNotifierState extends State<SizeNotifier> {
  final GlobalKey _key = GlobalKey();
  Size? _lastSize;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSize());
  }

  void _checkSize() {
    final context = _key.currentContext;
    if (context == null) return;

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    if (_lastSize != size) {
      _lastSize = size;
      widget.onSizeChange(size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (notification) {
        _checkSize();
        return false;
      },
      child: SizeChangedLayoutNotifier(
        key: _key,
        child: widget.child,
      ),
    );
  }
}

/// A widget that fills available space with optional constraints.
///
/// [FillParent] is a convenience widget that uses LayoutBuilder
/// to fill available space while respecting constraints.
class FillParent extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The minimum width.
  final double? minWidth;

  /// The minimum height.
  final double? minHeight;

  /// The maximum width.
  final double? maxWidth;

  /// The maximum height.
  final double? maxHeight;

  /// Creates a FillParent widget.
  const FillParent({
    super.key,
    required this.child,
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;

        if (minWidth != null && width < minWidth!) {
          width = minWidth!;
        }
        if (maxWidth != null && width > maxWidth!) {
          width = maxWidth!;
        }
        if (minHeight != null && height < minHeight!) {
          height = minHeight!;
        }
        if (maxHeight != null && height > maxHeight!) {
          height = maxHeight!;
        }

        return SizedBox(
          width: width.isFinite ? width : null,
          height: height.isFinite ? height : null,
          child: child,
        );
      },
    );
  }
}

/// A widget that maintains an aspect ratio while filling available space.
class AspectRatioFill extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// The aspect ratio (width / height).
  final double aspectRatio;

  /// How to align the child within the available space.
  final Alignment alignment;

  /// Creates an AspectRatioFill widget.
  const AspectRatioFill({
    super.key,
    required this.child,
    required this.aspectRatio,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        double width, height;

        // Calculate the size that fits within constraints while maintaining aspect ratio
        if (maxWidth / maxHeight > aspectRatio) {
          // Height is the limiting factor
          height = maxHeight;
          width = height * aspectRatio;
        } else {
          // Width is the limiting factor
          width = maxWidth;
          height = width / aspectRatio;
        }

        return Align(
          alignment: alignment,
          child: SizedBox(
            width: width.isFinite ? width : null,
            height: height.isFinite ? height : null,
            child: child,
          ),
        );
      },
    );
  }
}

/// Creates a ParentSize widget with the given builder.
ParentSize parentSize({
  required Widget Function(BuildContext context, Size size) builder,
  bool debounce = false,
  int debounceDuration = 100,
}) {
  return ParentSize(
    builder: builder,
    debounce: debounce,
    debounceDuration: debounceDuration,
  );
}
