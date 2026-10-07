import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmScaffold', () {
    final destinations = [
      const NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
      const NavigationDestination(
          icon: Icon(Icons.settings), label: 'Settings'),
    ];

    testWidgets('renders with destinations without throwing', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(size: Size(400, 800)),
            child: DmScaffold(
              destinations: destinations,
              body: (_) => const Text('Body'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // The scaffold should render without errors.
      expect(find.byType(DmScaffold), findsOneWidget);
    });

    test('has correct breakpoint constants', () {
      expect(DmScaffold.smallBreakpoint, Breakpoints.small);
      expect(DmScaffold.mediumBreakpoint, Breakpoints.medium);
      expect(DmScaffold.mediumLargeBreakpoint, Breakpoints.mediumLarge);
      expect(DmScaffold.largeBreakpoint, Breakpoints.large);
      expect(DmScaffold.extraLargeBreakpoint, Breakpoints.extraLarge);
      expect(DmScaffold.drawerBreakpoint, Breakpoints.smallDesktop);
    });

    testWidgets('forwards visibility and rail collapse controls',
        (tester) async {
      final changes = <bool>[];
      final devicePixelRatio = tester.view.devicePixelRatio;
      tester.view.physicalSize = Size(
        1200 * devicePixelRatio,
        800 * devicePixelRatio,
      );
      addTearDown(tester.view.resetPhysicalSize);
      Widget app({bool navigationVisible = false, bool isExtended = false}) =>
          MaterialApp(
            home: DmScaffold(
              destinations: destinations,
              navigationVisible: navigationVisible,
              showCollapseToggle: true,
              isExtendedOverride: isExtended,
              onExtendedChange: changes.add,
              collapseIcon: Icons.menu_open,
              expandIcon: Icons.menu,
              body: (_) => const Text('Body'),
            ),
          );
      await tester.pumpWidget(app());
      await tester.pumpAndSettle();
      final adaptive =
          tester.widget<DmAdaptiveScaffold>(find.byType(DmAdaptiveScaffold));
      expect(adaptive.navigationVisible, isFalse);
      expect(adaptive.showCollapseToggle, isTrue);
      expect(adaptive.isExtendedOverride, isFalse);
      expect(adaptive.collapseIcon, Icons.menu_open);
      expect(adaptive.expandIcon, Icons.menu);
      expect(find.byType(NavigationRail), findsNothing);
      expect(find.text('Body'), findsOneWidget);

      await tester.pumpWidget(app(navigationVisible: true));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.menu), findsOneWidget);
      await tester.tap(find.byTooltip('Expand navigation'));
      await tester.pumpAndSettle();
      expect(changes, [true]);
      expect(
          tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
          isFalse);

      await tester.pumpWidget(app(navigationVisible: true, isExtended: true));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.menu_open), findsOneWidget);
      await tester.tap(find.byTooltip('Collapse navigation'));
      await tester.pumpAndSettle();
      expect(changes, [true, false]);
      expect(tester.takeException(), isNull);
    });

    test('navigation and collapse defaults remain compatible', () {
      final scaffold = DmScaffold(destinations: destinations);
      expect(scaffold.navigationVisible, isTrue);
      expect(scaffold.showCollapseToggle, isFalse);
      expect(scaffold.isExtendedOverride, isNull);
      expect(scaffold.onExtendedChange, isNull);
      expect(scaffold.collapseIcon, Icons.chevron_left);
      expect(scaffold.expandIcon, Icons.chevron_right);
    });
  });
}
