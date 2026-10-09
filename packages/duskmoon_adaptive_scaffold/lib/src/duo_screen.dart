import 'dart:ui';

import 'package:flutter/widgets.dart';

/// Policy for how an adaptive layout distributes its slots across two
/// screens.
enum DuoScreenPolicy {
  /// Default behavior. Body and secondaryBody split around a separating hinge or fold.
  splitBody,

  /// Navigation and secondaryBody move to the second screen while the body
  /// stays on the first one.
  ///
  /// The policy only takes effect when a second screen actually exists:
  ///
  /// * [DuoScreenRole.single]: a separating hinge or fold is detected (see
  ///   [DuoScreen.hingeOf]).
  /// * [DuoScreenRole.primary] / [DuoScreenRole.secondary]: the app explicitly
  ///   runs on two displays.
  ///
  /// Otherwise the regular adaptive layout is used, so navigation is never
  /// lost on a single screen.
  navigationOnSecondary,
}

/// Role of the view hosting an adaptive layout in a multi-screen setup.
///
/// Roles other than [single] are honoured only with
/// [DuoScreenPolicy.navigationOnSecondary].
enum DuoScreenRole {
  /// The app runs in one view. A separating hinge or fold, if present, is the
  /// only possible second screen.
  single,

  /// The primary view of a multi-display setup. A companion view with role
  /// [secondary] renders navigation and secondaryBody, so this view renders
  /// only topNavigation and the body.
  primary,

  /// The companion view of a multi-display setup. It renders navigation and
  /// secondaryBody across the whole view.
  secondary,
}

/// Helpers for dual-screen and foldable layouts.
abstract final class DuoScreen {
  /// Bounds, in global logical coordinates, of the display feature that
  /// separates the view into two screens, or `null`.
  ///
  /// A [DisplayFeatureType.hinge] always separates the view. A
  /// [DisplayFeatureType.fold] separates it only while the device is
  /// half-opened or its bounds physically occlude pixels; a zero-width flat
  /// fold is treated as a single screen. Cutouts and features that do not span
  /// the view are ignored. Selection is independent of feature list order:
  /// physical hinges take precedence, then bounds are sorted top-to-bottom
  /// and left-to-right.
  static Rect? hingeOf(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final features = MediaQuery.displayFeaturesOf(context)
        .where((feature) =>
            isSeparating(feature) &&
            ((feature.bounds.top <= 0 &&
                    feature.bounds.bottom >= size.height &&
                    feature.bounds.left > 0 &&
                    feature.bounds.right < size.width) ||
                (feature.bounds.left <= 0 &&
                    feature.bounds.right >= size.width &&
                    feature.bounds.top > 0 &&
                    feature.bounds.bottom < size.height)))
        .toList()
      ..sort((a, b) {
        final priority = (a.type == DisplayFeatureType.hinge ? 0 : 1)
            .compareTo(b.type == DisplayFeatureType.hinge ? 0 : 1);
        if (priority != 0) return priority;
        for (final comparison in [
          a.bounds.top.compareTo(b.bounds.top),
          a.bounds.left.compareTo(b.bounds.left),
          a.bounds.bottom.compareTo(b.bounds.bottom),
          a.bounds.right.compareTo(b.bounds.right),
        ]) {
          if (comparison != 0) return comparison;
        }
        return 0;
      });
    return features.firstOrNull?.bounds;
  }

  /// Whether [feature] splits the view into two logical screens.
  static bool isSeparating(DisplayFeature feature) {
    return switch (feature.type) {
      DisplayFeatureType.hinge => true,
      DisplayFeatureType.fold =>
        feature.state == DisplayFeatureState.postureHalfOpened ||
            (feature.bounds.width > 0 && feature.bounds.height > 0),
      _ => false,
    };
  }
}

/// Which duo-screen arrangement an adaptive layout uses.
///
/// Internal to this package; not exported.
enum DuoLayoutMode {
  /// Regular adaptive layout.
  none,

  /// One view split by a hinge: body on one side, navigation and
  /// secondaryBody on the other.
  hinge,

  /// Body only; navigation lives on another display.
  primary,

  /// Navigation and secondaryBody only; the body lives on another display.
  secondary,
}

/// Resolves the [DuoLayoutMode] for a policy, role and hinge state.
DuoLayoutMode resolveDuoLayoutMode({
  required DuoScreenPolicy policy,
  required DuoScreenRole role,
  required bool hasHinge,
}) {
  if (policy != DuoScreenPolicy.navigationOnSecondary) {
    return DuoLayoutMode.none;
  }
  return switch (role) {
    DuoScreenRole.primary => DuoLayoutMode.primary,
    DuoScreenRole.secondary => DuoLayoutMode.secondary,
    DuoScreenRole.single => hasHinge ? DuoLayoutMode.hinge : DuoLayoutMode.none,
  };
}

/// Maps the deprecated integer display id onto a [DuoScreenRole].
DuoScreenRole resolveDuoScreenRole(DuoScreenRole role, int legacyDisplayId) {
  return legacyDisplayId > 0 ? DuoScreenRole.secondary : role;
}
