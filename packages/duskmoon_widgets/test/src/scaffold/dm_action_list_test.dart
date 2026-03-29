import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmActionList', () {
    final actions = [
      DmAction(
        title: 'Edit',
        icon: Icons.edit,
        onPressed: () {},
      ),
      DmAction(
        title: 'Delete',
        icon: Icons.delete,
        onPressed: () {},
      ),
    ];

    testWidgets('small size renders PopupMenuButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmActionList(
              size: DmActionSize.small,
              actions: actions,
            ),
          ),
        ),
      );
      expect(find.byType(PopupMenuButton<int>), findsOneWidget);
    });

    testWidgets('medium size renders IconButtons', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmActionList(
              size: DmActionSize.medium,
              actions: actions,
            ),
          ),
        ),
      );
      expect(find.byType(IconButton), findsNWidgets(2));
    });

    testWidgets('large size renders TextButton.icon widgets', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmActionList(
              size: DmActionSize.large,
              actions: actions,
            ),
          ),
        ),
      );
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('hideDisabled filters disabled actions', (tester) async {
      final mixedActions = [
        DmAction(
          title: 'Edit',
          icon: Icons.edit,
          onPressed: () {},
        ),
        DmAction(
          title: 'Delete',
          icon: Icons.delete,
          onPressed: () {},
          disabled: true,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmActionList(
              size: DmActionSize.large,
              actions: mixedActions,
              hideDisabled: true,
            ),
          ),
        ),
      );
      // Only the enabled action should be rendered.
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete'), findsNothing);
    });
  });
}
