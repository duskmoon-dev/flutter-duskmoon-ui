// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'adaptive_layout.dart';
import 'breakpoints.dart';
import 'duo_screen.dart';
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
    this.navigationVisible = true,
    this.showCollapseToggle = false,
    this.collapseIcon = Icons.chevron_left,
    this.expandIcon = Icons.chevron_right,
    this.duoScreenPolicy = DuoScreenPolicy.splitBody,
    this.duoScreenRole = DuoScreenRole.single,
    @Deprecated('Use duoScreenRole instead. Values greater than 0 map to '
        'DuoScreenRole.secondary. Will be removed in 2.0.0.')
    this.displayId = 0,
  }) : assert(
          destinations.length >= 2,
          'At least two destinations are required',
        );

  /// Legacy role selector: positive IDs map to [DuoScreenRole.secondary].
  /// Prefer role selection after a companion display has successfully connected.
  @Deprecated('Use duoScreenRole instead. Will be removed in 2.0.0.')
  final int displayId;

  /// The role of this view; primary requires an active companion view.
  /// Only used with [DuoScreenPolicy.navigationOnSecondary].
  final DuoScreenRole duoScreenRole;
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

  /// Whether rail, drawer and bottom navigation are visible.
  ///
  /// Hiding navigation preserves the selected destination, rail preference and
  /// body state. Provide a caller-owned control to restore navigation.
  final bool navigationVisible;

  final bool showCollapseToggle;
  final IconData collapseIcon;
  final IconData expandIcon;

  /// Distribution of body, secondary body and navigation across screens.
  /// Navigation remains local when no separating feature or companion exists.
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
        return Padding(
          padding: padding,
          child: SizedBox(
            width: width,
            height: MediaQuery.sizeOf(context).height,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: NavigationRail(
                        labelType: labelType,
                        leading: leading,
                        trailing: trailing,
                        onDestinationSelected: onDestinationSelected,
                        groupAlignment: groupAlignment,
                        backgroundColor: backgroundColor,
                        extended: extended,
                        selectedIndex: selectedIndex,
                        selectedIconTheme: selectedIconTheme,
                        unselectedIconTheme: unselectedIconTheme,
                        selectedLabelTextStyle: selectedLabelTextStyle,
                        unselectedLabelTextStyle: unSelectedLabelTextStyle,
                        destinations: destinations,
                      ),
                    ),
                  ),
                );
              },
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

  bool? _isExtended;

  bool _shouldBeExtended(bool defaultExtended) {
    return widget.isExtendedOverride ?? _isExtended ?? defaultExtended;
  }

  Widget _buildToggleButton(bool isExtended) {
    return IconButton(
      tooltip: isExtended ? 'Collapse navigation' : 'Expand navigation',
      constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
      icon: Icon(isExtended ? widget.collapseIcon : widget.expandIcon),
      onPressed: () {
        if (widget.isExtendedOverride == null) {
          setState(() => _isExtended = !isExtended);
        }
        widget.onExtendedChange?.call(!isExtended);
      },
    );
  }

  Widget _buildNavigationRail(
    List<NavigationRailDestination> destinations, {
    bool defaultExtended = false,
  }) {
    final isExtended = _shouldBeExtended(defaultExtended);
    final width = isExtended
        ? widget.extendedNavigationRailWidth
        : widget.navigationRailWidth;
    final padding =
        widget.navigationRailPadding.resolve(Directionality.of(context));
    final theme = NavigationRailTheme.of(context);
    final rail = DmAdaptiveScaffold.standardNavigationRail(
      width: widget.showCollapseToggle ? double.infinity : width,
      extended: isExtended,
      leading: isExtended
          ? widget.leadingExtendedNavRail
          : widget.leadingUnextendedNavRail,
      trailing: widget.trailingNavRail,
      padding: widget.showCollapseToggle
          ? padding.copyWith(bottom: 0)
          : widget.navigationRailPadding,
      destinations: destinations,
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: widget.onSelectedIndexChange,
      backgroundColor: theme.backgroundColor,
      selectedIconTheme: theme.selectedIconTheme,
      unselectedIconTheme: theme.unselectedIconTheme,
      selectedLabelTextStyle: theme.selectedLabelTextStyle,
      unSelectedLabelTextStyle: theme.unselectedLabelTextStyle,
      labelType: widget.showCollapseToggle
          ? NavigationRailLabelType.none
          : theme.labelType,
      groupAlignment: widget.groupAlignment,
    );
    if (!widget.showCollapseToggle) return rail;

    return _AnimatedNavigationRailWidth(
      extended: isExtended,
      collapsedWidth: widget.navigationRailWidth + padding.horizontal,
      extendedWidth: widget.extendedNavigationRailWidth + padding.horizontal,
      child: Column(
        children: [
          Expanded(
            child: NavigationRailTheme(
              data: theme.copyWith(
                minWidth: widget.navigationRailWidth,
                minExtendedWidth: widget.extendedNavigationRailWidth,
              ),
              child: rail,
            ),
          ),
          Padding(
            padding: padding.copyWith(top: 0),
            child: Material(
              color: theme.backgroundColor ??
                  Theme.of(context).colorScheme.surface,
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Divider(height: 1),
                    Align(
                      alignment: isExtended
                          ? AlignmentDirectional.centerEnd
                          : Alignment.center,
                      child: _buildToggleButton(isExtended),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
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

    // Android display identifiers belong at the integration boundary.
    // ignore: deprecated_member_use_from_same_package
    final role = resolveDuoScreenRole(widget.duoScreenRole, widget.displayId);
    final hinge = DuoScreen.hingeOf(context);
    final mode = resolveDuoLayoutMode(
        policy: widget.duoScreenPolicy, role: role, hasHinge: hinge != null);
    final viewWidth = MediaQuery.sizeOf(context).width;
    final secondaryWidth = hinge == null || hinge.width > hinge.height
        ? viewWidth
        : Directionality.of(context) == TextDirection.ltr
            ? viewWidth - hinge.right
            : hinge.left;
    final hingeBottomNavigation =
        mode == DuoLayoutMode.hinge && secondaryWidth < 600;
    final bool isDrawerMode = mode == DuoLayoutMode.none &&
        widget.drawerBreakpoint.isActive(context) &&
        widget.useDrawer;
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
      drawer: widget.navigationVisible && isDrawerMode
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
        duoScreenRole: role,
        // Keep navigation slots mounted so body elements retain their position.
        primaryNavigation: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig>{
            if (widget.navigationVisible) ...<Breakpoint, SlotLayoutConfig>{
              if (mode == DuoLayoutMode.hinge && !hingeBottomNavigation)
                Breakpoints.standard: SlotLayout.from(
                  key: const Key('primaryNavigationHinge'),
                  builder: (_) => _buildNavigationRail(destinations),
                ),
              if (mode !=
                  DuoLayoutMode.hinge) ...<Breakpoint, SlotLayoutConfig>{
                widget.mediumBreakpoint: SlotLayout.from(
                  key: const Key('primaryNavigation'),
                  builder: (_) => _buildNavigationRail(destinations),
                ),
                widget.mediumLargeBreakpoint: SlotLayout.from(
                  key: const Key('primaryNavigation1'),
                  builder: (_) =>
                      _buildNavigationRail(destinations, defaultExtended: true),
                ),
                widget.largeBreakpoint: SlotLayout.from(
                  key: const Key('primaryNavigation2'),
                  builder: (_) =>
                      _buildNavigationRail(destinations, defaultExtended: true),
                ),
                widget.extraLargeBreakpoint: SlotLayout.from(
                  key: const Key('primaryNavigation3'),
                  builder: (_) =>
                      _buildNavigationRail(destinations, defaultExtended: true),
                ),
              },
            },
          },
        ),
        bottomNavigation: !isDrawerMode
            ? SlotLayout(
                config: <Breakpoint, SlotLayoutConfig>{
                  if (widget.navigationVisible &&
                      (mode != DuoLayoutMode.hinge || hingeBottomNavigation))
                    (hingeBottomNavigation
                        ? Breakpoints.standard
                        : widget.smallBreakpoint): SlotLayout.from(
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
              inAnimation: DmAdaptiveScaffold.fadeIn,
              outAnimation: DmAdaptiveScaffold.fadeOut,
              builder: widget.body,
            ),
            if (widget.smallBody != null)
              widget.smallBreakpoint:
                  (widget.smallBody != DmAdaptiveScaffold.emptyBuilder)
                      ? SlotLayout.from(
                          key: const Key('smallBody'),
                          inAnimation: DmAdaptiveScaffold.fadeIn,
                          outAnimation: DmAdaptiveScaffold.fadeOut,
                          builder: widget.smallBody,
                        )
                      : null,
            if (widget.body != null)
              widget.mediumBreakpoint:
                  (widget.body != DmAdaptiveScaffold.emptyBuilder)
                      ? SlotLayout.from(
                          key: const Key('body'),
                          inAnimation: DmAdaptiveScaffold.fadeIn,
                          outAnimation: DmAdaptiveScaffold.fadeOut,
                          builder: widget.body,
                        )
                      : null,
            if (widget.mediumLargeBody != null)
              widget.mediumLargeBreakpoint:
                  (widget.mediumLargeBody != DmAdaptiveScaffold.emptyBuilder)
                      ? SlotLayout.from(
                          key: const Key('mediumLargeBody'),
                          inAnimation: DmAdaptiveScaffold.fadeIn,
                          outAnimation: DmAdaptiveScaffold.fadeOut,
                          builder: widget.mediumLargeBody,
                        )
                      : null,
            if (widget.largeBody != null)
              widget.largeBreakpoint:
                  (widget.largeBody != DmAdaptiveScaffold.emptyBuilder)
                      ? SlotLayout.from(
                          key: const Key('largeBody'),
                          inAnimation: DmAdaptiveScaffold.fadeIn,
                          outAnimation: DmAdaptiveScaffold.fadeOut,
                          builder: widget.largeBody,
                        )
                      : null,
            if (widget.extraLargeBody != null)
              widget.extraLargeBreakpoint:
                  (widget.extraLargeBody != DmAdaptiveScaffold.emptyBuilder)
                      ? SlotLayout.from(
                          key: const Key('extraLargeBody'),
                          inAnimation: DmAdaptiveScaffold.fadeIn,
                          outAnimation: DmAdaptiveScaffold.fadeOut,
                          builder: widget.extraLargeBody,
                        )
                      : null,
          },
        ),
        secondaryBody: SlotLayout(
          config: <Breakpoint, SlotLayoutConfig?>{
            if (mode == DuoLayoutMode.secondary)
              Breakpoints.standard: SlotLayout.from(
                key: const Key('sBodyForcedSecondary'),
                outAnimation: DmAdaptiveScaffold.stayOnScreen,
                builder: widget.secondaryBody,
              )
            else ...<Breakpoint, SlotLayoutConfig?>{
              Breakpoints.standard: SlotLayout.from(
                key: const Key('sBody'),
                outAnimation: DmAdaptiveScaffold.stayOnScreen,
                builder: widget.secondaryBody,
              ),
              if (widget.smallSecondaryBody != null)
                widget.smallBreakpoint: (widget.smallSecondaryBody !=
                        DmAdaptiveScaffold.emptyBuilder)
                    ? SlotLayout.from(
                        key: const Key('smallSBody'),
                        outAnimation: DmAdaptiveScaffold.stayOnScreen,
                        builder: widget.smallSecondaryBody,
                      )
                    : null,
              if (widget.secondaryBody != null)
                widget.mediumBreakpoint:
                    (widget.secondaryBody != DmAdaptiveScaffold.emptyBuilder)
                        ? SlotLayout.from(
                            key: const Key('sBody'),
                            outAnimation: DmAdaptiveScaffold.stayOnScreen,
                            builder: widget.secondaryBody,
                          )
                        : null,
              if (widget.mediumLargeSecondaryBody != null)
                widget.mediumLargeBreakpoint:
                    (widget.mediumLargeSecondaryBody !=
                            DmAdaptiveScaffold.emptyBuilder)
                        ? SlotLayout.from(
                            key: const Key('mediumLargeSBody'),
                            outAnimation: DmAdaptiveScaffold.stayOnScreen,
                            builder: widget.mediumLargeSecondaryBody,
                          )
                        : null,
              if (widget.largeSecondaryBody != null)
                widget.largeBreakpoint: (widget.largeSecondaryBody !=
                        DmAdaptiveScaffold.emptyBuilder)
                    ? SlotLayout.from(
                        key: const Key('largeSBody'),
                        outAnimation: DmAdaptiveScaffold.stayOnScreen,
                        builder: widget.largeSecondaryBody,
                      )
                    : null,
              if (widget.extraLargeSecondaryBody != null)
                widget.extraLargeBreakpoint: (widget.extraLargeSecondaryBody !=
                        DmAdaptiveScaffold.emptyBuilder)
                    ? SlotLayout.from(
                        key: const Key('extraLargeSBody'),
                        outAnimation: DmAdaptiveScaffold.stayOnScreen,
                        builder: widget.extraLargeSecondaryBody,
                      )
                    : null,
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

/// Matches NavigationRail's extension animation so its content always fits.
class _AnimatedNavigationRailWidth extends StatefulWidget {
  const _AnimatedNavigationRailWidth({
    required this.extended,
    required this.collapsedWidth,
    required this.extendedWidth,
    required this.child,
  });

  final bool extended;
  final double collapsedWidth;
  final double extendedWidth;
  final Widget child;

  @override
  State<_AnimatedNavigationRailWidth> createState() =>
      _AnimatedNavigationRailWidthState();
}

class _AnimatedNavigationRailWidthState
    extends State<_AnimatedNavigationRailWidth>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: kThemeAnimationDuration,
      vsync: this,
      value: widget.extended ? 1 : 0,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(_AnimatedNavigationRailWidth oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.extended != oldWidget.extended) {
      widget.extended ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _animation.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      child: widget.child,
      builder: (context, child) => SizedBox(
        width: widget.collapsedWidth +
            (widget.extendedWidth - widget.collapsedWidth) * _animation.value,
        child: child,
      ),
    );
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
