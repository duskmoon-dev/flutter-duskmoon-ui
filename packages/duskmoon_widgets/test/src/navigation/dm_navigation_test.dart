import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmAppBar', () {
    testWidgets('renders AppBar on Material platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(platform: TargetPlatform.android),
            child: const Scaffold(
              appBar: DmAppBar(title: Text('Title')),
              body: SizedBox(),
            ),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('renders CupertinoNavigationBar on Cupertino platform',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(platform: TargetPlatform.iOS),
            child: const Scaffold(
              appBar: DmAppBar(title: Text('Title')),
              body: SizedBox(),
            ),
          ),
        ),
      );

      expect(find.byType(CupertinoNavigationBar), findsOneWidget);
      expect(find.text('Title'), findsOneWidget);
    });

    testWidgets('renders actions in Material mode', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(platform: TargetPlatform.android),
            child: Scaffold(
              appBar: DmAppBar(
                title: const Text('Title'),
                actions: [
                  IconButton(onPressed: () {}, icon: const Icon(Icons.add))
                ],
              ),
              body: const SizedBox(),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('implements PreferredSizeWidget', (tester) async {
      const appBar = DmAppBar(title: Text('Title'));
      expect(appBar.preferredSize, const Size.fromHeight(kToolbarHeight));
    });

    testWidgets('respects platformOverride', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(platform: TargetPlatform.android),
            child: const Scaffold(
              appBar: DmAppBar(
                title: Text('Title'),
                platformOverride: DmPlatformStyle.cupertino,
              ),
              body: SizedBox(),
            ),
          ),
        ),
      );

      expect(find.byType(CupertinoNavigationBar), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
    });
  });

  group('DmBottomNav', () {
    const destinations = [
      DmNavDestination(icon: Icon(Icons.home), label: 'Home'),
      DmNavDestination(icon: Icon(Icons.settings), label: 'Settings'),
    ];

    testWidgets('renders NavigationBar on Material platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const SizedBox(),
            bottomNavigationBar: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: DmBottomNav(
                destinations: destinations,
                selectedIndex: 0,
                onDestinationSelected: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders CupertinoTabBar on Cupertino platform',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const SizedBox(),
            bottomNavigationBar: Theme(
              data: ThemeData(platform: TargetPlatform.iOS),
              child: DmBottomNav(
                destinations: destinations,
                selectedIndex: 0,
                onDestinationSelected: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(CupertinoTabBar), findsOneWidget);
    });

    testWidgets('calls onDestinationSelected on tap', (tester) async {
      int? tappedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: const SizedBox(),
            bottomNavigationBar: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: DmBottomNav(
                destinations: destinations,
                selectedIndex: 0,
                onDestinationSelected: (i) => tappedIndex = i,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Settings'));
      expect(tappedIndex, 1);
    });
  });

  group('DmTabBar', () {
    const tabs = [
      DmTab(label: 'Tab 1'),
      DmTab(label: 'Tab 2'),
    ];

    testWidgets('renders TabBar on Material platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmTabBar(tabs: tabs),
            ),
          ),
        ),
      );

      expect(find.byType(TabBar), findsOneWidget);
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
    });

    testWidgets(
        'renders CupertinoSlidingSegmentedControl on Cupertino platform',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.iOS),
              child: const DmTabBar(tabs: tabs),
            ),
          ),
        ),
      );

      expect(
        find.byType(CupertinoSlidingSegmentedControl<int>),
        findsOneWidget,
      );
    });

    testWidgets('calls onChanged when tab is tapped (Material)',
        (tester) async {
      int? changedIndex;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: DmTabBar(
                tabs: tabs,
                onChanged: (i) => changedIndex = i,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      expect(changedIndex, 1);
    });
  });

  group('DmDrawer', () {
    testWidgets('renders Drawer on Material platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Theme(
            data: ThemeData(platform: TargetPlatform.android),
            child: Scaffold(
              drawer: const DmDrawer(child: Text('Drawer content')),
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      // Open the drawer
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.byType(Drawer), findsOneWidget);
      expect(find.text('Drawer content'), findsOneWidget);
    });

    testWidgets('renders Container with border on Cupertino platform',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.iOS),
              child: const SizedBox(
                width: 400,
                height: 600,
                child: DmDrawer(child: Text('Drawer content')),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Drawer), findsNothing);
      expect(find.text('Drawer content'), findsOneWidget);

      // Find the decorated Container
      final container = tester
          .widgetList<Container>(
            find.byType(Container),
          )
          .where((c) => c.decoration != null)
          .first;
      final decoration = container.decoration! as BoxDecoration;
      expect(decoration.border, isNotNull);
    });

    testWidgets('respects platformOverride', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const SizedBox(
                width: 400,
                height: 600,
                child: DmDrawer(
                  platformOverride: DmPlatformStyle.cupertino,
                  child: Text('content'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Drawer), findsNothing);
    });
  });
}
