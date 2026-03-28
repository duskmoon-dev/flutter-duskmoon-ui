import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/platform_resolver.dart';

class DmTabBar extends StatelessWidget with AdaptiveWidget {
  const DmTabBar({
    super.key,
    required this.tabs,
    this.selectedIndex = 0,
    this.onChanged,
    this.platformOverride,
  });

  final List<DmTab> tabs;
  final int selectedIndex;
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
            tabs:
                tabs.map((t) => Tab(text: t.label, icon: t.icon)).toList(),
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
    };
  }
}

class DmTab {
  const DmTab({required this.label, this.icon});

  final String label;
  final Widget? icon;
}
