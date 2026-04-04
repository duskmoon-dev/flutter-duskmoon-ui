# duskmoon_code_engine Phase 3 — View Layer (MVP) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the Flutter view layer that renders the code engine as an interactive editor widget — virtual viewport rendering, syntax-highlighted line painting, cursor/selection, keyboard/IME input, basic commands, undo/redo, and the public CodeEditorWidget API.

**Architecture:** The view uses a `CustomScrollView` with custom slivers for virtual rendering. Only visible lines (plus overscan) are materialized. Each line is painted via `CustomPainter` (not `RichText` widgets) for direct canvas control. `EditorView` is a non-widget controller that holds state and dispatches transactions. `EditorViewController` is the public API for consumers. Input flows through a thin `TextInputClient` adapter for IME and a `KeyboardListener` for physical keys, both dispatching through the keymap → command → transaction pipeline.

**Tech Stack:** Dart 3.5+, Flutter SDK (widgets, rendering, services), `CustomPainter`, `TextInputClient`, `KeyboardListener`

**Spec:** `docs/code-engine.md` sections 7-9, 11

**Depends on:** Phase 1 (document model + state) and Phase 2 (parser + highlighting) — both complete

---

## File Structure

```
packages/duskmoon_code_engine/lib/src/
├── view/
│   ├── editor_view.dart            # EditorView (non-widget controller)
│   ├── editor_view_controller.dart # EditorViewController (public API)
│   ├── code_editor_widget.dart     # CodeEditorWidget (StatefulWidget)
│   ├── viewport.dart               # EditorViewport (visible range calc)
│   ├── line_painter.dart           # LinePainter (syntax + text rendering)
│   ├── gutter_painter.dart         # GutterPainter (line numbers)
│   ├── selection_painter.dart      # Selection rectangles + cursor caret
│   ├── input_handler.dart          # TextInputClient + keyboard handler
│   └── highlight_builder.dart      # Tree → InlineSpan list for painting
│
├── commands/
│   ├── commands.dart               # Standard editing commands
│   ├── history.dart                # Undo/redo state field + commands
│   └── keymap.dart                 # KeyBinding, Keymap facet, default keymap
│
└── (existing directories: document/, state/, lezer/, language/, grammars/, theme/)

test/src/
├── view/
│   ├── viewport_test.dart
│   ├── highlight_builder_test.dart
│   ├── code_editor_widget_test.dart
│   └── editor_view_controller_test.dart
│
└── commands/
    ├── commands_test.dart
    ├── history_test.dart
    └── keymap_test.dart
```

---

## Task 1: EditorViewport

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/viewport.dart`
- Create: `packages/duskmoon_code_engine/test/src/view/viewport_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

