# duskmoon_code_engine Phase 4b — Remaining Grammars & Codegen Pipeline Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Complete the language inventory with 7 remaining P2 grammars (Java, Kotlin, PHP, Ruby, Erlang, Swift, Zig) and build the grammar codegen pipeline for compiling Lezer `.grammar` files to Dart const data.

**Architecture:** The 7 grammars use the same StreamLanguage pattern from Phase 4a — each is a regex-based tokenizer registered with LanguageRegistry. The codegen pipeline has two parts: (1) a Bun/Node script that runs `@lezer/generator` to compile `.grammar` files to JSON intermediate format, and (2) a Dart script (`grammar_to_dart.dart`) that converts the JSON to Dart `const` lists for `LRParser.deserialize()`. Generated `.dart` files are committed to the repo — CI does not run codegen.

**Tech Stack:** Dart 3.5+, Bun/Node (for grammar compilation only), `@lezer/generator` (npm)

**Spec:** `docs/code-engine.md` sections 5.2-5.3, 6.3

**Depends on:** Phase 4a (complete) — StreamLanguage, LanguageRegistry, existing 12 grammars

---

## File Structure

```
packages/duskmoon_code_engine/
├── lib/src/grammars/
│   ├── java.dart                   # CREATE — Java grammar
│   ├── kotlin.dart                 # CREATE — Kotlin grammar
│   ├── php.dart                    # CREATE — PHP grammar
│   ├── ruby.dart                   # CREATE — Ruby grammar
│   ├── erlang.dart                 # CREATE — Erlang grammar
│   ├── swift.dart                  # CREATE — Swift grammar
│   └── zig.dart                    # CREATE — Zig grammar
│
├── tool/
│   ├── compile_grammar.mjs         # CREATE — Bun/Node: .grammar → JSON
│   ├── grammar_to_dart.dart        # CREATE — Dart: JSON → Dart const data
│   └── package.json               # CREATE — npm deps for @lezer/generator
│
├── grammars/                       # CREATE — upstream .grammar source files
│   └── .gitkeep                    # Placeholder for future .grammar files
│
└── test/src/grammars/
    └── remaining_grammars_test.dart # CREATE
```

---

## Task 1: Java, Kotlin, PHP grammars

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/grammars/java.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/kotlin.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/php.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Each follows the identical StreamLanguage pattern from Phase 4a.

- [ ] **Step 1: Implement java.dart**

Create `packages/duskmoon_code_engine/lib/src/grammars/java.dart`:

```dart
import '../language/language_data.dart';
import '../language/stream_language.dart';

LanguageSupport? _cached;

LanguageSupport javaLanguageSupport() {
  return _cached ??= _javaStream.languageSupport(
    extensions: ['java'],
    mimeTypes: ['text/x-java'],
  );
}

final _javaStream = StreamLanguage(
  name: 'java',
  rules: [
    TokenRule(RegExp(r'//.*'), 'Comment'),
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)'"), 'String'),
    TokenRule(RegExp(r'0x[0-9a-fA-F]+[lL]?'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?[fFdDlL]?\b'), 'Number'),
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    TokenRule(
      RegExp(r'\b(abstract|assert|boolean|break|byte|case|catch|char|class|'
          r'const|continue|default|do|double|else|enum|extends|false|final|'
          r'finally|float|for|goto|if|implements|import|instanceof|int|'
          r'interface|long|native|new|null|package|private|protected|public|'
          r'return|short|static|strictfp|super|switch|synchronized|this|'
          r'throw|throws|transient|true|try|var|void|volatile|while|'
          r'yield|record|sealed|permits|non-sealed)\b'),
      'Keyword',
    ),
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    TokenRule(RegExp(r'[a-zA-Z_$]\w*'), 'Identifier'),
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!?:]+'), 'Operator'),
    TokenRule(RegExp(r'[{}()\[\];,.]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//', block: (open: '/*', close: '*/')),
  ),
);
```

- [ ] **Step 2: Implement kotlin.dart**

Create `packages/duskmoon_code_engine/lib/src/grammars/kotlin.dart`:

