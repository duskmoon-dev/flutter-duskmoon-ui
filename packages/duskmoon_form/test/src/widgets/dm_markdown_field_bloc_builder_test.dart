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
      await tester.enterText(find.byType(EditableText), '# Hello');
      await tester.pump();
      expect(bloc.state.value, '# Hello');
    });

    testWidgets('updateTab causes DmMarkdownInput rebuild with new initialTab',
        (tester) async {
      final bloc = MarkdownFieldBloc(initialTab: DmMarkdownTab.write);
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

    for (final scrolling in [false, true]) {
      testWidgets(
          '${scrolling ? 'scrolling' : 'bounded'} decorated field retains edits through both tabs',
          (tester) async {
        final bloc = MarkdownFieldBloc(initialValue: '# Initial bio');
        addTearDown(bloc.close);
        final field = DmMarkdownFieldBlocBuilder(
          markdownFieldBloc: bloc,
          minLines: 8,
          animateWhenCanShow: false,
          decoration: const InputDecoration(labelText: 'Bio'),
        );
        await tester.pumpWidget(
          _wrap(scrolling ? SingleChildScrollView(child: field) : field),
        );
        await tester.pump(const Duration(milliseconds: 20));
        expect(tester.takeException(), isNull);

        const edited = '# Biography\n\nUpdated bio.';
        await tester.enterText(find.byType(EditableText), edited);
        await tester.pump();
        expect(bloc.state.value, edited);

        await tester.tap(find.text('Preview'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(bloc.state.tab, DmMarkdownTab.preview);
        expect(bloc.state.value, edited);
        expect(find.text('Biography', findRichText: true), findsOneWidget);

        await tester.tap(find.text('Write'));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(bloc.state.tab, DmMarkdownTab.write);
        expect(bloc.state.value, edited);
        expect(
          tester
              .widget<EditableText>(find.byType(EditableText))
              .controller
              .text,
          edited,
        );
        final height = tester.getSize(find.byType(DmMarkdownInput)).height;
        expect(height.isFinite, isTrue);
        expect(height, greaterThan(0));
      });
    }

    testWidgets('scrolling field applies external tab and value updates',
        (tester) async {
      final bloc = MarkdownFieldBloc(initialValue: '# Initial bio');
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(SingleChildScrollView(
          child: DmMarkdownFieldBlocBuilder(
            markdownFieldBloc: bloc,
            minLines: 8,
            animateWhenCanShow: false,
            decoration: const InputDecoration(labelText: 'Bio'),
          ),
        )),
      );
      await tester.pump(const Duration(milliseconds: 20));
      expect(tester.takeException(), isNull);

      bloc.updateTab(DmMarkdownTab.preview);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Initial bio', findRichText: true), findsOneWidget);

      bloc.changeValue('# External bio');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('External bio', findRichText: true), findsOneWidget);
      expect(find.text('Initial bio', findRichText: true), findsNothing);

      bloc.updateTab(DmMarkdownTab.write);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(bloc.state.value, '# External bio');
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        '# External bio',
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
