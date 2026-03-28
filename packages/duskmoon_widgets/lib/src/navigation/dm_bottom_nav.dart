import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive bottom navigation bar (Material NavigationBar / Cupertino tab bar).
class DmBottomNav extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive bottom navigation bar.
  const DmBottomNav({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.platformOverride,
  });

  /// The navigation destinations to display.
  final List<DmNavDestination> destinations;

  /// Index of the currently selected destination.
  final int selectedIndex;

  /// Called when a destination is tapped.
  final ValueChanged<int> onDestinationSelected;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
          destinations: destinations
              .map(
                (d) => NavigationDestination(icon: d.icon, label: d.label),
              )
              .toList(),
        ),
      DmPlatformStyle.cupertino => CupertinoTabBar(
          currentIndex: selectedIndex,
          onTap: onDestinationSelected,
          items: destinations
              .map(
                (d) => BottomNavigationBarItem(icon: d.icon, label: d.label),
              )
              .toList(),
        ),
    };
  }
}

/// A single destination entry used by [DmBottomNav].
class DmNavDestination {
  /// Creates a navigation destination with an [icon] and [label].
  const DmNavDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  /// Icon displayed for this destination.
  final Widget icon;

  /// Text label for this destination.
  final String label;

  /// Alternative icon shown when this destination is selected.
  final Widget? selectedIcon;
}
