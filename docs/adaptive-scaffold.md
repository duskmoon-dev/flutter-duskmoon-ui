# Adaptive Scaffold

The `duskmoon_adaptive_scaffold` package provides a responsive scaffold that implements Material Design 3 adaptive layout patterns. It automatically switches between `BottomNavigationBar`, `NavigationRail`, extended `NavigationRail`, and `Drawer` based on screen width and platform.

This package is a fork of `flutter_adaptive_scaffold`, versioned in sync with other DuskMoon packages.

## Table of Contents

- [Installation](#installation)
- [Quick Start](#quick-start)
- [AdaptiveScaffold](#adaptivescaffold)
- [Breakpoints](#breakpoints)
- [AdaptiveLayout](#adaptivelayout)
- [SlotLayout](#slotlayout)
- [Animations](#animations)
- [Collapsible Navigation Rail](#collapsible-navigation-rail)
- [Custom Breakpoints](#custom-breakpoints)

## Installation

```yaml
dependencies:
  duskmoon_adaptive_scaffold: ^1.2.3
```

```dart
import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';
```

> **Requirements:** Dart >= 3.5.0, Flutter >= 3.24.0

## Quick Start

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
        NavigationDestination(icon: Icon(Icons.article), label: 'Articles'),
        NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
        NavigationDestination(icon: Icon(Icons.video_call), label: 'Video'),
      ],
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (index) => setState(() => _selectedIndex = index),
      body: (_) => const Center(child: Text('Main content')),
    );
  }
}
```

This automatically renders:
- A **BottomNavigationBar** on phones (< 600 dp)
- A **NavigationRail** (icons only) on tablets (600-840 dp)
- An **extended NavigationRail** (icons + labels) on desktops (840+ dp)
- A **Drawer** on small desktop windows (< 600 dp on desktop platforms)

## AdaptiveScaffold

`AdaptiveScaffold` is the high-level API. It wraps `AdaptiveLayout` with sensible defaults for navigation and body content at each breakpoint.

### Body Builders Per Breakpoint

Provide different layouts for different screen sizes. If a breakpoint-specific body is not set, the default `body` is used.

```dart
AdaptiveScaffold(
  destinations: destinations,
  selectedIndex: _selectedIndex,
  onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),

  // Phone layout
  smallBody: (_) => ListView.builder(
    itemCount: items.length,
    itemBuilder: (_, i) => ListTile(title: Text(items[i])),
  ),

  // Default layout (medium and above)
  body: (_) => GridView.count(
    crossAxisCount: 2,
    children: items.map((i) => Card(child: Center(child: Text(i)))).toList(),
  ),

  // Extra-large screens get a 3-column grid
  extraLargeBody: (_) => GridView.count(
    crossAxisCount: 3,
    children: items.map((i) => Card(child: Center(child: Text(i)))).toList(),
  ),
)
```

### Main/Detail (Two-Pane) Layout

Use `secondaryBody` for a detail pane that appears alongside the body on larger screens.

```dart
AdaptiveScaffold(
  destinations: destinations,
  selectedIndex: _selectedIndex,
  onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),
  body: (_) => const ItemListView(),
  secondaryBody: (_) => const ItemDetailView(),
  bodyRatio: 0.4, // Body takes 40%, detail takes 60%
)
```

The `bodyOrientation` parameter controls whether body and secondaryBody are laid out side-by-side (`Axis.horizontal`, the default) or stacked (`Axis.vertical`).

### Navigation Rail Customization

```dart
AdaptiveScaffold(
  destinations: destinations,
  selectedIndex: _selectedIndex,
  onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),
  body: (_) => const MyContent(),

  // Add widgets above/below nav items
  leadingUnextendedNavRail: const Icon(Icons.menu),
  leadingExtendedNavRail: const Text('My App'),
  trailingNavRail: const Spacer(),

  // Size
  navigationRailWidth: 80,
  extendedNavigationRailWidth: 256,

  // Alignment (-1.0 = top, 0.0 = center, 1.0 = bottom)
  groupAlignment: -1.0,

  // Custom destination mapping
  navigationRailDestinationBuilder: (index, dest) {
    return NavigationRailDestination(
      icon: dest.icon,
      selectedIcon: dest.selectedIcon,
      label: Text(dest.label),
      padding: const EdgeInsets.symmetric(vertical: 8),
    );
  },
)
```

### Drawer Behavior

On desktop platforms at small widths, `AdaptiveScaffold` uses a `Drawer` instead of a `BottomNavigationBar` by default. Control this with:

```dart
AdaptiveScaffold(
  destinations: destinations,
  useDrawer: true,                         // default: true
  drawerBreakpoint: Breakpoints.smallDesktop, // when to show drawer
  appBar: AppBar(title: const Text('My App')), // custom AppBar with drawer
  appBarBreakpoint: Breakpoints.small,     // show AppBar at this breakpoint too
  // ...
)
```

### Overriding Breakpoints

Replace the default breakpoints with custom ones:

```dart
AdaptiveScaffold(
  destinations: destinations,
  smallBreakpoint: const Breakpoint(beginWidth: 0, endWidth: 500),
  mediumBreakpoint: const Breakpoint(beginWidth: 500, endWidth: 800),
  mediumLargeBreakpoint: const Breakpoint(beginWidth: 800, endWidth: 1100),
  largeBreakpoint: const Breakpoint(beginWidth: 1100, endWidth: 1500),
  extraLargeBreakpoint: const Breakpoint(beginWidth: 1500, endWidth: null),
  // ...
)
```

## Breakpoints

The `Breakpoints` class provides Material 3 standard screen-size constants:

| Breakpoint | Width Range | Recommended Panes |
|---|---|---|
| `Breakpoints.small` | 0 -- 600 dp | 1 |
| `Breakpoints.medium` | 600 -- 840 dp | 1 (max 2) |
| `Breakpoints.mediumLarge` | 840 -- 1200 dp | 2 |
| `Breakpoints.large` | 1200 -- 1600 dp | 2 |
| `Breakpoints.extraLarge` | 1600+ dp | 2 (max 3) |

### "And Up" Variants

These have no upper bound on width:

- `Breakpoints.smallAndUp` -- width >= 0
- `Breakpoints.mediumAndUp` -- width >= 600
- `Breakpoints.mediumLargeAndUp` -- width >= 840
- `Breakpoints.largeAndUp` -- width >= 1200

### Platform-Specific Variants

Each size breakpoint has desktop and mobile variants:

- `Breakpoints.smallDesktop` / `Breakpoints.smallMobile`
- `Breakpoints.mediumDesktop` / `Breakpoints.mediumMobile`
- `Breakpoints.mediumLargeDesktop` / `Breakpoints.mediumLargeMobile`
- `Breakpoints.largeDesktop` / `Breakpoints.largeMobile`
- `Breakpoints.extraLargeDesktop` / `Breakpoints.extraLargeMobile`

Desktop platforms: macOS, Windows, Linux. Mobile platforms: Android, iOS, Fuchsia.

### Querying the Active Breakpoint

```dart
// Get the active breakpoint from context
final bp = Breakpoint.activeBreakpointOf(context);
final bp = Breakpoint.defaultBreakpointOf(context);

// Platform checks
if (Breakpoint.isDesktop(context)) { /* desktop logic */ }
if (Breakpoint.isMobile(context))  { /* mobile logic */ }

// Manual activation check
if (Breakpoints.mediumAndUp.isActive(context)) {
  // Screen is 600dp or wider
}

// Comparison operators
Breakpoints.large > Breakpoints.medium  // true
bp.between(Breakpoints.medium, Breakpoints.large) // true if in range
```

## AdaptiveLayout

`AdaptiveLayout` is the lower-level widget that `AdaptiveScaffold` is built on. Use it when you need full control over every slot.

It provides 6 layout slots:
- `topNavigation` -- full width at the top
- `bottomNavigation` -- full width at the bottom
- `primaryNavigation` -- leading side (left in LTR)
- `secondaryNavigation` -- trailing side (right in LTR)
- `body` -- main content area
- `secondaryBody` -- detail pane beside body

Each slot accepts a `SlotLayout` widget that maps breakpoints to content.

```dart
AdaptiveLayout(
  primaryNavigation: SlotLayout(
    config: {
      Breakpoints.medium: SlotLayout.from(
        key: const Key('nav-medium'),
        inAnimation: AdaptiveScaffold.leftOutIn,
        builder: (_) => AdaptiveScaffold.standardNavigationRail(
          destinations: railDestinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onChanged,
        ),
      ),
      Breakpoints.mediumLargeAndUp: SlotLayout.from(
        key: const Key('nav-large'),
        inAnimation: AdaptiveScaffold.leftOutIn,
        builder: (_) => AdaptiveScaffold.standardNavigationRail(
          destinations: railDestinations,
          selectedIndex: selectedIndex,
          extended: true,
          onDestinationSelected: onChanged,
        ),
      ),
    },
  ),
  body: SlotLayout(
    config: {
      Breakpoints.standard: SlotLayout.from(
        key: const Key('body'),
        builder: (_) => const MyContent(),
      ),
    },
  ),
  bottomNavigation: SlotLayout(
    config: {
      Breakpoints.small: SlotLayout.from(
        key: const Key('bottom-nav'),
        inAnimation: AdaptiveScaffold.bottomToTop,
        builder: (_) => AdaptiveScaffold.standardBottomNavigationBar(
          destinations: destinations,
          currentIndex: selectedIndex,
          onDestinationSelected: onChanged,
        ),
      ),
    },
  ),
  bodyRatio: 0.5,
  bodyOrientation: Axis.horizontal,
  transitionDuration: const Duration(seconds: 1),
  internalAnimations: true,
)
```

## SlotLayout

`SlotLayout` maps `Breakpoint`s to `SlotLayoutConfig`s. The last active breakpoint takes priority.

```dart
SlotLayout(
  config: {
    Breakpoints.small: SlotLayout.from(
      key: const Key('content-small'),
      builder: (_) => const MobileView(),
      inAnimation: AdaptiveScaffold.fadeIn,
      outAnimation: AdaptiveScaffold.fadeOut,
      inDuration: const Duration(milliseconds: 500),
      outDuration: const Duration(milliseconds: 300),
      inCurve: Curves.easeOut,
      outCurve: Curves.easeIn,
    ),
    Breakpoints.mediumAndUp: SlotLayout.from(
      key: const Key('content-desktop'),
      builder: (_) => const DesktopView(),
    ),
  },
)
```

The `key` parameter is required and must be unique per config entry -- it drives the `AnimatedSwitcher` that handles transitions.

### Programmatic Widget Selection

```dart
final config = SlotLayout.pickWidget(context, {
  Breakpoints.small: SlotLayout.from(key: const Key('a'), builder: (_) => A()),
  Breakpoints.mediumAndUp: SlotLayout.from(key: const Key('b'), builder: (_) => B()),
});
// Returns the SlotLayoutConfig for the currently active breakpoint
```

## Animations

`AdaptiveScaffold` provides static animation builders for use with `SlotLayout.from`:

| Animation | Effect |
|---|---|
| `bottomToTop` | Slide up from below |
| `topToBottom` | Slide down off screen |
| `leftOutIn` | Slide in from left |
| `leftInOut` | Slide out to left |
| `rightOutIn` | Slide in from right |
| `fadeIn` | Fade in (easeInCubic) |
| `fadeOut` | Fade out (easeInCubic) |
| `stayOnScreen` | Keep visible during out-transition |

Usage:

```dart
SlotLayout.from(
  key: const Key('nav'),
  builder: (_) => const MyNavRail(),
  inAnimation: AdaptiveScaffold.leftOutIn,
  outAnimation: AdaptiveScaffold.leftInOut,
)
```

## Collapsible Navigation Rail

Allow users to collapse/expand the navigation rail on large screens:

```dart
class _MyHomeState extends State<MyHome> {
  int _selectedIndex = 0;
  bool? _isExtended; // null = auto (breakpoint-driven)

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      destinations: destinations,
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),
      body: (_) => const MyContent(),

      // Collapse/expand support
      showCollapseToggle: true,
      isExtendedOverride: _isExtended,
      onExtendedChange: (extended) {
        setState(() => _isExtended = extended);
      },
      collapseIcon: Icons.menu_open,  // shown when extended
      expandIcon: Icons.menu,          // shown when collapsed
    );
  }
}
```

## Custom Breakpoints

Create breakpoints with custom width, height, and platform constraints:

```dart
const tabletLandscape = Breakpoint(
  beginWidth: 900,
  endWidth: 1200,
  beginHeight: 600,
  endHeight: null,
  platform: Breakpoint.mobile,
  spacing: 24,
  margin: 24,
  padding: 12,
  recommendedPanes: 2,
  maxPanes: 2,
);

// Use in SlotLayout
SlotLayout(
  config: {
    tabletLandscape: SlotLayout.from(
      key: const Key('tablet-landscape'),
      builder: (_) => const TwoColumnLayout(),
    ),
  },
)

// Use as AdaptiveScaffold override
AdaptiveScaffold(
  mediumBreakpoint: tabletLandscape,
  // ...
)
```

Each breakpoint carries Material 3 spacing metadata (`spacing`, `margin`, `padding`, `recommendedPanes`, `maxPanes`) that helper methods like `toMaterialGrid` use automatically.
