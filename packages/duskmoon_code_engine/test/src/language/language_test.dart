import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(
      () => TreeSitterRuntime.ensureInitialized(languages: {'json', 'python'}));
  EditorState create(String text, LanguageSupport language) {
    final state =
        EditorState.create(docString: text, extensions: [language.extension]);
    addTearDown(() => disposeSyntax(state));
    return state;
  }

  test('language preserves editor metadata', () {
    final language = dartLanguageSupport().language;
    expect(language.name, 'dart');
    expect(language.data.commentTokens?.line, '//');
  });

  test('shared field isolates simultaneous editors and old snapshots', () {
    final json = create('{"one": [1, 2]}', jsonLanguageSupport());
    final python = create('def hello():\n  return 42', pythonLanguageSupport());
    final original = syntaxTree(json)!;
    expect(original.language, 'json');
    expect(syntaxTree(python)!.language, 'python');
    final next = json
        .update(TransactionSpec(
            changes: ChangeSet.of(json.doc.length, [
          const ChangeSpec(from: 9, to: 10, insert: '3'),
        ])))
        .state;
    expect(syntaxTree(next)!.incremental, isTrue);
    expect(syntaxTree(next)!.source, '{"one": [3, 2]}');
    expect(syntaxTree(json), same(original));
    expect(original.source, '{"one": [1, 2]}');
    expect(syntaxTree(python)!.source, 'def hello():\n  return 42');
    expect(() => original.rootNode.children.clear(), throwsUnsupportedError);
    expect(() => original.captures.clear(), throwsUnsupportedError);
  });

  test('incremental Unicode and multiline edits retain UTF16 ranges', () {
    final controller = EditorViewController(
        text: '{"emoji": "😀",\n "value": 1}', language: jsonLanguageSupport());
    addTearDown(controller.dispose);
    final old = syntaxTree(controller.state)!;
    controller.replaceRange(11, 13, '🚀\n雪');
    expect(syntaxTree(controller.state)!.incremental, isTrue);
    expect(syntaxTree(controller.state)!.rootNode.to, controller.text.length);
    expect(old.source, '{"emoji": "😀",\n "value": 1}');
    controller.text = '{"emoji": "🚀",\n "value": 2}';
    final tree = syntaxTree(controller.state)!;
    expect(tree.rootNode.hasError, isFalse);
    for (final capture in tree.captures) {
      expect(capture.from, greaterThanOrEqualTo(0));
      expect(capture.to, lessThanOrEqualTo(controller.text.length));
      expect(controller.text.substring(capture.from, capture.to), isNotEmpty);
    }
  });

  test('raw state readiness returns syntax without replacing document',
      () async {
    final state = create('{"x": 1}', jsonLanguageSupport());
    final ready = await ensureSyntaxTree(state);
    expect(ready.doc, same(state.doc));
    expect(syntaxTree(ready)!.rootNode.hasError, isFalse);
  });

  test('language facets resolve through compartment and precedence wrappers',
      () {
    final state = EditorState.create(docString: '{"value": 1}', extensions: [
      Compartment()
          .of(prec(Precedence.override_, jsonLanguageSupport().extension)),
    ]);
    addTearDown(() => disposeSyntax(state));
    expect(syntaxTree(state)!.language, 'json');
    expect(syntaxTree(state)!.rootNode.hasError, isFalse);
  });

  test('unrelated effects with language values cannot switch syntax', () {
    final state = create('42', jsonLanguageSupport());
    const unrelated = StateEffectType<Language?>();
    final next = state
        .update(TransactionSpec(effects: [
          unrelated.of(pythonLanguageSupport().language),
        ]))
        .state;
    expect(syntaxTree(next)!.language, 'json');
    expect(syntaxTree(next), same(syntaxTree(state)));
  });

  test('state with no language has no syntax tree', () {
    expect(syntaxTree(EditorState.create(docString: 'plain')), isNull);
  });
}
