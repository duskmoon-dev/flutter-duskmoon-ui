import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _viewSize = Size(874, 402);
const _bodyKey = Key('safe-area-body');
const _destinations = [
  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
];

Future<void> _pumpScaffold(
  WidgetTester tester, {
  required EdgeInsets insets,
  required TextDirection direction,
  required bool extended,
  bool showToggle = false,
  bool settle = true,
  bool standalone = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = _viewSize;
  tester.view.padding = FakeViewPadding(
    left: insets.left,
    right: insets.right,
    bottom: insets.bottom,
  );
  tester.view.viewPadding = tester.view.padding;
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetPadding);
  addTearDown(tester.view.resetViewPadding);

  await tester.pumpWidget(MaterialApp(
    theme: ThemeData(platform: TargetPlatform.iOS),
    builder: (context, child) => Directionality(
      textDirection: direction,
      child: child!,
    ),
    home: standalone
        ? Scaffold(
            body: Align(
              alignment: AlignmentDirectional.centerStart,
              child: DmAdaptiveScaffold.standardNavigationRail(
                destinations: _destinations
                    .map(DmAdaptiveScaffold.toRailDestination)
                    .toList(),
                selectedIndex: 0,
                extended: extended,
              ),
            ),
          )
        : DmAdaptiveScaffold(
            destinations: _destinations,
            useDrawer: false,
            isExtendedOverride: extended,
            showCollapseToggle: showToggle,
            transitionDuration: Duration.zero,
            body: (_) => const ColoredBox(
              key: _bodyKey,
              color: Colors.white,
            ),
          ),
  ));
  if (settle) await tester.pumpAndSettle();
}

void _expectSafeContent(
  WidgetTester tester, {
  required EdgeInsets insets,
  required TextDirection direction,
  bool showToggle = false,
  bool standalone = false,
}) {
  final rail = tester.getRect(find.byType(NavigationRail));
  for (final icon in [Icons.home, Icons.settings, Icons.person]) {
    final rect = tester.getRect(find.byIcon(icon));
    expect(rect.size, const Size(24, 24));
    expect(rect.left, greaterThanOrEqualTo(insets.left));
    expect(rect.right, lessThanOrEqualTo(_viewSize.width - insets.right));
    expect(rect.left, greaterThanOrEqualTo(rail.left));
    expect(rect.right, lessThanOrEqualTo(rail.right));
  }
  if (!standalone) {
    final body = tester.getRect(find.byKey(_bodyKey));
    if (direction == TextDirection.ltr) {
      expect(rail.right, lessThanOrEqualTo(body.left));
    } else {
      expect(rail.left, greaterThanOrEqualTo(body.right));
    }
  }
  if (showToggle) {
    final button = tester.getRect(find.byType(IconButton));
    expect(button.width, greaterThanOrEqualTo(48));
    expect(button.left, greaterThanOrEqualTo(insets.left));
    expect(button.right, lessThanOrEqualTo(_viewSize.width - insets.right));
    final divider = tester.getRect(find.byType(Divider));
    expect(divider.left, rail.left);
    expect(divider.right, rail.right);
  }
  expect(tester.takeException(), isNull);
}

void main() {
  const insetsToTest = [
    EdgeInsets.zero,
    EdgeInsets.fromLTRB(62, 0, 62, 21),
    EdgeInsets.fromLTRB(17, 0, 62, 21),
  ];
  for (final direction in TextDirection.values) {
    for (final insets in insetsToTest) {
      final startInset =
          direction == TextDirection.ltr ? insets.left : insets.right;
      for (final showToggle in [false, true]) {
        for (final extended in [false, true]) {
          testWidgets(
              'rail respects $insets in $direction '
              '(extended=$extended, toggle=$showToggle)', (tester) async {
            await _pumpScaffold(tester,
                insets: insets,
                direction: direction,
                extended: extended,
                showToggle: showToggle);
            _expectSafeContent(tester,
                insets: insets, direction: direction, showToggle: showToggle);
            expect(tester.getSize(find.byType(NavigationRail)).width,
                (extended ? 192 : 72) + startInset);
          });
        }
      }
    }

    testWidgets('standard rail reserves start inset in $direction',
        (tester) async {
      const insets = EdgeInsets.fromLTRB(62, 0, 17, 21);
      final startInset =
          direction == TextDirection.ltr ? insets.left : insets.right;
      for (final extended in [false, true]) {
        await _pumpScaffold(tester,
            insets: insets,
            direction: direction,
            extended: extended,
            standalone: true);
        expect(tester.getSize(find.byType(NavigationRail)).width,
            (extended ? 192 : 72) + startInset);
        _expectSafeContent(tester,
            insets: insets, direction: direction, standalone: true);
      }
    });

    testWidgets(
        'rail remains safe through animation and inset changes $direction',
        (tester) async {
      const insets = EdgeInsets.fromLTRB(62, 0, 62, 21);
      await _pumpScaffold(tester,
          insets: insets,
          direction: direction,
          extended: false,
          showToggle: true);
      for (final extended in [true, false]) {
        await _pumpScaffold(tester,
            insets: insets,
            direction: direction,
            extended: extended,
            showToggle: true,
            settle: false);
        for (var frame = 0; frame < 14; frame++) {
          await tester.pump(const Duration(milliseconds: 16));
          _expectSafeContent(tester,
              insets: insets, direction: direction, showToggle: true);
        }
        expect(tester.getSize(find.byType(NavigationRail)).width,
            (extended ? 192 : 72) + 62);
      }
      for (final newInsets in [EdgeInsets.zero, insets]) {
        await _pumpScaffold(tester,
            insets: newInsets,
            direction: direction,
            extended: false,
            showToggle: true);
        expect(tester.getSize(find.byType(NavigationRail)).width,
            72 + newInsets.left);
        _expectSafeContent(tester,
            insets: newInsets, direction: direction, showToggle: true);
      }
    });
  }
}
