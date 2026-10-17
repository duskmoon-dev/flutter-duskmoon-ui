import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('independent field states have value equality and matching hashes', () {
    final first = TextFieldBloc(initialValue: 'hello');
    final second = TextFieldBloc(initialValue: 'hello');
    addTearDown(first.close);
    addTearDown(second.close);

    expect(identical(first.state, second.state), isFalse);
    expect(first.state, second.state);
    expect(first.state.hashCode, second.state.hashCode);
    expect({first.state, second.state}, hasLength(1));

    second.changeValue('updated');
    expect(first.state, isNot(second.state));
  });

  test('selection state equality includes nested collection values', () {
    MultiSelectFieldBloc<Map<String, List<String>>, Object?> create(
      String value,
    ) =>
        MultiSelectFieldBloc(
          initialValue: [
            {
              'group': [value],
            },
          ],
        );

    final first = create('one');
    final second = create('one');
    final different = create('two');
    addTearDown(first.close);
    addTearDown(second.close);
    addTearDown(different.close);

    expect(
        identical(first.state.value.first, second.state.value.first), isFalse);
    expect(first.state, second.state);
    expect(first.state.hashCode, second.state.hashCode);
    expect(first.state, isNot(different.state));
  });

  test('form state equality handles nested maps and distinct lifecycle types',
      () {
    final field = TextFieldBloc(name: 'name');
    addTearDown(field.close);
    final first = FormBlocLoaded<String, String>(
      isValidByStep: {0: true, 1: false},
      fieldBlocs: {
        0: {'name': field},
      },
    );
    final second = FormBlocLoaded<String, String>(
      isValidByStep: {1: false, 0: true},
      fieldBlocs: {
        0: {'name': field},
      },
    );

    expect(first, second);
    expect(first.hashCode, second.hashCode);
    expect(first, isNot(first.toSubmissionCancelled()));
    expect(first, isNot(first.toFailure(failureResponse: 'failed')));
  });

  test('field bloc suppresses equal states and emits language changes',
      () async {
    final bloc = CodeEditorFieldBloc();
    addTearDown(bloc.close);
    final emissions = expectLater(
      bloc.stream.map((state) => state.language),
      emitsInOrder(['dart', 'python', null, emitsDone]),
    );

    bloc
      ..updateLanguage('dart')
      ..updateLanguage('dart')
      ..updateLanguage('python')
      ..updateLanguage(null)
      ..updateLanguage(null);

    await bloc.close();
    await emissions;
  });
}
