import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmTextField', () {
    testWidgets('Material renders TextField', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: const Scaffold(
            body: DmTextField(
              placeholder: 'Enter text',
            ),
          ),
        ),
      );
      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('Cupertino renders CupertinoTextField', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: const Scaffold(
            body: DmTextField(
              placeholder: 'Enter text',
            ),
          ),
        ),
      );
      expect(find.byType(CupertinoTextField), findsOneWidget);
    });
  });

  group('DmCheckbox', () {
    testWidgets('Material renders Checkbox', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmCheckbox(
              value: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets('Cupertino renders CupertinoCheckbox', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Scaffold(
            body: DmCheckbox(
              value: true,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(CupertinoCheckbox), findsOneWidget);
    });
  });

  group('DmSwitch', () {
    testWidgets('Material renders Switch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmSwitch(
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(Switch), findsOneWidget);
    });

    testWidgets('Cupertino renders CupertinoSwitch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Scaffold(
            body: DmSwitch(
              value: false,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(CupertinoSwitch), findsOneWidget);
    });
  });

  group('DmSlider', () {
    testWidgets('Material renders Slider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmSlider(
              value: 0.5,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(Slider), findsOneWidget);
    });

    testWidgets('Cupertino renders CupertinoSlider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Scaffold(
            body: DmSlider(
              value: 0.5,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(CupertinoSlider), findsOneWidget);
    });
  });
}
