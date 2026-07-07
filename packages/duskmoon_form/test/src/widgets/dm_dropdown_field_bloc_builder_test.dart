import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmDropdown;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? DmThemeData.sunshine(),
    themeAnimationDuration: Duration.zero,
    home: Scaffold(body: child),
  );
}

void main() {
  group('DmDropdownFieldBlocBuilder', () {
    testWidgets('renders decoration label on macOS platform', (tester) async {
      final bloc = SelectFieldBloc<String, dynamic>(
        initialValue: 'camera1',
        items: const ['camera1'],
      );
      addTearDown(bloc.close);

      await tester.pumpWidget(
        _wrap(
          DmDropdownFieldBlocBuilder<String>(
            selectFieldBloc: bloc,
            decoration: const InputDecoration(
              labelText: 'Video Device',
              border: OutlineInputBorder(),
            ),
            itemBuilder: (context, value) => FieldItem(child: Text(value)),
          ),
          theme: DmThemeData.sunshine().copyWith(
            platform: TargetPlatform.macOS,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 20));

      expect(find.byType(DmDropdown<String>), findsOneWidget);
      expect(find.text('Video Device'), findsOneWidget);
      expect(find.text('camera1'), findsOneWidget);
    });
  });
}
