import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:example/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  for (final width in [390.0, 1200.0]) {
    for (final brightness in Brightness.values) {
      testWidgets(
          'gamepad demo navigation and input at $width in ${brightness.name}',
          (tester) async {
        tester.view.physicalSize = Size(width, 900);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final router =
            GoRouter(initialLocation: '/widgets', routes: AppRouter.routes);
        addTearDown(router.dispose);
        await tester.pumpWidget(DuskmoonApp(
          platformStyle: DmPlatformStyle.material,
          child: MaterialApp.router(
              theme: ThemeData(brightness: brightness), routerConfig: router),
        ));
        await tester.pumpAndSettle();
        final entry = find.text('Gamepads');
        await tester.ensureVisible(entry);
        await tester.tap(entry);
        await tester.pumpAndSettle();
        expect(router.routeInformationProvider.value.uri.path,
            '/widgets/gamepads');
        expect(find.byType(BackButton), findsOneWidget);

        for (final style in DmControllerStyle.values) {
          final card = find.byKey(ValueKey('gamepad-${style.name}'));
          final scrollable = find.descendant(
            of: find.byKey(const ValueKey('gamepads-list')),
            matching: find.byType(Scrollable),
          );
          await tester.scrollUntilVisible(card, 200, scrollable: scrollable);
          await tester.pumpAndSettle();
          expect(
              find.descendant(
                  of: card,
                  matching: find.byType(switch (style) {
                    DmControllerStyle.xbox => DmXboxControllerView,
                    DmControllerStyle.dualSense => DmPs5ControllerView,
                    DmControllerStyle.switchPro => DmSwitchProControllerView,
                  })),
              findsOneWidget);
          Finder text(String value) =>
              find.descendant(of: card, matching: find.text(value));
          if (style != DmControllerStyle.switchPro) {
            final toggle =
                find.byKey(ValueKey('${style.name}-trigger-indicators-toggle'));
            await tester.ensureVisible(toggle);
            await tester.tap(toggle);
            await tester.pumpAndSettle();
            expect(find.byKey(ValueKey('${style.name}-leftTrigger-indicator')),
                findsNothing);
            await tester.tap(toggle);
            await tester.pumpAndSettle();
            expect(find.byKey(ValueKey('${style.name}-leftTrigger-indicator')),
                findsOneWidget);
          }
          final stick = find.byKey(ValueKey('${style.name}-leftStick'));
          await tester.ensureVisible(stick);
          await tester.pumpAndSettle();
          final controller = find.descendant(
              of: card, matching: find.byType(DmControllerView));
          final scale = tester.getSize(controller).width / 600;
          final drag = await tester.startGesture(tester.getCenter(stick));
          await drag.moveBy(Offset(12 * scale, 0));
          await tester.pump();
          expect(text('Left stick: X 0.50  Y 0.00'), findsOneWidget);
          await drag.up();
          await tester.pumpAndSettle();
          expect(text('Left stick: X 0.00  Y 0.00'), findsOneWidget);

          final trigger = find.byKey(ValueKey('${style.name}-leftTrigger'));
          await tester.ensureVisible(trigger);
          await tester.pumpAndSettle();
          final hold = await tester.startGesture(tester.getCenter(trigger));
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 500));
          expect(
              text(
                  'Triggers: L ${style == DmControllerStyle.switchPro ? 100 : 50}%  R 0%'),
              findsOneWidget);
          await hold.up();
          await tester.pumpAndSettle();
          expect(text('Triggers: L 0%  R 0%'), findsOneWidget);
          final south = find.byKey(ValueKey('${style.name}-south'));
          await tester.ensureVisible(south);
          await tester.pumpAndSettle();
          await tester.tap(south);
          await tester.pumpAndSettle();
          expect(text('south up'), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      });
    }
  }
}
