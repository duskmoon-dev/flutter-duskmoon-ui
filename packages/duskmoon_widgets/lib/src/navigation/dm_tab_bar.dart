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
      DmPlatformStyle.fluent => wrapWithFluentTheme(
          context,
          _FluentTabBar(
              tabs: tabs, selectedIndex: selectedIndex, onChanged: onChanged),
        ),
    };
  }
}

class _FluentTabBar extends StatefulWidget {
  const _FluentTabBar({
    required this.tabs,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<DmTab> tabs;
  final int selectedIndex;
  final ValueChanged<int>? onChanged;

  @override
  State<_FluentTabBar> createState() => _FluentTabBarState();
}

class _FluentTabBarState extends State<_FluentTabBar> {
  late final _controller = fluent.TabViewController(
    initialTabs: _buildTabs(),
    initialIndex: widget.tabs.isEmpty ? 0 : widget.selectedIndex,
  );

  List<fluent.Tab> _buildTabs() => [
        for (final tab in widget.tabs)
          fluent.Tab(
            text: Text(tab.label),
            icon: tab.icon,
            body: const SizedBox.shrink(),
          ),
      ];

  @override
  void didUpdateWidget(covariant _FluentTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tabs != oldWidget.tabs) {
      _controller.replaceTabs(_buildTabs());
    }
    if (widget.tabs.isNotEmpty) _controller.select(widget.selectedIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: fluent.TabView(
        controller: _controller,
        onChanged: (index) {
          // TabView updates the controller before notifying its caller.
          _controller.select(widget.selectedIndex);
          widget.onChanged?.call(index);
        },
        // TabView 4.18 reorders its controller before invoking this callback.
        onReorder: (oldIndex, newIndex) => _controller.move(newIndex, oldIndex),
        tabWidthBehavior: fluent.TabWidthBehavior.sizeToContent,
        closeButtonVisibility: fluent.CloseButtonVisibilityMode.never,
        showScrollButtons: false,
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
