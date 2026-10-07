import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _bodyKey = Key('visibility-body');
const _controlKey = Key('navigation-visibility-control');
const _destinations = [
  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
];

Future<void> _pumpScaffold(
  WidgetTester tester, {
  bool navigationVisible = true,
  double width = 1200,
  TargetPlatform platform = TargetPlatform.android,
}) async {
  final devicePixelRatio = tester.view.devicePixelRatio;
  tester.view.physicalSize = Size(
    width * devicePixelRatio,
    800 * devicePixelRatio,
  );
  addTearDown(tester.view.resetPhysicalSize);
  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(platform: platform),
    home: DmAdaptiveScaffold(
      destinations: _destinations,
      selectedIndex: 1,
      navigationVisible: navigationVisible,
      showCollapseToggle: true,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBarBreakpoint: Breakpoints.standard,
      appBar: AppBar(
        leading: IconButton(
          key: _controlKey,
          tooltip: 'Toggle navigation visibility',
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
      ),
      body: (_) => const SizedBox.expand(
        key: _bodyKey,
        child: Center(child: SizedBox(width: 200, child: TextField())),
      ),
    ),
  ));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('hiding a compact rail reclaims width and preserves body state',
      (tester) async {
    await _pumpScaffold(tester);
    await tester.enterText(find.byType(TextField), 'Unsaved settings');
    final inputState = tester.state(find.byType(EditableText));
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    final compactBodyWidth = tester.getSize(find.byKey(_bodyKey)).width;

    await _pumpScaffold(tester, navigationVisible: false);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byTooltip('Expand navigation'), findsNothing);
    expect(tester.getRect(find.byKey(_bodyKey)).left, 0);
    expect(tester.getSize(find.byKey(_bodyKey)).width, 1200);
    expect(tester.state(find.byType(EditableText)), same(inputState));
    expect(find.byKey(_controlKey), findsOneWidget);

    await _pumpScaffold(tester);
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isFalse);
    expect(rail.selectedIndex, 1);
    expect(tester.getSize(find.byKey(_bodyKey)).width, compactBodyWidth);
    expect(tester.state(find.byType(EditableText)), same(inputState));
    expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        'Unsaved settings');
    expect(tester.takeException(), isNull);
  });

  testWidgets('hiding and restoring an expanded rail preserves its preference',
      (tester) async {
    await _pumpScaffold(tester);
    final expandedWidth = tester.getSize(find.byType(NavigationRail)).width;
    await _pumpScaffold(tester, navigationVisible: false);
    expect(tester.getSize(find.byKey(_bodyKey)).width, 1200);
    await _pumpScaffold(tester);
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isTrue);
    expect(tester.getSize(find.byType(NavigationRail)).width, expandedWidth);
    expect(tester.takeException(), isNull);
  });

  testWidgets('mobile navigation is visible by default and can be hidden',
      (tester) async {
    await _pumpScaffold(tester, width: 500);
    expect(find.byType(NavigationBar), findsOneWidget);
    final bodyHeight = tester.getSize(find.byKey(_bodyKey)).height;
    final inputState = tester.state(find.byType(EditableText));
    await _pumpScaffold(tester, width: 500, navigationVisible: false);
    expect(find.byType(NavigationBar), findsNothing);
    expect(
        tester.getSize(find.byKey(_bodyKey)).height, greaterThan(bodyHeight));
    expect(tester.state(find.byType(EditableText)), same(inputState));
    expect(find.byKey(_controlKey), findsOneWidget);
    await _pumpScaffold(tester, width: 500);
    expect(
        tester.widget<NavigationBar>(find.byType(NavigationBar)).selectedIndex,
        1);
    expect(tester.getSize(find.byKey(_bodyKey)).height, bodyHeight);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'desktop drawer is removed while the caller app bar stays visible',
      (tester) async {
    await _pumpScaffold(tester, width: 500, platform: TargetPlatform.macOS);
    final inputState = tester.state(find.byType(EditableText));
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).drawer, isNotNull);
    await _pumpScaffold(tester,
        width: 500, platform: TargetPlatform.macOS, navigationVisible: false);
    expect(tester.widget<Scaffold>(find.byType(Scaffold)).drawer, isNull);
    expect(find.byKey(_controlKey), findsOneWidget);
    expect(tester.state(find.byType(EditableText)), same(inputState));
    expect(tester.takeException(), isNull);
  });
}
