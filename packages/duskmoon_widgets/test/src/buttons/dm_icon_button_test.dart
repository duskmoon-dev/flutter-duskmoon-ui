import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmIconButton', () {
    group('Material', () {
      testWidgets('renders IconButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmIconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ),
        );
        expect(find.byType(IconButton), findsOneWidget);
      });
    });

    group('Cupertino', () {
      testWidgets('renders CupertinoButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmIconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ),
        );
        expect(find.byType(CupertinoButton), findsOneWidget);
      });
    });
  });
}
