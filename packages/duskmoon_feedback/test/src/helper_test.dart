import 'package:duskmoon_feedback/duskmoon_feedback.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('dmScaffoldMessengerKey', () {
    test('is a GlobalKey<ScaffoldMessengerState>', () {
      expect(dmScaffoldMessengerKey, isA<GlobalKey<ScaffoldMessengerState>>());
    });
  });

  group('getDmWidgetSize', () {
    testWidgets('returns size of rendered widget', (WidgetTester tester) async {
      final GlobalKey testKey = GlobalKey();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: SizedBox(key: testKey, width: 200, height: 100)),
        ),
      );

      final size = getDmWidgetSize(testKey);

      expect(size, isNotNull);
      expect(size!.width, equals(200));
      expect(size.height, equals(100));
    });

    testWidgets('returns null for invalid key', (WidgetTester tester) async {
      final GlobalKey unusedKey = GlobalKey();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: SizedBox(width: 100, height: 100)),
        ),
      );

      final size = getDmWidgetSize(unusedKey);

      expect(size, isNull);
    });
  });
}
