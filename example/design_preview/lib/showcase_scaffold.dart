import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

import 'destination.dart';

/// Shared across showcase routes; null retains breakpoint-driven defaults.
final navigationRailExtendedNotifier = ValueNotifier<bool?>(null);

/// Common showcase navigation with a shared sidebar width preference.
class ShowcaseScaffold extends StatelessWidget {
  const ShowcaseScaffold({
    super.key,
    required this.selectedIndex,
    required this.appBar,
    required this.body,
  });

  final int selectedIndex;
  final PreferredSizeWidget appBar;
  final WidgetBuilder body;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool?>(
      valueListenable: navigationRailExtendedNotifier,
      builder: (context, isExtended, _) => DmAdaptiveScaffold(
        selectedIndex: selectedIndex,
        onSelectedIndexChange: (index) =>
            Destinations.changeHandler(index, context),
        destinations: Destinations.navs,
        useDrawer: true,
        transitionDuration: Duration.zero,
        appBar: appBar,
        appBarBreakpoint: Breakpoints.standard,
        body: body,
        showCollapseToggle: true,
        isExtendedOverride: isExtended,
        onExtendedChange: (value) =>
            navigationRailExtendedNotifier.value = value,
      ),
    );
  }
}
