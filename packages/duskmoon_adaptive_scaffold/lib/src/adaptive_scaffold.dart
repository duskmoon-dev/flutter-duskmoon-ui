// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'adaptive_layout.dart';
import 'breakpoints.dart';
import 'slot_layout.dart';

/// Spacing value of the compact breakpoint according to
/// the material 3 design spec.
const double kMaterialCompactSpacing = 0;

/// Spacing value of the medium and up breakpoint according to
/// the material 3 design spec.
const double kMaterialMediumAndUpSpacing = 24;

/// Margin value of the compact breakpoint according to the material
/// design 3 spec.
const double kMaterialCompactMargin = 16;

/// Margin value of the medium breakpoint according to the material
/// design 3 spec.
const double kMaterialMediumAndUpMargin = 24;

/// Padding value of the compact breakpoint according to the material
/// design 3 spec.
const double kMaterialPadding = 4;

/// Padding value of the default padding for the navigation rail
const double kNavigationRailDefaultPadding = 8;

/// Signature for a builder used by [DmAdaptiveScaffold.navigationRailDestinationBuilder] that converts a
/// [NavigationDestination] to a [NavigationRailDestination].
typedef NavigationRailDestinationBuilder = NavigationRailDestination Function(
  int index,
  NavigationDestination destination,
);

/// Implements the basic visual layout structure for
/// [Material Design 3](https://m3.material.io/foundations/adaptive-design/overview)
/// that adapts to a variety of screens.
class DmAdaptiveScaffold extends StatefulWidget {
  /// Returns a const [DmAdaptiveScaffold] by passing information down to an
  /// [AdaptiveLayout].
  const DmAdaptiveScaffold({
    super.key,
    required this.destinations,
    this.selectedIndex = 0,
    this.leadingUnextendedNavRail,
    this.leadingExtendedNavRail,
    this.trailingNavRail,
    this.navigationRailPadding = const EdgeInsets.all(
      kNavigationRailDefaultPadding,
    ),
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
    this.smallBreakpoint = Breakpoints.small,
    this.mediumBreakpoint = Breakpoints.medium,
    this.mediumLargeBreakpoint = Breakpoints.mediumLarge,
    this.largeBreakpoint = Breakpoints.large,
    this.extraLargeBreakpoint = Breakpoints.extraLarge,
    this.drawerBreakpoint = Breakpoints.smallDesktop,
    this.internalAnimations = true,
    this.transitionDuration = const Duration(seconds: 1),
    this.bodyOrientation = Axis.horizontal,
    this.onSelectedIndexChange,
    this.useDrawer = true,
    this.appBar,
    this.navigationRailWidth = 72,
    this.extendedNavigationRailWidth = 192,
    this.appBarBreakpoint,
    this.navigationRailDestinationBuilder,
    this.groupAlignment,
    this.isExtendedOverride,
    this.onExtendedChange,
    this.showCollapseToggle = false,
    this.collapseIcon = Icons.menu_open,
    this.expandIcon = Icons.menu,
    this.duoScreenPolicy = DuoScreenPolicy.splitBody,
    this.displayId = 0,
  }) : assert(
          destinations.length >= 2,
          'At least two destinations are required',
        );

  final int displayId;
  final List<NavigationDestination> destinations;
  final int? selectedIndex;
  final Widget? leadingUnextendedNavRail;
  final Widget? leadingExtendedNavRail;
  final Widget? trailingNavRail;
  final EdgeInsetsGeometry navigationRailPadding;
  final double? groupAlignment;
  final WidgetBuilder? smallBody;
  final WidgetBuilder? body;
  final WidgetBuilder? mediumLargeBody;
  final WidgetBuilder? largeBody;
  final WidgetBuilder? extraLargeBody;
  final WidgetBuilder? smallSecondaryBody;
  final WidgetBuilder? secondaryBody;
  final WidgetBuilder? mediumLargeSecondaryBody;
  final WidgetBuilder? largeSecondaryBody;
  final WidgetBuilder? extraLargeSecondaryBody;
  final double? bodyRatio;
  final Breakpoint smallBreakpoint;
  final Breakpoint mediumBreakpoint;
  final Breakpoint mediumLargeBreakpoint;
  final Breakpoint largeBreakpoint;
  final Breakpoint extraLargeBreakpoint;
  final Breakpoint drawerBreakpoint;
  final bool internalAnimations;
  final Duration transitionDuration;
  final Axis bodyOrientation;
  final bool useDrawer;
  final Breakpoint? appBarBreakpoint;
  final PreferredSizeWidget? appBar;
  final void Function(int)? onSelectedIndexChange;
  final double navigationRailWidth;
  final double extendedNavigationRailWidth;
  final NavigationRailDestinationBuilder? navigationRailDestinationBuilder;
  final bool? isExtendedOverride;
  final void Function(bool isExtended)? onExtendedChange;
  final bool showCollapseToggle;
  final IconData collapseIcon;
  final IconData expandIcon;
  final DuoScreenPolicy duoScreenPolicy;

