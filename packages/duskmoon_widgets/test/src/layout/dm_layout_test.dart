import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmCard', () {
    testWidgets('renders Card on Material platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmCard(child: Text('content')),
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsOneWidget);
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('renders Container with decoration on Cupertino platform',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.iOS),
              child: const DmCard(child: Text('content')),
            ),
          ),
        ),
      );

      expect(find.byType(Card), findsNothing);
      expect(find.byType(Container), findsWidgets);
      expect(find.text('content'), findsOneWidget);
    });

    testWidgets('applies padding when provided', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmCard(
                padding: EdgeInsets.all(16),
                child: Text('padded'),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Padding), findsWidgets);
      expect(find.text('padded'), findsOneWidget);
    });

    testWidgets('respects platformOverride', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmCard(
                platformOverride: DmPlatformStyle.cupertino,
                child: Text('override'),
              ),
            ),
          ),
        ),
      );

      // Should render Cupertino style despite Android platform
      expect(find.byType(Card), findsNothing);
    });
  });

  group('DmDivider', () {
    testWidgets('renders Divider on Material platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmDivider(),
            ),
          ),
        ),
      );

      expect(find.byType(Divider), findsOneWidget);
    });

    testWidgets('renders Container on Cupertino platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.iOS),
              child: const DmDivider(),
            ),
          ),
        ),
      );

      expect(find.byType(Divider), findsNothing);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('passes color and thickness to Material Divider',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmDivider(
                color: Colors.red,
                thickness: 2,
              ),
            ),
          ),
        ),
      );

      final divider = tester.widget<Divider>(find.byType(Divider));
      expect(divider.color, Colors.red);
      expect(divider.thickness, 2);
    });

    testWidgets('respects platformOverride', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmDivider(
                platformOverride: DmPlatformStyle.cupertino,
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Divider), findsNothing);
    });
  });
}
