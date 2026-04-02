import 'package:flutter/widgets.dart';

/// Breakpoint configuration for responsive layouts.
class Breakpoints {
  /// Width threshold for small screens.
  final double small;

  /// Width threshold for medium screens.
  final double medium;

  /// Width threshold for large screens.
  final double large;

  /// Creates Breakpoints with custom values.
  const Breakpoints({
    this.small = 600,
    this.medium = 900,
    this.large = 1200,
  });

  /// Default breakpoints.
  static const Breakpoints defaultBreakpoints = Breakpoints();

  /// Material Design breakpoints.
  static const Breakpoints material = Breakpoints(
    small: 600,
    medium: 905,
    large: 1240,
  );
}

/// The current screen size category.
enum ScreenSize {
  /// Extra small screens (width < small breakpoint).
  extraSmall,

  /// Small screens (small <= width < medium).
  small,

  /// Medium screens (medium <= width < large).
  medium,

  /// Large screens (width >= large).
  large,
}

/// A widget that provides responsive behavior based on available space.
///
/// [ResponsiveContainer] wraps its child and provides size information
/// through a builder function, allowing for responsive chart layouts.
class ResponsiveContainer extends StatelessWidget {
  /// The builder function that creates the child widget.
  final Widget Function(
    BuildContext context,
    BoxConstraints constraints,
    ScreenSize screenSize,
  ) builder;

  /// The breakpoints to use for determining screen size.
  final Breakpoints breakpoints;

  /// The minimum width of the container.
  final double? minWidth;

  /// The minimum height of the container.
  final double? minHeight;

  /// The maximum width of the container.
  final double? maxWidth;

  /// The maximum height of the container.
  final double? maxHeight;

  /// The aspect ratio to maintain.
  final double? aspectRatio;

  /// Creates a ResponsiveContainer widget.
  const ResponsiveContainer({
    super.key,
    required this.builder,
    this.breakpoints = const Breakpoints(),
    this.minWidth,
    this.minHeight,
    this.maxWidth,
    this.maxHeight,
    this.aspectRatio,
  });

  ScreenSize _getScreenSize(double width) {
    if (width < breakpoints.small) {
      return ScreenSize.extraSmall;
    } else if (width < breakpoints.medium) {
      return ScreenSize.small;
    } else if (width < breakpoints.large) {
      return ScreenSize.medium;
    } else {
      return ScreenSize.large;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var effectiveConstraints = constraints;

        // Apply min/max constraints
        if (minWidth != null ||
            minHeight != null ||
            maxWidth != null ||
            maxHeight != null) {
          effectiveConstraints = BoxConstraints(
            minWidth: minWidth ?? constraints.minWidth,
            maxWidth: maxWidth ?? constraints.maxWidth,
            minHeight: minHeight ?? constraints.minHeight,
            maxHeight: maxHeight ?? constraints.maxHeight,
          );
        }

        final screenSize = _getScreenSize(effectiveConstraints.maxWidth);

        Widget child = builder(context, effectiveConstraints, screenSize);

        // Apply aspect ratio if specified
        if (aspectRatio != null) {
          child = AspectRatio(
            aspectRatio: aspectRatio!,
            child: child,
          );
        }

        return child;
      },
    );
  }
}

/// A widget that builds different layouts based on screen size.
class ResponsiveBuilder extends StatelessWidget {
  /// The builder for extra small screens.
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      extraSmall;

  /// The builder for small screens.
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      small;

  /// The builder for medium screens.
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      medium;

  /// The builder for large screens.
  final Widget Function(BuildContext context, BoxConstraints constraints)?
      large;

  /// The default builder used when a specific size builder is not provided.
  final Widget Function(BuildContext context, BoxConstraints constraints)
      defaultBuilder;

  /// The breakpoints to use.
  final Breakpoints breakpoints;

  /// Creates a ResponsiveBuilder widget.
  const ResponsiveBuilder({
    super.key,
    this.extraSmall,
    this.small,
    this.medium,
    this.large,
    required this.defaultBuilder,
    this.breakpoints = const Breakpoints(),
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveContainer(
      breakpoints: breakpoints,
      builder: (context, constraints, screenSize) {
        switch (screenSize) {
          case ScreenSize.extraSmall:
            return extraSmall?.call(context, constraints) ??
                small?.call(context, constraints) ??
                defaultBuilder(context, constraints);
          case ScreenSize.small:
            return small?.call(context, constraints) ??
                defaultBuilder(context, constraints);
          case ScreenSize.medium:
            return medium?.call(context, constraints) ??
                defaultBuilder(context, constraints);
          case ScreenSize.large:
            return large?.call(context, constraints) ??
                medium?.call(context, constraints) ??
                defaultBuilder(context, constraints);
        }
      },
    );
  }
}

/// A widget that provides different values based on screen size.
class ResponsiveValue<T> {
  /// Value for extra small screens.
  final T? extraSmall;

  /// Value for small screens.
  final T? small;

  /// Value for medium screens.
  final T? medium;

  /// Value for large screens.
  final T? large;

  /// The default value.
  final T defaultValue;

  /// Creates a ResponsiveValue.
  const ResponsiveValue({
    this.extraSmall,
    this.small,
    this.medium,
    this.large,
    required this.defaultValue,
  });

  /// Creates a ResponsiveValue with the same value for all sizes.
  const ResponsiveValue.all(T value)
      : extraSmall = value,
        small = value,
        medium = value,
        large = value,
        defaultValue = value;

  /// Gets the value for the given screen size.
  T getValue(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.extraSmall:
        return extraSmall ?? small ?? defaultValue;
      case ScreenSize.small:
        return small ?? defaultValue;
      case ScreenSize.medium:
        return medium ?? defaultValue;
      case ScreenSize.large:
        return large ?? medium ?? defaultValue;
    }
  }
}

/// Extension methods for responsive values.
extension ResponsiveValueExtension<T> on T {
  /// Creates a ResponsiveValue with this as the default.
  ResponsiveValue<T> responsive({
    T? extraSmall,
    T? small,
    T? medium,
    T? large,
  }) {
    return ResponsiveValue(
      extraSmall: extraSmall,
      small: small,
      medium: medium,
      large: large,
      defaultValue: this,
    );
  }
}
