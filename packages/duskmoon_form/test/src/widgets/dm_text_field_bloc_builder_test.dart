import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpField(
  WidgetTester tester,
  Widget field, {
  ThemeData? theme,
}) async {
  await tester.pumpWidget(
    DuskmoonApp(
      child: MaterialApp(
        theme: theme ??
            DmThemeData.moonlight().copyWith(platform: TargetPlatform.macOS),
        themeAnimationDuration: Duration.zero,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 320, child: field),
          ),
        ),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 20));
  await tester.pumpAndSettle();
}

void main() {
  for (final platform in [TargetPlatform.macOS, TargetPlatform.iOS]) {
    for (final entry in {
      'sunshine': DmThemeData.sunshine(),
      'moonlight': DmThemeData.moonlight(),
      'forest': DmThemeData.forest(),
      'ocean': DmThemeData.ocean(),
    }.entries) {
      testWidgets(
          '${platform.name} ${entry.key} retains themed form decoration',
          (tester) async {
        final bloc = TextFieldBloc(initialValue: '53');
        addTearDown(bloc.close);
        final theme = entry.value.copyWith(platform: platform);
        await _pumpField(
          tester,
          DmTextFieldBlocBuilder(
            textFieldBloc: bloc,
            animateWhenCanShow: false,
            decoration: const InputDecoration(
              labelText: 'Port',
              hintText: 'e.g., 53',
              helperText: 'Non-privileged port recommended',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.dns),
              suffixIcon: Icon(Icons.info),
            ),
          ),
          theme: theme,
        );

        expect(find.byType(CupertinoTextField), findsOneWidget);
        expect(find.text('Port'), findsOneWidget);
        expect(find.text('Non-privileged port recommended'), findsOneWidget);
        expect(find.byIcon(Icons.dns), findsOneWidget);
        expect(find.byIcon(Icons.info), findsOneWidget);
        final decorator = tester.widget<InputDecorator>(
          find.byType(InputDecorator),
        );
        expect(decorator.decoration.border, isA<OutlineInputBorder>());
        expect(decorator.decoration.filled, isTrue);
        expect(decorator.decoration.fillColor,
            theme.colorScheme.surfaceContainerHighest);
        // The native editor must not paint a white surface over the decorator.
        expect(
          tester
              .widget<CupertinoTextField>(find.byType(CupertinoTextField))
              .decoration,
          isNull,
        );
        expect(
            tester.widget<EditableText>(find.byType(EditableText)).style.color,
            theme.colorScheme.onSurface);
        expect(
            CupertinoTheme.of(tester.element(find.byType(CupertinoTextField)))
                .brightness,
            theme.brightness);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets(
      'Cupertino labels follow focus and edits and show validation errors',
      (tester) async {
    final bloc = TextFieldBloc();
    final focusNode = FocusNode();
    addTearDown(bloc.close);
    addTearDown(focusNode.dispose);
    await _pumpField(
      tester,
      DmTextFieldBlocBuilder(
        textFieldBloc: bloc,
        animateWhenCanShow: false,
        focusNode: focusNode,
        decoration: const InputDecoration(
          labelText: 'Port',
          hintText: 'e.g., 53',
          helperText: 'Enter a port',
        ),
      ),
    );
    InputDecorator decorator() =>
        tester.widget<InputDecorator>(find.byType(InputDecorator));
    expect(decorator().isEmpty, isTrue);
    expect(decorator().isFocused, isFalse);

    await tester.tap(find.byType(CupertinoTextField));
    await tester.pumpAndSettle();
    expect(decorator().isFocused, isTrue);
    expect(find.text('e.g., 53'), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'invalid');
    await tester.pump();
    expect(bloc.state.value, 'invalid');
    expect(decorator().isEmpty, isFalse);

    bloc.addFieldError('Invalid port');
    await tester.pumpAndSettle();
    expect(find.text('Port'), findsOneWidget);
    expect(find.text('Invalid port'), findsOneWidget);
    expect(decorator().decoration.errorText, 'Invalid port');

    focusNode.unfocus();
    await tester.pumpAndSettle();
    expect(decorator().isFocused, isFalse);
    expect(decorator().isEmpty, isFalse);
    bloc.changeValue('');
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pumpAndSettle();
    expect(decorator().isEmpty, isTrue);
    expect(find.text('Enter a port'), findsOneWidget);
  });

  testWidgets('Cupertino fields retain custom decoration and disabled state',
      (tester) async {
    final bloc = TextFieldBloc(initialValue: '53');
    addTearDown(bloc.close);
    const fill = Color(0xFF223344);
    const border = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      borderSide: BorderSide(color: Color(0xFFABCDEF), width: 3),
    );
    await _pumpField(
      tester,
      DmTextFieldBlocBuilder(
        textFieldBloc: bloc,
        animateWhenCanShow: false,
        isEnabled: false,
        decoration: const InputDecoration(
          label: Text('Custom label'),
          helper: Text('Custom helper'),
          fillColor: fill,
          disabledBorder: border,
        ),
      ),
    );

    final decorator =
        tester.widget<InputDecorator>(find.byType(InputDecorator));
    expect(find.text('Custom label'), findsOneWidget);
    expect(find.text('Custom helper'), findsOneWidget);
    expect(decorator.decoration.fillColor, fill);
    expect(decorator.decoration.disabledBorder, border);
    expect(decorator.decoration.enabled, isFalse);
    expect(
        tester
            .widget<CupertinoTextField>(find.byType(CupertinoTextField))
            .enabled,
        isFalse);
    await tester.tapAt(tester.getCenter(find.byType(CupertinoTextField)));
    await tester.pump();
    expect(tester.widget<InputDecorator>(find.byType(InputDecorator)).isFocused,
        isFalse);
    expect(bloc.state.value, '53');
  });

  testWidgets('Cupertino decoration retains clear button and suggestions',
      (tester) async {
    final bloc = TextFieldBloc(suggestions: (pattern) async => ['5353']);
    addTearDown(bloc.close);
    await _pumpField(
      tester,
      DmTextFieldBlocBuilder(
        textFieldBloc: bloc,
        animateWhenCanShow: false,
        suffixButton: SuffixButton.clearText,
        debounceSuggestionDuration: Duration.zero,
        decoration: const InputDecoration(labelText: 'Port'),
      ),
    );
    await tester.enterText(find.byType(EditableText), '53');
    await tester.pumpAndSettle();
    expect(find.text('5353'), findsOneWidget);
    await tester.tap(find.text('5353'));
    await tester.pumpAndSettle();
    expect(bloc.state.value, '5353');
    expect(find.text('Port'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.clear));
    await tester.pumpAndSettle();
    expect(bloc.state.value, isEmpty);
    expect(tester.widget<InputDecorator>(find.byType(InputDecorator)).isEmpty,
        isTrue);
  });
}
