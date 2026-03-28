import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmBottomNav extends StatelessWidget with AdaptiveWidget {
  const DmBottomNav({
    super.key,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    this.platformOverride,
  });

  final List<DmNavDestination> destinations;
  final int selectedIndex;
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

class DmNavDestination {
  const DmNavDestination({
    required this.icon,
    required this.label,
    this.selectedIcon,
  });

  final Widget icon;
  final String label;
  final Widget? selectedIcon;
}
