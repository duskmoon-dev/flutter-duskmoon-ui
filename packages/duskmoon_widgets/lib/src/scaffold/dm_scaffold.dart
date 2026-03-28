import 'package:flutter/material.dart';
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

export 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

/// A convenience wrapper around [AdaptiveScaffold] that exposes named
/// breakpoint constants and shorter parameter names for breakpoints.
class DmScaffold extends StatelessWidget {
  /// Breakpoint constant aliases for common screen sizes.
  static const smallBreakpoint = Breakpoints.small;
  static const mediumBreakpoint = Breakpoints.medium;
  static const mediumLargeBreakpoint = Breakpoints.mediumLarge;
  static const largeBreakpoint = Breakpoints.large;
  static const extraLargeBreakpoint = Breakpoints.extraLarge;
  static const drawerBreakpoint = Breakpoints.smallDesktop;

  /// Navigation destinations shown in the bottom bar / rail / drawer.
  final List<NavigationDestination> destinations;

  /// The currently selected destination index.
  final int? selectedIndex;

  /// Widget placed above destinations when the rail is collapsed.
  final Widget? leadingUnextendedNavRail;

  /// Widget placed above destinations when the rail is extended.
  final Widget? leadingExtendedNavRail;

  /// Widget placed below the destinations in the navigation rail.
  final Widget? trailingNavRail;

  /// Padding around the navigation rail.
  final EdgeInsetsGeometry navigationRailPadding;

  /// Vertical alignment of destinations within the navigation rail.
  final double? groupAlignment;

  /// Body builders per breakpoint.
  final WidgetBuilder? smallBody;
  final WidgetBuilder? body;
  final WidgetBuilder? mediumLargeBody;
  final WidgetBuilder? largeBody;
  final WidgetBuilder? extraLargeBody;

  /// Secondary body builders per breakpoint.
  final WidgetBuilder? smallSecondaryBody;
  final WidgetBuilder? secondaryBody;
  final WidgetBuilder? mediumLargeSecondaryBody;
  final WidgetBuilder? largeSecondaryBody;
  final WidgetBuilder? extraLargeSecondaryBody;

  /// Ratio between body and secondary body (0.0 – 1.0).
  final double? bodyRatio;

  /// Override breakpoints for each size category.
  final Breakpoint smallBp;
  final Breakpoint mediumBp;
  final Breakpoint mediumLargeBp;
  final Breakpoint largeBp;
  final Breakpoint extraLargeBp;
  final Breakpoint drawerBp;

  /// Whether internal slot animations are enabled.
  final bool internalAnimations;

  /// Duration of body transition animations.
  final Duration transitionDuration;

  /// Axis along which body and secondary body are laid out.
  final Axis bodyOrientation;

  /// Whether a drawer is used instead of a bottom navigation bar.
  final bool useDrawer;

  /// Breakpoint at which the app bar is shown.
  final Breakpoint? appBarBreakpoint;

  /// Optional app bar widget.
  final PreferredSizeWidget? appBar;

  /// Called when the selected destination changes.
  final void Function(int)? onSelectedIndexChange;

  /// Width of the collapsed navigation rail.
  final double navigationRailWidth;

  /// Width of the extended navigation rail.
  final double extendedNavigationRailWidth;

  /// Custom builder for navigation rail destinations.
  final NavigationRailDestinationBuilder? navigationRailDestinationBuilder;

  /// Creates a responsive scaffold with adaptive navigation.
  const DmScaffold({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.leadingUnextendedNavRail,
    this.leadingExtendedNavRail,
    this.trailingNavRail,
    this.navigationRailPadding =
        const EdgeInsets.all(kNavigationRailDefaultPadding),
    this.smallBody,
    this.body,
    this.mediumLargeBody,
    this.largeBody,
    this.extraLargeBody,
    this.smallSecondaryBody,
    this.secondaryBody,
    this.mediumLargeSecondaryBody,
    this.largeSecondaryBody,
    this.extraLargeSecondaryBody,
    this.bodyRatio,
    this.smallBp = smallBreakpoint,
    this.mediumBp = mediumBreakpoint,
    this.mediumLargeBp = mediumLargeBreakpoint,
    this.largeBp = largeBreakpoint,
    this.extraLargeBp = extraLargeBreakpoint,
    this.drawerBp = drawerBreakpoint,
    this.internalAnimations = true,
    this.transitionDuration = const Duration(milliseconds: 0),
    this.bodyOrientation = Axis.horizontal,
    this.onSelectedIndexChange,
    this.useDrawer = false,
    this.appBar,
    this.navigationRailWidth = 72,
    this.extendedNavigationRailWidth = 192,
    this.appBarBreakpoint,
    this.navigationRailDestinationBuilder,
    this.groupAlignment,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: destinations,
      selectedIndex: selectedIndex,
      leadingUnextendedNavRail: leadingUnextendedNavRail,
      leadingExtendedNavRail: leadingExtendedNavRail,
      trailingNavRail: trailingNavRail,
      navigationRailPadding: navigationRailPadding,
      smallBody: smallBody,
      body: body,
      mediumLargeBody: mediumLargeBody,
      largeBody: largeBody,
      extraLargeBody: extraLargeBody,
      smallSecondaryBody: smallSecondaryBody,
      secondaryBody: secondaryBody,
      mediumLargeSecondaryBody: mediumLargeSecondaryBody,
      largeSecondaryBody: largeSecondaryBody,
      extraLargeSecondaryBody: extraLargeSecondaryBody,
      bodyRatio: bodyRatio,
      smallBreakpoint: smallBp,
      mediumBreakpoint: mediumBp,
      mediumLargeBreakpoint: mediumLargeBp,
      largeBreakpoint: largeBp,
      extraLargeBreakpoint: extraLargeBp,
      drawerBreakpoint: drawerBp,
      internalAnimations: internalAnimations,
      transitionDuration: transitionDuration,
      bodyOrientation: bodyOrientation,
      onSelectedIndexChange: onSelectedIndexChange,
      useDrawer: useDrawer,
      appBar: appBar,
      navigationRailWidth: navigationRailWidth,
      extendedNavigationRailWidth: extendedNavigationRailWidth,
      appBarBreakpoint: appBarBreakpoint,
      navigationRailDestinationBuilder: navigationRailDestinationBuilder,
      groupAlignment: groupAlignment,
    );
  }
}
