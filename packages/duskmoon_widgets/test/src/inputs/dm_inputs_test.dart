import 'package:fluent_ui/fluent_ui.dart' as fluent;
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
            body: DmTextField(placeholder: 'Enter text'),
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
            body: DmTextField(placeholder: 'Enter text'),
          ),
        ),
      );
      expect(find.byType(CupertinoTextField), findsOneWidget);
    });

    testWidgets('Fluent renders fluent.TextBox', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DmTextField(
              placeholder: 'Enter text',
              platformOverride: DmPlatformStyle.fluent,
            ),
          ),
        ),
      );
      expect(find.byType(fluent.TextBox), findsOneWidget);
    });
  });

  group('DmCheckbox', () {
    testWidgets('Material renders Checkbox', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmCheckbox(value: true, onChanged: (_) {}),
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
            body: DmCheckbox(value: true, onChanged: (_) {}),
          ),
        ),
      );
      expect(find.byType(CupertinoCheckbox), findsOneWidget);
    });

    testWidgets('Fluent renders fluent.Checkbox', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmCheckbox(
              value: true,
              onChanged: (_) {},
              platformOverride: DmPlatformStyle.fluent,
            ),
          ),
        ),
      );
      expect(find.byType(fluent.Checkbox), findsOneWidget);
    });
  });

  group('DmSwitch', () {
    testWidgets('Material renders Switch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmSwitch(value: false, onChanged: (_) {}),
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
            body: DmSwitch(value: false, onChanged: (_) {}),
          ),
        ),
      );
      expect(find.byType(CupertinoSwitch), findsOneWidget);
    });

    testWidgets('Fluent renders fluent.ToggleSwitch', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmSwitch(
              value: false,
              onChanged: (_) {},
              platformOverride: DmPlatformStyle.fluent,
            ),
          ),
        ),
      );
      expect(find.byType(fluent.ToggleSwitch), findsOneWidget);
    });
  });

  group('DmSlider', () {
    testWidgets('Material renders Slider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmSlider(value: 0.5, onChanged: (_) {}),
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
            body: DmSlider(value: 0.5, onChanged: (_) {}),
          ),
        ),
      );
      expect(find.byType(CupertinoSlider), findsOneWidget);
    });

    testWidgets('Fluent renders fluent.Slider', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmSlider(
              value: 0.5,
              onChanged: (_) {},
              platformOverride: DmPlatformStyle.fluent,
            ),
          ),
        ),
      );
      expect(find.byType(fluent.Slider), findsOneWidget);
    });
  });

  group('DmDropdown', () {
    final items = [
      const DmDropdownItem<String>(value: 'a', child: Text('Alpha')),
      const DmDropdownItem<String>(value: 'b', child: Text('Beta')),
    ];

    testWidgets('Material renders DropdownButton', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: Scaffold(
            body: DmDropdown<String>(
              items: items,
              value: 'a',
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.byType(DropdownButton<String>), findsOneWidget);
    });

    testWidgets('Cupertino renders picker trigger', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: Scaffold(
            body: DmDropdown<String>(
              items: items,
              value: 'a',
              onChanged: (_) {},
            ),
          ),
        ),
      );
      // The Cupertino variant uses a GestureDetector with chevron icon
      expect(find.byIcon(CupertinoIcons.chevron_down), findsOneWidget);
    });

    testWidgets('Fluent renders fluent.ComboBox', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DmDropdown<String>(
              items: items,
              value: 'a',
              onChanged: (_) {},
              platformOverride: DmPlatformStyle.fluent,
            ),
          ),
        ),
      );
      expect(find.byType(fluent.ComboBox<String>), findsOneWidget);
    });
  });
}
