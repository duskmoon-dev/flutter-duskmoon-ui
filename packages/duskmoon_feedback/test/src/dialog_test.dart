import 'package:duskmoon_feedback/duskmoon_feedback.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('showDmDialog', () {
    testWidgets('displays title and content', (WidgetTester tester) async {
      const Key tapTarget = Key('tap-target');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    showDmDialog(
                      context: context,
                      title: const Text('Dialog Title'),
                      content: const Text('Dialog Content'),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    height: 100.0,
                    width: 100.0,
                    key: tapTarget,
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(tapTarget), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('Dialog Title'), findsOneWidget);
      expect(find.text('Dialog Content'), findsOneWidget);
    });

    testWidgets('uses dark Cupertino theme for dark adaptive dialogs', (
      WidgetTester tester,
    ) async {
      const Key tapTarget = Key('tap-target');
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: DmPlatformOverride(
            style: DmPlatformStyle.cupertino,
            child: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    showDmDialog(
                      context: context,
                      title: const Text('Dark Dialog'),
                      content: const Text('Dark Content'),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    height: 100.0,
                    width: 100.0,
                    key: tapTarget,
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(tapTarget), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      final dialogContext = tester.element(find.byType(CupertinoAlertDialog));
      expect(CupertinoTheme.brightnessOf(dialogContext), Brightness.dark);
    });

    testWidgets('can keep Cupertino dialogs on a nested local navigator', (
      WidgetTester tester,
    ) async {
      final outerNavigatorKey = GlobalKey<NavigatorState>();
      final innerNavigatorKey = GlobalKey<NavigatorState>();
      const Key tapTarget = Key('tap-target');

      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: outerNavigatorKey,
          theme: ThemeData.light(),
          home: MaterialApp(
            navigatorKey: innerNavigatorKey,
            theme: DmThemeData.moonlight(),
            home: DmPlatformOverride(
              style: DmPlatformStyle.cupertino,
              child: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      showDmDialog(
                        context: context,
                        title: const Text('Run Deploy'),
                        content: const Text('Branch/Tag'),
                        useRootNavigator: false,
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: const SizedBox(
                      height: 100.0,
                      width: 100.0,
                      key: tapTarget,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(tapTarget), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.byType(CupertinoAlertDialog), findsOneWidget);
      final dialogContext = tester.element(find.byType(CupertinoAlertDialog));
      expect(CupertinoTheme.brightnessOf(dialogContext), Brightness.dark);
      expect(innerNavigatorKey.currentState!.canPop(), isTrue);
      expect(outerNavigatorKey.currentState!.canPop(), isFalse);
    });

    testWidgets('displays action buttons', (WidgetTester tester) async {
      const Key tapTarget = Key('tap-target');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    showDmDialog(
                      context: context,
                      title: const Text('Confirm'),
                      content: const Text('Are you sure?'),
                      actions: [
                        DmDialogAction(
                          onPressed: (ctx) => Navigator.of(ctx).pop(false),
                          child: const Text('Cancel'),
                        ),
                        DmDialogAction(
                          onPressed: (ctx) => Navigator.of(ctx).pop(true),
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    height: 100.0,
                    width: 100.0,
                    key: tapTarget,
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(tapTarget), warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('returns result when action pressed', (
      WidgetTester tester,
    ) async {
      const Key tapTarget = Key('tap-target');
      bool? result;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () async {
                    result = await showDmDialog<bool>(
                      context: context,
                      title: const Text('Confirm'),
                      content: const Text('Are you sure?'),
                      actions: [
                        DmDialogAction(
                          onPressed: (ctx) => Navigator.of(ctx).pop(true),
                          child: const Text('Yes'),
                        ),
                      ],
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox(
                    height: 100.0,
                    width: 100.0,
                    key: tapTarget,
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(tapTarget), warnIfMissed: false);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Yes'));
      await tester.pumpAndSettle();

      expect(result, isTrue);
    });
  });

  group('DmDialogAction', () {
    testWidgets('renders as TextButton on Android', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmDialogAction(
              onPressed: (ctx) {},
              child: const Text('Action'),
            ),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
    });
  });
}
