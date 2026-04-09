import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:duskmoon_theme/duskmoon_theme.dart';
import '../adaptive/fluent_theme_bridge.dart';

/// An adaptive tab bar (Material TabBar / Cupertino segmented control).
class DmTabBar extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive tab bar.
  const DmTabBar({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.onChanged,
    this.platformOverride,
  });

  /// The tabs to display.
  final List<DmTab> tabs;

  /// Index of the currently selected tab.
  final int selectedIndex;

  /// Called when the selected tab changes.
  final ValueChanged<int>? onChanged;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => DefaultTabController(
          length: tabs.length,
          initialIndex: selectedIndex,
          child: TabBar(
            onTap: onChanged,
            tabs: tabs.map((t) => Tab(text: t.label, icon: t.icon)).toList(),
          ),
        ),
      DmPlatformStyle.cupertino => CupertinoSlidingSegmentedControl<int>(
          groupValue: selectedIndex,
          onValueChanged: (value) {
            if (value != null) onChanged?.call(value);
          },
          children: {
            for (var i = 0; i < tabs.length; i++)
              i: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(tabs[i].label),
              ),
          },
        ),
      DmPlatformStyle.fluent => _buildFluent(context),
    };
  }

  Widget _buildFluent(BuildContext context) {
    return wrapWithFluentTheme(
      context,
      SizedBox(
        height: 40,
        child: fluent.TabView(
          currentIndex: selectedIndex,
          onChanged: onChanged ?? (_) {},
          tabWidthBehavior: fluent.TabWidthBehavior.sizeToContent,
          closeButtonVisibility: fluent.CloseButtonVisibilityMode.never,
          showScrollButtons: false,
          tabs: tabs
              .map((t) => fluent.Tab(
                    text: Text(t.label),
                    icon: t.icon,
                    body: const SizedBox.shrink(),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

/// A single tab entry used by [DmTabBar].
class DmTab {
  /// Creates a tab with a [label] and optional [icon].
  const DmTab({required this.label, this.icon});

  /// Text label for this tab.
  final String label;

  /// Optional icon displayed alongside the label.
  final Widget? icon;
}
