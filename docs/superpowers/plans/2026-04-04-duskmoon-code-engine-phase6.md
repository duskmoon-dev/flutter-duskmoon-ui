# duskmoon_code_engine Phase 6 — Polish & Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Integrate duskmoon_code_engine with the DuskMoon design system (DmDesignTokens → EditorTheme adapter), add to the duskmoon_ui umbrella, create an example app page, and ensure public API has dartdoc documentation.

**Architecture:** The DmDesignTokens adapter lives in `duskmoon_ui` (not in duskmoon_code_engine — keeping the code engine standalone). It maps `ColorScheme` + `DmColorExtension` to `EditorTheme`. The example page demonstrates the CodeEditorWidget with language switching and theme switching. The umbrella re-exports `duskmoon_code_engine`.

**Tech Stack:** Dart 3.5+, Flutter SDK, duskmoon_theme, duskmoon_code_engine

**Spec:** `docs/code-engine.md` sections 10.2, 12

**Depends on:** All prior phases (1-5) complete

---

## File Structure

```
packages/
├── duskmoon_ui/
│   ├── lib/
│   │   ├── duskmoon_ui.dart              # MODIFY — add re-export
│   │   └── src/
│   │       └── code_engine_theme.dart     # CREATE — DmDesignTokens adapter
│   └── pubspec.yaml                       # MODIFY — add dependency
│
├── duskmoon_code_engine/
│   └── lib/src/
│       └── (existing — no changes, only dartdoc review)
│
└── example/
    ├── lib/
    │   └── pages/
    │       └── code_editor_page.dart      # CREATE — example page
    ├── lib/main.dart                      # MODIFY — add navigation
    └── pubspec.yaml                       # MODIFY — add dependency
```

---

## Task 1: DmDesignTokens → EditorTheme adapter

**Files:**
- Create: `packages/duskmoon_ui/lib/src/code_engine_theme.dart`
- Modify: `packages/duskmoon_ui/lib/duskmoon_ui.dart`
- Modify: `packages/duskmoon_ui/pubspec.yaml`

The adapter maps Material `ColorScheme` and `DmColorExtension` to `EditorTheme`. It lives in duskmoon_ui (not duskmoon_code_engine) to keep the code engine dependency-free.

- [ ] **Step 1: Add duskmoon_code_engine dependency to duskmoon_ui**

In `packages/duskmoon_ui/pubspec.yaml`, add to `dependencies:`:

```yaml
  duskmoon_code_engine: ^0.1.0
```

- [ ] **Step 2: Create the adapter**

Create `packages/duskmoon_ui/lib/src/code_engine_theme.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';

/// Creates an [EditorTheme] from a Material [ThemeData].
///
/// Maps [ColorScheme] colors to editor chrome and uses
/// [DmColorExtension] (if available) for semantic token colors
/// in the highlight style.
///
/// Usage:
/// ```dart
/// final theme = DmEditorTheme.fromTheme(Theme.of(context));
/// CodeEditorWidget(theme: theme, ...)
/// ```
abstract final class DmEditorTheme {
  /// Build an [EditorTheme] from a Flutter [ThemeData].
  ///
  /// Uses [ColorScheme] for editor chrome (background, gutter, selection,
  /// cursor) and derives syntax highlighting colors from the scheme.
  /// If [DmColorExtension] is available, uses its semantic tokens
  /// for richer highlighting.
  static EditorTheme fromTheme(ThemeData themeData) {
    final cs = themeData.colorScheme;
    final dmExt = themeData.extension<DmColorExtension>();
    final isDark = themeData.brightness == Brightness.dark;

    return EditorTheme(
      background: cs.surface,
      foreground: cs.onSurface,
      gutterBackground: isDark
          ? cs.surfaceContainerLow
          : cs.surfaceContainerLow,
      gutterForeground: cs.onSurfaceVariant,
      gutterActiveForeground: cs.onSurface,
      selectionBackground: cs.primaryContainer,
      cursorColor: cs.primary,
      lineHighlight: cs.surfaceContainerHighest.withValues(alpha: 0.5),
      searchMatchBackground: cs.tertiaryContainer,
      searchActiveMatchBackground: cs.secondaryContainer,
      matchingBracketBackground: (dmExt?.success ?? cs.primary).withValues(alpha: 0.2),
      matchingBracketOutline: dmExt?.success ?? cs.primary,
      scrollbarThumb: cs.onSurface.withValues(alpha: 0.2),
      scrollbarTrack: cs.onSurface.withValues(alpha: 0.04),
      highlightStyle: _buildHighlightStyle(cs, dmExt, isDark),
    );
  }

  /// Build an [EditorTheme] for the Sunshine theme.
  static EditorTheme sunshine() =>
      fromTheme(DmThemeData.sunshine());

