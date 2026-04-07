import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CodeEditorFieldBloc', () {
    test('initial state has language = null by default', () {
      final bloc = CodeEditorFieldBloc();
      expect(bloc.state.language, isNull);
      bloc.close();
    });

    test('initial state has language = "dart" when specified', () {
      final bloc = CodeEditorFieldBloc(initialLanguage: 'dart');
      expect(bloc.state.language, 'dart');
      bloc.close();
    });

    test('updateLanguage emits state with updated language', () {
      final bloc = CodeEditorFieldBloc();
      bloc.updateLanguage('python');
      expect(bloc.state.language, 'python');
      bloc.close();
    });

    test('updateLanguage(null) emits state with null language', () {
      final bloc = CodeEditorFieldBloc(initialLanguage: 'dart');
      bloc.updateLanguage(null);
      expect(bloc.state.language, isNull);
      bloc.close();
    });

    test('initial value is empty string by default', () {
      final bloc = CodeEditorFieldBloc();
      expect(bloc.state.value, '');
      bloc.close();
    });

    test('initialValue sets state.value', () {
      final bloc = CodeEditorFieldBloc(initialValue: 'void main() {}');
      expect(bloc.state.value, 'void main() {}');
      bloc.close();
    });

    test('changeValue updates state.value', () {
      final bloc = CodeEditorFieldBloc();
      bloc.changeValue('print("hello")');
      expect(bloc.state.value, 'print("hello")');
      bloc.close();
    });

    test('validators run on changeValue', () {
      final bloc = CodeEditorFieldBloc(
        validators: [(v) => v.isEmpty ? 'required' : null],
      );
      bloc.changeValue('');
      expect(bloc.state.hasError, isTrue);
      bloc.changeValue('x = 1');
      expect(bloc.state.hasError, isFalse);
      bloc.close();
    });

    test('language is preserved after changeValue', () {
      final bloc = CodeEditorFieldBloc(initialLanguage: 'dart');
      bloc.changeValue('var x = 1;');
      expect(bloc.state.language, 'dart');
      bloc.close();
    });
  });
}
