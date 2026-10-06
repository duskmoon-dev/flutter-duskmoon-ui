import 'package:example/router.dart';
import 'package:example/screens/form/form_screen.dart';
import 'package:example/screens/widgets/widgets_screen.dart';
import 'package:example/showcase_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  setUp(() => navigationRailExtendedNotifier.value = null);
  tearDown(() => navigationRailExtendedNotifier.value = null);

  testWidgets('sidebar preference survives showcase navigation',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      initialLocation: WidgetsScreen.path,
      routes: AppRouter.routes,
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Buttons & Inputs'), findsOneWidget);
    expect(find.byTooltip('Collapse navigation'), findsOneWidget);
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse);
    expect(find.text('Buttons & Inputs'), findsOneWidget);

    router.go(FormScreen.path);
    await tester.pumpAndSettle();
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse);
    expect(find.byTooltip('Expand navigation'), findsOneWidget);
    expect(find.widgetWithText(AppBar, 'Form'), findsOneWidget);
  });
}
