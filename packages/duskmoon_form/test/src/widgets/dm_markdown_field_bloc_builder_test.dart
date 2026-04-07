import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? DmThemeData.sunshine(),
    home: Scaffold(
      body: SizedBox(height: 400, child: child),
    ),
  );
}

void main() {
  group('DmMarkdownFieldBlocBuilder', () {
    testWidgets('renders DmMarkdownInput', (tester) async {
      final bloc = MarkdownFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmMarkdownFieldBlocBuilder(markdownFieldBloc: bloc)),
      );
      // Advance past the 10 ms first-frame delay in DmCanShowFieldBlocBuilder.
      await tester.pump(const Duration(milliseconds: 20));
      expect(find.byType(DmMarkdownInput), findsOneWidget);
    });

    testWidgets('onChanged fires bloc.changeValue', (tester) async {
      final bloc = MarkdownFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmMarkdownFieldBlocBuilder(markdownFieldBloc: bloc)),
      );
      await tester.pump(const Duration(milliseconds: 20));

      // Simulate text change via entering text in the editor
      await tester.enterText(find.byType(TextField), '# Hello');
      await tester.pump();
      expect(bloc.state.value, '# Hello');
    });

    testWidgets('updateTab causes DmMarkdownInput rebuild with new initialTab',
        (tester) async {
      final bloc =
          MarkdownFieldBloc(initialTab: DmMarkdownTab.write);
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmMarkdownFieldBlocBuilder(markdownFieldBloc: bloc)),
      );
      await tester.pump(const Duration(milliseconds: 20));

      // Verify initial tab
      expect(
        tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput)).initialTab,
        DmMarkdownTab.write,
      );

      // Change tab from BLoC
      bloc.updateTab(DmMarkdownTab.preview);
      // Two pumps: first processes the BLoC state emission, second redraws.
      await tester.pump();
      await tester.pump();

      // Widget should rebuild with new initialTab
      expect(
        tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput)).initialTab,
        DmMarkdownTab.preview,
      );
    });

    testWidgets('isEnabled = false sets DmMarkdownInput.enabled = false',
        (tester) async {
      final bloc = MarkdownFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmMarkdownFieldBlocBuilder(
          markdownFieldBloc: bloc,
          isEnabled: false,
        )),
      );
      await tester.pump(const Duration(milliseconds: 20));
      expect(
        tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput)).enabled,
        isFalse,
      );
    });
  });
}
