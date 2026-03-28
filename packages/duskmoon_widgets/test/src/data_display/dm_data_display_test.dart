import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmBadge', () {
    testWidgets('renders Badge on Material platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmBadge(
                label: '3',
                child: Icon(Icons.mail),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Badge), findsOneWidget);
      expect(find.text('3'), findsOneWidget);
    });

    testWidgets('renders Stack on Cupertino platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.iOS),
              child: const DmBadge(
                label: '5',
                child: Icon(Icons.mail),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Badge), findsNothing);
      // DmBadge renders a Stack; Scaffold may also contain Stacks
      final badgeStack = find.ancestor(
        of: find.text('5'),
        matching: find.byType(Stack),
      );
      expect(badgeStack, findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('applies custom backgroundColor on Material', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmBadge(
                label: '1',
                backgroundColor: Colors.blue,
                child: Icon(Icons.mail),
              ),
            ),
          ),
        ),
      );

      final badge = tester.widget<Badge>(find.byType(Badge));
      expect(badge.backgroundColor, Colors.blue);
    });

    testWidgets('renders without label (dot badge)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmBadge(
                child: Icon(Icons.mail),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Badge), findsOneWidget);
    });

    testWidgets('respects platformOverride', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmBadge(
                label: '2',
                platformOverride: DmPlatformStyle.cupertino,
                child: Icon(Icons.mail),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Badge), findsNothing);
      final badgeStack = find.ancestor(
        of: find.text('2'),
        matching: find.byType(Stack),
      );
      expect(badgeStack, findsOneWidget);
    });
  });

  group('DmChip', () {
    testWidgets('renders Chip by default', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmChip(label: Text('Tag')),
            ),
          ),
        ),
      );

      expect(find.byType(Chip), findsOneWidget);
      expect(find.text('Tag'), findsOneWidget);
    });

    testWidgets('renders FilterChip when onSelected is provided',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: DmChip(
                label: const Text('Filter'),
                onSelected: (_) {},
              ),
            ),
          ),
        ),
      );

      expect(find.byType(FilterChip), findsOneWidget);
      expect(find.text('Filter'), findsOneWidget);
    });

    testWidgets('calls onSelected callback', (tester) async {
      bool? selectedValue;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: DmChip(
                label: const Text('Toggle'),
                onSelected: (value) => selectedValue = value,
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();
      expect(selectedValue, isNotNull);
    });

    testWidgets('renders with avatar', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmChip(
                label: Text('With Avatar'),
                avatar: Icon(Icons.person),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Chip), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });

  group('DmAvatar', () {
    testWidgets('renders CircleAvatar on Material platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmAvatar(child: Text('AB')),
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('AB'), findsOneWidget);
    });

    testWidgets('renders CircleAvatar on Cupertino platform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.iOS),
              child: const DmAvatar(child: Text('CD')),
            ),
          ),
        ),
      );

      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('CD'), findsOneWidget);
    });

    testWidgets('applies custom backgroundColor', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmAvatar(
                backgroundColor: Colors.green,
                child: Text('EF'),
              ),
            ),
          ),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundColor, Colors.green);
    });

    testWidgets('applies custom radius', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: ThemeData(platform: TargetPlatform.android),
              child: const DmAvatar(
                radius: 30,
                child: Text('GH'),
              ),
            ),
          ),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, 30);
    });

    testWidgets('uses primaryContainer as default backgroundColor on Cupertino',
        (tester) async {
      final theme = ThemeData(platform: TargetPlatform.iOS);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Theme(
              data: theme,
              child: const DmAvatar(child: Text('IJ')),
            ),
          ),
        ),
      );

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundColor, theme.colorScheme.primaryContainer);
    });
  });
}
