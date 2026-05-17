import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

import '../../destination.dart';

class ScaffoldScreen extends StatelessWidget {
  static const name = 'Scaffold';
  static const path = 'scaffold';

  const ScaffoldScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key('Widgets')),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: const BackButton(),
        title: const Text('Scaffold & Layout'),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => const _ScaffoldBody(),
    );
  }
}

class _ScaffoldBody extends StatelessWidget {
  const _ScaffoldBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildActionListSection(context),
        const SizedBox(height: 16),
        _buildAppBarSection(context),
        const SizedBox(height: 16),
        _buildTabBarSection(context),
        const SizedBox(height: 16),
        _buildDrawerSection(context),
        const SizedBox(height: 16),
        _buildLayoutWidgets(context),
        const SizedBox(height: 16),
        _buildScaffoldDemo(context),
        const SizedBox(height: 16),
        _buildDuoScreenDemo(context),
      ],
    );
  }

  Widget _buildActionListSection(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DmActionList', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
                'Renders as popup (small), icon buttons (medium), or text buttons (large)',
                style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 16),
            for (final size in DmActionSize.values) ...[
              Text('Size: ${size.name}',
                  style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 8),
              DmActionList(
                size: size,
                actions: [
                  DmAction(
                    title: 'Edit',
                    icon: Icons.edit,
                    onPressed: () => _showMessage(context, 'Edit'),
                  ),
                  DmAction(
                    title: 'Share',
                    icon: Icons.share,
                    onPressed: () => _showMessage(context, 'Share'),
                  ),
                  DmAction(
                    title: 'Delete',
                    icon: Icons.delete,
                    onPressed: () => _showMessage(context, 'Delete'),
                  ),
                  DmAction(
                    title: 'Disabled',
                    icon: Icons.block,
                    onPressed: () {},
                    disabled: true,
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarSection(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DmAppBar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DmButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: DmAppBar(
                      title: const Text('DmAppBar Demo'),
                      actions: [
                        DmIconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {},
                        ),
                        DmIconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    body: const Center(
                      child: Text('Page with DmAppBar'),
                    ),
                  ),
                ),
              ),
              child: const Text('Open AppBar Demo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBarSection(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DmTabBar', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            const _TabBarDemo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerSection(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DmDrawer', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            DmButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Scaffold(
                    appBar: const DmAppBar(title: Text('Drawer Demo')),
                    drawer: DmDrawer(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          DrawerHeader(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: Text(
                              'DmDrawer',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.home),
                            title: const Text('Home'),
                            onTap: () => Navigator.pop(context),
                          ),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Settings'),
                            onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    body: const Center(
                      child: Text('Swipe from left or tap menu button'),
                    ),
                  ),
                ),
              ),
              child: const Text('Open Drawer Demo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayoutWidgets(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Layout Widgets',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Text('DmCard', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DmCard(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('elevation: 0',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DmCard(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('elevation: 2',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DmCard(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text('elevation: 6',
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text('DmDivider', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            const DmDivider(),
            const SizedBox(height: 4),
            const DmDivider(thickness: 2, indent: 16, endIndent: 16),
            const SizedBox(height: 4),
            DmDivider(color: Theme.of(context).colorScheme.primary),
          ],
        ),
      ),
    );
  }

  Widget _buildScaffoldDemo(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DmScaffold', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Responsive scaffold: NavigationRail (desktop) / BottomNav (mobile)',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            DmButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const _ScaffoldDemoPage()),
              ),
              child: const Text('Open DmScaffold Demo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuoScreenDemo(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Duo Screen Layout',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'Adaptive scaffold for dual-screen devices (e.g., AYANEO Pocket DS).\n'
              'Body on main screen, NavigationRail + secondary body on second screen.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final feature
                    in MediaQuery.displayFeaturesOf(context))
                  Chip(
                    label: Text(
                      '${feature.type.name}: ${feature.bounds}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                if (MediaQuery.displayFeaturesOf(context).isEmpty)
                  Chip(
                    label: Text(
                      'No display features detected',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            DmButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const _DuoScreenDemoPage()),
              ),
              child: const Text('Open Duo Screen Demo'),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String msg) {
    showDmSnackbar(
      context: context,
      message: Text(msg),
      duration: const Duration(seconds: 2),
    );
  }
}

class _TabBarDemo extends StatefulWidget {
  const _TabBarDemo();

  @override
  State<_TabBarDemo> createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<_TabBarDemo> {
  int _selectedTab = 0;

  static const _tabLabels = ['Photos', 'Videos', 'Music'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DmTabBar(
          tabs: [
            for (final label in _tabLabels) DmTab(label: label),
          ],
          selectedIndex: _selectedTab,
          onChanged: (i) => setState(() => _selectedTab = i),
        ),
        const SizedBox(height: 12),
        Container(
          height: 60,
          alignment: Alignment.center,
          child: Text('Selected: ${_tabLabels[_selectedTab]}'),
        ),
      ],
    );
  }
}

class _ScaffoldDemoPage extends StatefulWidget {
  const _ScaffoldDemoPage();

  @override
  State<_ScaffoldDemoPage> createState() => _ScaffoldDemoPageState();
}

class _ScaffoldDemoPageState extends State<_ScaffoldDemoPage> {
  int _selectedIndex = 0;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.explore), label: 'Explore'),
    NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
  ];

  static const _labels = ['Home', 'Explore', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return DmScaffold(
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),
      destinations: _destinations,
      appBar: DmAppBar(
        title: const Text('DmScaffold Demo'),
        actions: [
          DmIconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      body: (_) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              [Icons.home, Icons.explore, Icons.person][_selectedIndex],
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              _labels[_selectedIndex],
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Resize window to see NavigationRail vs BottomNav',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}

class _DuoScreenDemoPage extends StatefulWidget {
  const _DuoScreenDemoPage();

  @override
  State<_DuoScreenDemoPage> createState() => _DuoScreenDemoPageState();
}

class _DuoScreenDemoPageState extends State<_DuoScreenDemoPage> {
  int _selectedIndex = 0;

  static const _destinations = [
    NavigationDestination(icon: Icon(Icons.inbox), label: 'Inbox'),
    NavigationDestination(icon: Icon(Icons.article), label: 'Articles'),
    NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
    NavigationDestination(icon: Icon(Icons.video_call), label: 'Video'),
  ];

  static const _labels = ['Inbox', 'Articles', 'Chat', 'Video'];
  static const _icons = [Icons.inbox, Icons.article, Icons.chat, Icons.video_call];
  static const _colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];

  @override
  Widget build(BuildContext context) {
    final features = MediaQuery.displayFeaturesOf(context);

    return DmAdaptiveScaffold(
      duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
      selectedIndex: _selectedIndex,
      onSelectedIndexChange: (i) => setState(() => _selectedIndex = i),
      destinations: _destinations,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        title: const Text('Duo Screen Demo'),
        actions: [
          DmIconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => Container(
        color: _colors[_selectedIndex].withValues(alpha: 0.05),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _icons[_selectedIndex],
                size: 80,
                color: _colors[_selectedIndex],
              ),
              const SizedBox(height: 24),
              Text(
                'Main Screen',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 8),
              Text(
                _labels[_selectedIndex],
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: _colors[_selectedIndex],
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'Display features: ${features.length}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              for (final f in features)
                Text(
                  '${f.type.name}: ${f.bounds}',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
            ],
          ),
        ),
      ),
      secondaryBody: (_) => Container(
        color: _colors[_selectedIndex].withValues(alpha: 0.1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.devices_fold,
                size: 48,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'Secondary Screen',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Detail view for: ${_labels[_selectedIndex]}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

