import 'package:duskmoon_feedback/duskmoon_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('showDmSnackbar', () {
    testWidgets('displays message widget', (WidgetTester tester) async {
      const Key tapTarget = Key('tap-target');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    showDmSnackbar(
                      context: context,
                      message: const Text('Test message'),
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
      await tester.pump();
      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('shows action button when provided', (
      WidgetTester tester,
    ) async {
      const Key tapTarget = Key('tap-target');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    showDmSnackbar(
                      context: context,
                      message: const Text('Message'),
                      actionLabel: 'ACTION',
                      onActionPressed: () {},
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
      await tester.pump();

      expect(find.byType(SnackBarAction), findsOneWidget);
      expect(find.text('ACTION'), findsOneWidget);
    });
  });

  group('showDmUndoSnackbar', () {
    testWidgets('displays message and undo button', (
      WidgetTester tester,
    ) async {
      const Key tapTarget = Key('tap-target');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    showDmUndoSnackbar(
                      context: context,
                      message: const Text('Item deleted'),
                      onUndoPressed: () {},
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
      await tester.pump();

      expect(find.text('Item deleted'), findsOneWidget);
      expect(find.byType(SnackBarAction), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);
    });

    testWidgets('uses custom undo label', (WidgetTester tester) async {
      const Key tapTarget = Key('tap-target');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (BuildContext context) {
                return GestureDetector(
                  onTap: () {
                    showDmUndoSnackbar(
                      context: context,
                      message: const Text('Deleted'),
                      onUndoPressed: () {},
                      undoLabel: 'Rückgängig',
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
      await tester.pump();

      expect(find.text('Rückgängig'), findsOneWidget);
    });
  });
}