  static WidgetBuilder emptyBuilder = (_) => const SizedBox();

  static NavigationRailDestination toRailDestination(
    NavigationDestination destination,
  ) {
    return NavigationRailDestination(
      label: Text(destination.label),
      icon: destination.icon,
      selectedIcon: destination.selectedIcon,
    );
  }

  static Builder standardNavigationRail({
    required List<NavigationRailDestination> destinations,
    double width = 72,
    int? selectedIndex,
    bool extended = false,
    Color? backgroundColor,
    EdgeInsetsGeometry padding = const EdgeInsets.all(
      kNavigationRailDefaultPadding,
    ),
    Widget? leading,
    Widget? trailing,
    void Function(int)? onDestinationSelected,
    double? groupAlignment,
    IconThemeData? selectedIconTheme,
    IconThemeData? unselectedIconTheme,
    TextStyle? selectedLabelTextStyle,
    TextStyle? unSelectedLabelTextStyle,
    NavigationRailLabelType? labelType = NavigationRailLabelType.none,
  }) {
    if (extended && width == 72) {
      width = 192;
    }
    return Builder(
      builder: (BuildContext context) {
        return Container(
          color: backgroundColor ?? Colors.red.withValues(alpha: 0.3), // FORCE RED FOR DEBUG
          padding: padding,
          child: SizedBox(
            width: width,
            height: double.infinity,
            child: NavigationRail(
              labelType: labelType,
              leading: leading,
              trailing: trailing,
              onDestinationSelected: onDestinationSelected,
              groupAlignment: groupAlignment,
              backgroundColor: Colors.transparent, // Use parent container color
              extended: extended,
              selectedIndex: selectedIndex,
              selectedIconTheme: selectedIconTheme,
              unselectedIconTheme: unselectedIconTheme,
              selectedLabelTextStyle: selectedLabelTextStyle,
              unselectedLabelTextStyle: unSelectedLabelTextStyle,
              destinations: destinations,
            ),
          ),
        );
      },
    );
  }

  static Builder standardBottomNavigationBar({
    required List<NavigationDestination> destinations,
    int? currentIndex,
    double iconSize = 24,
    ValueChanged<int>? onDestinationSelected,
  }) {
    return Builder(
      builder: (BuildContext context) {
        final NavigationBarThemeData currentNavBarTheme = NavigationBarTheme.of(
          context,
        );
        return NavigationBarTheme(
          data: currentNavBarTheme.copyWith(
            iconTheme: WidgetStateProperty.resolveWith((
              Set<WidgetState> states,
            ) {
              return currentNavBarTheme.iconTheme
                      ?.resolve(states)
                      ?.copyWith(size: iconSize) ??
                  IconTheme.of(context).copyWith(size: iconSize);
            }),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).removePadding(removeTop: true),
            child: NavigationBar(
              selectedIndex: currentIndex ?? 0,
              destinations: destinations,
              onDestinationSelected: onDestinationSelected,
            ),
          ),
        );
      },
    );
  }

  static AnimatedWidget bottomToTop(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static AnimatedWidget topToBottom(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(0, 1),
      ).animate(animation),
      child: child,
    );
  }

  static AnimatedWidget leftOutIn(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static AnimatedWidget leftInOut(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-1, 0),
      ).animate(animation),
      child: child,
    );
  }

  static AnimatedWidget rightOutIn(Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  }

  static Widget fadeIn(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeInCubic),
      child: child,
    );
  }

  static Widget fadeOut(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: ReverseAnimation(animation),
        curve: Curves.easeInCubic,
      ),
      child: child,
    );
  }

  static Widget stayOnScreen(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 1.0).animate(animation),
      child: child,
    );
  }

  @override
  State<DmAdaptiveScaffold> createState() => _DmAdaptiveScaffoldState();
}

