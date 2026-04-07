import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarkdownFieldBloc', () {
    test('initial state has tab = DmMarkdownTab.write by default', () {
      final bloc = MarkdownFieldBloc();
      expect(bloc.state.tab, DmMarkdownTab.write);
      bloc.close();
    });

    test('initial state has tab = DmMarkdownTab.preview when specified', () {
      final bloc = MarkdownFieldBloc(initialTab: DmMarkdownTab.preview);
      expect(bloc.state.tab, DmMarkdownTab.preview);
      bloc.close();
    });

    test('updateTab emits state with updated tab', () {
      final bloc = MarkdownFieldBloc();
      bloc.updateTab(DmMarkdownTab.preview);
      expect(bloc.state.tab, DmMarkdownTab.preview);
      bloc.close();
    });

    test('initial value is empty string by default', () {
      final bloc = MarkdownFieldBloc();
      expect(bloc.state.value, '');
      bloc.close();
    });

    test('initialValue sets state.value', () {
      final bloc = MarkdownFieldBloc(initialValue: '# Hello');
      expect(bloc.state.value, '# Hello');
      bloc.close();
    });

    test('changeValue updates state.value', () {
      final bloc = MarkdownFieldBloc();
      bloc.changeValue('# Updated');
      expect(bloc.state.value, '# Updated');
      bloc.close();
    });

    test('validators run on changeValue', () {
      final bloc = MarkdownFieldBloc(
        validators: [(v) => v.isEmpty ? 'required' : null],
      );
      bloc.changeValue('');
      expect(bloc.state.hasError, isTrue);
      bloc.changeValue('hello');
      expect(bloc.state.hasError, isFalse);
      bloc.close();
    });

    test('tab is preserved after changeValue', () {
      final bloc = MarkdownFieldBloc();
      bloc.updateTab(DmMarkdownTab.preview);
      bloc.changeValue('# Test');
      expect(bloc.state.tab, DmMarkdownTab.preview);
      bloc.close();
    });
  });
}