  /// Build an [EditorTheme] for the Moonlight theme.
  static EditorTheme moonlight() =>
      fromTheme(DmThemeData.moonlight());

  static HighlightStyle _buildHighlightStyle(
    ColorScheme cs,
    DmColorExtension? dmExt,
    bool isDark,
  ) {
    // Derive syntax colors from the color scheme
    final keyword = cs.primary;
    final string = cs.tertiary;
    final comment = cs.onSurfaceVariant;
    final number = cs.secondary;
    final typeName = dmExt?.info ?? cs.primary;
    final function_ = cs.onSurface;
    final operator_ = cs.onSurfaceVariant;
    final annotation = dmExt?.accent ?? cs.secondary;

    return HighlightStyle([
      TagStyle(Tag.keyword, TextStyle(
        color: keyword,
        fontWeight: FontWeight.bold,
      )),
      TagStyle(Tag.string, TextStyle(color: string)),
      TagStyle(Tag.comment, TextStyle(
        color: comment,
        fontStyle: FontStyle.italic,
      )),
      TagStyle(Tag.number, TextStyle(color: number)),
      TagStyle(Tag.typeName, TextStyle(color: typeName)),
      TagStyle(Tag.function_, TextStyle(color: function_)),
      TagStyle(Tag.variableName, TextStyle(color: cs.onSurface)),
      TagStyle(Tag.operator_, TextStyle(color: operator_)),
      TagStyle(Tag.punctuation, TextStyle(color: cs.onSurface)),
      TagStyle(Tag.bool_, TextStyle(color: keyword)),
      TagStyle(Tag.null_, TextStyle(color: keyword)),
      TagStyle(Tag.meta, TextStyle(color: comment)),
      TagStyle(Tag.annotation_, TextStyle(color: annotation)),
      TagStyle(Tag.invalid, TextStyle(
        color: cs.error,
        decoration: TextDecoration.lineThrough,
      )),
    ]);
  }
}
```

- [ ] **Step 3: Add re-export to duskmoon_ui barrel**

In `packages/duskmoon_ui/lib/duskmoon_ui.dart`, add:

```dart
export 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
export 'src/code_engine_theme.dart' show DmEditorTheme;
```

- [ ] **Step 4: Run `dart pub get` and analyzer**

```bash
dart pub get
cd packages/duskmoon_ui && dart analyze --fatal-infos
```

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_ui/
git commit -m "feat(duskmoon_ui): add DmEditorTheme adapter and re-export duskmoon_code_engine"
```

---

## Task 2: Example app — code editor page

**Files:**
- Create: `packages/example/lib/pages/code_editor_page.dart`
- Modify: `packages/example/lib/main.dart`
- Modify: `packages/example/pubspec.yaml`

A showcase page demonstrating the CodeEditorWidget with language switching, theme switching, and sample code.

- [ ] **Step 1: Add dependency to example**

In `example/pubspec.yaml`, add to dependencies:

```yaml
  duskmoon_code_engine:
    path: ../packages/duskmoon_code_engine
```

- [ ] **Step 2: Create the code editor page**

Create `example/lib/pages/code_editor_page.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

class CodeEditorPage extends StatefulWidget {
  const CodeEditorPage({super.key});

  @override
  State<CodeEditorPage> createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends State<CodeEditorPage> {
  late EditorViewController _controller;
  String _selectedLanguage = 'dart';

  final _languages = <String, LanguageSupport Function()>{
    'dart': dartLanguageSupport,
    'javascript': javascriptLanguageSupport,
    'python': pythonLanguageSupport,
    'html': htmlLanguageSupport,
    'css': cssLanguageSupport,
    'rust': rustLanguageSupport,
    'go': goLanguageSupport,
    'json': jsonLanguageSupport,
    'yaml': yamlLanguageSupport,
    'markdown': markdownLanguageSupport,
    'elixir': elixirLanguageSupport,
    'java': javaLanguageSupport,
    'kotlin': kotlinLanguageSupport,
    'swift': swiftLanguageSupport,
    'c': cLanguageSupport,
    'ruby': rubyLanguageSupport,
    'php': phpLanguageSupport,
    'erlang': erlangLanguageSupport,
    'zig': zigLanguageSupport,
  };

  final _sampleCode = <String, String>{
    'dart': '''import 'package:flutter/material.dart';

/// A simple Flutter widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DuskMoon',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

void main() => runApp(const MyApp());
''',
    'javascript': '''// Fibonacci generator
function* fibonacci() {
  let [a, b] = [0, 1];
  while (true) {
    yield a;
    [a, b] = [b, a + b];
  }
}

const fib = fibonacci();
for (let i = 0; i < 10; i++) {
  console.log(fib.next().value);
}
''',
    'python': '''# Quick sort implementation
def quicksort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quicksort(left) + middle + quicksort(right)

numbers = [3, 6, 8, 10, 1, 2, 1]
print(quicksort(numbers))
''',
    'json': '''{"name": "duskmoon_code_engine", "version": "0.1.0"}''',
  };

  @override
  void initState() {
    super.initState();
    _controller = EditorViewController(
      text: _sampleCode['dart'] ?? '',
      language: _languages['dart']!(),
      extensions: [historyExtension()],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _switchLanguage(String lang) {
    setState(() {
      _selectedLanguage = lang;
      _controller.language = _languages[lang]!();
      if (_sampleCode.containsKey(lang)) {
        _controller.text = _sampleCode[lang]!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Editor'),
        actions: [
          DropdownButton<String>(
            value: _selectedLanguage,
            items: _languages.keys.map((lang) {
              return DropdownMenuItem(value: lang, child: Text(lang));
            }).toList(),
            onChanged: (lang) {
              if (lang != null) _switchLanguage(lang);
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: CodeEditorWidget(
        controller: _controller,
        theme: isDark ? EditorTheme.dark() : EditorTheme.light(),
        lineNumbers: true,
        highlightActiveLine: true,
      ),
    );
  }
}
```

