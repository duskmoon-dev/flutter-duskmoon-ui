import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:example/screens/scaffold/scaffold_screen.dart';
import 'package:example/showcase_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() => navigationRailExtendedNotifier.value = null);
  tearDown(() => navigationRailExtendedNotifier.value = null);

  final demoBody = find.byKey(const ValueKey('scaffold-demo-body'));

  void expectNoAppBarVisibilityControls() {
    final appBars = find
        .byWidgetPredicate((widget) => widget is AppBar || widget is DmAppBar);
    expect(
        find.descendant(
            of: appBars, matching: find.byTooltip('Hide navigation')),
        findsNothing);
    expect(
        find.descendant(
            of: appBars, matching: find.byTooltip('Show navigation')),
        findsNothing);
  }

  void expectHideInSidebar(WidgetTester tester, IconData firstIcon) {
    final rail = find.byType(NavigationRail);
    final hide = find.byTooltip('Hide navigation');
    expect(find.descendant(of: rail, matching: hide), findsOneWidget);
    expectNoAppBarVisibilityControls();
    final railRect = tester.getRect(rail);
    final hideRect = tester.getRect(hide);
    final firstDestination = find.descendant(
      of: rail,
      matching: find.byIcon(firstIcon),
    );
    expect(hideRect.right, closeTo(railRect.right, 0.01));
    expect(hideRect.top - railRect.top, inInclusiveRange(0, 16));
    expect(hideRect.bottom, lessThan(tester.getRect(firstDestination).top));
  }

  void expectShowInDemoBody(WidgetTester tester) {
    final show = find.byTooltip('Show navigation');
    expect(find.descendant(of: demoBody, matching: show), findsOneWidget);
    expectNoAppBarVisibilityControls();
    final showRect = tester.getRect(show);
    final bodyRect = tester.getRect(demoBody);
    expect(showRect.left, closeTo(bodyRect.left, 0.01));
    expect(showRect.top, closeTo(bodyRect.top, 0.01));
    expect(find.byType(NavigationRail), findsNothing);
  }

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

  void expectShowcaseShell(WidgetTester tester) {
    expect(find.widgetWithText(AppBar, 'Scaffold & Layout'), findsOneWidget);
    expect(find.byType(BackButton), findsOneWidget);
    expect(find.byTooltip('Platform style'), findsOneWidget);
    expect(find.byTooltip('Hide navigation'), findsNothing);
    expect(find.byTooltip('Show navigation'), findsNothing);
    expect(find.byType(DmScaffold), findsNothing);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.selectedIndex, 1);
  }

  testWidgets('scaffold route keeps showcase navigation outside demo',
      (tester) async {
    await pumpScaffoldScreen(tester);
    expectShowcaseShell(tester);
    expect(find.byTooltip('Collapse navigation'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('DmScaffold demo restores collapsed rail and selected page',
      (tester) async {
    await pumpScaffoldScreen(tester);
    expectShowcaseShell(tester);
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Open DmScaffold Demo'), 300,
        scrollable: find
            .descendant(
              of: find.byType(ListView),
              matching: find.byType(Scrollable),
            )
            .first);
    final outerBody = tester.element(find.byType(ListView));
    final outerScrollable = find
        .descendant(
          of: find.byType(ListView),
          matching: find.byType(Scrollable),
        )
        .first;
    final outerScrollOffset =
        tester.state<ScrollableState>(outerScrollable).position.pixels;
    await tester.tap(find.text('Open DmScaffold Demo'));
    await tester.pumpAndSettle();
    expect(find.byType(DmScaffold), findsOneWidget);
    expect(find.byTooltip('Hide navigation'), findsOneWidget);
    expectHideInSidebar(tester, Icons.home);

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
    expectHideInSidebar(tester, Icons.home);
    final demoBodyElement = tester.element(demoBody);
    final visibleBodyWidth = tester.getSize(demoBody).width;

    await tester.tap(find.byTooltip('Hide navigation'));
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.text('Explore'), findsOneWidget);
    expect(find.byTooltip('Show navigation'), findsOneWidget);
    expectShowInDemoBody(tester);
    expect(tester.element(demoBody), same(demoBodyElement));
    expect(tester.getRect(demoBody).left, closeTo(0, 0.01));
    expect(tester.getSize(demoBody).width, greaterThan(visibleBodyWidth));

    await tester.tap(find.byTooltip('Show navigation'));
    await tester.pumpAndSettle();
    final restoredRail =
        tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(restoredRail.extended, isFalse);
    expect(restoredRail.selectedIndex, 1);
    expect(find.byTooltip('Expand navigation'), findsOneWidget);
    expectHideInSidebar(tester, Icons.home);
    expect(tester.element(demoBody), same(demoBodyElement));
    expect(find.text('Explore'), findsWidgets);
    expect(tester.getSize(demoBody).width, visibleBodyWidth);

    await tester.tap(find.byTooltip('Hide navigation'));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
    expectShowcaseShell(tester);
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse);
    expect(find.byTooltip('Expand navigation'), findsOneWidget);
    expect(tester.element(find.byType(ListView)), same(outerBody));
    expect(tester.state<ScrollableState>(outerScrollable).position.pixels,
        outerScrollOffset);
    expect(tester.takeException(), isNull);
  });

  testWidgets('small demo keeps visibility controls inside its body',
      (tester) async {
    await pumpScaffoldScreen(tester);
    await tester.scrollUntilVisible(find.text('Open DmScaffold Demo'), 300,
        scrollable: find
            .descendant(
              of: find.byType(ListView),
              matching: find.byType(Scrollable),
            )
            .first);
    await tester.tap(find.text('Open DmScaffold Demo'));
    await tester.pumpAndSettle();
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpAndSettle();
    expect(find.byType(NavigationRail), findsNothing);
    final hide = find.byTooltip('Hide navigation');
    expect(find.descendant(of: demoBody, matching: hide), findsOneWidget);
    expectNoAppBarVisibilityControls();
    expect(tester.getTopLeft(hide), tester.getTopLeft(demoBody));

    await tester.tap(hide);
    await tester.pumpAndSettle();
    expectShowInDemoBody(tester);
    await tester.tap(find.byTooltip('Show navigation'));
    await tester.pumpAndSettle();
    expect(find.descendant(of: demoBody, matching: hide), findsOneWidget);
    expectNoAppBarVisibilityControls();
    expect(tester.widget<DmScaffold>(find.byType(DmScaffold)).selectedIndex, 0);
    expect(tester.takeException(), isNull);
  });
}