```dart
import '../language/language_data.dart';
import '../language/stream_language.dart';

LanguageSupport? _cached;

LanguageSupport kotlinLanguageSupport() {
  return _cached ??= _kotlinStream.languageSupport(
    extensions: ['kt', 'kts'],
    mimeTypes: ['text/x-kotlin'],
  );
}

final _kotlinStream = StreamLanguage(
  name: 'kotlin',
  rules: [
    TokenRule(RegExp(r'//.*'), 'Comment'),
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    TokenRule(RegExp(r'"""[\s\S]*?"""'), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)'"), 'String'),
    TokenRule(RegExp(r'0x[0-9a-fA-F]+[uUlL]*'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?[fFuUlL]*\b'), 'Number'),
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    TokenRule(
      RegExp(r'\b(abstract|actual|annotation|as|break|by|catch|class|'
          r'companion|const|constructor|continue|crossinline|data|do|'
          r'else|enum|expect|external|false|final|finally|for|fun|get|'
          r'if|import|in|infix|init|inline|inner|interface|internal|is|'
          r'it|lateinit|noinline|null|object|open|operator|out|override|'
          r'package|private|protected|public|reified|return|sealed|set|'
          r'super|suspend|tailrec|this|throw|true|try|typealias|typeof|'
          r'val|var|vararg|when|where|while|yield)\b'),
      'Keyword',
    ),
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
    TokenRule(RegExp(r'->|[+\-*/%&|^~<>=!?:]+'), 'Operator'),
    TokenRule(RegExp(r'[{}()\[\];,.]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//', block: (open: '/*', close: '*/')),
  ),
);
```

- [ ] **Step 3: Implement php.dart**

Create `packages/duskmoon_code_engine/lib/src/grammars/php.dart`:

```dart
import '../language/language_data.dart';
import '../language/stream_language.dart';

LanguageSupport? _cached;

LanguageSupport phpLanguageSupport() {
  return _cached ??= _phpStream.languageSupport(
    extensions: ['php', 'phtml'],
    mimeTypes: ['application/x-httpd-php', 'text/x-php'],
  );
}

final _phpStream = StreamLanguage(
  name: 'php',
  rules: [
    TokenRule(RegExp(r'//.*'), 'Comment'),
    TokenRule(RegExp(r'#.*'), 'Comment'),
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r'\$[a-zA-Z_]\w*'), 'Identifier'),
    TokenRule(RegExp(r'0x[0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    TokenRule(
      RegExp(r'\b(abstract|and|array|as|break|callable|case|catch|class|'
          r'clone|const|continue|declare|default|die|do|echo|else|elseif|'
          r'empty|enddeclare|endfor|endforeach|endif|endswitch|endwhile|'
          r'eval|exit|extends|false|final|finally|fn|for|foreach|function|'
          r'global|goto|if|implements|include|include_once|instanceof|'
          r'insteadof|interface|isset|list|match|namespace|new|null|or|'
          r'print|private|protected|public|readonly|require|require_once|'
          r'return|static|switch|throw|trait|true|try|unset|use|var|'
          r'void|while|xor|yield)\b'),
      'Keyword',
    ),
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
    TokenRule(RegExp(r'=>|->|[+\-*/%&|^~<>=!?.:]+'), 'Operator'),
    TokenRule(RegExp(r'[{}()\[\];,]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//', block: (open: '/*', close: '*/')),
  ),
);
```

- [ ] **Step 4: Add exports**

Add to barrel:
```dart
export 'src/grammars/java.dart' show javaLanguageSupport;
export 'src/grammars/kotlin.dart' show kotlinLanguageSupport;
export 'src/grammars/php.dart' show phpLanguageSupport;
```

- [ ] **Step 5: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Java, Kotlin, PHP grammars"
```

---

## Task 2: Ruby, Erlang, Swift, Zig grammars

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/grammars/ruby.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/erlang.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/swift.dart`
- Create: `packages/duskmoon_code_engine/lib/src/grammars/zig.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

- [ ] **Step 1: Implement ruby.dart**

Create `packages/duskmoon_code_engine/lib/src/grammars/ruby.dart`:

```dart
import '../language/language_data.dart';
import '../language/stream_language.dart';

LanguageSupport? _cached;

