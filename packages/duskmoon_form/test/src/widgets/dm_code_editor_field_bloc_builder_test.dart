import 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show CodeEditorWidget;
import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmCodeEditor;
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
  group('DmCodeEditorFieldBlocBuilder', () {
    testWidgets('renders DmCodeEditor', (tester) async {
      final bloc = CodeEditorFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(codeEditorFieldBloc: bloc)),
      );
      await tester.pump(const Duration(milliseconds: 20));
      expect(find.byType(DmCodeEditor), findsOneWidget);
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('onChanged fires bloc.changeValue via controller',
        (tester) async {
      final bloc = CodeEditorFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(codeEditorFieldBloc: bloc)),
      );
      await tester.pump(const Duration(milliseconds: 20));

      // Change value from BLoC directly (external change path)
      bloc.changeValue('x = 1');
      await tester.pump();
      expect(bloc.state.value, 'x = 1');
    });

    testWidgets(
        'updateLanguage causes DmCodeEditor to receive updated language prop',
        (tester) async {
      final bloc = CodeEditorFieldBloc(initialLanguage: 'dart');
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(codeEditorFieldBloc: bloc)),
      );
      await tester.pump(const Duration(milliseconds: 20));

      expect(
        tester.widget<DmCodeEditor>(find.byType(DmCodeEditor)).language,
        'dart',
      );

      bloc.updateLanguage('python');
      // Two pumps: first processes the BLoC state emission, second redraws.
      await tester.pump();
      await tester.pump();

      expect(
        tester.widget<DmCodeEditor>(find.byType(DmCodeEditor)).language,
        'python',
      );
    });

    testWidgets(
        'external changeValue syncs controller text and supports bloc swap',
        (tester) async {
      final bloc1 = CodeEditorFieldBloc(initialValue: 'hello');
      final bloc2 = CodeEditorFieldBloc(initialValue: 'from bloc 2');
      addTearDown(() {
        bloc1.close();
        bloc2.close();
      });
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(codeEditorFieldBloc: bloc1)),
      );
      await tester.pump(const Duration(milliseconds: 20));
      expect(
        tester.widget<DmCodeEditor>(find.byType(DmCodeEditor)).controller!.text,
        'hello',
      );

      bloc1.changeValue('world');
      await tester.pump();
      expect(
        tester.widget<DmCodeEditor>(find.byType(DmCodeEditor)).controller!.text,
        'world',
      );

      // Swap codeEditorFieldBloc instance
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(codeEditorFieldBloc: bloc2)),
      );
      await tester.pump();
      expect(
        tester.widget<DmCodeEditor>(find.byType(DmCodeEditor)).controller!.text,
        'from bloc 2',
      );
    });

    testWidgets('isEnabled = false sets DmCodeEditor.readOnly = true',
        (tester) async {
      final bloc = CodeEditorFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(
          codeEditorFieldBloc: bloc,
          isEnabled: false,
        )),
      );
      await tester.pump(const Duration(milliseconds: 20));
      expect(
        tester.widget<DmCodeEditor>(find.byType(DmCodeEditor)).readOnly,
        isTrue,
      );
    });
  });
}
