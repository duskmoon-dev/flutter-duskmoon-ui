import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _destinations = [
  NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
  NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
];

Future<void> _pumpScaffold(
  WidgetTester tester, {
  double width = 1200,
  Brightness brightness = Brightness.light,
  bool? isExtended,
  ValueChanged<bool>? onExtendedChange,
  bool showToggle = true,
  Widget? leading,
  Widget? trailing,
  Widget? body,
  bool useDrawer = false,
  TargetPlatform platform = TargetPlatform.android,
  TextDirection textDirection = TextDirection.ltr,
  IconData collapseIcon = Icons.chevron_left,
  IconData expandIcon = Icons.chevron_right,
  EdgeInsetsGeometry navigationRailPadding =
      const EdgeInsets.all(kNavigationRailDefaultPadding),
  bool useMaterial3 = true,
  double navigationRailWidth = 72,
  double extendedNavigationRailWidth = 192,
  bool settle = true,
}) async {
  await tester.binding.setSurfaceSize(Size(width, 800));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(
          brightness: brightness,
          platform: platform,
          useMaterial3: useMaterial3),
      builder: (context, child) => Directionality(
        textDirection: textDirection,
        child: child!,
      ),
      home: DmAdaptiveScaffold(
        destinations: _destinations,
        selectedIndex: 1,
        useDrawer: useDrawer,
        showCollapseToggle: showToggle,
        isExtendedOverride: isExtended,
        onExtendedChange: onExtendedChange,
        collapseIcon: collapseIcon,
        expandIcon: expandIcon,
        navigationRailPadding: navigationRailPadding,
        navigationRailWidth: navigationRailWidth,
        extendedNavigationRailWidth: extendedNavigationRailWidth,
        leadingUnextendedNavRail: leading,
        leadingExtendedNavRail: leading,
        trailingNavRail: trailing,
        transitionDuration: Duration.zero,
        body: (_) =>
            body ?? const Center(child: Text('Selected settings page')),
      ),
    ),
  );
  if (settle) await tester.pumpAndSettle();
}

