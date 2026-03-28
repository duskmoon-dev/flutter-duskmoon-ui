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
  });
}
