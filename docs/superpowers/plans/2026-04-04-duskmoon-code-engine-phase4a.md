# duskmoon_code_engine Phase 4a — Language Ecosystem Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add multi-language support via StreamLanguage (regex-based highlighting), bracket matching, comment toggling, and code folding — delivering syntax highlighting for 10+ languages without waiting for the full LR parser port.

**Architecture:** `StreamLanguage` is a simple line-by-line tokenizer that uses regex patterns to classify tokens. Each language defines a list of `TokenRule`s (pattern + tag). StreamLanguage implements `Parser` and produces Trees compatible with the existing highlighting pipeline. Bracket matching, comment toggling, and folding are independent features that operate on the syntax tree and LanguageData metadata.

**Tech Stack:** Dart 3.5+, Flutter SDK, RegExp

**Spec:** `docs/code-engine.md` sections 6, 9.3 (comment/fold commands)

**Depends on:** Phases 1-3b (complete)

**Scoping note:** The full table-driven LR parser port (~4K lines) is deferred to a dedicated plan. StreamLanguage provides immediate multi-language support with simpler implementation. When real LR grammars are added later, they'll slot in via the same Language/LanguageSupport/LanguageRegistry system — consumers won't need to change anything.

---

## File Structure

```
packages/duskmoon_code_engine/lib/src/
├── language/
│   └── stream_language.dart        # CREATE — StreamLanguage regex tokenizer
│
├── grammars/
│   ├── _registry.dart              # EXISTS
│   ├── json.dart                   # EXISTS
│   ├── dart.dart                   # CREATE — Dart language
│   ├── javascript.dart             # CREATE — JavaScript/TypeScript
│   ├── python.dart                 # CREATE — Python
│   ├── html.dart                   # CREATE — HTML
│   ├── css.dart                    # CREATE — CSS
│   ├── markdown.dart               # CREATE — Markdown
│   ├── rust.dart                   # CREATE — Rust
│   ├── go.dart                     # CREATE — Go
│   ├── yaml.dart                   # CREATE — YAML
│   ├── c.dart                      # CREATE — C/C++
│   └── elixir.dart                 # CREATE — Elixir
│
├── commands/
│   ├── bracket_matching.dart       # CREATE — bracket pair detection
│   ├── comment.dart                # CREATE — toggle comment commands
│   └── folding.dart                # CREATE — indent-based fold detection
│
└── view/
    └── bracket_painter.dart        # CREATE — bracket highlight rendering

test/src/
├── language/
│   └── stream_language_test.dart   # CREATE
├── grammars/
│   ├── dart_test.dart              # CREATE
│   └── multi_language_test.dart    # CREATE
└── commands/
    ├── bracket_matching_test.dart   # CREATE
    ├── comment_test.dart            # CREATE
    └── folding_test.dart            # CREATE
```

---

## Task 1: StreamLanguage tokenizer

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/language/stream_language.dart`
- Create: `packages/duskmoon_code_engine/test/src/language/stream_language_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

