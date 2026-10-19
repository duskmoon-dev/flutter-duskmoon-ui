// Browser smoke entry point for both dart compile js and dart compile wasm.
import 'dart:js_interop';

import 'package:duskmoon_highlight/tree_sitter.dart';

@JS('duskmoonTreeSitterProbe')
external set _result(JSAny value);

String _tree(SyntaxNode node) => '${node.type}:${node.from}:${node.to}'
    ':${node.isNamed}:${node.hasError}'
    '[${node.children.map(_tree).join(',')}]';
String _captures(SyntaxSnapshot snapshot) => snapshot.captures
    .map((c) => '${c.name}:${c.from}:${c.to}:${c.priority}:${c.patternIndex}')
    .join('|');

void main() async {
  var stage = 'initialize';
  try {
    const examples = {
      'json': '{"emoji":"😀","value":42}',
      'javascript': 'const emoji = "😀";\nconst value = 42;',
      'dart': 'void main() { final emoji = "😀"; final value = 42; }',
      'tsx': 'const value = 42; const view = <div title="😀">{value}</div>;',
      'cpp': 'int main() { const char* emoji = "😀"; return 42; }',
      'nim': 'let emoji = "😀"\nif true:\n  echo 42\n',
      'vala': 'void main () { string value = """😀\nworld"""; int n = 42; }',
    };
    await TreeSitterRuntime.ensureInitialized(languages: examples.keys.toSet());
    final sessions = <String, TreeSitterSession>{};
    for (final language in examples.keys) {
      stage = language;
      sessions[language] = TreeSitterSession(language: language);
    }
    final initial = {
      for (final entry in examples.entries)
        entry.key: sessions[entry.key]!.parse(entry.value),
    };
    for (final entry in examples.entries) {
      stage = entry.key;
      final next = entry.value.replaceAll('😀', '😁').replaceAll('42', '420');
      final actual = sessions[entry.key]!.parse(next);
      final fresh = TreeSitterSession(language: entry.key);
      final expected = fresh.parse(next);
      if (_tree(actual.rootNode) != _tree(expected.rootNode) ||
          _captures(actual) != _captures(expected)) {
        throw StateError('${entry.key}: incremental tree/captures differ');
      }
      if (!actual.incremental ||
          actual.rootNode.hasError ||
          actual.rootNode.to != next.length ||
          actual.captures.isEmpty) {
        throw StateError('${entry.key}: invalid syntax snapshot/captures');
      }
      fresh.dispose();
    }
    for (final session in sessions.values) {
      session.dispose();
    }
    for (final entry in initial.entries) {
      if (entry.value.source != examples[entry.key] ||
          entry.value.rootNode.to != examples[entry.key]!.length) {
        throw StateError('${entry.key}: disposed snapshot changed');
      }
    }
    var count = 0;
    for (final language in TreeSitterRuntime.languages) {
      stage = language;
      await TreeSitterRuntime.ensureInitialized(languages: {language});
      final session = TreeSitterSession(language: language);
      final snapshot = session.parse('');
      if (snapshot.language != language || snapshot.rootNode.to != 0) {
        throw StateError('$language: invalid empty syntax tree');
      }
      session.dispose();
      count++;
    }
    _result = {
      'ok': true,
      'utf16': true,
      'incremental': true,
      'simultaneousSessions': examples.length,
      'snapshotLifetime': true,
      'representativeLanguages': examples.keys.toList(),
      'allGrammars': count,
    }.jsify()!;
  } catch (error, stack) {
    _result = {
      'ok': false,
      'stage': stage,
      'error': '$error',
      'stack': '$stack'
    }.jsify()!;
  }
}