class _DmAdaptiveScaffoldState extends State<DmAdaptiveScaffold> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _shouldBeExtended(bool defaultExtended) {
    return widget.isExtendedOverride ?? defaultExtended;
  }

  Widget? _buildToggleButton(bool isExtended) {
    if (!widget.showCollapseToggle) return null;
    return IconButton(
      icon: Icon(isExtended ? widget.collapseIcon : widget.expandIcon),
      onPressed: () => widget.onExtendedChange?.call(!isExtended),
    );
  }

  Widget? _buildLeading(bool isExtended) {
    final toggleButton = _buildToggleButton(isExtended);
    final existingLeading = isExtended
        ? widget.leadingExtendedNavRail
        : widget.leadingUnextendedNavRail;
    if (toggleButton == null && existingLeading == null) return null;
    if (toggleButton == null) return existingLeading;
    if (existingLeading == null) return toggleButton;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [toggleButton, const SizedBox(height: 8), existingLeading],
    );
  }

  @override
  Widget build(BuildContext context) {
    final NavigationRailThemeData navRailTheme =
        Theme.of(context).navigationRailTheme;
    final List<NavigationRailDestination> destinations = widget.destinations
        .map((d) =>
            widget.navigationRailDestinationBuilder
                ?.call(widget.destinations.indexOf(d), d) ??
            DmAdaptiveScaffold.toRailDestination(d))
        .toList();

    final bool isExtendedOnLarge = _shouldBeExtended(true);
    final double largeWidth = isExtendedOnLarge
        ? widget.extendedNavigationRailWidth
        : widget.navigationRailWidth;

    final bool isDrawerMode =
        widget.drawerBreakpoint.isActive(context) && widget.useDrawer;
    final bool showAppBar =
        isDrawerMode || (widget.appBarBreakpoint?.isActive(context) ?? false);

    return Scaffold(
      key: _scaffoldKey,
      appBar: showAppBar
          ? _AppBarProxy(
              key: ValueKey(isDrawerMode),
              child: widget.appBar ?? AppBar(),
            )
          : null,
      drawer: isDrawerMode
          ? Drawer(
              child: NavigationRail(
                extended: true,
                leading: widget.leadingExtendedNavRail,
                trailing: widget.trailingNavRail,
                selectedIndex: widget.selectedIndex,
                destinations: destinations,
                onDestinationSelected: _onDrawerDestinationSelected,
                backgroundColor: navRailTheme.backgroundColor,
                selectedIconTheme: navRailTheme.selectedIconTheme,
                unselectedIconTheme: navRailTheme.unselectedIconTheme,
                selectedLabelTextStyle: navRailTheme.selectedLabelTextStyle,
                unselectedLabelTextStyle: navRailTheme.unselectedLabelTextStyle,
                groupAlignment: widget.groupAlignment,
                labelType: navRailTheme.labelType,
              ),
            )
          : null,
      body: AdaptiveLayout(
        transitionDuration: widget.transitionDuration,
        bodyOrientation: widget.bodyOrientation,
        bodyRatio: widget.bodyRatio,
        internalAnimations: widget.internalAnimations,
        duoScreenPolicy: widget.duoScreenPolicy,
        displayId: widget.displayId,
        primaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            if (widget.displayId > 0)
              Breakpoints.standard: SlotLayout.from(
                key: const Key('primaryNavigationForcedSecondary'),
                builder: (_) => DmAdaptiveScaffold.standardNavigationRail(
                  width: widget.navigationRailWidth,
                  leading: widget.leadingUnextendedNavRail,
                  trailing: widget.trailingNavRail,
                  padding: widget.navigationRailPadding,
                  selectedIndex: widget.selectedIndex,
                  destinations: destinations,
                  onDestinationSelected: widget.onSelectedIndexChange,
                  backgroundColor: Colors.yellow, // DEBUG VISIBILITY
                  selectedIconTheme: navRailTheme.selectedIconTheme,
                  unselectedIconTheme: navRailTheme.unselectedIconTheme,
                  selectedLabelTextStyle: navRailTheme.selectedLabelTextStyle,
                  unSelectedLabelTextStyle:
                      navRailTheme.unselectedLabelTextStyle,
                  labelType: NavigationRailLabelType.all,
                  groupAlignment: widget.groupAlignment,
                ),
              )
            else ...<Breakpoint, SlotLayoutConfig>{
              if (widget.duoScreenPolicy ==
                  DuoScreenPolicy.navigationOnSecondary)
                Breakpoints.standard: SlotLayout.from(
                  key: const Key('primaryNavigationStandard'),
                  builder: (_) => DmAdaptiveScaffold.standardNavigationRail(
                    width: widget.navigationRailWidth,
                    destinations: destinations,
                    selectedIndex: widget.selectedIndex,
                    onDestinationSelected: widget.onSelectedIndexChange,
                  ),
                ),
              widget.mediumBreakpoint: SlotLayout.from(
                key: const Key('primaryNavigation'),
                builder: (_) => DmAdaptiveScaffold.standardNavigationRail(
                  width: widget.navigationRailWidth,
                  leading: widget.leadingUnextendedNavRail,
                  trailing: widget.trailingNavRail,
                  padding: widget.navigationRailPadding,
                  selectedIndex: widget.selectedIndex,
                  destinations: destinations,
                  onDestinationSelected: widget.onSelectedIndexChange,
                  backgroundColor: navRailTheme.backgroundColor,
                  selectedIconTheme: navRailTheme.selectedIconTheme,
                  unselectedIconTheme: navRailTheme.unselectedIconTheme,
                  selectedLabelTextStyle: navRailTheme.selectedLabelTextStyle,
                  unSelectedLabelTextStyle:
                      navRailTheme.unselectedLabelTextStyle,
                  labelType: navRailTheme.labelType,
                  groupAlignment: widget.groupAlignment,
                ),
              ),
              widget.mediumLargeBreakpoint: SlotLayout.from(
                key: const Key('primaryNavigation1'),
                builder: (_) => DmAdaptiveScaffold.standardNavigationRail(
                  width: largeWidth,
                  extended: isExtendedOnLarge,
                  leading: _buildLeading(isExtendedOnLarge),
                  trailing: widget.trailingNavRail,
                  selectedIndex: widget.selectedIndex,
                  destinations: destinations,
                  onDestinationSelected: widget.onSelectedIndexChange,
                ),
              ),
              widget.largeBreakpoint: SlotLayout.from(
                key: const Key('primaryNavigation2'),
                builder: (_) => DmAdaptiveScaffold.standardNavigationRail(
                  width: largeWidth,
                  extended: isExtendedOnLarge,
                  leading: _buildLeading(isExtendedOnLarge),
                  destinations: destinations,
                  selectedIndex: widget.selectedIndex,
                  onDestinationSelected: widget.onSelectedIndexChange,
                ),
              ),
              widget.extraLargeBreakpoint: SlotLayout.from(
                key: const Key('primaryNavigation3'),
                builder: (_) => DmAdaptiveScaffold.standardNavigationRail(
                  width: largeWidth,
                  extended: isExtendedOnLarge,
                  leading: _buildLeading(isExtendedOnLarge),
                  destinations: destinations,
                  selectedIndex: widget.selectedIndex,
                  onDestinationSelected: widget.onSelectedIndexChange,
                ),
              ),
            },
          },
        ),
        bottomNavigation: !isDrawerMode &&
                widget.duoScreenPolicy != DuoScreenPolicy.navigationOnSecondary
            ? SlotLayout(
                config: <Breakpoint, SlotLayoutConfig>{
                  widget.smallBreakpoint: SlotLayout.from(
                    key: const Key('bottomNavigation'),
                    builder: (_) =>
                        DmAdaptiveScaffold.standardBottomNavigationBar(
                      currentIndex: widget.selectedIndex,
                      destinations: widget.destinations,
                      onDestinationSelected: widget.onSelectedIndexChange,
                    ),
                  ),
                },
              )
            : null,
        body: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig?>{
            Breakpoints.standard: SlotLayout.from(
              key: const Key('body'),
              builder: widget.body,
            ),
            if (widget.smallBody != null)
              widget.smallBreakpoint: SlotLayout.from(
                key: const Key('smallBody'),
                builder: widget.smallBody,
              ),
          },
        ),
        secondaryBody: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig?>{
            if (widget.displayId > 0)
              Breakpoints.standard: SlotLayout.from(
                key: const Key('sBodyForcedSecondary'),
                builder: widget.secondaryBody,
              )
            else ...<Breakpoint, SlotLayoutConfig?>{
              Breakpoints.standard: SlotLayout.from(
                key: const Key('sBody'),
                builder: widget.secondaryBody,
              ),
              if (widget.smallSecondaryBody != null)
                widget.smallBreakpoint: SlotLayout.from(
                  key: const Key('smallSBody'),
                  builder: widget.smallSecondaryBody,
                ),
            }
          },
        ),
      ),
    );
  }

  void _onDrawerDestinationSelected(int index) {
    if (widget.useDrawer) {
      final ScaffoldState? scaffoldCurrentContext = _scaffoldKey.currentState;
      if (scaffoldCurrentContext?.isDrawerOpen ?? false) {
        scaffoldCurrentContext!.closeDrawer();
      }
    }
    widget.onSelectedIndexChange?.call(index);
  }
}

class _AppBarProxy extends StatelessWidget implements PreferredSizeWidget {
  const _AppBarProxy({required super.key, required this.child});
  final PreferredSizeWidget child;
  @override
  Size get preferredSize => child.preferredSize;
  @override
  Widget build(BuildContext context) => child;
}