LanguageSupport rubyLanguageSupport() {
  return _cached ??= _rubyStream.languageSupport(
    extensions: ['rb', 'rake', 'gemspec'],
    mimeTypes: ['text/x-ruby', 'application/x-ruby'],
  );
}

final _rubyStream = StreamLanguage(
  name: 'ruby',
  rules: [
    TokenRule(RegExp(r'#.*'), 'Comment'),
    TokenRule(RegExp(r'=begin[\s\S]*?=end'), 'Comment'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r':[a-zA-Z_]\w*'), 'Atom'),
    TokenRule(RegExp(r'@{1,2}[a-zA-Z_]\w*'), 'Identifier'),
    TokenRule(RegExp(r'0x[0-9a-fA-F]+'), 'Number'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    TokenRule(
      RegExp(r'\b(alias|and|begin|break|case|class|def|defined\?|do|else|'
          r'elsif|end|ensure|false|for|if|in|module|next|nil|not|or|redo|'
          r'rescue|retry|return|self|super|then|true|undef|unless|until|'
          r'when|while|yield|require|include|extend|attr_reader|'
          r'attr_writer|attr_accessor|private|protected|public|raise|'
          r'lambda|proc|block_given\?)\b'),
      'Keyword',
    ),
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    TokenRule(RegExp(r'[a-zA-Z_]\w*[?!]?'), 'Identifier'),
    TokenRule(RegExp(r'=>|->|[+\-*/%&|^~<>=!]+'), 'Operator'),
    TokenRule(RegExp(r'[{}()\[\];,.]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '#'),
  ),
);
```

- [ ] **Step 2: Implement erlang.dart**

Create `packages/duskmoon_code_engine/lib/src/grammars/erlang.dart`:

```dart
import '../language/language_data.dart';
import '../language/stream_language.dart';

LanguageSupport? _cached;

LanguageSupport erlangLanguageSupport() {
  return _cached ??= _erlangStream.languageSupport(
    extensions: ['erl', 'hrl'],
    mimeTypes: ['text/x-erlang'],
  );
}

final _erlangStream = StreamLanguage(
  name: 'erlang',
  rules: [
    TokenRule(RegExp(r'%.*'), 'Comment'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r'\b[a-z][a-zA-Z0-9_]*(?=\s*\()'), 'Identifier'),
    TokenRule(RegExp(r'\b[a-z][a-zA-Z0-9_@]*\b'), 'Atom'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)*'"), 'Atom'),
    TokenRule(RegExp(r'\b[A-Z_][a-zA-Z0-9_]*\b'), 'Identifier'),
    TokenRule(RegExp(r'\b\d+\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    TokenRule(RegExp(r'\$[^\s]'), 'Number'),
    TokenRule(
      RegExp(r'\b(after|and|andalso|band|begin|bnot|bor|bsl|bsr|bxor|'
          r'case|catch|cond|div|end|fun|if|let|not|of|or|orelse|receive|'
          r'rem|try|when|xor)\b'),
      'Keyword',
    ),
    TokenRule(RegExp(r'-(?:module|export|import|compile|record|define|include|'
        r'ifdef|ifndef|else|endif|type|spec|callback|behaviour|behavior)'
        r'\b'), 'Meta'),
    TokenRule(RegExp(r'->|[+\-*/<>=!|:;]+'), 'Operator'),
    TokenRule(RegExp(r'[{}()\[\],.]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '%'),
  ),
);
```

- [ ] **Step 3: Implement swift.dart**

Create `packages/duskmoon_code_engine/lib/src/grammars/swift.dart`:

```dart
import '../language/language_data.dart';
import '../language/stream_language.dart';

LanguageSupport? _cached;

LanguageSupport swiftLanguageSupport() {
  return _cached ??= _swiftStream.languageSupport(
    extensions: ['swift'],
    mimeTypes: ['text/x-swift'],
  );
}

final _swiftStream = StreamLanguage(
  name: 'swift',
  rules: [
    TokenRule(RegExp(r'//.*'), 'Comment'),
    TokenRule(RegExp(r'/\*[\s\S]*?\*/'), 'Comment'),
    TokenRule(RegExp(r'"""[\s\S]*?"""'), 'String'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r'0x[0-9a-fA-F_]+'), 'Number'),
    TokenRule(RegExp(r'0b[01_]+'), 'Number'),
    TokenRule(RegExp(r'0o[0-7_]+'), 'Number'),
    TokenRule(RegExp(r'\b\d[\d_]*\.?[\d_]*([eE][+-]?[\d_]+)?\b'), 'Number'),
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    TokenRule(RegExp(r'#[a-zA-Z_]\w*'), 'Meta'),
    TokenRule(
      RegExp(r'\b(actor|any|as|associatedtype|async|await|break|case|catch|'
          r'class|continue|convenience|deinit|default|defer|do|dynamic|else|'
          r'enum|extension|fallthrough|false|fileprivate|final|for|func|get|'
          r'guard|if|import|in|indirect|infix|init|inout|internal|is|lazy|'
          r'let|mutating|nil|nonmutating|open|operator|optional|override|'
          r'postfix|precedencegroup|prefix|private|protocol|public|repeat|'
          r'required|rethrows|return|self|Self|set|some|static|struct|'
          r'subscript|super|switch|throw|throws|true|try|typealias|unowned|'
          r'var|weak|where|while|willSet|didSet)\b'),
      'Keyword',
    ),
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
    TokenRule(RegExp(r'->|[+\-*/%&|^~<>=!?]+'), 'Operator'),
    TokenRule(RegExp(r'[{}()\[\];,.:@#]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//', block: (open: '/*', close: '*/')),
  ),
);
```

- [ ] **Step 4: Implement zig.dart**

Create `packages/duskmoon_code_engine/lib/src/grammars/zig.dart`:

```dart
import '../language/language_data.dart';
import '../language/stream_language.dart';

LanguageSupport? _cached;

LanguageSupport zigLanguageSupport() {
  return _cached ??= _zigStream.languageSupport(
    extensions: ['zig'],
    mimeTypes: ['text/x-zig'],
  );
}

final _zigStream = StreamLanguage(
  name: 'zig',
  rules: [
    TokenRule(RegExp(r'//.*'), 'Comment'),
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    TokenRule(RegExp(r"'(?:[^'\\]|\\.)'"), 'String'),
    TokenRule(RegExp(r'0x[0-9a-fA-F_]+'), 'Number'),
    TokenRule(RegExp(r'0b[01_]+'), 'Number'),
    TokenRule(RegExp(r'0o[0-7_]+'), 'Number'),
    TokenRule(RegExp(r'\b\d[\d_]*\.?[\d_]*([eE][+-]?[\d_]+)?\b'), 'Number'),
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    TokenRule(
      RegExp(r'\b(addrspace|align|allowzero|and|anyframe|anytype|asm|async|'
          r'await|break|callconv|catch|comptime|const|continue|defer|else|'
          r'enum|errdefer|error|export|extern|false|fn|for|if|inline|'
          r'linksection|noalias|nosuspend|null|opaque|or|orelse|packed|'
          r'pub|resume|return|struct|suspend|switch|test|threadlocal|'
          r'true|try|undefined|union|unreachable|var|volatile|while)\b'),
      'Keyword',
    ),
    TokenRule(RegExp(r'\b(bool|f16|f32|f64|f80|f128|i8|i16|i32|i64|i128|'
        r'u8|u16|u32|u64|u128|usize|isize|void|type|anyerror|'
        r'comptime_int|comptime_float|noreturn)\b'), 'TypeName'),
    TokenRule(RegExp(r'[a-zA-Z_]\w*'), 'Identifier'),
    TokenRule(RegExp(r'=>|[+\-*/%&|^~<>=!]+'), 'Operator'),
    TokenRule(RegExp(r'[{}()\[\];,.]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '//'),
  ),
);
```

- [ ] **Step 5: Add exports**

```dart
export 'src/grammars/ruby.dart' show rubyLanguageSupport;
export 'src/grammars/erlang.dart' show erlangLanguageSupport;
export 'src/grammars/swift.dart' show swiftLanguageSupport;
export 'src/grammars/zig.dart' show zigLanguageSupport;
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Ruby, Erlang, Swift, Zig grammars"
```

---

## Task 3: Test all 19 grammars

**Files:**
- Create: `packages/duskmoon_code_engine/test/src/grammars/remaining_grammars_test.dart`

- [ ] **Step 1: Write tests**

Create `packages/duskmoon_code_engine/test/src/grammars/remaining_grammars_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  setUp(() => LanguageRegistry.clear());

  final grammars = <String, LanguageSupport Function()>{
    'java': javaLanguageSupport,
    'kotlin': kotlinLanguageSupport,
    'php': phpLanguageSupport,
    'ruby': rubyLanguageSupport,
    'erlang': erlangLanguageSupport,
    'swift': swiftLanguageSupport,
    'zig': zigLanguageSupport,
  };

  const sampleCode = <String, String>{
    'java': 'public class Main { public static void main(String[] args) { int x = 42; } } // comment',
    'kotlin': 'fun main() { val x: Int = 42; println("hello") } // comment',
    'php': '<?php function hello() { \$x = 42; return "world"; } // comment',
    'ruby': 'def hello\n  x = 42\n  "world"\nend  # comment',
    'erlang': '-module(hello).\nhello() -> 42.  % comment',
    'swift': 'func main() { let x: Int = 42; print("hello") } // comment',
    'zig': 'pub fn main() void { const x: u32 = 42; } // comment',
  };

  for (final entry in grammars.entries) {
    group(entry.key, () {
      test('registers by name', () {
        entry.value();
        expect(LanguageRegistry.byName(entry.key), isNotNull);
      });

      test('parses sample code with tokens', () {
        final support = entry.value();
        final state = EditorState.create(
          docString: sampleCode[entry.key]!,
          extensions: [support.extension],
        );
        final tree = syntaxTree(state);
        expect(tree, isNotNull);
        expect(tree!.type.isTop, true);
        expect(tree.children, isNotEmpty);
      });

      test('has comment tokens defined', () {
        final support = entry.value();
        final ct = support.language.data.commentTokens;
        expect(ct?.line != null || ct?.block != null, true,
            reason: '${entry.key} needs comment tokens');
      });

      test('cursor traversal finds tokens', () {
        final support = entry.value();
        final state = EditorState.create(
          docString: sampleCode[entry.key]!,
          extensions: [support.extension],
        );
        final tree = syntaxTree(state)!;
        final cursor = tree.cursor();
        final names = <String>{};
        if (cursor.firstChild()) {
          names.add(cursor.name);
          while (cursor.nextSibling()) names.add(cursor.name);
        }
        expect(names, isNotEmpty,
            reason: '${entry.key} should produce named tokens');
      });
    });
  }

  group('Full language inventory', () {
    test('all 19 languages register successfully', () {
      LanguageRegistry.clear();
      // Register all
      jsonLanguageSupport();
      dartLanguageSupport();
      javascriptLanguageSupport();
      pythonLanguageSupport();
      htmlLanguageSupport();
      cssLanguageSupport();
      markdownLanguageSupport();
      rustLanguageSupport();
      goLanguageSupport();
      yamlLanguageSupport();
      cLanguageSupport();
      elixirLanguageSupport();
      javaLanguageSupport();
      kotlinLanguageSupport();
      phpLanguageSupport();
      rubyLanguageSupport();
      erlangLanguageSupport();
      swiftLanguageSupport();
      zigLanguageSupport();

      expect(LanguageRegistry.names.length, 19);
    });

    test('each language has unique extensions', () {
      LanguageRegistry.clear();
      jsonLanguageSupport();
      dartLanguageSupport();
      javascriptLanguageSupport();
      pythonLanguageSupport();
      htmlLanguageSupport();
      cssLanguageSupport();
      markdownLanguageSupport();
      rustLanguageSupport();
      goLanguageSupport();
      yamlLanguageSupport();
      cLanguageSupport();
      elixirLanguageSupport();
      javaLanguageSupport();
      kotlinLanguageSupport();
      phpLanguageSupport();
      rubyLanguageSupport();
      erlangLanguageSupport();
      swiftLanguageSupport();
      zigLanguageSupport();

      // Spot-check some extensions
      expect(LanguageRegistry.byExtension('java'), isNotNull);
      expect(LanguageRegistry.byExtension('kt'), isNotNull);
      expect(LanguageRegistry.byExtension('php'), isNotNull);
      expect(LanguageRegistry.byExtension('rb'), isNotNull);
      expect(LanguageRegistry.byExtension('erl'), isNotNull);
      expect(LanguageRegistry.byExtension('swift'), isNotNull);
      expect(LanguageRegistry.byExtension('zig'), isNotNull);
    });
  });
}
```

- [ ] **Step 2: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/grammars/remaining_grammars_test.dart -r expanded
```

- [ ] **Step 3: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "test(duskmoon_code_engine): add tests for all 19 language grammars"
```

---

## Task 4: Grammar codegen pipeline (tool/)

**Files:**
- Create: `packages/duskmoon_code_engine/tool/package.json`
- Create: `packages/duskmoon_code_engine/tool/compile_grammar.mjs`
- Create: `packages/duskmoon_code_engine/tool/grammar_to_dart.dart`
- Create: `packages/duskmoon_code_engine/grammars/.gitkeep`
- Modify: `packages/duskmoon_code_engine/pubspec.yaml` (add melos script reference in root)

The codegen pipeline compiles Lezer `.grammar` files to Dart const data for `LRParser.deserialize()`. This is a build-time tool — not used at runtime.

- [ ] **Step 1: Create tool/package.json**

Create `packages/duskmoon_code_engine/tool/package.json`:

```json
{
  "name": "duskmoon-grammar-codegen",
  "private": true,
  "type": "module",
  "scripts": {
    "compile": "node compile_grammar.mjs"
  },
  "dependencies": {
    "@lezer/generator": "^1.7.0",
    "@lezer/common": "^1.2.0",
    "@lezer/lr": "^1.4.0"
  }
}
```

- [ ] **Step 2: Create tool/compile_grammar.mjs**

Create `packages/duskmoon_code_engine/tool/compile_grammar.mjs`:

```javascript
#!/usr/bin/env node
/**
 * Compiles a Lezer .grammar file to a JSON intermediate format.
 *
 * Usage:
 *   node compile_grammar.mjs <input.grammar> [output.json]
 *
 * The JSON output contains:
 *   - nodeNames: string[]
 *   - states: number[]
 *   - stateData: number[]
 *   - goto: number[]
 *   - nodeProps: Record<number, Record<string, any>>
 *   - tokenData: number[]
 *   - topRuleIndex: number
 *   - skippedNodes: number[]
 *   - tokenPrec: number
 *
 * This JSON is then fed to grammar_to_dart.dart to produce Dart source.
 */

import { buildParser } from "@lezer/generator";
import { readFileSync, writeFileSync } from "fs";
import { basename } from "path";

const args = process.argv.slice(2);
if (args.length < 1) {
  console.error("Usage: node compile_grammar.mjs <input.grammar> [output.json]");
  process.exit(1);
}

const inputFile = args[0];
const outputFile = args[1] || inputFile.replace(/\.grammar$/, ".json");

const grammarSource = readFileSync(inputFile, "utf-8");

try {
  const parser = buildParser(grammarSource);

  // Extract the serialized data from the parser
  // The parser object has internal fields we need to extract
  const serialized = {
    nodeNames: parser.nodeSet.types.map((t) => t.name),
    states: Array.from(parser.states),
    stateData: Array.from(parser.stateData),
    goto: Array.from(parser.goto),
    tokenData: Array.from(parser.tokenData),
    topRuleIndex: parser.topNode
      ? parser.nodeSet.types.findIndex((t) => t.name === parser.topNode.name)
      : 0,
    skippedNodes: parser.nodeSet.types
      .filter((t) => t.is("SkippedNode") || t.name === "⚠")
      .map((t) => t.id),
    tokenPrec: parser.tokenPrec || 0,
    nodeProps: {},
  };

  // Extract node properties
  for (let i = 0; i < parser.nodeSet.types.length; i++) {
    const type = parser.nodeSet.types[i];
    const props = {};
    if (type.isTop) props.top = true;
    if (type.isError) props.error = true;
    if (type.isSkipped) props.skipped = true;
    if (Object.keys(props).length > 0) {
      serialized.nodeProps[i] = props;
    }
  }

  writeFileSync(outputFile, JSON.stringify(serialized, null, 2));
  console.log(`Compiled ${basename(inputFile)} → ${basename(outputFile)}`);
  console.log(`  ${serialized.nodeNames.length} node types`);
  console.log(`  ${serialized.states.length} state entries`);
} catch (err) {
  console.error(`Error compiling ${inputFile}:`, err.message);
  process.exit(1);
}
```

- [ ] **Step 3: Create tool/grammar_to_dart.dart**

Create `packages/duskmoon_code_engine/tool/grammar_to_dart.dart`:

```dart
#!/usr/bin/env dart
/// Converts a JSON grammar file (from compile_grammar.mjs) to a Dart
/// source file with const data for LRParser.deserialize().
///
/// Usage:
///   dart run tool/grammar_to_dart.dart <input.json> <language_name> [output.dart]
///
/// The generated file will contain:
///   - const lists for states, stateData, goto, tokenData
///   - node names list
///   - node props map
///   - A top-level `<lang>LRParser` getter

import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln(
      'Usage: dart run tool/grammar_to_dart.dart <input.json> <language_name> [output.dart]',
    );
    exit(1);
  }

  final inputFile = args[0];
  final langName = args[1];
  final outputFile =
      args.length > 2 ? args[2] : 'lib/src/grammars/${langName}_lr.g.dart';

  final json = jsonDecode(File(inputFile).readAsStringSync())
      as Map<String, dynamic>;

  final nodeNames = (json['nodeNames'] as List).cast<String>();
  final states = (json['states'] as List).cast<int>();
  final stateData = (json['stateData'] as List).cast<int>();
  final gotoTable = (json['goto'] as List).cast<int>();
  final tokenData = (json['tokenData'] as List).cast<int>();
  final topRuleIndex = json['topRuleIndex'] as int;
  final skippedNodes =
      (json['skippedNodes'] as List?)?.cast<int>() ?? const <int>[];
  final tokenPrec = json['tokenPrec'] as int? ?? 0;
  final nodeProps = json['nodeProps'] as Map<String, dynamic>? ?? {};

  final buf = StringBuffer();

  buf.writeln('// GENERATED FILE — do not edit by hand.');
  buf.writeln(
    '// Generated by: dart run tool/grammar_to_dart.dart',
  );
  buf.writeln('// Source: $inputFile');
  buf.writeln();
  buf.writeln(
    "import '../lezer/common/node_type.dart';",
  );
  buf.writeln("import '../lezer/lr/lr_parser.dart';");
  buf.writeln();

  // Node names
  buf.writeln('const _nodeNames = <String>[');
  for (final name in nodeNames) {
    buf.writeln("  '${_escape(name)}',");
  }
  buf.writeln('];');
  buf.writeln();

  // States
  _writeIntList(buf, '_states', states);
  _writeIntList(buf, '_stateData', stateData);
  _writeIntList(buf, '_goto', gotoTable);
  _writeIntList(buf, '_tokenData', tokenData);

  // Skipped nodes
  if (skippedNodes.isNotEmpty) {
    _writeIntList(buf, '_skippedNodes', skippedNodes);
  }

  // Node props
  if (nodeProps.isNotEmpty) {
    buf.writeln(
      'const _nodeProps = <int, Map<NodeProp<dynamic>, dynamic>>{',
    );
    for (final entry in nodeProps.entries) {
      final id = entry.key;
      final props = entry.value as Map<String, dynamic>;
      buf.write('  $id: {');
      final parts = <String>[];
      if (props['top'] == true) parts.add('NodeProp.top: true');
      if (props['error'] == true) parts.add('NodeProp.error: true');
      if (props['skipped'] == true) {
        parts.add('NodeProp.skipped: true');
      }
      buf.write(parts.join(', '));
      buf.writeln('},');
    }
    buf.writeln('};');
  } else {
    buf.writeln(
      'const _nodeProps = <int, Map<NodeProp<dynamic>, dynamic>>{};',
    );
  }
  buf.writeln();

  // Parser getter
  final camelName = _toCamelCase(langName);
  buf.writeln('/// LR parser for $langName, deserialized from compiled grammar tables.');
  buf.writeln('final ${camelName}LRParser = LRParser.deserialize(');
  buf.writeln('  nodeNames: _nodeNames,');
  buf.writeln('  states: _states,');
  buf.writeln('  stateData: _stateData,');
  buf.writeln('  gotoTable: _goto,');
  buf.writeln('  tokenData: _tokenData,');
  buf.writeln('  topRuleIndex: $topRuleIndex,');
  buf.writeln('  nodeProps: _nodeProps,');
  if (skippedNodes.isNotEmpty) {
    buf.writeln('  skippedNodes: _skippedNodes,');
  }
  if (tokenPrec != 0) {
    buf.writeln('  tokenPrec: $tokenPrec,');
  }
  buf.writeln(');');

  final output = File(outputFile);
  output.parent.createSync(recursive: true);
  output.writeAsStringSync(buf.toString());

  stdout.writeln('Generated $outputFile');
  stdout.writeln('  ${nodeNames.length} node types');
  stdout.writeln('  ${states.length} state entries');
  stdout.writeln('  ${stateData.length} state data entries');
  stdout.writeln('  ${gotoTable.length} goto entries');
  stdout.writeln('  ${tokenData.length} token data entries');
}

void _writeIntList(StringBuffer buf, String name, List<int> data) {
  buf.writeln('const $name = <int>[');
  // Write in rows of 20 for readability
  for (var i = 0; i < data.length; i += 20) {
    final end = (i + 20).clamp(0, data.length);
    buf.writeln('  ${data.sublist(i, end).join(', ')},');
  }
  buf.writeln('];');
  buf.writeln();
}

String _escape(String s) =>
    s.replaceAll(r'\', r'\\').replaceAll("'", r"\'");

String _toCamelCase(String s) {
  if (s.isEmpty) return s;
  return s[0].toLowerCase() + s.substring(1);
}
```

- [ ] **Step 4: Create grammars directory**

```bash
mkdir -p packages/duskmoon_code_engine/grammars
touch packages/duskmoon_code_engine/grammars/.gitkeep
```

- [ ] **Step 5: Add melos script for grammar codegen**

In root `pubspec.yaml`, add to the `melos:` → `scripts:` section:

```yaml
  codegen:grammars:
    description: Compile Lezer grammars to Dart (local dev only — output committed to repo)
    run: |
      cd packages/duskmoon_code_engine
      dart run tool/grammar_to_dart.dart
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/ pubspec.yaml
git commit -m "feat(duskmoon_code_engine): add grammar codegen pipeline (compile_grammar.mjs + grammar_to_dart.dart)"
```

---

## Task 5: Final verification

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart` (if needed)

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
git commit -m "chore(duskmoon_code_engine): finalize Phase 4b"
```

---

## Summary

Phase 4b delivers **5 tasks** producing:

| Component | Files | Tests |
|-----------|-------|-------|
| Java, Kotlin, PHP grammars | java.dart, kotlin.dart, php.dart | — |
| Ruby, Erlang, Swift, Zig grammars | ruby.dart, erlang.dart, swift.dart, zig.dart | — |
| Grammar test suite | remaining_grammars_test.dart | 30 tests |
| Codegen pipeline | compile_grammar.mjs, grammar_to_dart.dart, package.json | — |

**Deliverable:** Complete 19-language inventory (JSON + Dart + JS + Python + HTML + CSS + Markdown + Rust + Go + YAML + C + Elixir + Java + Kotlin + PHP + Ruby + Erlang + Swift + Zig). Grammar codegen pipeline ready for when real Lezer grammar tables are needed.

**Deferred to Phase 4c (separate plan):**
- Full table-driven LR parser port (~4K lines of Dart ported from `@lezer/lr`)
- Compiling actual `.grammar` files through the pipeline
- Mixed-language parsing (HTML+CSS+JS, PHP+HTML)
- Syntax-tree-based folding (replacing indent-based)
- Incremental parsing with tree reuse
