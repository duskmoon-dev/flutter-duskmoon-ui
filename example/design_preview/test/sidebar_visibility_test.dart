import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:example/screens/scaffold/scaffold_screen.dart';
import 'package:example/showcase_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() => navigationRailExtendedNotifier.value = null);
  tearDown(() => navigationRailExtendedNotifier.value = null);

  Future<void> pumpScaffoldScreen(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final router = GoRouter(
      initialLocation: '/widgets/scaffold',
      routes: [
        GoRoute(
          path: '/widgets/scaffold',
          builder: (_, __) => const ScaffoldScreen(),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(
      DuskmoonApp(
        platformStyle: DmPlatformStyle.material,
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('scaffold route hides navigation without resetting body',
      (tester) async {
    await pumpScaffoldScreen(tester);
    expect(find.byTooltip('Hide navigation'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    final body = find.byType(ListView);
    final visibleWidth = tester.getSize(body).width;
    await tester.scrollUntilVisible(find.text('Videos'), 200,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Videos'));
    await tester.pumpAndSettle();
    expect(find.text('Selected: Videos'), findsOneWidget);

    await tester.tap(find.byTooltip('Hide navigation'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byTooltip('Show navigation'), findsOneWidget);
    expect(tester.getSize(body).width, greaterThan(visibleWidth));
    expect(find.text('Selected: Videos'), findsOneWidget);

    await tester.tap(find.byTooltip('Show navigation'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(tester.getSize(body).width, visibleWidth);
    expect(find.text('Selected: Videos'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('DmScaffold demo restores collapsed rail and selected page',
      (tester) async {
    await pumpScaffoldScreen(tester);
    await tester.scrollUntilVisible(find.text('Open DmScaffold Demo'), 300,
        scrollable: find.byType(Scrollable).last);
    await tester.tap(find.text('Open DmScaffold Demo'));
    await tester.pumpAndSettle();
    expect(find.byType(DmScaffold), findsOneWidget);
    expect(find.byTooltip('Hide navigation'), findsOneWidget);

    await tester.tap(find.descendant(
      of: find.byType(NavigationRail),
      matching: find.text('Explore'),
    ));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isFalse);
    expect(rail.selectedIndex, 1);

    await tester.tap(find.byTooltip('Hide navigation'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.byTooltip('Show navigation'), findsOneWidget);

    await tester.tap(find.byTooltip('Show navigation'));
    await tester.pumpAndSettle();
    final restoredRail =
        tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(restoredRail.extended, isFalse);
    expect(restoredRail.selectedIndex, 1);
    expect(find.byTooltip('Expand navigation'), findsOneWidget);
    expect(find.text('Explore'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
