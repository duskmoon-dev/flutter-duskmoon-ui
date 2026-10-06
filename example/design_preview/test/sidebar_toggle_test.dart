import 'package:example/showcase_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() => navigationRailExtendedNotifier.value = null);
  tearDown(() => navigationRailExtendedNotifier.value = null);

  testWidgets('sidebar preference survives showcase navigation',
      (tester) async {
    final devicePixelRatio = tester.view.devicePixelRatio;
    tester.view.physicalSize = Size(
      1200 * devicePixelRatio,
      900 * devicePixelRatio,
    );
    addTearDown(tester.view.resetPhysicalSize);
    final router = GoRouter(
      initialLocation: '/first',
      routes: [
        GoRoute(
          path: '/first',
          builder: (context, state) => ShowcaseScaffold(
            selectedIndex: 0,
            appBar: AppBar(title: const Text('First route')),
            body: (_) => const Text('First page'),
          ),
        ),
        GoRoute(
          path: '/second',
          builder: (context, state) => ShowcaseScaffold(
            selectedIndex: 1,
            appBar: AppBar(title: const Text('Second route')),
            body: (_) => const Text('Second page'),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('First page'), findsOneWidget);
    expect(find.byTooltip('Collapse navigation'), findsOneWidget);
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse);
    expect(find.text('First page'), findsOneWidget);

    router.go('/second');
    await tester.pumpAndSettle();
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse);
    expect(find.byTooltip('Expand navigation'), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Second route'), findsOneWidget);
    expect(find.text('Second page'), findsOneWidget);
  });
}