- [ ] **Step 3: Add navigation to main.dart**

Read the current `example/lib/main.dart` first. Add an import for `CodeEditorPage` and a navigation entry in the page list (following the existing pattern — likely a `ListTile` or navigation item).

The implementer should read main.dart, find the navigation pattern, and add a "Code Editor" entry that navigates to `CodeEditorPage`.

- [ ] **Step 4: Run `dart pub get` and analyzer**

```bash
dart pub get
cd example && dart analyze --fatal-infos
```

- [ ] **Step 5: Commit**

```bash
git add example/
git commit -m "feat(example): add code editor showcase page with language switching"
```

---

## Task 3: Public API dartdoc review

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart` (barrel doc comments)

Ensure the barrel export file has clear section comments and the library doc comment is comprehensive. This is a documentation-only task.

- [ ] **Step 1: Update barrel library doc comment**

Read the current barrel. Update the library doc comment to be a comprehensive package overview:

```dart
/// Pure Dart code editor engine with incremental parsing.
///
/// A ground-up port of the CodeMirror 6 architecture for Flutter,
/// providing document model, state management, syntax highlighting,
/// and an interactive editor widget.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
///
/// CodeEditorWidget(
///   initialDoc: 'print("hello")',
///   language: dartLanguageSupport(),
///   theme: EditorTheme.dark(),
///   lineNumbers: true,
/// )
/// ```
///
/// ## Supported Languages
///
/// 19 languages: Dart, JavaScript/TypeScript, Python, HTML, CSS,
/// JSON, Markdown, Rust, Go, YAML, C/C++, Elixir, Java, Kotlin,
/// PHP, Ruby, Erlang, Swift, Zig.
///
/// ## Key Classes
///
/// - [CodeEditorWidget] — the main editor widget
/// - [EditorViewController] — programmatic editor control
/// - [EditorState] — immutable editor state snapshot
/// - [EditorTheme] — editor visual theme
/// - [Language] / [LanguageSupport] — language definitions
library;
```

- [ ] **Step 2: Ensure section comments are clear**

Verify the barrel has organized sections:
```dart
// Document model
// State system
// Lezer common
// Lezer LR
// Lezer highlight
// Language system
// Grammars
// Theme
// View
// Commands
```

- [ ] **Step 3: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "docs(duskmoon_code_engine): add comprehensive library dartdoc with quick start guide"
```

---

## Task 4: Final workspace verification

- [ ] **Step 1: Run workspace analyzer**

```bash
melos run analyze
```

- [ ] **Step 2: Verify all packages resolve**

```bash
dart pub get
```

- [ ] **Step 3: Check git status**

```bash
git status
git log --oneline -10
```

- [ ] **Step 4: Commit any remaining changes**

```bash
git add .
git commit -m "chore(duskmoon_code_engine): finalize Phase 6 — polish and integration complete"
```

---

## Summary

Phase 6 delivers **4 tasks** producing:

| Component | Files | Location |
|-----------|-------|----------|
| DmEditorTheme adapter | code_engine_theme.dart | duskmoon_ui |
| Umbrella re-export | duskmoon_ui.dart (modified) | duskmoon_ui |
| Example page | code_editor_page.dart + main.dart | example |
| Dartdoc | duskmoon_code_engine.dart (modified) | duskmoon_code_engine |

**Deliverable:** The code engine is fully integrated into the DuskMoon design system. Consumers can use `DmEditorTheme.fromTheme(Theme.of(context))` for design-system-aligned theming. The example app showcases all 19 languages with a language switcher. The barrel export has comprehensive dartdoc with a quick start guide.

**The duskmoon_code_engine package is now complete for v0.1.0.**