void main() {
  for (final brightness in Brightness.values) {
    testWidgets('footer toggle preserves the selected page on $brightness', (
      tester,
    ) async {
      await _pumpScaffold(tester, brightness: brightness);
      final rail = find.byType(NavigationRail);
      final expandedWidth = tester.getSize(rail).width;
      final collapse = find.byTooltip('Collapse navigation');

      expect(collapse, findsOneWidget);
      expect(tester.getBottomRight(collapse).dy, greaterThan(740));
      expect(tester.getSize(collapse).height, greaterThanOrEqualTo(48));
      expect(tester.getSize(collapse).width, greaterThanOrEqualTo(48));
      await tester.tap(collapse);
      await tester.pumpAndSettle();

      expect(tester.getSize(rail).width, lessThan(expandedWidth));
      expect(tester.widget<NavigationRail>(rail).extended, isFalse);
      expect(tester.widget<NavigationRail>(rail).labelType,
          NavigationRailLabelType.none);
      expect(tester.widget<NavigationRail>(rail).selectedIndex, 1);
      expect(find.text('Selected settings page'), findsOneWidget);
      expect(find.byTooltip('Expand navigation'), findsOneWidget);
      expect(tester.getCenter(find.byTooltip('Expand navigation')).dx,
          closeTo(tester.getCenter(rail).dx, 0.01));

      await tester.tap(find.byTooltip('Expand navigation'));
      await tester.pumpAndSettle();
      expect(tester.widget<NavigationRail>(rail).extended, isTrue);
      expect(tester.getSize(rail).width, expandedWidth);
      expect(find.text('Selected settings page'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  for (final useMaterial3 in [true, false]) {
    for (final widths in [(72.0, 192.0), (96.0, 280.0)]) {
      testWidgets(
          'rail transition fits every frame for $widths M3=$useMaterial3',
          (tester) async {
        await _pumpScaffold(tester,
            useMaterial3: useMaterial3,
            navigationRailWidth: widths.$1,
            extendedNavigationRailWidth: widths.$2,
            body:
                const Center(child: SizedBox(width: 200, child: TextField())));
        await tester.enterText(find.byType(TextField), 'Unsaved input');
        final rail = find.byType(NavigationRail);

        void checkFrame() {
          expect(tester.takeException(), isNull);
          final railRect = tester.getRect(rail);
          expect(railRect.width, inInclusiveRange(widths.$1, widths.$2));
          expect(tester.getRect(find.byType(Divider)).top,
              closeTo(railRect.bottom, 0.01));
          expect(tester.widget<NavigationRail>(rail).selectedIndex, 1);
          expect(
              tester
                  .widget<EditableText>(find.byType(EditableText))
                  .controller
                  .text,
              'Unsaved input');
        }

        for (final tooltip in ['Collapse navigation', 'Expand navigation']) {
          await tester.tap(find.byTooltip(tooltip));
          await tester.pump();
          checkFrame();
          for (final milliseconds in [16, 32, 48, 104]) {
            await tester.pump(Duration(milliseconds: milliseconds));
            checkFrame();
          }
          expect(tester.getSize(rail).width,
              tooltip == 'Collapse navigation' ? widths.$1 : widths.$2);
        }

        for (var i = 0; i < 4; i++) {
          await tester.tap(find.byTooltip(
              i.isEven ? 'Collapse navigation' : 'Expand navigation'));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 16));
          checkFrame();
        }
        await tester.pumpAndSettle();
        checkFrame();
        expect(tester.getSize(rail).width, widths.$2);
      });
    }
  }

  testWidgets('configured rail widths can change during a transition',
      (tester) async {
    await _pumpScaffold(tester, isExtended: true);
    await _pumpScaffold(tester, isExtended: false, settle: false);
    await tester.pump(const Duration(milliseconds: 16));
    expect(tester.takeException(), isNull);
    await _pumpScaffold(tester,
        isExtended: false,
        navigationRailWidth: 96,
        extendedNavigationRailWidth: 280,
        settle: false);
    for (var i = 0; i < 14; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.takeException(), isNull);
    }
    expect(tester.getSize(find.byType(NavigationRail)).width, 96);

    await _pumpScaffold(tester,
        isExtended: true,
        navigationRailWidth: 96,
        extendedNavigationRailWidth: 280,
        settle: false);
    await tester.pump(const Duration(milliseconds: 16));
    expect(tester.takeException(), isNull);
    await _pumpScaffold(tester,
        isExtended: true,
        navigationRailWidth: 80,
        extendedNavigationRailWidth: 240,
        settle: false);
    for (var i = 0; i < 14; i++) {
      await tester.pump(const Duration(milliseconds: 16));
      expect(tester.takeException(), isNull);
    }
    expect(tester.getSize(find.byType(NavigationRail)).width, 240);
  });

  testWidgets('rail surface meets footer without a padding gap',
      (tester) async {
    const paddings = [
      EdgeInsets.all(kNavigationRailDefaultPadding),
      EdgeInsets.all(16),
      EdgeInsetsDirectional.fromSTEB(5, 11, 17, 23),
    ];
    for (final padding in paddings) {
      for (final textDirection in TextDirection.values) {
        for (final isExtended in [true, false]) {
          await _pumpScaffold(tester,
              isExtended: isExtended,
              navigationRailPadding: padding,
              textDirection: textDirection);
          final railRect = tester.getRect(find.byType(NavigationRail));
          final dividerRect = tester.getRect(find.byType(Divider));
          expect(dividerRect.top, closeTo(railRect.bottom, 0.01));
          expect(dividerRect.left, closeTo(railRect.left, 0.01));
          expect(dividerRect.right, closeTo(railRect.right, 0.01));
          expect(tester.takeException(), isNull);
        }
      }
    }
  });

  testWidgets('controlled extension notifies without changing selection', (
    tester,
  ) async {
    final changes = <bool>[];
    await _pumpScaffold(tester,
        isExtended: true, onExtendedChange: changes.add);
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    expect(changes, [false]);
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isTrue);
    expect(
        tester
            .widget<NavigationRail>(find.byType(NavigationRail))
            .selectedIndex,
        1);

    await _pumpScaffold(tester,
        isExtended: false, onExtendedChange: changes.add);
    expect(find.byTooltip('Expand navigation'), findsOneWidget);
    await tester.tap(find.byTooltip('Expand navigation'));
    await tester.pumpAndSettle();
    expect(changes, [false, true]);
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse);
  });

  testWidgets('collapse preserves unsaved body input', (tester) async {
    await _pumpScaffold(tester,
        body: const Center(child: SizedBox(width: 200, child: TextField())));
    await tester.enterText(find.byType(TextField), 'Unsaved settings');
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        'Unsaved settings');
  });

  testWidgets('controlled override applies across rail breakpoints',
      (tester) async {
    for (final width in [700.0, 1000.0, 1200.0, 1800.0]) {
      await _pumpScaffold(tester, width: width, isExtended: true);
      expect(
          tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
          isTrue);
      await _pumpScaffold(tester, width: width, isExtended: false);
      expect(
          tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
          isFalse);
    }
  });

  testWidgets('footer preserves custom leading and trailing widgets', (
    tester,
  ) async {
    await _pumpScaffold(tester,
        leading: const Text('Custom leading'),
        trailing: const Text('Custom trailing'));
    final toggle = find.byTooltip('Collapse navigation');
    expect(tester.getTopLeft(toggle).dy,
        greaterThan(tester.getBottomRight(find.text('Custom trailing')).dy));
    await tester.tap(toggle);
    await tester.pumpAndSettle();
    expect(find.text('Custom leading'), findsOneWidget);
    expect(find.text('Custom trailing'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('medium rail can expand and retains preference on resize', (
    tester,
  ) async {
    await _pumpScaffold(tester, width: 700);
    final rail = find.byType(NavigationRail);
    expect(tester.widget<NavigationRail>(rail).extended, isFalse);
    await tester.tap(find.byTooltip('Expand navigation'));
    await tester.pumpAndSettle();
    expect(tester.widget<NavigationRail>(rail).extended, isTrue);
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    await tester.pumpAndSettle();
    expect(tester.widget<NavigationRail>(rail).extended, isTrue);
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    await tester.binding.setSurfaceSize(const Size(700, 800));
    await tester.pumpAndSettle();
    expect(tester.widget<NavigationRail>(rail).extended, isFalse);
    expect(find.byTooltip('Expand navigation'), findsOneWidget);
  });

  testWidgets('small mobile keeps bottom navigation without a toggle', (
    tester,
  ) async {
    await _pumpScaffold(tester, width: 500, useDrawer: true);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byTooltip('Collapse navigation'), findsNothing);
    expect(find.byTooltip('Expand navigation'), findsNothing);
  });

  testWidgets('small desktop keeps the drawer without a toggle',
      (tester) async {
    await _pumpScaffold(tester,
        width: 500, useDrawer: true, platform: TargetPlatform.macOS);
    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();
    expect(find.byType(Drawer), findsOneWidget);
    expect(find.byTooltip('Collapse navigation'), findsNothing);
    expect(find.byTooltip('Expand navigation'), findsNothing);
  });

  testWidgets('toggle remains opt-in', (tester) async {
    await _pumpScaffold(tester, showToggle: false);
    expect(tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isTrue);
    expect(find.byTooltip('Collapse navigation'), findsNothing);
    expect(find.byTooltip('Expand navigation'), findsNothing);
  });

  testWidgets('footer chevron points toward collapse in RTL', (tester) async {
    await _pumpScaffold(tester, textDirection: TextDirection.rtl);
    final collapseIcon = tester.widget<Icon>(find.byIcon(Icons.chevron_left));
    expect(collapseIcon.icon!.matchTextDirection, isTrue);
    expect(Directionality.of(tester.element(find.byIcon(Icons.chevron_left))),
        TextDirection.rtl);
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    final expandIcon = tester.widget<Icon>(find.byIcon(Icons.chevron_right));
    expect(expandIcon.icon!.matchTextDirection, isTrue);
    expect(Directionality.of(tester.element(find.byIcon(Icons.chevron_right))),
        TextDirection.rtl);
  });

  testWidgets('footer preserves custom toggle icons', (tester) async {
    await _pumpScaffold(tester,
        collapseIcon: Icons.menu_open, expandIcon: Icons.menu);
    expect(find.byIcon(Icons.menu_open), findsOneWidget);
    await tester.tap(find.byTooltip('Collapse navigation'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.menu), findsOneWidget);
  });
}