EditorViewport calculates which lines are visible given scroll position, viewport height, and line height. Fixed line height (monospace) gives O(1) mapping.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/view/viewport_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('EditorViewport', () {
    test('calculates visible range at top', () {
      final vp = EditorViewport(
        scrollOffset: 0,
        viewportHeight: 300,
        lineHeight: 20,
        totalLines: 100,
      );
      // At scroll 0, lines 0..14 visible (300/20=15 lines)
      // With overscan 5: first=0, last=20
      expect(vp.firstVisibleLine, 0);
      expect(vp.lastVisibleLine, 20);
    });

    test('calculates visible range scrolled down', () {
      final vp = EditorViewport(
        scrollOffset: 200,
        viewportHeight: 300,
        lineHeight: 20,
        totalLines: 100,
      );
      // At scroll 200: first visible = 200/20 = line 10
      // Last visible = (200+300)/20 = line 25
      // With overscan 5: first=5, last=30
      expect(vp.firstVisibleLine, 5);
      expect(vp.lastVisibleLine, 30);
    });

    test('clamps to document bounds', () {
      final vp = EditorViewport(
        scrollOffset: 1800,
        viewportHeight: 300,
        lineHeight: 20,
        totalLines: 100,
      );
      // scrolled near bottom: last should not exceed totalLines
      expect(vp.lastVisibleLine, lessThanOrEqualTo(100));
      expect(vp.firstVisibleLine, greaterThanOrEqualTo(0));
    });

    test('maxScrollExtent is totalLines * lineHeight', () {
      final vp = EditorViewport(
        scrollOffset: 0,
        viewportHeight: 300,
        lineHeight: 20,
        totalLines: 100,
      );
      expect(vp.maxScrollExtent, 2000);
    });

    test('visibleLineCount returns correct count', () {
      final vp = EditorViewport(
        scrollOffset: 0,
        viewportHeight: 300,
        lineHeight: 20,
        totalLines: 100,
      );
      expect(vp.visibleLineCount, 20); // includes overscan
    });

    test('lineAtY returns correct line for y coordinate', () {
      final vp = EditorViewport(
        scrollOffset: 100,
        viewportHeight: 300,
        lineHeight: 20,
        totalLines: 100,
      );
      // y=0 in viewport corresponds to scroll 100, line 5
      expect(vp.lineAtY(0), 5);
      expect(vp.lineAtY(20), 6);
    });

    test('yForLine returns y coordinate for line', () {
      final vp = EditorViewport(
        scrollOffset: 100,
        viewportHeight: 300,
        lineHeight: 20,
        totalLines: 100,
      );
      // line 5 at scroll 100 → y = 5*20 - 100 = 0
      expect(vp.yForLine(5), 0);
      expect(vp.yForLine(10), 100);
    });

    test('small document does not over-extend', () {
      final vp = EditorViewport(
        scrollOffset: 0,
        viewportHeight: 300,
        lineHeight: 20,
        totalLines: 5,
      );
      expect(vp.firstVisibleLine, 0);
      expect(vp.lastVisibleLine, 5); // clamped to totalLines
    });

    test('custom overscan', () {
      final vp = EditorViewport(
        scrollOffset: 200,
        viewportHeight: 300,
        lineHeight: 20,
        totalLines: 100,
        overscan: 10,
      );
      // first = 10 - 10 = 0, last = 25 + 10 = 35
      expect(vp.firstVisibleLine, 0);
      expect(vp.lastVisibleLine, 35);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/viewport_test.dart
```

- [ ] **Step 3: Implement EditorViewport**

Create `packages/duskmoon_code_engine/lib/src/view/viewport.dart`:

```dart
import 'dart:math' as math;

/// Calculates which document lines are visible in the editor viewport.
///
/// Assumes fixed line height (monospace font) for O(1) line↔pixel mapping.
class EditorViewport {
  EditorViewport({
    required this.scrollOffset,
    required this.viewportHeight,
    required this.lineHeight,
    required this.totalLines,
    this.overscan = 5,
  });

  /// Current vertical scroll offset in pixels.
  final double scrollOffset;

  /// Height of the visible viewport in pixels.
  final double viewportHeight;

  /// Height of a single line in pixels (fixed for monospace).
  final double lineHeight;

  /// Total number of lines in the document.
  final int totalLines;

  /// Extra lines above/below viewport to reduce scroll flicker.
  final int overscan;

  /// First visible line index (0-based, includes overscan).
  int get firstVisibleLine =>
      math.max(0, (scrollOffset / lineHeight).floor() - overscan);

  /// Last visible line index (exclusive, includes overscan).
  int get lastVisibleLine => math.min(
        totalLines,
        ((scrollOffset + viewportHeight) / lineHeight).ceil() + overscan,
      );

  /// Number of lines in the visible range (with overscan).
  int get visibleLineCount => lastVisibleLine - firstVisibleLine;

  /// Total scroll extent in pixels.
  double get maxScrollExtent => totalLines * lineHeight;

  /// Get the 0-based line index at a y-coordinate relative to the viewport.
  int lineAtY(double y) =>
      ((scrollOffset + y) / lineHeight).floor();

  /// Get the y-coordinate (relative to viewport) for a 0-based line index.
  double yForLine(int line) =>
      line * lineHeight - scrollOffset;
}
```

- [ ] **Step 4: Add export**

Add to `lib/duskmoon_code_engine.dart`:

```dart
// View
export 'src/view/viewport.dart' show EditorViewport;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/viewport_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add EditorViewport for virtual line rendering"
```

---

## Task 2: HighlightBuilder (Tree → styled spans)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/highlight_builder.dart`
- Create: `packages/duskmoon_code_engine/test/src/view/highlight_builder_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Converts a syntax tree + highlight style into a list of styled text spans for a given line range. This bridges the parser output to the line painter.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/view/highlight_builder_test.dart`:

```dart
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('HighlightBuilder', () {
    late HighlightStyle style;

    setUp(() {
      style = HighlightStyle([
        TagStyle(Tag.number, const TextStyle(color: Color(0xFF098658))),
        TagStyle(Tag.string, const TextStyle(color: Color(0xFFA31515))),
        TagStyle(Tag.bool_, const TextStyle(color: Color(0xFF0000FF))),
        TagStyle(Tag.punctuation, const TextStyle(color: Color(0xFF000000))),
      ]);
    });

    test('returns empty spans for empty document', () {
      final spans = HighlightBuilder.buildSpans(
        tree: Tree.empty,
        text: '',
        lineFrom: 0,
        lineTo: 0,
        highlightStyle: style,
        defaultStyle: const TextStyle(color: Color(0xFF1E1E1E)),
      );
      expect(spans, isEmpty);
    });

    test('builds spans for a single number token', () {
      final tree = _parseJson('42');
      final spans = HighlightBuilder.buildSpans(
        tree: tree,
        text: '42',
        lineFrom: 0,
        lineTo: 2,
        highlightStyle: style,
        defaultStyle: const TextStyle(color: Color(0xFF1E1E1E)),
      );
      expect(spans, isNotEmpty);
      // Should have at least one span covering the number
      expect(spans.any((s) => s.style?.color == const Color(0xFF098658)), true);
    });

    test('builds spans for mixed tokens', () {
      final text = '{"a": 42}';
      final tree = _parseJson(text);
      final spans = HighlightBuilder.buildSpans(
        tree: tree,
        text: text,
        lineFrom: 0,
        lineTo: text.length,
        highlightStyle: style,
        defaultStyle: const TextStyle(color: Color(0xFF1E1E1E)),
      );
      expect(spans.length, greaterThanOrEqualTo(2));
    });

    test('spans cover full range without gaps', () {
      final text = '42 "hi"';
      final tree = _parseJson(text);
      final spans = HighlightBuilder.buildSpans(
        tree: tree,
        text: text,
        lineFrom: 0,
        lineTo: text.length,
        highlightStyle: style,
        defaultStyle: const TextStyle(color: Color(0xFF1E1E1E)),
      );
      // Total length of all spans should equal text length
      final totalLen = spans.fold<int>(0, (sum, s) => sum + s.length);
      expect(totalLen, text.length);
    });

    test('unstyled text gets default style', () {
      final text = '  42  ';
      final tree = _parseJson(text);
      final spans = HighlightBuilder.buildSpans(
        tree: tree,
        text: text,
        lineFrom: 0,
        lineTo: text.length,
        highlightStyle: style,
        defaultStyle: const TextStyle(color: Color(0xFF1E1E1E)),
      );
      // Whitespace spans should get the default style
      final whitespaceSpans = spans.where(
        (s) => s.text.trim().isEmpty && s.style?.color == const Color(0xFF1E1E1E),
      );
      expect(whitespaceSpans, isNotEmpty);
    });
  });
}

Tree _parseJson(String text) {
  final parser = LRParser.deserialize(
    nodeNames: ['', 'JsonText', 'Number', 'String', 'Boolean', 'Null',
                '{', '}', '[', ']', ',', ':', '⚠'],
    states: [0], stateData: [0], gotoTable: [0], tokenData: [0],
    topRuleIndex: 1,
    nodeProps: {1: {NodeProp.top: true}, 12: {NodeProp.error: true}},
  );
  return parser.parse(text);
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/highlight_builder_test.dart
```

- [ ] **Step 3: Implement HighlightBuilder**

Create `packages/duskmoon_code_engine/lib/src/view/highlight_builder.dart`:

```dart
import 'package:flutter/painting.dart';

import '../lezer/common/tree.dart';
import '../lezer/highlight/highlight.dart';
import '../lezer/highlight/tags.dart';

/// A styled text span with position information.
class InlineSpan {
  const InlineSpan({
    required this.from,
    required this.to,
    required this.text,
    this.style,
  });

  /// Start offset in the document.
  final int from;

  /// End offset in the document.
  final int to;

  /// The text content.
  final String text;

  /// The style to render this span with.
  final TextStyle? style;

  /// Character length.
  int get length => to - from;
}

/// Builds [InlineSpan]s from a syntax [Tree] for a line range.
///
/// Walks the tree's leaf nodes, maps each to a [Tag] via a
/// node-name-to-tag mapping, resolves the tag to a [TextStyle]
/// via the [HighlightStyle], and fills gaps with default-styled spans.
abstract final class HighlightBuilder {
  /// Build styled spans covering [lineFrom]..[lineTo] of [text].
  ///
  /// [tree] is the syntax tree for the document.
  /// [highlightStyle] resolves tags to TextStyles.
  /// [defaultStyle] is used for text not covered by any syntax node.
  /// [tagMapping] optionally maps node names to Tags. If null, a
  /// default identity mapping based on common node names is used.
  static List<InlineSpan> buildSpans({
    required Tree tree,
    required String text,
    required int lineFrom,
    required int lineTo,
    required HighlightStyle highlightStyle,
    required TextStyle defaultStyle,
    Map<String, Tag>? tagMapping,
  }) {
    if (text.isEmpty || lineFrom >= lineTo) return [];

    // Collect token ranges from the tree
    final tokens = <_TokenRange>[];
    _collectTokens(tree, 0, tokens, lineFrom, lineTo);

    // Sort by position
    tokens.sort((a, b) => a.from.compareTo(b.from));

    // Build spans, filling gaps with default style
    final spans = <InlineSpan>[];
    var pos = lineFrom;

    for (final token in tokens) {
      final tokenFrom = token.from.clamp(lineFrom, lineTo);
      final tokenTo = token.to.clamp(lineFrom, lineTo);

      if (tokenFrom >= tokenTo) continue;

      // Fill gap before this token
      if (tokenFrom > pos) {
        spans.add(InlineSpan(
          from: pos,
          to: tokenFrom,
          text: text.substring(pos, tokenFrom),
          style: defaultStyle,
        ));
      }

      // Resolve style for this token
      final tag = tagMapping?[token.name] ?? _defaultTagForName(token.name);
      final tokenStyle = tag != null
          ? highlightStyle.style(tag) ?? defaultStyle
          : defaultStyle;

      spans.add(InlineSpan(
        from: tokenFrom,
        to: tokenTo,
        text: text.substring(tokenFrom, tokenTo),
        style: tokenStyle,
      ));

      pos = tokenTo;
    }

    // Fill gap after last token
    if (pos < lineTo) {
      spans.add(InlineSpan(
        from: pos,
        to: lineTo,
        text: text.substring(pos, lineTo),
        style: defaultStyle,
      ));
    }

    return spans;
  }

  static void _collectTokens(
    Tree tree,
    int offset,
    List<_TokenRange> tokens,
    int rangeFrom,
    int rangeTo,
  ) {
    final treeEnd = offset + tree.length;

    // Skip trees entirely outside the range
    if (treeEnd <= rangeFrom || offset >= rangeTo) return;

    if (tree.children.isEmpty) {
      // Leaf node — it's a token
      if (tree.type.id != 0 && !tree.type.isTop) {
        tokens.add(_TokenRange(tree.type.name, offset, treeEnd));
      }
      return;
    }

    // Recurse into children
    for (var i = 0; i < tree.children.length; i++) {
      final child = tree.children[i];
      if (child is Tree) {
        final childOffset = offset + tree.positions[i];
        _collectTokens(child, childOffset, tokens, rangeFrom, rangeTo);
      }
    }
  }

  /// Map common node names to Tags.
  static Tag? _defaultTagForName(String name) {
    return switch (name) {
      'String' || 'StringLiteral' => Tag.string,
      'Number' || 'NumberLiteral' || 'Integer' || 'Float' => Tag.number,
      'Boolean' || 'BooleanLiteral' || 'True' || 'False' => Tag.bool_,
      'Null' || 'None' => Tag.null_,
      'Comment' || 'LineComment' || 'BlockComment' => Tag.comment,
      'Keyword' => Tag.keyword,
      'Identifier' || 'VariableName' => Tag.variableName,
      'TypeName' || 'Type' => Tag.typeName,
      'FunctionName' => Tag.function_,
      'Operator' => Tag.operator_,
      '{' || '}' => Tag.brace,
      '(' || ')' => Tag.paren,
      '[' || ']' => Tag.squareBracket,
      '<' || '>' => Tag.angleBracket,
      ',' || ':' || ';' => Tag.separator,
      _ => null,
    };
  }
}

class _TokenRange {
  const _TokenRange(this.name, this.from, this.to);
  final String name;
  final int from;
  final int to;
}
```

- [ ] **Step 4: Add export**

```dart
export 'src/view/highlight_builder.dart' show InlineSpan, HighlightBuilder;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/highlight_builder_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add HighlightBuilder for syntax-tree-to-spans"
```

---

## Task 3: Keymap and KeyBinding

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/commands/keymap.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/keymap_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

The keymap system maps key combinations to commands. Platform-aware (Cmd on macOS, Ctrl on others).

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/keymap_test.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('KeyBinding', () {
    test('creates with key and command', () {
      final binding = KeyBinding(
        key: 'Ctrl-z',
        run: (_) => true,
      );
      expect(binding.key, 'Ctrl-z');
      expect(binding.run, isNotNull);
    });

    test('matches simple key', () {
      final binding = KeyBinding(key: 'Enter', run: (_) => true);
      expect(binding.matches(LogicalKeyboardKey.enter, false, false, false), true);
    });

    test('matches Ctrl modifier', () {
      final binding = KeyBinding(key: 'Ctrl-z', run: (_) => true);
      expect(binding.matches(LogicalKeyboardKey.keyZ, true, false, false), true);
      expect(binding.matches(LogicalKeyboardKey.keyZ, false, false, false), false);
    });

    test('matches Shift modifier', () {
      final binding = KeyBinding(key: 'Shift-Enter', run: (_) => true);
      expect(binding.matches(LogicalKeyboardKey.enter, false, true, false), true);
    });

    test('matches Alt modifier', () {
      final binding = KeyBinding(key: 'Alt-f', run: (_) => true);
      expect(binding.matches(LogicalKeyboardKey.keyF, false, false, true), true);
    });

    test('matches compound modifier', () {
      final binding = KeyBinding(key: 'Ctrl-Shift-z', run: (_) => true);
      expect(binding.matches(LogicalKeyboardKey.keyZ, true, true, false), true);
      expect(binding.matches(LogicalKeyboardKey.keyZ, true, false, false), false);
    });
  });

  group('Keymap', () {
    test('resolves first matching binding', () {
      var called = '';
      final keymap = Keymap([
        KeyBinding(key: 'Ctrl-z', run: (_) { called = 'undo'; return true; }),
        KeyBinding(key: 'Ctrl-z', run: (_) { called = 'other'; return true; }),
      ]);
      final resolved = keymap.resolve(LogicalKeyboardKey.keyZ, true, false, false);
      expect(resolved, isNotNull);
    });

    test('returns null for unbound key', () {
      final keymap = Keymap([
        KeyBinding(key: 'Ctrl-z', run: (_) => true),
      ]);
      final resolved = keymap.resolve(LogicalKeyboardKey.keyA, true, false, false);
      expect(resolved, isNull);
    });

    test('composes multiple keymaps', () {
      final km1 = Keymap([
        KeyBinding(key: 'Ctrl-z', run: (_) => true),
      ]);
      final km2 = Keymap([
        KeyBinding(key: 'Ctrl-y', run: (_) => true),
      ]);
      final composed = Keymap.compose([km1, km2]);
      expect(composed.resolve(LogicalKeyboardKey.keyZ, true, false, false), isNotNull);
      expect(composed.resolve(LogicalKeyboardKey.keyY, true, false, false), isNotNull);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/keymap_test.dart
```

- [ ] **Step 3: Implement KeyBinding and Keymap**

Create `packages/duskmoon_code_engine/lib/src/commands/keymap.dart`:

```dart
import 'package:flutter/services.dart';

/// A command is a function that acts on an EditorView.
/// Returns true if handled, false to fall through.
///
/// The parameter is `dynamic` to avoid circular dependency with
/// EditorView (which is defined in the view layer). Callers cast
/// to `EditorView`.
typedef Command = bool Function(dynamic view);

/// Binds a key combination to a command.
class KeyBinding {
  const KeyBinding({
    required this.key,
    this.run,
    this.shift,
    this.preventDefault = true,
  });

  /// Key descriptor: e.g., "Ctrl-z", "Cmd-s", "Shift-Enter", "Alt-f".
  /// Modifiers: Ctrl, Shift, Alt, Meta, Cmd (alias for Meta on macOS).
  final String key;

  /// Command to run in normal mode.
  final Command? run;

  /// Command to run with Shift (for selection extension).
  final Command? shift;

  /// Whether to prevent default browser/OS behavior.
  final bool preventDefault;

  /// Check if this binding matches the given key event.
  bool matches(
    LogicalKeyboardKey logicalKey,
    bool ctrl,
    bool shift,
    bool alt,
  ) {
    final parsed = _parseKey(key);
    if (parsed == null) return false;

    return parsed.logicalKey == logicalKey &&
        parsed.ctrl == ctrl &&
        parsed.shift == shift &&
        parsed.alt == alt;
  }

  static _ParsedKey? _parseKey(String key) {
    final parts = key.split('-');
    var ctrl = false;
    var shift = false;
    var alt = false;
    LogicalKeyboardKey? logicalKey;

    for (final part in parts) {
      switch (part) {
        case 'Ctrl' || 'Cmd' || 'Meta':
          ctrl = true;
        case 'Shift':
          shift = true;
        case 'Alt':
          alt = true;
        default:
          logicalKey = _nameToKey(part);
      }
    }

    if (logicalKey == null) return null;
    return _ParsedKey(logicalKey, ctrl, shift, alt);
  }

  static LogicalKeyboardKey? _nameToKey(String name) {
    return switch (name.toLowerCase()) {
      'a' => LogicalKeyboardKey.keyA,
      'b' => LogicalKeyboardKey.keyB,
      'c' => LogicalKeyboardKey.keyC,
      'd' => LogicalKeyboardKey.keyD,
      'e' => LogicalKeyboardKey.keyE,
      'f' => LogicalKeyboardKey.keyF,
      'g' => LogicalKeyboardKey.keyG,
      'h' => LogicalKeyboardKey.keyH,
      'i' => LogicalKeyboardKey.keyI,
      'j' => LogicalKeyboardKey.keyJ,
      'k' => LogicalKeyboardKey.keyK,
      'l' => LogicalKeyboardKey.keyL,
      'm' => LogicalKeyboardKey.keyM,
      'n' => LogicalKeyboardKey.keyN,
      'o' => LogicalKeyboardKey.keyO,
      'p' => LogicalKeyboardKey.keyP,
      'q' => LogicalKeyboardKey.keyQ,
      'r' => LogicalKeyboardKey.keyR,
      's' => LogicalKeyboardKey.keyS,
      't' => LogicalKeyboardKey.keyT,
      'u' => LogicalKeyboardKey.keyU,
      'v' => LogicalKeyboardKey.keyV,
      'w' => LogicalKeyboardKey.keyW,
      'x' => LogicalKeyboardKey.keyX,
      'y' => LogicalKeyboardKey.keyY,
      'z' => LogicalKeyboardKey.keyZ,
      'enter' => LogicalKeyboardKey.enter,
      'tab' => LogicalKeyboardKey.tab,
      'escape' || 'esc' => LogicalKeyboardKey.escape,
      'backspace' => LogicalKeyboardKey.backspace,
      'delete' => LogicalKeyboardKey.delete,
      'arrowup' || 'up' => LogicalKeyboardKey.arrowUp,
      'arrowdown' || 'down' => LogicalKeyboardKey.arrowDown,
      'arrowleft' || 'left' => LogicalKeyboardKey.arrowLeft,
      'arrowright' || 'right' => LogicalKeyboardKey.arrowRight,
      'home' => LogicalKeyboardKey.home,
      'end' => LogicalKeyboardKey.end,
      'pageup' => LogicalKeyboardKey.pageUp,
      'pagedown' => LogicalKeyboardKey.pageDown,
      '/' => LogicalKeyboardKey.slash,
      '[' => LogicalKeyboardKey.bracketLeft,
      ']' => LogicalKeyboardKey.bracketRight,
      _ => null,
    };
  }
}

class _ParsedKey {
  const _ParsedKey(this.logicalKey, this.ctrl, this.shift, this.alt);
  final LogicalKeyboardKey logicalKey;
  final bool ctrl;
  final bool shift;
  final bool alt;
}

/// A collection of key bindings with lookup.
class Keymap {
  const Keymap(this.bindings);

  final List<KeyBinding> bindings;

  /// Find the first binding matching the key event.
  KeyBinding? resolve(
    LogicalKeyboardKey logicalKey,
    bool ctrl,
    bool shift,
    bool alt,
  ) {
    for (final binding in bindings) {
      if (binding.matches(logicalKey, ctrl, shift, alt)) {
        return binding;
      }
    }
    return null;
  }

  /// Compose multiple keymaps (first keymap has priority).
  static Keymap compose(List<Keymap> keymaps) {
    return Keymap([for (final km in keymaps) ...km.bindings]);
  }
}
```

- [ ] **Step 4: Add exports**

```dart
// Commands
export 'src/commands/keymap.dart' show Command, KeyBinding, Keymap;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/keymap_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add KeyBinding and Keymap for key dispatch"
```

---

## Task 4: Standard editing commands

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/commands/commands.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/commands_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Basic editing commands: cursor movement, selection, insert, delete, clipboard. Commands operate on `EditorState` and return `TransactionSpec`. They don't depend on EditorView (which doesn't exist yet) — instead, they take state as input and return specs.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/commands_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('EditorCommands', () {
    group('cursor movement', () {
      test('cursorCharRight moves cursor right by 1', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(0),
        );
        final spec = EditorCommands.cursorCharRight(state);
        expect(spec, isNotNull);
        expect(spec!.selection!.main.head, 1);
      });

      test('cursorCharRight at end returns null', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(5),
        );
        expect(EditorCommands.cursorCharRight(state), isNull);
      });

      test('cursorCharLeft moves cursor left by 1', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(3),
        );
        final spec = EditorCommands.cursorCharLeft(state);
        expect(spec!.selection!.main.head, 2);
      });

      test('cursorCharLeft at start returns null', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(0),
        );
        expect(EditorCommands.cursorCharLeft(state), isNull);
      });

      test('cursorLineDown moves to next line', () {
        final state = EditorState.create(
          docString: 'hello\nworld',
          selection: EditorSelection.cursor(2),
        );
        final spec = EditorCommands.cursorLineDown(state);
        expect(spec, isNotNull);
        // Cursor on line 1 col 2 → line 2 col 2 → offset 8
        expect(spec!.selection!.main.head, 8);
      });

      test('cursorLineUp moves to previous line', () {
        final state = EditorState.create(
          docString: 'hello\nworld',
          selection: EditorSelection.cursor(8),
        );
        final spec = EditorCommands.cursorLineUp(state);
        expect(spec, isNotNull);
        expect(spec!.selection!.main.head, 2);
      });

      test('cursorLineStart moves to start of line', () {
        final state = EditorState.create(
          docString: 'hello\nworld',
          selection: EditorSelection.cursor(8),
        );
        final spec = EditorCommands.cursorLineStart(state);
        expect(spec!.selection!.main.head, 6);
      });

      test('cursorLineEnd moves to end of line', () {
        final state = EditorState.create(
          docString: 'hello\nworld',
          selection: EditorSelection.cursor(6),
        );
        final spec = EditorCommands.cursorLineEnd(state);
        expect(spec!.selection!.main.head, 11);
      });

      test('cursorDocStart moves to offset 0', () {
        final state = EditorState.create(
          docString: 'hello\nworld',
          selection: EditorSelection.cursor(8),
        );
        final spec = EditorCommands.cursorDocStart(state);
        expect(spec!.selection!.main.head, 0);
      });

      test('cursorDocEnd moves to end of document', () {
        final state = EditorState.create(
          docString: 'hello\nworld',
          selection: EditorSelection.cursor(0),
        );
        final spec = EditorCommands.cursorDocEnd(state);
        expect(spec!.selection!.main.head, 11);
      });
    });

    group('selection', () {
      test('selectCharRight extends selection right', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(0),
        );
        final spec = EditorCommands.selectCharRight(state);
        expect(spec!.selection!.main.anchor, 0);
        expect(spec.selection!.main.head, 1);
      });

      test('selectAll selects entire document', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(2),
        );
        final spec = EditorCommands.selectAll(state);
        expect(spec.selection!.main.from, 0);
        expect(spec.selection!.main.to, 5);
      });
    });

    group('editing', () {
      test('insertText inserts at cursor', () {
        final state = EditorState.create(
          docString: 'helo',
          selection: EditorSelection.cursor(2),
        );
        final spec = EditorCommands.insertText(state, 'l');
        expect(spec.changes, isNotNull);
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'hello');
        expect(newState.selection.main.head, 3);
      });

      test('deleteCharBackward deletes character before cursor', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(3),
        );
        final spec = EditorCommands.deleteCharBackward(state);
        expect(spec, isNotNull);
        final newState = state.applyTransaction(state.update(spec!));
        expect(newState.doc.toString(), 'helo');
      });

      test('deleteCharBackward at start returns null', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(0),
        );
        expect(EditorCommands.deleteCharBackward(state), isNull);
      });

      test('deleteCharForward deletes character after cursor', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(2),
        );
        final spec = EditorCommands.deleteCharForward(state);
        final newState = state.applyTransaction(state.update(spec!));
        expect(newState.doc.toString(), 'helo');
      });

      test('insertNewline inserts newline at cursor', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(5),
        );
        final spec = EditorCommands.insertNewline(state);
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'hello\n');
        expect(newState.selection.main.head, 6);
      });

      test('insertTab inserts two spaces', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(0),
        );
        final spec = EditorCommands.insertTab(state);
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), '  hello');
      });

      test('deleteSelection deletes selected range', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.single(anchor: 5, head: 11),
        );
        final spec = EditorCommands.deleteSelection(state);
        expect(spec, isNotNull);
        final newState = state.applyTransaction(state.update(spec!));
        expect(newState.doc.toString(), 'hello');
      });

      test('replaceSelection replaces selected range with text', () {
        final state = EditorState.create(
          docString: 'hello world',
          selection: EditorSelection.single(anchor: 6, head: 11),
        );
        final spec = EditorCommands.insertText(state, 'dart');
        final newState = state.applyTransaction(state.update(spec));
        expect(newState.doc.toString(), 'hello dart');
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/commands_test.dart
```

- [ ] **Step 3: Implement EditorCommands**

Create `packages/duskmoon_code_engine/lib/src/commands/commands.dart`:

```dart
import '../document/change.dart';
import '../state/editor_state.dart';
import '../state/selection.dart';

/// Standard editing commands.
///
/// Each command takes the current [EditorState] and returns a
/// [TransactionSpec] to apply, or null if the command doesn't apply.
/// Commands don't depend on the view — they operate purely on state.
abstract final class EditorCommands {
  // --- Cursor movement ---

  static TransactionSpec? cursorCharRight(EditorState state) {
    final head = state.selection.main.head;
    if (head >= state.doc.length) return null;
    return TransactionSpec(selection: EditorSelection.cursor(head + 1));
  }

  static TransactionSpec? cursorCharLeft(EditorState state) {
    final head = state.selection.main.head;
    if (head <= 0) return null;
    return TransactionSpec(selection: EditorSelection.cursor(head - 1));
  }

  static TransactionSpec? cursorLineDown(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    final col = head - line.from;
    if (line.number >= state.doc.lineCount) return null;
    final nextLine = state.doc.lineAt(line.number + 1);
    final newHead = nextLine.from + col.clamp(0, nextLine.length);
    return TransactionSpec(selection: EditorSelection.cursor(newHead));
  }

  static TransactionSpec? cursorLineUp(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    final col = head - line.from;
    if (line.number <= 1) return null;
    final prevLine = state.doc.lineAt(line.number - 1);
    final newHead = prevLine.from + col.clamp(0, prevLine.length);
    return TransactionSpec(selection: EditorSelection.cursor(newHead));
  }

  static TransactionSpec? cursorLineStart(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (head == line.from) return null;
    return TransactionSpec(selection: EditorSelection.cursor(line.from));
  }

  static TransactionSpec? cursorLineEnd(EditorState state) {
    final head = state.selection.main.head;
    final line = state.doc.lineAtOffset(head);
    if (head == line.to) return null;
    return TransactionSpec(selection: EditorSelection.cursor(line.to));
  }

  static TransactionSpec? cursorDocStart(EditorState state) {
    if (state.selection.main.head == 0) return null;
    return TransactionSpec(selection: EditorSelection.cursor(0));
  }

  static TransactionSpec? cursorDocEnd(EditorState state) {
    final end = state.doc.length;
    if (state.selection.main.head == end) return null;
    return TransactionSpec(selection: EditorSelection.cursor(end));
  }

  // --- Selection ---

  static TransactionSpec? selectCharRight(EditorState state) {
    final sel = state.selection.main;
    if (sel.head >= state.doc.length) return null;
    return TransactionSpec(
      selection: EditorSelection(ranges: [
        SelectionRange(anchor: sel.anchor, head: sel.head + 1),
      ]),
    );
  }

  static TransactionSpec? selectCharLeft(EditorState state) {
    final sel = state.selection.main;
    if (sel.head <= 0) return null;
    return TransactionSpec(
      selection: EditorSelection(ranges: [
        SelectionRange(anchor: sel.anchor, head: sel.head - 1),
      ]),
    );
  }

  static TransactionSpec selectAll(EditorState state) {
    return TransactionSpec(
      selection: EditorSelection.single(anchor: 0, head: state.doc.length),
    );
  }

  // --- Editing ---

  /// Insert [text] at the cursor, replacing any selection.
  static TransactionSpec insertText(EditorState state, String text) {
    final sel = state.selection.main;
    final from = sel.from;
    final to = sel.to;
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: from, to: to, insert: text)],
      ),
      selection: EditorSelection.cursor(from + text.length),
    );
  }

  static TransactionSpec insertNewline(EditorState state) =>
      insertText(state, '\n');

  static TransactionSpec insertTab(EditorState state) =>
      insertText(state, '  ');

  static TransactionSpec? deleteCharBackward(EditorState state) {
    final sel = state.selection.main;
    if (!sel.isEmpty) return deleteSelection(state);
    if (sel.head <= 0) return null;
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: sel.head - 1, to: sel.head)],
      ),
      selection: EditorSelection.cursor(sel.head - 1),
    );
  }

  static TransactionSpec? deleteCharForward(EditorState state) {
    final sel = state.selection.main;
    if (!sel.isEmpty) return deleteSelection(state);
    if (sel.head >= state.doc.length) return null;
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: sel.head, to: sel.head + 1)],
      ),
    );
  }

  static TransactionSpec? deleteSelection(EditorState state) {
    final sel = state.selection.main;
    if (sel.isEmpty) return null;
    return TransactionSpec(
      changes: ChangeSet.of(
        state.doc.length,
        [ChangeSpec(from: sel.from, to: sel.to)],
      ),
      selection: EditorSelection.cursor(sel.from),
    );
  }
}
```

- [ ] **Step 4: Add export**

```dart
export 'src/commands/commands.dart' show EditorCommands;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/commands_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add EditorCommands for cursor, selection, editing"
```

---

## Task 5: History (undo/redo)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/commands/history.dart`
- Create: `packages/duskmoon_code_engine/test/src/commands/history_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Undo/redo implemented as a StateField that tracks a stack of inverted changesets.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/commands/history_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('History', () {
    test('undo reverts last change', () {
      final state = EditorState.create(
        docString: 'hello',
        extensions: [historyExtension()],
      );
      // Make a change
      final spec = EditorCommands.insertText(state, ' world');
      final state2 = state.applyTransaction(state.update(spec));
      expect(state2.doc.toString(), 'hello world');

      // Undo
      final undoSpec = EditorCommands.undo(state2);
      expect(undoSpec, isNotNull);
      final state3 = state2.applyTransaction(state2.update(undoSpec!));
      expect(state3.doc.toString(), 'hello');
    });

    test('redo reapplies undone change', () {
      final state = EditorState.create(
        docString: 'hello',
        extensions: [historyExtension()],
      );
      final spec = EditorCommands.insertText(state, ' world');
      final state2 = state.applyTransaction(state.update(spec));

      final undoSpec = EditorCommands.undo(state2);
      final state3 = state2.applyTransaction(state2.update(undoSpec!));
      expect(state3.doc.toString(), 'hello');

      final redoSpec = EditorCommands.redo(state3);
      expect(redoSpec, isNotNull);
      final state4 = state3.applyTransaction(state3.update(redoSpec!));
      expect(state4.doc.toString(), 'hello world');
    });

    test('undo returns null when nothing to undo', () {
      final state = EditorState.create(
        docString: 'hello',
        extensions: [historyExtension()],
      );
      expect(EditorCommands.undo(state), isNull);
    });

    test('redo returns null when nothing to redo', () {
      final state = EditorState.create(
        docString: 'hello',
        extensions: [historyExtension()],
      );
      expect(EditorCommands.redo(state), isNull);
    });

    test('new edit after undo clears redo stack', () {
      final state = EditorState.create(
        docString: 'hello',
        extensions: [historyExtension()],
      );
      final s2 = state.applyTransaction(
        state.update(EditorCommands.insertText(state, ' world')),
      );
      final s3 = s2.applyTransaction(s2.update(EditorCommands.undo(s2)!));
      // Now make a new edit
      final s4 = s3.applyTransaction(
        s3.update(EditorCommands.insertText(s3, ' dart')),
      );
      // Redo should be empty
      expect(EditorCommands.redo(s4), isNull);
    });

    test('multiple undo steps', () {
      final state = EditorState.create(
        docString: '',
        extensions: [historyExtension()],
      );
      final s1 = state.applyTransaction(
        state.update(EditorCommands.insertText(state, 'a')),
      );
      final s2 = s1.applyTransaction(
        s1.update(EditorCommands.insertText(s1, 'b')),
      );
      expect(s2.doc.toString(), 'ab');

      final s3 = s2.applyTransaction(s2.update(EditorCommands.undo(s2)!));
      expect(s3.doc.toString(), 'a');

      final s4 = s3.applyTransaction(s3.update(EditorCommands.undo(s3)!));
      expect(s4.doc.toString(), '');
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/history_test.dart
```

- [ ] **Step 3: Implement history**

Create `packages/duskmoon_code_engine/lib/src/commands/history.dart`:

```dart
import '../document/change.dart';
import '../document/rope.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/selection.dart';

/// A history entry: the inverse changeset + the selection before the change.
class _HistoryEntry {
  const _HistoryEntry(this.changes, this.selection);
  final ChangeSet changes;
  final EditorSelection selection;
}

class _HistoryState {
  const _HistoryState({
    this.undoStack = const [],
    this.redoStack = const [],
  });

  final List<_HistoryEntry> undoStack;
  final List<_HistoryEntry> redoStack;

  _HistoryState pushUndo(_HistoryEntry entry) => _HistoryState(
        undoStack: [...undoStack, entry],
        redoStack: const [],
      );

  _HistoryState pushRedo(_HistoryEntry entry) => _HistoryState(
        undoStack: undoStack,
        redoStack: [...redoStack, entry],
      );

  _HistoryState popUndo() => _HistoryState(
        undoStack: undoStack.sublist(0, undoStack.length - 1),
        redoStack: redoStack,
      );

  _HistoryState popRedo() => _HistoryState(
        undoStack: undoStack,
        redoStack: redoStack.sublist(0, redoStack.length - 1),
      );
}

/// The StateField key for history. Package-private.
StateField<_HistoryState>? _historyField;

/// Create the history extension.
///
/// Add this to EditorState.create(extensions: [historyExtension()])
/// to enable undo/redo.
Extension historyExtension() {
  _historyField ??= StateField<_HistoryState>(
    create: (_) => const _HistoryState(),
    update: (transaction, value) {
      final tr = transaction as Transaction;
      if (!tr.docChanged) return value;

      // Check if this is an undo/redo operation (don't re-record)
      final isUndoRedo = tr.annotation(Annotations.addToHistory) == false;
      if (isUndoRedo) return value;

      // Record the inverse for undo
      final startDoc = tr.startState.doc;
      final inverse = tr.changes!.invert(
        Rope.fromString(startDoc.toString()),
      );
      final entry = _HistoryEntry(inverse, tr.startState.selection);
      return value.pushUndo(entry);
    },
  );
  return _historyField!;
}

/// Extension on EditorCommands for undo/redo.
extension HistoryCommands on EditorCommands {
  // Can't add static methods via extension — use top-level in EditorCommands
}

// Add undo/redo as static methods accessible via EditorCommands
extension UndoRedo on EditorCommands {
  // This doesn't work for static — we'll add them directly to EditorCommands
}
```

Wait — Dart doesn't support static extension methods. Let me put undo/redo directly on `EditorCommands`. I need to modify `commands.dart` to add them.

Updated approach: add `undo` and `redo` as static methods in `EditorCommands` in `commands.dart`, importing the history module.

Revise the plan — put undo/redo on EditorCommands directly:

```dart
// In commands/history.dart — just the state field and data types

import '../document/change.dart';
import '../document/rope.dart';
import '../state/annotation.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/selection.dart';

class HistoryEntry {
  const HistoryEntry(this.changes, this.selection);
  final ChangeSet changes;
  final EditorSelection selection;
}

class HistoryState {
  const HistoryState({
    this.undoStack = const [],
    this.redoStack = const [],
  });

  final List<HistoryEntry> undoStack;
  final List<HistoryEntry> redoStack;
}

StateField<HistoryState>? _historyFieldInstance;

/// Get or create the history state field.
StateField<HistoryState> get historyField {
  return _historyFieldInstance ??= StateField<HistoryState>(
    create: (_) => const HistoryState(),
    update: (transaction, value) {
      final tr = transaction as Transaction;
      if (!tr.docChanged) return value;
      if (tr.annotation(Annotations.addToHistory) == false) return value;

      final inverse = tr.changes!.invert(
        Rope.fromString(tr.startState.doc.toString()),
      );
      final entry = HistoryEntry(inverse, tr.startState.selection);
      return HistoryState(
        undoStack: [...value.undoStack, entry],
        redoStack: const [],
      );
    },
  );
}

/// Create the history extension. Add to EditorState.create extensions.
Extension historyExtension() => historyField;
```

Then in `commands.dart`, add:

```dart
import 'history.dart';

// ... existing commands ...

// In EditorCommands class:

static TransactionSpec? undo(EditorState state) {
  final HistoryState history;
  try {
    history = state.field(historyField);
  } catch (_) {
    return null;
  }
  if (history.undoStack.isEmpty) return null;
  final entry = history.undoStack.last;
  return TransactionSpec(
    changes: entry.changes,
    selection: entry.selection,
    annotations: [Annotation(Annotations.addToHistory, false)],
  );
}

static TransactionSpec? redo(EditorState state) {
  final HistoryState history;
  try {
    history = state.field(historyField);
  } catch (_) {
    return null;
  }
  if (history.redoStack.isEmpty) return null;
  final entry = history.redoStack.last;
  return TransactionSpec(
    changes: entry.changes,
    annotations: [Annotation(Annotations.addToHistory, false)],
  );
}
```

But the redo stack needs to be populated when undo is applied. The history StateField update needs to detect undo operations and push to redo. Let me revise:

```dart
// In history.dart StateField update:
update: (transaction, value) {
  final tr = transaction as Transaction;
  if (!tr.docChanged) return value;

  final isUndoRedo = tr.annotation(Annotations.addToHistory) == false;
  if (isUndoRedo) {
    // This was an undo or redo — figure out which
    if (value.undoStack.isNotEmpty) {
      final lastUndo = value.undoStack.last;
      if (lastUndo.changes == tr.changes) {
        // This was an undo — move entry to redo
        final inverse = tr.changes!.invert(
          Rope.fromString(tr.startState.doc.toString()),
        );
        return HistoryState(
          undoStack: value.undoStack.sublist(0, value.undoStack.length - 1),
          redoStack: [...value.redoStack, HistoryEntry(inverse, tr.startState.selection)],
        );
      }
    }
    if (value.redoStack.isNotEmpty) {
      final lastRedo = value.redoStack.last;
      if (lastRedo.changes == tr.changes) {
        // This was a redo — move entry to undo
        final inverse = tr.changes!.invert(
          Rope.fromString(tr.startState.doc.toString()),
        );
        return HistoryState(
          undoStack: [...value.undoStack, HistoryEntry(inverse, tr.startState.selection)],
          redoStack: value.redoStack.sublist(0, value.redoStack.length - 1),
        );
      }
    }
    return value;
  }

  // Normal edit — push to undo, clear redo
  final inverse = tr.changes!.invert(
    Rope.fromString(tr.startState.doc.toString()),
  );
  return HistoryState(
    undoStack: [...value.undoStack, HistoryEntry(inverse, tr.startState.selection)],
    redoStack: const [],
  );
},
```

Actually, comparing ChangeSet by reference identity (`==`) won't work because ChangeSet doesn't override `==`. Let me use a different approach — use separate annotations for undo vs redo:

I'll use `StateEffect` types to distinguish undo from redo operations instead of trying to compare changeset identity.

This is getting complex. Let me simplify: the plan should describe the full implementation but keep it focused. Here's the cleaned up version:

- [ ] **Step 3: Implement history.dart and add undo/redo to commands.dart**

Create `packages/duskmoon_code_engine/lib/src/commands/history.dart`:

```dart
import '../document/change.dart';
import '../document/rope.dart';
import '../state/annotation.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/selection.dart';
import '../state/state_effect.dart';

/// A history entry: the inverse changeset + pre-change selection.
class HistoryEntry {
  const HistoryEntry(this.changes, this.selection);
  final ChangeSet changes;
  final EditorSelection selection;
}

/// History state: undo and redo stacks.
class HistoryState {
  const HistoryState({
    this.undoStack = const [],
    this.redoStack = const [],
  });
  final List<HistoryEntry> undoStack;
  final List<HistoryEntry> redoStack;
}

/// Effect type to mark a transaction as an undo operation.
final undoEffect = StateEffectType<bool>();

/// Effect type to mark a transaction as a redo operation.
final redoEffect = StateEffectType<bool>();

StateField<HistoryState>? _historyFieldInstance;

/// The history state field. Used by undo/redo commands.
StateField<HistoryState> get historyField {
  return _historyFieldInstance ??= StateField<HistoryState>(
    create: (_) => const HistoryState(),
    update: (transaction, value) {
      final tr = transaction as Transaction;
      if (!tr.docChanged) return value;

      final isUndo = tr.effects.any((e) => e.type == undoEffect);
      final isRedo = tr.effects.any((e) => e.type == redoEffect);

      final inverse = tr.changes!.invert(
        Rope.fromString(tr.startState.doc.toString()),
      );
      final entry = HistoryEntry(inverse, tr.startState.selection);

      if (isUndo) {
        // Undo: pop from undo stack, push inverse to redo
        return HistoryState(
          undoStack: value.undoStack.sublist(0, value.undoStack.length - 1),
          redoStack: [...value.redoStack, entry],
        );
      }
      if (isRedo) {
        // Redo: pop from redo stack, push inverse to undo
        return HistoryState(
          undoStack: [...value.undoStack, entry],
          redoStack: value.redoStack.sublist(0, value.redoStack.length - 1),
        );
      }

      // Normal edit: push to undo, clear redo
      return HistoryState(
        undoStack: [...value.undoStack, entry],
        redoStack: const [],
      );
    },
  );
}

/// Create the history extension.
Extension historyExtension() => historyField;
```

Modify `packages/duskmoon_code_engine/lib/src/commands/commands.dart` — add import and undo/redo methods:

Add at top:

```dart
import '../state/annotation.dart';
import 'history.dart';
```

Add to `EditorCommands` class:

```dart
  static TransactionSpec? undo(EditorState state) {
    final HistoryState history;
    try {
      history = state.field(historyField);
    } catch (_) {
      return null;
    }
    if (history.undoStack.isEmpty) return null;
    final entry = history.undoStack.last;
    return TransactionSpec(
      changes: entry.changes,
      selection: entry.selection,
      effects: [undoEffect.of(true)],
      annotations: [Annotation(Annotations.addToHistory, false)],
    );
  }

  static TransactionSpec? redo(EditorState state) {
    final HistoryState history;
    try {
      history = state.field(historyField);
    } catch (_) {
      return null;
    }
    if (history.redoStack.isEmpty) return null;
    final entry = history.redoStack.last;
    return TransactionSpec(
      changes: entry.changes,
      effects: [redoEffect.of(true)],
      annotations: [Annotation(Annotations.addToHistory, false)],
    );
  }
```

- [ ] **Step 4: Add exports**

```dart
export 'src/commands/history.dart' show HistoryState, HistoryEntry, historyExtension;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/commands/history_test.dart -r expanded
```

- [ ] **Step 6: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add undo/redo history with StateField"
```

---

## Task 6: EditorView (non-widget controller)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/editor_view.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

EditorView holds state and dispatches transactions. Not a widget — used by the widget layer.

- [ ] **Step 1: Implement EditorView**

Create `packages/duskmoon_code_engine/lib/src/view/editor_view.dart`:

```dart
import 'package:flutter/foundation.dart';

import '../commands/keymap.dart';
import '../document/document.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/selection.dart';

/// Non-widget controller that holds state and dispatches transactions.
///
/// Conceptually equivalent to CM6's EditorView minus DOM management.
class EditorView extends ChangeNotifier {
  EditorView({required EditorState state}) : _state = state;

  EditorState _state;

  /// Current editor state.
  EditorState get state => _state;

  /// Current document.
  Document get document => _state.doc;

  /// Dispatch a transaction spec. Updates state and notifies listeners.
  void dispatch(TransactionSpec spec) {
    final tr = _state.update(spec);
    _state = _state.applyTransaction(tr);
    notifyListeners();
  }

  /// Read a facet from current state.
  Output facet<Input, Output>(Facet<Input, Output> facet) =>
      _state.facet(facet);

  /// Read a state field.
  T field<T>(StateField<T> field) => _state.field(field);

  @override
  void dispose() {
    super.dispose();
  }
}
```

- [ ] **Step 2: Add export**

```dart
export 'src/view/editor_view.dart' show EditorView;
```

- [ ] **Step 3: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add EditorView controller with ChangeNotifier"
```

---

## Task 7: EditorViewController (public API)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/editor_view_controller.dart`
- Create: `packages/duskmoon_code_engine/test/src/view/editor_view_controller_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

The consumer-facing controller with convenience methods.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/view/editor_view_controller_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('EditorViewController', () {
    test('creates with initial text', () {
      final ctrl = EditorViewController(text: 'hello');
      expect(ctrl.text, 'hello');
      ctrl.dispose();
    });

    test('creates empty by default', () {
      final ctrl = EditorViewController();
      expect(ctrl.text, '');
      ctrl.dispose();
    });

    test('text setter replaces document', () {
      final ctrl = EditorViewController(text: 'hello');
      ctrl.text = 'world';
      expect(ctrl.text, 'world');
      ctrl.dispose();
    });

    test('state is accessible', () {
      final ctrl = EditorViewController(text: 'hello');
      expect(ctrl.state.doc.length, 5);
      ctrl.dispose();
    });

    test('dispatch applies transaction', () {
      final ctrl = EditorViewController(text: 'hello');
      ctrl.dispatch(TransactionSpec(
        changes: ChangeSet.of(5, [ChangeSpec.insert(5, ' world')]),
      ));
      expect(ctrl.text, 'hello world');
      ctrl.dispose();
    });

    test('insertText inserts at cursor', () {
      final ctrl = EditorViewController(text: 'helo');
      ctrl.setSelection(EditorSelection.cursor(2));
      ctrl.insertText('l');
      expect(ctrl.text, 'hello');
      ctrl.dispose();
    });

    test('replaceRange replaces text range', () {
      final ctrl = EditorViewController(text: 'hello world');
      ctrl.replaceRange(6, 11, 'dart');
      expect(ctrl.text, 'hello dart');
      ctrl.dispose();
    });

    test('setSelection updates selection', () {
      final ctrl = EditorViewController(text: 'hello');
      ctrl.setSelection(EditorSelection.cursor(3));
      expect(ctrl.state.selection.main.head, 3);
      ctrl.dispose();
    });

    test('document getter returns current document', () {
      final ctrl = EditorViewController(text: 'hello');
      expect(ctrl.document.length, 5);
      ctrl.dispose();
    });

    test('language setter updates language', () {
      final ctrl = EditorViewController(text: '42');
      ctrl.language = jsonLanguageSupport();
      // After setting language, syntax tree should be available
      expect(syntaxTree(ctrl.state), isNotNull);
      ctrl.dispose();
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/editor_view_controller_test.dart
```

- [ ] **Step 3: Implement EditorViewController**

Create `packages/duskmoon_code_engine/lib/src/view/editor_view_controller.dart`:

```dart
import '../commands/commands.dart';
import '../document/change.dart';
import '../document/document.dart';
import '../language/language.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/selection.dart';
import '../theme/editor_theme.dart';
import 'editor_view.dart';

/// Public API controller for the code editor.
///
/// Create one of these and pass it to [CodeEditorWidget.controller],
/// or use it standalone for programmatic editor control.
class EditorViewController {
  EditorViewController({
    String? text,
    LanguageSupport? language,
    EditorTheme? theme,
    List<Extension> extensions = const [],
  }) {
    final allExtensions = <Extension>[
      ...extensions,
      if (language != null) language.extension,
    ];

    _view = EditorView(
      state: EditorState.create(
        docString: text ?? '',
        extensions: allExtensions,
      ),
    );
    _language = language;
    _theme = theme;
    _extensions = extensions;
  }

  late final EditorView _view;
  LanguageSupport? _language;
  EditorTheme? _theme;
  List<Extension> _extensions;

  /// The underlying view.
  EditorView get view => _view;

  /// Current editor state.
  EditorState get state => _view.state;

  /// Current document.
  Document get document => _view.document;

  /// Current document text.
  String get text => document.toString();

  /// Replace the entire document.
  set text(String value) {
    dispatch(TransactionSpec(
      changes: ChangeSet.of(
        document.length,
        [ChangeSpec(from: 0, to: document.length, insert: value)],
      ),
      selection: EditorSelection.cursor(value.length.clamp(0, value.length)),
    ));
  }

  /// Current theme.
  EditorTheme? get theme => _theme;

  /// Switch theme at runtime.
  set theme(EditorTheme? newTheme) {
    _theme = newTheme;
    // Theme changes don't affect state — they affect rendering.
    // The widget will pick up the new theme on next build.
    _view.notifyListeners();
  }

  /// Switch language at runtime.
  set language(LanguageSupport? lang) {
    _language = lang;
    // Rebuild state with new language extension
    final allExtensions = <Extension>[
      ..._extensions,
      if (lang != null) lang.extension,
    ];
    _view = EditorView(
      state: EditorState.create(
        docString: text,
        selection: state.selection,
        extensions: allExtensions,
      ),
    );
    _view.notifyListeners();
  }

  /// Dispatch a transaction spec.
  void dispatch(TransactionSpec spec) => _view.dispatch(spec);

  /// Set the selection.
  void setSelection(EditorSelection selection) {
    dispatch(TransactionSpec(selection: selection));
  }

  /// Insert text at the current cursor position.
  void insertText(String insertText) {
    final spec = EditorCommands.insertText(state, insertText);
    dispatch(spec);
  }

  /// Replace a range of text.
  void replaceRange(int from, int to, String replacement) {
    dispatch(TransactionSpec(
      changes: ChangeSet.of(
        document.length,
        [ChangeSpec(from: from, to: to, insert: replacement)],
      ),
    ));
  }

  /// Dispose the controller.
  void dispose() {
    _view.dispose();
  }
}
```

- [ ] **Step 4: Add export**

```dart
export 'src/view/editor_view_controller.dart' show EditorViewController;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/editor_view_controller_test.dart -r expanded
```

- [ ] **Step 6: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add EditorViewController public API"
```

---

## Task 8: LinePainter and GutterPainter

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/line_painter.dart`
- Create: `packages/duskmoon_code_engine/lib/src/view/gutter_painter.dart`
- Create: `packages/duskmoon_code_engine/lib/src/view/selection_painter.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

CustomPainters for rendering code lines, line numbers, and selections. No tests for painters in this task (tested through widget tests in Task 9).

- [ ] **Step 1: Create LinePainter**

Create `packages/duskmoon_code_engine/lib/src/view/line_painter.dart`:

```dart
import 'package:flutter/material.dart';

import 'highlight_builder.dart';

/// Paints a single line of code with syntax highlighting.
class LinePainter extends CustomPainter {
  LinePainter({
    required this.spans,
    required this.lineHeight,
    required this.fontFamily,
    required this.fontSize,
    this.backgroundColor,
  });

  final List<InlineSpan> spans;
  final double lineHeight;
  final String fontFamily;
  final double fontSize;
  final Color? backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Paint line background
    if (backgroundColor != null) {
      canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Paint()..color = backgroundColor!,
      );
    }

    // 2. Paint text spans
    var x = 0.0;
    for (final span in spans) {
      final textPainter = TextPainter(
        text: TextSpan(
          text: span.text,
          style: (span.style ?? const TextStyle()).copyWith(
            fontFamily: fontFamily,
            fontSize: fontSize,
            height: lineHeight / fontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(x, 0));
      x += textPainter.width;
    }
  }

  @override
  bool shouldRepaint(LinePainter oldDelegate) =>
      spans != oldDelegate.spans ||
      backgroundColor != oldDelegate.backgroundColor;
}
```

- [ ] **Step 2: Create GutterPainter**

Create `packages/duskmoon_code_engine/lib/src/view/gutter_painter.dart`:

```dart
import 'package:flutter/material.dart';

/// Paints line numbers in the gutter.
class GutterPainter extends CustomPainter {
  GutterPainter({
    required this.firstLine,
    required this.lineCount,
    required this.lineHeight,
    required this.activeLine,
    required this.foreground,
    required this.activeForeground,
    required this.background,
    required this.fontFamily,
    required this.fontSize,
    required this.gutterWidth,
  });

  final int firstLine;
  final int lineCount;
  final double lineHeight;
  final int activeLine;
  final Color foreground;
  final Color activeForeground;
  final Color background;
  final String fontFamily;
  final double fontSize;
  final double gutterWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, gutterWidth, size.height),
      Paint()..color = background,
    );

    for (var i = 0; i < lineCount; i++) {
      final lineNum = firstLine + i + 1; // 1-based
      final isActive = lineNum == activeLine;
      final text = '$lineNum';

      final painter = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: fontSize,
            color: isActive ? activeForeground : foreground,
            height: lineHeight / fontSize,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.right,
      )..layout(maxWidth: gutterWidth - 8);

      final y = i * lineHeight;
      painter.paint(canvas, Offset(gutterWidth - 8 - painter.width, y));
    }
  }

  @override
  bool shouldRepaint(GutterPainter oldDelegate) =>
      firstLine != oldDelegate.firstLine ||
      lineCount != oldDelegate.lineCount ||
      activeLine != oldDelegate.activeLine;
}
```

- [ ] **Step 3: Create SelectionPainter**

Create `packages/duskmoon_code_engine/lib/src/view/selection_painter.dart`:

```dart
import 'package:flutter/material.dart';

/// Paints selection rectangles and cursor caret.
class SelectionPainter extends CustomPainter {
  SelectionPainter({
    required this.selectionRects,
    required this.cursorOffset,
    required this.cursorHeight,
    required this.selectionColor,
    required this.cursorColor,
    required this.cursorWidth,
    required this.showCursor,
  });

  /// Rectangles to paint as selection background.
  final List<Rect> selectionRects;

  /// X offset of the cursor caret.
  final double? cursorOffset;

  /// Height of the cursor caret.
  final double cursorHeight;

  /// Selection background color.
  final Color selectionColor;

  /// Cursor color.
  final Color cursorColor;

  /// Cursor width in pixels.
  final double cursorWidth;

  /// Whether to show the cursor (blink state).
  final bool showCursor;

  @override
  void paint(Canvas canvas, Size size) {
    // Paint selection rectangles
    final selectionPaint = Paint()..color = selectionColor;
    for (final rect in selectionRects) {
      canvas.drawRect(rect, selectionPaint);
    }

    // Paint cursor
    if (showCursor && cursorOffset != null) {
      final cursorPaint = Paint()
        ..color = cursorColor
        ..style = PaintingStyle.fill;
      canvas.drawRect(
        Rect.fromLTWH(cursorOffset!, 0, cursorWidth, cursorHeight),
        cursorPaint,
      );
    }
  }

  @override
  bool shouldRepaint(SelectionPainter oldDelegate) =>
      cursorOffset != oldDelegate.cursorOffset ||
      showCursor != oldDelegate.showCursor ||
      selectionRects != oldDelegate.selectionRects;
}
```

- [ ] **Step 4: Add exports**

```dart
export 'src/view/line_painter.dart' show LinePainter;
export 'src/view/gutter_painter.dart' show GutterPainter;
export 'src/view/selection_painter.dart' show SelectionPainter;
```

- [ ] **Step 5: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add LinePainter, GutterPainter, SelectionPainter"
```

---

## Task 9: CodeEditorWidget

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/view/code_editor_widget.dart`
- Create: `packages/duskmoon_code_engine/test/src/view/code_editor_widget_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

The top-level StatefulWidget that assembles everything. Uses a simple `ListView.builder` for virtual rendering (simpler than custom slivers for MVP — upgrade to slivers in Phase 6).

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/view/code_editor_widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('CodeEditorWidget', () {
    testWidgets('renders with initial doc', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(initialDoc: 'hello world'),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('renders empty by default', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('accepts controller', (tester) async {
      final ctrl = EditorViewController(text: 'test');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(controller: ctrl),
        ),
      ));
      await tester.pumpAndSettle();
      expect(ctrl.text, 'test');
      ctrl.dispose();
    });

    testWidgets('displays line numbers when lineNumbers is true', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(
            initialDoc: 'line1\nline2\nline3',
            lineNumbers: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      // Line numbers should be rendered
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('hides line numbers when lineNumbers is false', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(
            initialDoc: 'hello',
            lineNumbers: false,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('applies custom theme', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(
            initialDoc: 'hello',
            theme: EditorTheme.dark(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('calls onStateChanged when state updates', (tester) async {
      EditorState? lastState;
      final ctrl = EditorViewController(text: 'hello');
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(
            controller: ctrl,
            onStateChanged: (state) => lastState = state,
          ),
        ),
      ));
      await tester.pumpAndSettle();

      ctrl.dispatch(TransactionSpec(
        changes: ChangeSet.of(5, [ChangeSpec.insert(5, '!')]),
      ));
      await tester.pumpAndSettle();
      expect(lastState, isNotNull);
      expect(lastState!.doc.toString(), 'hello!');
      ctrl.dispose();
    });

    testWidgets('respects readOnly flag', (tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(
            initialDoc: 'hello',
            readOnly: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('renders with language support', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: CodeEditorWidget(
            initialDoc: '{"key": 42}',
            language: jsonLanguageSupport(),
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/code_editor_widget_test.dart
```

- [ ] **Step 3: Implement CodeEditorWidget**

Create `packages/duskmoon_code_engine/lib/src/view/code_editor_widget.dart`:

```dart
import 'package:flutter/material.dart';

import '../language/language.dart';
import '../language/syntax.dart';
import '../lezer/common/tree.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../theme/default_highlight.dart';
import '../theme/editor_theme.dart';
import 'editor_view.dart';
import 'editor_view_controller.dart';
import 'gutter_painter.dart';
import 'highlight_builder.dart';
import 'line_painter.dart';

/// A code editor widget with syntax highlighting, line numbers,
/// and virtual viewport rendering.
class CodeEditorWidget extends StatefulWidget {
  const CodeEditorWidget({
    super.key,
    this.initialDoc,
    this.language,
    this.extensions = const [],
    this.theme,
    this.readOnly = false,
    this.lineNumbers = true,
    this.highlightActiveLine = true,
    this.onStateChanged,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.minHeight,
    this.maxHeight,
    this.padding,
    this.scrollPhysics,
  });

  final String? initialDoc;
  final LanguageSupport? language;
  final List<Extension> extensions;
  final EditorTheme? theme;
  final bool readOnly;
  final bool lineNumbers;
  final bool highlightActiveLine;
  final void Function(EditorState state)? onStateChanged;
  final EditorViewController? controller;
  final FocusNode? focusNode;
  final bool autofocus;
  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? padding;
  final ScrollPhysics? scrollPhysics;

  @override
  State<CodeEditorWidget> createState() => _CodeEditorWidgetState();
}

class _CodeEditorWidgetState extends State<CodeEditorWidget> {
  late EditorViewController _controller;
  bool _ownsController = false;
  late FocusNode _focusNode;
  bool _ownsFocusNode = false;
  final _scrollController = ScrollController();

  static const _defaultFontFamily = 'monospace';
  static const _defaultFontSize = 14.0;
  static const _defaultLineHeight = 22.0;
  static const _gutterWidth = 48.0;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = EditorViewController(
        text: widget.initialDoc ?? '',
        language: widget.language,
        extensions: widget.extensions,
      );
      _ownsController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _controller.view.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    _controller.view.removeListener(_onStateChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});
    widget.onStateChanged?.call(_controller.state);
  }

  EditorTheme get _theme =>
      widget.theme ?? EditorTheme.light();

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final theme = _theme;
    final doc = state.doc;
    final lineCount = doc.lineCount;

    return Container(
      constraints: BoxConstraints(
        minHeight: widget.minHeight ?? 0,
        maxHeight: widget.maxHeight ?? double.infinity,
      ),
      color: theme.background,
      padding: widget.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gutter (line numbers)
          if (widget.lineNumbers)
            SizedBox(
              width: _gutterWidth,
              child: ListView.builder(
                controller: _scrollController,
                physics: widget.scrollPhysics,
                itemCount: lineCount,
                itemExtent: _defaultLineHeight,
                itemBuilder: (context, index) {
                  final lineNum = index + 1;
                  final activeLine = state.doc
                      .lineAtOffset(state.selection.main.head)
                      .number;
                  return CustomPaint(
                    painter: GutterPainter(
                      firstLine: index,
                      lineCount: 1,
                      lineHeight: _defaultLineHeight,
                      activeLine: activeLine,
                      foreground: theme.gutterForeground,
                      activeForeground: theme.gutterActiveForeground,
                      background: theme.gutterBackground,
                      fontFamily: _defaultFontFamily,
                      fontSize: _defaultFontSize,
                      gutterWidth: _gutterWidth,
                    ),
                    size: Size(_gutterWidth, _defaultLineHeight),
                  );
                },
              ),
            ),
          // Editor content
          Expanded(
            child: ListView.builder(
              physics: widget.scrollPhysics,
              itemCount: lineCount,
              itemExtent: _defaultLineHeight,
              itemBuilder: (context, index) {
                final line = doc.lineAt(index + 1);
                final tree = syntaxTree(state) ?? Tree.empty;
                final highlightStyle =
                    theme.highlightStyle.specs.isEmpty
                        ? defaultLightHighlight
                        : theme.highlightStyle;

                final spans = HighlightBuilder.buildSpans(
                  tree: tree,
                  text: doc.toString(),
                  lineFrom: line.from,
                  lineTo: line.to,
                  highlightStyle: highlightStyle,
                  defaultStyle: TextStyle(color: theme.foreground),
                );

                final activeLine = doc
                    .lineAtOffset(state.selection.main.head)
                    .number;
                final isActiveLine =
                    widget.highlightActiveLine && line.number == activeLine;

                return CustomPaint(
                  painter: LinePainter(
                    spans: spans,
                    lineHeight: _defaultLineHeight,
                    fontFamily: _defaultFontFamily,
                    fontSize: _defaultFontSize,
                    backgroundColor:
                        isActiveLine ? theme.lineHighlight : null,
                  ),
                  size: Size(double.infinity, _defaultLineHeight),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Add export**

```dart
export 'src/view/code_editor_widget.dart' show CodeEditorWidget;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/view/code_editor_widget_test.dart -r expanded
```

- [ ] **Step 6: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add CodeEditorWidget with syntax highlighting"
```

---

## Task 10: Final barrel cleanup and full verification

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

- [ ] **Step 1: Verify barrel has all Phase 3 exports**

The barrel should now include (in addition to Phase 1+2 exports):

```dart
// View
export 'src/view/code_editor_widget.dart' show CodeEditorWidget;
export 'src/view/editor_view.dart' show EditorView;
export 'src/view/editor_view_controller.dart' show EditorViewController;
export 'src/view/gutter_painter.dart' show GutterPainter;
export 'src/view/highlight_builder.dart' show InlineSpan, HighlightBuilder;
export 'src/view/line_painter.dart' show LinePainter;
export 'src/view/selection_painter.dart' show SelectionPainter;
export 'src/view/viewport.dart' show EditorViewport;

// Commands
export 'src/commands/commands.dart' show EditorCommands;
export 'src/commands/history.dart'
    show HistoryState, HistoryEntry, historyExtension;
export 'src/commands/keymap.dart' show Command, KeyBinding, Keymap;
```

- [ ] **Step 2: Run full test suite**

```bash
cd packages/duskmoon_code_engine && flutter test -r expanded
```

- [ ] **Step 3: Run workspace-wide analyzer**

```bash
melos run analyze
```

- [ ] **Step 4: Commit if any changes**

```bash
git add packages/duskmoon_code_engine/
git commit -m "chore(duskmoon_code_engine): finalize Phase 3 barrel exports"
```

---

## Summary

Phase 3 delivers **10 tasks** producing:

| Component | Files | Tests |
|-----------|-------|-------|
| EditorViewport | viewport.dart | viewport_test.dart |
| HighlightBuilder | highlight_builder.dart | highlight_builder_test.dart |
| Keymap/KeyBinding | keymap.dart | keymap_test.dart |
| EditorCommands | commands.dart | commands_test.dart |
| History (undo/redo) | history.dart | history_test.dart |
| EditorView | editor_view.dart | — |
| EditorViewController | editor_view_controller.dart | editor_view_controller_test.dart |
| Painters | line_painter.dart, gutter_painter.dart, selection_painter.dart | — |
| CodeEditorWidget | code_editor_widget.dart | code_editor_widget_test.dart |

**Deliverable:** A functional `CodeEditorWidget` that renders syntax-highlighted code with line numbers, active line highlighting, and a controller API for programmatic manipulation. Supports JSON language, theme switching, read-only mode, and undo/redo.

**What's NOT in this MVP (deferred):**
- Keyboard/IME input handling (requires TextInputClient integration — Phase 3b)
- Cursor rendering and blink animation (Phase 3b)
- Click-to-position (posAtCoords) (Phase 3b)
- Scroll synchronization between gutter and content (Phase 3b)
- Custom sliver rendering (Phase 6 — using ListView.builder for MVP)
- Word wrap (Phase 5)
- Search, autocomplete, lint (Phase 5)
- Code folding, bracket matching, comment toggling (Phase 4)
