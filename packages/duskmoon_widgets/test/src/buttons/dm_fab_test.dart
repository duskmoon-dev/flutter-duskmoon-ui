import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmFab', () {
    group('Material', () {
      testWidgets('renders FloatingActionButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmFab(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ),
        );
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });

      testWidgets('extended with icon and label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmFab(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Create'),
              ),
            ),
          ),
        );
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.text('Create'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });
    });
  });
}