StreamLanguage is a simple regex-based line-by-line tokenizer that implements `Parser` and produces Trees. Each language defines a list of `TokenRule`s — a regex pattern and the node name to assign.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/language/stream_language_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('StreamLanguage', () {
    late StreamLanguage lang;

    setUp(() {
      lang = StreamLanguage(
        name: 'test',
        rules: [
          TokenRule(RegExp(r'\b\d+\b'), 'Number'),
          TokenRule(RegExp(r'"[^"]*"'), 'String'),
          TokenRule(RegExp(r'\b(if|else|return)\b'), 'Keyword'),
          TokenRule(RegExp(r'//.*'), 'Comment'),
          TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
        ],
      );
    });

    test('parses empty string', () {
      final tree = lang.parser.parse('');
      expect(tree.length, 0);
      expect(tree.type.isTop, true);
    });

    test('parses single number', () {
      final tree = lang.parser.parse('42');
      expect(tree.length, 2);
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Number');
    });

    test('parses string literal', () {
      final tree = lang.parser.parse('"hello"');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'String');
    });

    test('parses keyword', () {
      final tree = lang.parser.parse('if');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Keyword');
    });

    test('parses comment', () {
      final tree = lang.parser.parse('// hello world');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Comment');
    });

    test('parses mixed tokens', () {
      final tree = lang.parser.parse('if (x > 42) return "done"');
      final cursor = tree.cursor();
      final names = <String>[];
      if (cursor.firstChild()) {
        names.add(cursor.name);
        while (cursor.nextSibling()) {
          names.add(cursor.name);
        }
      }
      expect(names, contains('Keyword'));
      expect(names, contains('Number'));
      expect(names, contains('String'));
    });

    test('skips whitespace without creating nodes', () {
      final tree = lang.parser.parse('  42  ');
      expect(tree.length, 6);
      // Only the number token, not whitespace
      final tokenNames = <String>[];
      final cursor = tree.cursor();
      if (cursor.firstChild()) {
        tokenNames.add(cursor.name);
        while (cursor.nextSibling()) tokenNames.add(cursor.name);
      }
      expect(tokenNames, ['Number']);
    });

    test('handles multi-line text', () {
      final tree = lang.parser.parse('42\n"hi"\nreturn');
      expect(tree.length, 14);
      final cursor = tree.cursor();
      final names = <String>[];
      if (cursor.firstChild()) {
        names.add(cursor.name);
        while (cursor.nextSibling()) names.add(cursor.name);
      }
      expect(names, ['Number', 'String', 'Keyword']);
    });

    test('integrates with LanguageSupport and EditorState', () {
      final support = lang.languageSupport();
      final state = EditorState.create(
        docString: 'if (42) return "ok"',
        extensions: [support.extension],
      );
      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      expect(tree!.type.isTop, true);
    });

    test('first rule wins on tie', () {
      // "if" matches both Keyword and Identifier rules
      // Keyword comes first, so it should win
      final tree = lang.parser.parse('if');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Keyword');
    });

    test('registers in LanguageRegistry', () {
      final support = lang.languageSupport(
        extensions: ['test'],
        mimeTypes: ['text/x-test'],
      );
      // After calling languageSupport, it should be findable
      expect(LanguageRegistry.byName('test'), isNotNull);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/language/stream_language_test.dart
```

- [ ] **Step 3: Implement StreamLanguage**

Create `packages/duskmoon_code_engine/lib/src/language/stream_language.dart`:

```dart
import '../lezer/common/node_type.dart';
import '../lezer/common/parser.dart';
import '../lezer/common/tree.dart';
import '../grammars/_registry.dart';
import 'language.dart';
import 'language_data.dart';

/// A rule mapping a regex pattern to a node type name.
class TokenRule {
  const TokenRule(this.pattern, this.nodeName);

  /// Regex pattern to match. Must match at the start of remaining input
  /// (anchored internally).
  final RegExp pattern;

  /// Node type name for matched tokens (e.g., "Keyword", "String").
  final String nodeName;
}

/// A simple line-by-line regex tokenizer implementing [Parser].
///
/// For languages where a full LR grammar isn't available yet,
/// StreamLanguage provides basic syntax highlighting via regex rules.
/// Rules are tried in order; the first match wins.
class StreamLanguage {
  StreamLanguage({
    required this.name,
    required this.rules,
    this.data = const LanguageData(),
  }) {
    // Build node types from rule names
    final nameSet = <String>{'', name}; // 0=none, 1=top
    for (final rule in rules) {
      nameSet.add(rule.nodeName);
    }
    final nameList = nameSet.toList();
    _nodeTypes = List.generate(nameList.length, (i) {
      final props = <NodeProp<dynamic>, dynamic>{};
      if (i == 1) props[NodeProp.top] = true;
      return NodeType(nameList[i], i, props: props);
    });
    _nodeNameIndex = {
      for (var i = 0; i < nameList.length; i++) nameList[i]: i,
    };
    _topTypeIndex = 1;
  }

  final String name;
  final List<TokenRule> rules;
  final LanguageData data;

  late final List<NodeType> _nodeTypes;
  late final Map<String, int> _nodeNameIndex;
  late final int _topTypeIndex;

  /// The parser for this stream language.
  Parser get parser => _StreamParser(this);

  /// Create a [LanguageSupport] and optionally register it.
  LanguageSupport languageSupport({
    List<String> extensions = const [],
    List<String> mimeTypes = const [],
  }) {
    final language = Language(name: name, parser: parser, data: data);
    final support = LanguageSupport(language: language);
    LanguageRegistry.register(
      support,
      extensions: extensions,
      mimeTypes: mimeTypes,
    );
    return support;
  }
}

class _StreamParser extends Parser {
  const _StreamParser(this._lang);
  final StreamLanguage _lang;

  @override
  Tree parse(
    String input, {
    Tree? previousTree,
    List<ChangedRange>? changedRanges,
    int? stopAt,
  }) {
    final children = <Object>[];
    final positions = <int>[];
    var pos = 0;

    while (pos < input.length) {
      // Skip whitespace
      if (_isWhitespace(input.codeUnitAt(pos))) {
        pos++;
        continue;
      }

      // Try each rule
      var matched = false;
      for (final rule in _lang.rules) {
        final match = rule.pattern.matchAsPrefix(input, pos);
        if (match != null && match.end > pos) {
          final typeIdx = _lang._nodeNameIndex[rule.nodeName];
          if (typeIdx != null) {
            final nodeType = _lang._nodeTypes[typeIdx];
            children.add(Tree(nodeType, const [], const [], match.end - pos));
            positions.add(pos);
          }
          pos = match.end;
          matched = true;
          break;
        }
      }

      // Skip unrecognized character
      if (!matched) {
        pos++;
      }
    }

    final topType = _lang._nodeTypes[_lang._topTypeIndex];
    return Tree(topType, children, positions, input.length);
  }

  bool _isWhitespace(int ch) =>
      ch == 0x20 || ch == 0x09 || ch == 0x0A || ch == 0x0D;
}
```

- [ ] **Step 4: Add export**

```dart
export 'src/language/stream_language.dart' show TokenRule, StreamLanguage;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/language/stream_language_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add StreamLanguage regex-based tokenizer"
```

---

## Task 2: Dart language grammar

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/grammars/dart.dart`
- Create: `packages/duskmoon_code_engine/test/src/grammars/dart_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

A StreamLanguage-based Dart grammar with regex rules for keywords, strings, comments, numbers, annotations, types, and identifiers.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/grammars/dart_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('Dart grammar', () {
    test('is registered by name', () {
      dartLanguageSupport();
      expect(LanguageRegistry.byName('dart'), isNotNull);
    });

    test('is registered by extension', () {
      dartLanguageSupport();
      expect(LanguageRegistry.byExtension('dart'), isNotNull);
    });

    test('highlights keywords', () {
      final state = EditorState.create(
        docString: 'class Foo extends Bar {}',
        extensions: [dartLanguageSupport().extension],
      );
      final tree = syntaxTree(state)!;
      final names = _collectNodeNames(tree);
      expect(names, contains('Keyword'));
    });

    test('highlights string literals', () {
      final state = EditorState.create(
        docString: "final x = 'hello';",
        extensions: [dartLanguageSupport().extension],
      );
      final tree = syntaxTree(state)!;
      final names = _collectNodeNames(tree);
      expect(names, contains('String'));
    });

    test('highlights line comments', () {
      final state = EditorState.create(
        docString: '// this is a comment\nvar x = 1;',
        extensions: [dartLanguageSupport().extension],
      );
      final tree = syntaxTree(state)!;
      final names = _collectNodeNames(tree);
      expect(names, contains('Comment'));
    });

    test('highlights numbers', () {
      final state = EditorState.create(
        docString: 'var x = 42;',
        extensions: [dartLanguageSupport().extension],
      );
      final tree = syntaxTree(state)!;
      final names = _collectNodeNames(tree);
      expect(names, contains('Number'));
    });

    test('highlights annotations', () {
      final state = EditorState.create(
        docString: '@override\nvoid foo() {}',
        extensions: [dartLanguageSupport().extension],
      );
      final tree = syntaxTree(state)!;
      final names = _collectNodeNames(tree);
      expect(names, contains('Annotation'));
    });

    test('has comment tokens defined', () {
      final support = dartLanguageSupport();
      expect(support.language.data.commentTokens?.line, '//');
      expect(support.language.data.commentTokens?.block?.open, '/*');
      expect(support.language.data.commentTokens?.block?.close, '*/');
    });
  });
}

List<String> _collectNodeNames(Tree tree) {
  final names = <String>[];
  final cursor = tree.cursor();
  if (cursor.firstChild()) {
    names.add(cursor.name);
    while (cursor.nextSibling()) names.add(cursor.name);
  }
  return names;
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/grammars/dart_test.dart
```

- [ ] **Step 3: Implement Dart grammar**

Create `packages/duskmoon_code_engine/lib/src/grammars/dart.dart`:

```dart
import '../language/language_data.dart';
import '../language/stream_language.dart';

LanguageSupport? _cached;

/// Get or create the Dart LanguageSupport.
LanguageSupport dartLanguageSupport() {
  return _cached ??= _dartStreamLanguage.languageSupport(
    extensions: ['dart'],
    mimeTypes: ['application/dart', 'text/x-dart'],
  );
}

final _dartStreamLanguage = StreamLanguage(
  name: 'dart',
  rules: [
    // Line comments (must come before operator to catch //)
    TokenRule(RegExp(r'///.*'), 'Comment'),
    TokenRule(RegExp(r'//.*'), 'Comment'),
    // Block comments (non-greedy)
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    // Annotations
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    // String literals (single/double/triple quoted)
    TokenRule(RegExp(r"'''[\s\S]*?'''"), 'String'),
    TokenRule(RegExp(r'"""[\s\S]*?"""'), 'String'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Numbers
    TokenRule(RegExp(r'0x[0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(
        r'\b(abstract|as|assert|async|await|base|break|case|catch|class|'
        r'const|continue|covariant|default|deferred|do|dynamic|else|enum|'
        r'export|extends|extension|external|factory|false|final|finally|'
        r'for|Function|get|hide|if|implements|import|in|interface|is|late|'
        r'library|mixin|new|null|on|operator|part|required|rethrow|return|'
        r'sealed|set|show|static|super|switch|sync|this|throw|true|try|'
        r'typedef|var|void|when|while|with|yield)\b',
      ),
      'Keyword',
    ),
    // Type names (uppercase start)
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    // Identifiers
    TokenRule(RegExp(r'[a-zA-Z_$]\w*'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!?]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.:@#]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(
      line: '//',
      block: (open: '/*', close: '*/'),
    ),
  ),
);
```

- [ ] **Step 4: Add export**

```dart
export 'src/grammars/dart.dart' show dartLanguageSupport;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/grammars/dart_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Dart language grammar via StreamLanguage"
```

---

## Task 3: JavaScript, Python, HTML, CSS, Markdown, Rust, Go, YAML, C/C++, Elixir grammars

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/grammars/javascript.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/python.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/html.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/css.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/markdown.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/rust.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/go.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/yaml.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/c.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/elixir.dart`
- Create: `packages/duskmoon_code_engine/test/src/grammars/multi_language_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Each grammar follows the same pattern as the Dart grammar. Each provides a `<lang>LanguageSupport()` function that creates a StreamLanguage with language-appropriate regex rules, comment tokens, and file extensions.

- [ ] **Step 1: Write failing multi-language test**

Create `packages/duskmoon_code_engine/test/src/grammars/multi_language_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  setUp(() {
    LanguageRegistry.clear();
  });

  group('Language grammars', () {
    final grammars = <String, LanguageSupport Function()>{
      'javascript': javascriptLanguageSupport,
      'python': pythonLanguageSupport,
      'html': htmlLanguageSupport,
      'css': cssLanguageSupport,
      'markdown': markdownLanguageSupport,
      'rust': rustLanguageSupport,
      'go': goLanguageSupport,
      'yaml': yamlLanguageSupport,
      'c': cLanguageSupport,
      'elixir': elixirLanguageSupport,
    };

    for (final entry in grammars.entries) {
      group(entry.key, () {
        test('registers by name', () {
          entry.value();
          expect(LanguageRegistry.byName(entry.key), isNotNull);
        });

        test('parses sample code without errors', () {
          final support = entry.value();
          final state = EditorState.create(
            docString: _sampleCode[entry.key]!,
            extensions: [support.extension],
          );
          final tree = syntaxTree(state);
          expect(tree, isNotNull);
          expect(tree!.type.isTop, true);
          expect(tree.children, isNotEmpty);
        });

        test('has comment tokens', () {
          final support = entry.value();
          final comments = support.language.data.commentTokens;
          // All languages should define at least line or block comments
          expect(
            comments?.line != null || comments?.block != null,
            true,
            reason: '${entry.key} should define comment tokens',
          );
        });
      });
    }
  });
}

const _sampleCode = <String, String>{
  'javascript': 'function hello() { return "world"; } // comment',
  'python': 'def hello():\n    return "world"  # comment',
  'html': '<div class="hello">world</div><!-- comment -->',
  'css': '.hello { color: red; font-size: 14px; } /* comment */',
  'markdown': '# Hello\n\nSome **bold** and `code`',
  'rust': 'fn main() { let x: i32 = 42; } // comment',
  'go': 'func main() { x := 42 } // comment',
  'yaml': 'key: value\nlist:\n  - item1\n  - item2  # comment',
  'c': 'int main() { int x = 42; return 0; } // comment',
  'elixir': 'defmodule Foo do\n  def bar, do: "hello"\nend  # comment',
};
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/grammars/multi_language_test.dart
```

- [ ] **Step 3: Implement all 10 grammar files**

Each grammar file follows this pattern (showing JavaScript as example):

Create `packages/duskmoon_code_engine/lib/src/grammars/javascript.dart`:

```dart
import '../language/language_data.dart';
import '../language/stream_language.dart';

LanguageSupport? _cached;

LanguageSupport javascriptLanguageSupport() {
  return _cached ??= _jsStream.languageSupport(
    extensions: ['js', 'jsx', 'ts', 'tsx', 'mjs', 'cjs'],
    mimeTypes: ['application/javascript', 'text/javascript',
                'application/typescript'],
  );
}

final _jsStream = StreamLanguage(
  name: 'javascript',
  rules: [
    TokenRule(RegExp(r'//.*'), 'Comment'),
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    TokenRule(RegExp(r"`(?:[^`\\]|\\.)*`"), 'String'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r'0x[0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    TokenRule(
      RegExp(r'\b(async|await|break|case|catch|class|const|continue|'
             r'debugger|default|delete|do|else|enum|export|extends|'
             r'false|finally|for|from|function|get|if|import|in|'
             r'instanceof|interface|let|new|null|of|return|set|'
             r'static|super|switch|this|throw|true|try|type|typeof|'
             r'undefined|var|void|while|with|yield)\b'),
      'Keyword',
    ),
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    TokenRule(RegExp(r'[a-zA-Z_$]\w*'), 'Identifier'),
    TokenRule(RegExp(r'=>|[+\-*/%&|^~<>=!?]+'), 'Operator'),
    TokenRule(RegExp(r'[{}()\[\];,.:@#]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(
      line: '//',
      block: (open: '/*', close: '*/'),
    ),
  ),
);
```

Implement all 10 files following this same pattern with language-appropriate keywords, string delimiters, comment syntax, and file extensions:

**python.dart**: `#` comments, `"""` triple strings, Python keywords (def, class, import, from, if, elif, else, for, while, try, except, finally, with, as, return, yield, lambda, pass, break, continue, raise, True, False, None, and, or, not, in, is, global, nonlocal, assert, del, async, await), `@` decorators as Annotation

**html.dart**: `<!-- -->` comments, tags as `<tagname` and `</tagname>` patterns, `=` attribute operator, quoted attribute values as String

**css.dart**: `/* */` comments, property names, values, selectors, `@media`/`@import` as Keyword, hex colors as Number, quoted strings

**markdown.dart**: `#` headings as Heading, `**bold**` as Strong, `*italic*` as Emphasis, `` `code` `` as Code, `[text](url)` as Link, `- ` list items

**rust.dart**: `//` and `/* */` comments, `fn`, `let`, `mut`, `struct`, `enum`, `impl`, `pub`, `use`, etc. keywords, `'` lifetime annotations, `#[attr]` annotations

**go.dart**: `//` and `/* */` comments, `func`, `var`, `const`, `type`, `struct`, `interface`, `package`, `import`, `return`, `if`, `else`, `for`, `range`, `go`, `defer`, `chan`, `select` keywords

**yaml.dart**: `#` comments, key: value patterns (Key node type), quoted strings, `- ` list markers, numbers, booleans (true/false/yes/no/null)

**c.dart**: `//` and `/* */` comments, C/C++ keywords (int, char, void, struct, enum, typedef, if, else, for, while, do, switch, case, return, break, continue, sizeof, #include, #define, etc.), `#` preprocessor directives as Meta

**elixir.dart**: `#` comments, Elixir keywords (def, defp, defmodule, do, end, if, else, cond, case, when, fn, use, import, require, alias, with, for, raise, rescue, try, catch, after, defstruct, defprotocol, defimpl), `:atom` as Atom, `@attr` as Annotation, `~r//` sigils as Regexp

- [ ] **Step 4: Add all exports**

```dart
export 'src/grammars/javascript.dart' show javascriptLanguageSupport;
export 'src/grammars/python.dart' show pythonLanguageSupport;
export 'src/grammars/html.dart' show htmlLanguageSupport;
export 'src/grammars/css.dart' show cssLanguageSupport;
export 'src/grammars/markdown.dart' show markdownLanguageSupport;
export 'src/grammars/rust.dart' show rustLanguageSupport;
export 'src/grammars/go.dart' show goLanguageSupport;
export 'src/grammars/yaml.dart' show yamlLanguageSupport;
export 'src/grammars/c.dart' show cLanguageSupport;
export 'src/grammars/elixir.dart' show elixirLanguageSupport;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/grammars/multi_language_test.dart -r expanded
```

- [ ] **Step 6: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add 10 language grammars via StreamLanguage"
```

---

## Task 4: Bracket matching

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/commands/bracket_matching.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/bracket_matching_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Finds matching bracket pairs in the document text. Used for highlight rendering and cursor navigation.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/bracket_matching_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('BracketMatching', () {
    test('finds matching closing bracket', () {
      final doc = Document.fromString('foo(bar)');
      final match = BracketMatching.findMatch(doc, 3); // at '('
      expect(match, 7); // ')'
    });

    test('finds matching opening bracket', () {
      final doc = Document.fromString('foo(bar)');
      final match = BracketMatching.findMatch(doc, 7); // at ')'
      expect(match, 3); // '('
    });

    test('handles nested brackets', () {
      final doc = Document.fromString('a(b(c))');
      expect(BracketMatching.findMatch(doc, 1), 6); // outer (→)
      expect(BracketMatching.findMatch(doc, 3), 5); // inner (→)
    });

    test('handles curly braces', () {
      final doc = Document.fromString('if {x}');
      expect(BracketMatching.findMatch(doc, 3), 5);
      expect(BracketMatching.findMatch(doc, 5), 3);
    });

    test('handles square brackets', () {
      final doc = Document.fromString('a[b[c]]');
      expect(BracketMatching.findMatch(doc, 1), 6);
    });

    test('returns null for non-bracket character', () {
      final doc = Document.fromString('hello');
      expect(BracketMatching.findMatch(doc, 2), null);
    });

    test('returns null for unmatched bracket', () {
      final doc = Document.fromString('a(b');
      expect(BracketMatching.findMatch(doc, 1), null);
    });

    test('works across multiple lines', () {
      final doc = Document.fromString('{\n  x\n}');
      expect(BracketMatching.findMatch(doc, 0), 6);
      expect(BracketMatching.findMatch(doc, 6), 0);
    });

    test('matchForState returns pair at cursor position', () {
      final state = EditorState.create(
        docString: 'foo(bar)',
        selection: EditorSelection.cursor(3),
      );
      final pair = BracketMatching.matchForState(state);
      expect(pair, isNotNull);
      expect(pair!.open, 3);
      expect(pair.close, 7);
    });

    test('matchForState returns null when not at bracket', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(2),
      );
      expect(BracketMatching.matchForState(state), null);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/bracket_matching_test.dart
```

- [ ] **Step 3: Implement BracketMatching**

Create `packages/duskmoon_code_engine/lib/src/commands/bracket_matching.dart`:

```dart
import '../document/document.dart';
import '../state/editor_state.dart';

/// A matched bracket pair.
class BracketPair {
  const BracketPair(this.open, this.close);
  final int open;
  final int close;
}

/// Bracket matching utilities.
abstract final class BracketMatching {
  static const _pairs = <int, int>{
    0x28: 0x29, // ( → )
    0x5B: 0x5D, // [ → ]
    0x7B: 0x7D, // { → }
  };

  static const _closers = <int, int>{
    0x29: 0x28, // ) → (
    0x5D: 0x5B, // ] → [
    0x7D: 0x7B, // } → {
  };

  /// Find the matching bracket for the character at [pos].
  /// Returns the position of the matching bracket, or null.
  static int? findMatch(Document doc, int pos) {
    if (pos < 0 || pos >= doc.length) return null;
    final text = doc.toString();
    final ch = text.codeUnitAt(pos);

    // Opening bracket → scan forward
    if (_pairs.containsKey(ch)) {
      final closer = _pairs[ch]!;
      var depth = 1;
      for (var i = pos + 1; i < text.length; i++) {
        final c = text.codeUnitAt(i);
        if (c == ch) {
          depth++;
        } else if (c == closer) {
          depth--;
          if (depth == 0) return i;
        }
      }
      return null;
    }

    // Closing bracket → scan backward
    if (_closers.containsKey(ch)) {
      final opener = _closers[ch]!;
      var depth = 1;
      for (var i = pos - 1; i >= 0; i--) {
        final c = text.codeUnitAt(i);
        if (c == ch) {
          depth++;
        } else if (c == opener) {
          depth--;
          if (depth == 0) return i;
        }
      }
      return null;
    }

    return null;
  }

  /// Find bracket match at the cursor position in an EditorState.
  static BracketPair? matchForState(EditorState state) {
    final head = state.selection.main.head;
    final doc = state.doc;

    // Check character at cursor
    if (head < doc.length) {
      final match = findMatch(doc, head);
      if (match != null) {
        final text = doc.toString();
        final ch = text.codeUnitAt(head);
        if (_pairs.containsKey(ch)) {
          return BracketPair(head, match);
        } else {
          return BracketPair(match, head);
        }
      }
    }

    // Check character before cursor
    if (head > 0) {
      final match = findMatch(doc, head - 1);
      if (match != null) {
        final text = doc.toString();
        final ch = text.codeUnitAt(head - 1);
        if (_pairs.containsKey(ch)) {
          return BracketPair(head - 1, match);
        } else {
          return BracketPair(match, head - 1);
        }
      }
    }

    return null;
  }
}
```

- [ ] **Step 4: Add export**

```dart
export 'src/commands/bracket_matching.dart' show BracketPair, BracketMatching;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/bracket_matching_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add bracket matching"
```

---

## Task 5: Comment toggling

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/commands/comment.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/comment_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/src/commands/commands.dart` (add toggleComment)
- Modify: `packages/duskmoon_code_engine/lib/src/commands/default_keymap.dart` (add Ctrl-/ binding)
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Toggle line comments using the language's comment token. Reads `LanguageData.commentTokens.line` from the Language attached to the state.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/comment_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('CommentCommands', () {
    test('toggleLineComment adds comment to uncommented line', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(5),
        extensions: [dartLanguageSupport().extension],
      );
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final newState = state.applyTransaction(state.update(spec!));
      expect(newState.doc.toString(), '// hello world');
    });

    test('toggleLineComment removes comment from commented line', () {
      final state = EditorState.create(
        docString: '// hello world',
        selection: EditorSelection.cursor(5),
        extensions: [dartLanguageSupport().extension],
      );
      final spec = CommentCommands.toggleLineComment(state, '//');
      expect(spec, isNotNull);
      final newState = state.applyTransaction(state.update(spec!));
      expect(newState.doc.toString(), 'hello world');
    });

    test('toggleLineComment handles "// " prefix (with space)', () {
      final state = EditorState.create(
        docString: '// hello',
        selection: EditorSelection.cursor(3),
      );
      final spec = CommentCommands.toggleLineComment(state, '//');
      final newState = state.applyTransaction(state.update(spec!));
      expect(newState.doc.toString(), 'hello');
    });

    test('toggleLineComment on empty line adds comment', () {
      final state = EditorState.create(
        docString: '',
        selection: EditorSelection.cursor(0),
      );
      final spec = CommentCommands.toggleLineComment(state, '//');
      final newState = state.applyTransaction(state.update(spec!));
      expect(newState.doc.toString(), '// ');
    });

    test('toggleLineComment with # prefix (Python style)', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(0),
      );
      final spec = CommentCommands.toggleLineComment(state, '#');
      final newState = state.applyTransaction(state.update(spec!));
      expect(newState.doc.toString(), '# hello');
    });

    test('returns null when no comment token provided', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(0),
      );
      expect(CommentCommands.toggleLineComment(state, null), null);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/comment_test.dart
```

- [ ] **Step 3: Implement CommentCommands**

Create `packages/duskmoon_code_engine/lib/src/commands/comment.dart`:

```dart
import '../document/change.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';

/// Comment toggling commands.
abstract final class CommentCommands {
  /// Toggle line comment on the line containing the cursor.
  ///
  /// [lineCommentToken] is the comment prefix (e.g., "//", "#").
  /// If null, returns null (no comment defined).
  static TransactionSpec? toggleLineComment(
    EditorState state,
    String? lineCommentToken,
  ) {
    if (lineCommentToken == null) return null;

    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    final lineText = line.text;
    final prefix = lineCommentToken;
    final prefixWithSpace = '$prefix ';

    // Check if line is already commented
    final trimmed = lineText.trimLeft();
    final leadingSpaces = lineText.length - trimmed.length;

    if (trimmed.startsWith(prefixWithSpace)) {
      // Remove "// " prefix
      final removeFrom = line.from + leadingSpaces;
      final removeTo = removeFrom + prefixWithSpace.length;
      return TransactionSpec(
        changes: ChangeSet.of(
          state.doc.length,
          [ChangeSpec(from: removeFrom, to: removeTo)],
        ),
        selection: EditorSelection.cursor(
          (head - prefixWithSpace.length).clamp(line.from, line.from + lineText.length - prefixWithSpace.length),
        ),
      );
    } else if (trimmed.startsWith(prefix)) {
      // Remove "//" prefix (no space)
      final removeFrom = line.from + leadingSpaces;
      final removeTo = removeFrom + prefix.length;
      return TransactionSpec(
        changes: ChangeSet.of(
          state.doc.length,
          [ChangeSpec(from: removeFrom, to: removeTo)],
        ),
        selection: EditorSelection.cursor(
          (head - prefix.length).clamp(line.from, state.doc.length - prefix.length),
        ),
      );
    } else {
      // Add "// " prefix at line start (after leading whitespace)
      final insertAt = line.from + leadingSpaces;
      return TransactionSpec(
        changes: ChangeSet.of(
          state.doc.length,
          [ChangeSpec.insert(insertAt, prefixWithSpace)],
        ),
        selection: EditorSelection.cursor(head + prefixWithSpace.length),
      );
    }
  }
}
```

- [ ] **Step 4: Add export and keymap binding**

Add to barrel:
```dart
export 'src/commands/comment.dart' show CommentCommands;
```

Add to `default_keymap.dart` — a Ctrl-/ binding that reads the comment token from the language. This requires knowing the language at keymap time. Since the keymap Command receives `dynamic view` (EditorView), we can read the syntax tree to find the language:

Add to `defaultKeymap()` in `default_keymap.dart`:
```dart
// Comment toggling
KeyBinding(key: 'Ctrl-/', run: (dynamic view) {
  final ev = view as EditorView;
  // Try to find comment token from language data
  // For now, default to '//' — proper language detection comes later
  final spec = CommentCommands.toggleLineComment(ev.state, '//');
  if (spec == null) return false;
  ev.dispatch(spec);
  return true;
}),
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/comment_test.dart -r expanded
```

- [ ] **Step 6: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add comment toggling with Ctrl-/ binding"
```

---

## Task 6: Code folding (indent-based)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/commands/folding.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/folding_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Indent-based fold detection — finds foldable regions by detecting lines where the indentation level increases. This works for any language without requiring a syntax tree.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/folding_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('FoldDetector', () {
    test('detects fold region from indent increase', () {
      final doc = Document.fromString('if true\n  a\n  b\nend');
      final regions = FoldDetector.detectRegions(doc);
      expect(regions.length, 1);
      expect(regions[0].startLine, 1); // "if true" (1-based)
      expect(regions[0].endLine, 3);   // "  b"
    });

    test('detects multiple fold regions', () {
      final doc = Document.fromString('a\n  b\n  c\nd\n  e\nf');
      final regions = FoldDetector.detectRegions(doc);
      expect(regions.length, 2);
    });

    test('detects nested fold regions', () {
      final doc = Document.fromString('a\n  b\n    c\n    d\n  e\nf');
      final regions = FoldDetector.detectRegions(doc);
      // "a" folds b-e, "b" folds c-d
      expect(regions.length, 2);
    });

    test('no fold regions for flat document', () {
      final doc = Document.fromString('a\nb\nc');
      final regions = FoldDetector.detectRegions(doc);
      expect(regions, isEmpty);
    });

    test('empty document has no fold regions', () {
      final doc = Document.fromString('');
      final regions = FoldDetector.detectRegions(doc);
      expect(regions, isEmpty);
    });

    test('single line has no fold regions', () {
      final doc = Document.fromString('hello');
      final regions = FoldDetector.detectRegions(doc);
      expect(regions, isEmpty);
    });

    test('foldRegionAt returns region starting at given line', () {
      final doc = Document.fromString('if true\n  a\n  b\nend');
      final region = FoldDetector.regionAtLine(doc, 1);
      expect(region, isNotNull);
      expect(region!.startLine, 1);
      expect(region.endLine, 3);
    });

    test('foldRegionAt returns null for non-foldable line', () {
      final doc = Document.fromString('if true\n  a\n  b\nend');
      expect(FoldDetector.regionAtLine(doc, 2), null); // "  a" can't fold
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/folding_test.dart
```

- [ ] **Step 3: Implement FoldDetector**

Create `packages/duskmoon_code_engine/lib/src/commands/folding.dart`:

```dart
import '../document/document.dart';

/// A foldable region in the document.
class FoldRegion {
  const FoldRegion(this.startLine, this.endLine);

  /// The line that starts the fold (1-based).
  final int startLine;

  /// The last line included in the fold (1-based).
  final int endLine;
}

/// Detects foldable regions using indentation.
abstract final class FoldDetector {
  /// Detect all foldable regions in the document.
  static List<FoldRegion> detectRegions(Document doc) {
    if (doc.lineCount <= 1) return [];

    final indents = <int>[];
    for (var i = 1; i <= doc.lineCount; i++) {
      final line = doc.lineAt(i);
      indents.add(_indentLevel(line.text));
    }

    final regions = <FoldRegion>[];

    for (var i = 0; i < indents.length - 1; i++) {
      final currentIndent = indents[i];
      final nextIndent = indents[i + 1];

      // A fold starts when the next line has higher indentation
      if (nextIndent > currentIndent) {
        // Find where the fold ends: last consecutive line with
        // indentation > currentIndent
        var endIdx = i + 1;
        for (var j = i + 2; j < indents.length; j++) {
          if (indents[j] > currentIndent) {
            endIdx = j;
          } else {
            break;
          }
        }
        regions.add(FoldRegion(i + 1, endIdx + 1)); // 1-based
      }
    }

    return regions;
  }

  /// Find the fold region starting at [lineNumber] (1-based).
  static FoldRegion? regionAtLine(Document doc, int lineNumber) {
    final regions = detectRegions(doc);
    for (final r in regions) {
      if (r.startLine == lineNumber) return r;
    }
    return null;
  }

  static int _indentLevel(String text) {
    var level = 0;
    for (var i = 0; i < text.length; i++) {
      if (text.codeUnitAt(i) == 0x20) {
        level++;
      } else if (text.codeUnitAt(i) == 0x09) {
        level += 2;
      } else {
        break;
      }
    }
    return level;
  }
}
```

- [ ] **Step 4: Add export**

```dart
export 'src/commands/folding.dart' show FoldRegion, FoldDetector;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/folding_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add indent-based code fold detection"
```

---

## Task 7: Final verification and barrel cleanup

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

- [ ] **Step 1: Run full test suite**

```bash
cd packages/duskmoon_code_engine && flutter test -r expanded
```

- [ ] **Step 2: Run workspace analyzer**

```bash
melos run analyze
```

- [ ] **Step 3: Commit if needed**

```bash
git add packages/duskmoon_code_engine/
git commit -m "chore(duskmoon_code_engine): finalize Phase 4a barrel exports"
```

---

## Summary

Phase 4a delivers **7 tasks** producing:

| Component | Files | Tests |
|-----------|-------|-------|
| StreamLanguage | stream_language.dart | stream_language_test.dart |
| Dart grammar | dart.dart | dart_test.dart |
| 10 language grammars | js, py, html, css, md, rust, go, yaml, c, elixir | multi_language_test.dart |
| Bracket matching | bracket_matching.dart | bracket_matching_test.dart |
| Comment toggling | comment.dart | comment_test.dart |
| Code folding | folding.dart | folding_test.dart |

**Deliverable:** 12 languages with syntax highlighting (JSON + Dart + JS + Python + HTML + CSS + Markdown + Rust + Go + YAML + C + Elixir), bracket matching, comment toggling (Ctrl-/), and indent-based fold region detection.

**Deferred to Phase 4b:**
- Full table-driven LR parser port (~4K lines of Dart)
- Grammar codegen pipeline (Bun/Node → JSON → Dart)
- Real Lezer grammar tables for all languages
- Mixed-language parsing (HTML+CSS+JS, PHP+HTML, Markdown+fenced)
- Syntax-tree-based folding (vs indent-based)
- Remaining P2 grammars (Java, Kotlin, PHP, Ruby, Erlang, Swift, Zig)
