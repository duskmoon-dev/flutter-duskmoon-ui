import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

class ScaffoldPage extends StatelessWidget {
  const ScaffoldPage({super.key});

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
