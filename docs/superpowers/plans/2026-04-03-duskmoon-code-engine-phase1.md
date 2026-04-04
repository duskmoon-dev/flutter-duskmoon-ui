# duskmoon_code_engine Phase 1 — Foundation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build the foundational document model and state system for the code engine — rope data structure, immutable document, change sets, editor state, facets, state fields, and transactions. No rendering.

**Architecture:** Port of CodeMirror 6's core architecture to idiomatic Dart. Immutable state snapshots, functional transaction pipeline, facet-based extension system. Rope tree for O(log n) document operations. All types are pure Dart with zero external dependencies beyond Flutter SDK.

**Tech Stack:** Dart 3.5+, Flutter SDK (for test infrastructure only in this phase), flutter_lints

**Spec:** `docs/code-engine.md` sections 2-4

**Phases overview:** This is Phase 1 of 6. Phase 1 blocks all subsequent phases. Future plans:
- Phase 2: Lezer Runtime (parser port)
- Phase 3: View Layer (MVP editor widget)
- Phase 4: Language Ecosystem (21 grammars)
- Phase 5: Advanced Features (search, autocomplete, lint)
- Phase 6: Polish & Integration

---

## File Structure

```
packages/duskmoon_code_engine/
├── pubspec.yaml
├── analysis_options.yaml
├── LICENSE
├── lib/
│   ├── duskmoon_code_engine.dart              # barrel export
│   └── src/
│       ├── document/
│       │   ├── rope.dart                      # RopeNode, RopeLeaf, RopeBranch
│       │   ├── document.dart                  # Document (immutable, rope-backed)
│       │   ├── text.dart                      # Line class
│       │   ├── change.dart                    # ChangeSet, ChangeSpec, ChangeDesc
│       │   └── position.dart                  # Pos helpers
│       │
│       └── state/
│           ├── editor_state.dart              # EditorState
│           ├── transaction.dart               # Transaction, TransactionSpec
│           ├── selection.dart                 # EditorSelection, SelectionRange
│           ├── facet.dart                     # Facet<Input, Output>
│           ├── state_field.dart               # StateField<T>
│           ├── state_effect.dart              # StateEffect<T>
│           ├── extension.dart                 # Extension type + Precedence
│           ├── annotation.dart                # Annotation<T>
│           └── compartment.dart               # Compartment (dynamic reconfig)
│
├── test/
│   ├── src/
│   │   ├── document/
│   │   │   ├── rope_test.dart
│   │   │   ├── document_test.dart
│   │   │   └── change_test.dart
│   │   └── state/
│   │       ├── facet_test.dart
│   │       ├── editor_state_test.dart
│   │       └── selection_test.dart
```

---

## Task 1: Scaffold the package

**Files:**
- Create: `packages/duskmoon_code_engine/pubspec.yaml`
- Create: `packages/duskmoon_code_engine/analysis_options.yaml`
- Create: `packages/duskmoon_code_engine/LICENSE`
- Create: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`
- Modify: `pubspec.yaml` (root — add workspace member)

- [ ] **Step 1: Create package directory**

```bash
mkdir -p packages/duskmoon_code_engine/lib/src/document
mkdir -p packages/duskmoon_code_engine/lib/src/state
mkdir -p packages/duskmoon_code_engine/test/src/document
mkdir -p packages/duskmoon_code_engine/test/src/state
```

- [ ] **Step 2: Create pubspec.yaml**

Create `packages/duskmoon_code_engine/pubspec.yaml`:

```yaml
name: duskmoon_code_engine
description: >-
  Pure Dart code editor engine with incremental parsing —
  a ground-up port of the CodeMirror 6 architecture for Flutter.
version: 0.1.0
repository: https://github.com/duskmoon-dev/flutter_duskmoon_ui
issue_tracker: https://github.com/duskmoon-dev/flutter_duskmoon_ui/issues
publish_to: none
resolution: workspace
topics:
  - code-editor
  - syntax-highlighting
  - flutter
  - codemirror

environment:
  sdk: ">=3.5.0 <4.0.0"
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

- [ ] **Step 3: Create analysis_options.yaml**

Create `packages/duskmoon_code_engine/analysis_options.yaml`:

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    prefer_const_constructors: true
    prefer_const_declarations: true
    avoid_print: true
```

- [ ] **Step 4: Create LICENSE**

Copy the MIT license from `packages/duskmoon_theme/LICENSE` into `packages/duskmoon_code_engine/LICENSE`.

- [ ] **Step 5: Create barrel export (empty for now)**

Create `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`:

```dart
/// Pure Dart code editor engine with incremental parsing.
///
/// A ground-up port of the CodeMirror 6 architecture for Flutter,
/// providing: document model, state management, incremental parser,
/// virtual-viewport rendering, and syntax highlighting.
library;
```

- [ ] **Step 6: Add to workspace**

In root `pubspec.yaml`, add `packages/duskmoon_code_engine` to the `workspace:` list (after `packages/duskmoon_form`).

- [ ] **Step 7: Run `dart pub get` and verify**

```bash
dart pub get
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

Expected: Clean analysis, no errors.

- [ ] **Step 8: Commit**

```bash
git add packages/duskmoon_code_engine/ pubspec.yaml
git commit -m "chore(duskmoon_code_engine): scaffold package with pubspec and barrel export"
```

---

## Task 2: Rope data structure

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/document/rope.dart`
- Create: `packages/duskmoon_code_engine/test/src/document/rope_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

The rope is the core data structure — an immutable balanced tree for O(log n) text operations. Leaves hold <=1KB of text. Internal nodes cache length and line count.

- [ ] **Step 1: Write failing tests for RopeNode basics**

Create `packages/duskmoon_code_engine/test/src/document/rope_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('RopeNode', () {
    group('RopeLeaf', () {
      test('stores text and reports length', () {
        final leaf = RopeLeaf('hello');
        expect(leaf.length, 5);
        expect(leaf.text, 'hello');
      });

      test('reports line count for single line', () {
        final leaf = RopeLeaf('hello');
        expect(leaf.lineCount, 1);
      });

      test('counts newlines for line count', () {
        final leaf = RopeLeaf('hello\nworld\n');
        expect(leaf.lineCount, 3);
      });

      test('empty text has length 0 and 1 line', () {
        final leaf = RopeLeaf('');
        expect(leaf.length, 0);
        expect(leaf.lineCount, 1);
      });
    });

    group('RopeBranch', () {
      test('combines length of children', () {
        final left = RopeLeaf('hello');
        final right = RopeLeaf(' world');
        final branch = RopeBranch(left, right);
        expect(branch.length, 11);
      });

      test('combines line count of children (subtract 1 overlap)', () {
        // "hello\n" has 2 lines, "world" has 1 line
        // Combined "hello\nworld" has 2 lines, not 3
        final left = RopeLeaf('hello\n');
        final right = RopeLeaf('world');
        final branch = RopeBranch(left, right);
        expect(branch.lineCount, 2);
      });

      test('line count with newlines in both children', () {
        // "a\nb\n" (3 lines) + "c\nd" (2 lines)
        // Combined "a\nb\nc\nd" has 4 lines
        final left = RopeLeaf('a\nb\n');
        final right = RopeLeaf('c\nd');
        final branch = RopeBranch(left, right);
        expect(branch.lineCount, 4);
      });
    });
  });

  group('Rope', () {
    group('fromString', () {
      test('creates leaf for short text', () {
        final rope = Rope.fromString('hello');
        expect(rope.length, 5);
        expect(rope.lineCount, 1);
      });

      test('creates tree for text exceeding leaf size', () {
        // Create text larger than max leaf size (1024 bytes)
        final longText = 'a' * 2000;
        final rope = Rope.fromString(longText);
        expect(rope.length, 2000);
      });

      test('empty string creates empty leaf', () {
        final rope = Rope.fromString('');
        expect(rope.length, 0);
        expect(rope.lineCount, 1);
      });
    });

    group('charAt', () {
      test('returns character at offset', () {
        final rope = Rope.fromString('hello');
        expect(rope.charAt(0), 'h');
        expect(rope.charAt(4), 'o');
      });

      test('works across branch boundaries', () {
        final longText = 'a' * 1024 + 'XYZ';
        final rope = Rope.fromString(longText);
        expect(rope.charAt(1024), 'X');
        expect(rope.charAt(1025), 'Y');
        expect(rope.charAt(1026), 'Z');
      });
    });

    group('sliceString', () {
      test('returns substring', () {
        final rope = Rope.fromString('hello world');
        expect(rope.sliceString(0, 5), 'hello');
        expect(rope.sliceString(6, 11), 'world');
        expect(rope.sliceString(0, 11), 'hello world');
      });

      test('sliceString to end when to is omitted', () {
        final rope = Rope.fromString('hello');
        expect(rope.sliceString(3), 'lo');
      });

      test('works across branch boundaries', () {
        final text = 'a' * 1020 + 'BOUNDARY' + 'b' * 1020;
        final rope = Rope.fromString(text);
        expect(rope.sliceString(1020, 1028), 'BOUNDARY');
      });
    });

    group('splice', () {
      test('inserts text at offset', () {
        final rope = Rope.fromString('helo');
        final result = rope.splice(2, 2, 'llo');
        expect(result.sliceString(0), 'hello');
      });

      test('deletes text range', () {
        final rope = Rope.fromString('hello world');
        final result = rope.splice(5, 11, '');
        expect(result.sliceString(0), 'hello');
      });

      test('replaces text range', () {
        final rope = Rope.fromString('hello world');
        final result = rope.splice(6, 11, 'dart');
        expect(result.sliceString(0), 'hello dart');
      });

      test('inserts at beginning', () {
        final rope = Rope.fromString('world');
        final result = rope.splice(0, 0, 'hello ');
        expect(result.sliceString(0), 'hello world');
      });

      test('inserts at end', () {
        final rope = Rope.fromString('hello');
        final result = rope.splice(5, 5, ' world');
        expect(result.sliceString(0), 'hello world');
      });

      test('updates line count after insert with newlines', () {
        final rope = Rope.fromString('hello');
        final result = rope.splice(5, 5, '\nworld');
        expect(result.lineCount, 2);
      });

      test('updates line count after deleting newlines', () {
        final rope = Rope.fromString('hello\nworld');
        final result = rope.splice(5, 6, ' ');
        expect(result.lineCount, 1);
        expect(result.sliceString(0), 'hello world');
      });
    });

    group('lineAt', () {
      test('returns line by 1-based number', () {
        final rope = Rope.fromString('hello\nworld\nfoo');
        final line1 = rope.lineAt(1);
        expect(line1.text, 'hello');
        expect(line1.from, 0);
        expect(line1.to, 5);

        final line2 = rope.lineAt(2);
        expect(line2.text, 'world');
        expect(line2.from, 6);
        expect(line2.to, 11);

        final line3 = rope.lineAt(3);
        expect(line3.text, 'foo');
        expect(line3.from, 12);
        expect(line3.to, 15);
      });

      test('single line document', () {
        final rope = Rope.fromString('hello');
        final line = rope.lineAt(1);
        expect(line.text, 'hello');
        expect(line.from, 0);
        expect(line.to, 5);
        expect(line.number, 1);
      });
    });

    group('lineAtOffset', () {
      test('returns line containing character offset', () {
        final rope = Rope.fromString('hello\nworld');
        expect(rope.lineAtOffset(0).number, 1);
        expect(rope.lineAtOffset(5).number, 1);
        expect(rope.lineAtOffset(6).number, 2);
        expect(rope.lineAtOffset(10).number, 2);
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/document/rope_test.dart
```

Expected: Compilation errors — `RopeLeaf`, `RopeBranch`, `Rope` not defined.

- [ ] **Step 3: Implement Line class**

Create `packages/duskmoon_code_engine/lib/src/document/text.dart`:

```dart
/// A single line in a document.
class Line {
  const Line({
    required this.number,
    required this.from,
    required this.to,
    required this.text,
  });

  /// 1-based line number.
  final int number;

  /// Start offset (inclusive).
  final int from;

  /// End offset (exclusive, before newline).
  final int to;

  /// Line text content (without trailing newline).
  final String text;

  /// Character length of this line.
  int get length => to - from;

  @override
  String toString() => 'Line($number, $from..$to, "$text")';
}
```

- [ ] **Step 4: Implement Rope**

Create `packages/duskmoon_code_engine/lib/src/document/rope.dart`:

```dart
import 'dart:math' as math;

import 'text.dart';

/// Maximum characters in a leaf node.
const int maxLeafSize = 1024;

/// Immutable rope node. Balanced tree for O(log n) text operations.
sealed class RopeNode {
  const RopeNode();

  /// Total character length.
  int get length;

  /// Number of lines (always >= 1). Counts newline characters + 1.
  int get lineCount;
}

/// Leaf node holding up to [maxLeafSize] characters.
final class RopeLeaf extends RopeNode {
  const RopeLeaf(this.text);

  final String text;

  @override
  int get length => text.length;

  @override
  int get lineCount {
    var count = 1;
    for (var i = 0; i < text.length; i++) {
      if (text.codeUnitAt(i) == 0x0A) count++;
    }
    return count;
  }
}

/// Internal node with left and right children and cached aggregates.
final class RopeBranch extends RopeNode {
  RopeBranch(this.left, this.right)
      : length = left.length + right.length,
        lineCount = left.lineCount + right.lineCount - 1;

  final RopeNode left;
  final RopeNode right;

  @override
  final int length;

  @override
  final int lineCount;
}

/// Facade over [RopeNode] providing document-level operations.
class Rope {
  const Rope._(this._root);

  final RopeNode _root;

  /// Total character length.
  int get length => _root.length;

  /// Number of lines (always >= 1).
  int get lineCount => _root.lineCount;

  /// Build a rope from a plain string.
  factory Rope.fromString(String text) {
    return Rope._(_buildFromString(text, 0, text.length));
  }

  /// Character at [offset].
  String charAt(int offset) {
    return sliceString(offset, offset + 1);
  }

  /// Extract a substring from [from] to [to].
  /// If [to] is omitted, extracts to the end.
  String sliceString(int from, [int? to]) {
    to ??= length;
    final buf = StringBuffer();
    _sliceInto(buf, _root, from, to, 0);
    return buf.toString();
  }

  /// Replace the range [from]..[to] with [insert].
  /// Returns a new Rope (immutable).
  Rope splice(int from, int to, String insert) {
    final pieces = <RopeNode>[];

    // Left part: [0, from)
    if (from > 0) {
      pieces.add(_extractNode(_root, 0, from));
    }

    // Inserted text
    if (insert.isNotEmpty) {
      pieces.add(_buildFromString(insert, 0, insert.length));
    }

    // Right part: [to, length)
    if (to < length) {
      pieces.add(_extractNode(_root, to, length));
    }

    if (pieces.isEmpty) {
      return Rope._(const RopeLeaf(''));
    }

    return Rope._(_mergeNodes(pieces));
  }

  /// Get line by 1-based [lineNumber].
  Line lineAt(int lineNumber) {
    assert(lineNumber >= 1 && lineNumber <= lineCount);
    final fullText = sliceString(0);
    var lineStart = 0;
    var currentLine = 1;

    for (var i = 0; i < fullText.length; i++) {
      if (currentLine == lineNumber) {
        // Find end of this line
        var end = i;
        while (end < fullText.length && fullText.codeUnitAt(end) != 0x0A) {
          end++;
        }
        return Line(
          number: lineNumber,
          from: lineStart,
          to: end,
          text: fullText.substring(i, end),
        );
      }
      if (fullText.codeUnitAt(i) == 0x0A) {
        currentLine++;
        lineStart = i + 1;
      }
    }

    // Last line (no trailing newline)
    return Line(
      number: lineNumber,
      from: lineStart,
      to: fullText.length,
      text: fullText.substring(lineStart),
    );
  }

  /// Get the line containing character [offset].
  Line lineAtOffset(int offset) {
    assert(offset >= 0 && offset <= length);
    final fullText = sliceString(0);
    var lineStart = 0;
    var currentLine = 1;

    for (var i = 0; i < fullText.length; i++) {
      if (i == offset) {
        // Find end of this line
        var end = i;
        while (end < fullText.length && fullText.codeUnitAt(end) != 0x0A) {
          end++;
        }
        return Line(
          number: currentLine,
          from: lineStart,
          to: end,
          text: fullText.substring(lineStart, end),
        );
      }
      if (fullText.codeUnitAt(i) == 0x0A) {
        if (offset <= i) {
          return Line(
            number: currentLine,
            from: lineStart,
            to: i,
            text: fullText.substring(lineStart, i),
          );
        }
        currentLine++;
        lineStart = i + 1;
      }
    }

    // Offset at or past end — return last line
    return Line(
      number: currentLine,
      from: lineStart,
      to: fullText.length,
      text: fullText.substring(lineStart),
    );
  }

  /// Iterate lines in the range [fromLine]..[toLine] (1-based, inclusive).
  Iterable<Line> linesInRange(int fromLine, int toLine) sync* {
    for (var i = fromLine; i <= toLine; i++) {
      yield lineAt(i);
    }
  }

  // --- internal helpers ---

  static RopeNode _buildFromString(String text, int start, int end) {
    final len = end - start;
    if (len <= maxLeafSize) {
      return RopeLeaf(text.substring(start, end));
    }
    final mid = start + len ~/ 2;
    // Don't split in the middle of a \r\n sequence
    final splitAt =
        (mid < end && text.codeUnitAt(mid) == 0x0A && mid > start)
            ? mid
            : mid;
    return RopeBranch(
      _buildFromString(text, start, splitAt),
      _buildFromString(text, splitAt, end),
    );
  }

  static void _sliceInto(
    StringBuffer buf,
    RopeNode node,
    int from,
    int to,
    int nodeStart,
  ) {
    switch (node) {
      case RopeLeaf(:final text):
        final localFrom = math.max(0, from - nodeStart);
        final localTo = math.min(text.length, to - nodeStart);
        if (localFrom < localTo) {
          buf.write(text.substring(localFrom, localTo));
        }
      case RopeBranch(:final left, :final right):
        final leftEnd = nodeStart + left.length;
        if (from < leftEnd) {
          _sliceInto(buf, left, from, to, nodeStart);
        }
        if (to > leftEnd) {
          _sliceInto(buf, right, from, to, leftEnd);
        }
    }
  }

  static RopeNode _extractNode(RopeNode node, int from, int to) {
    if (from == 0 && to == node.length) return node;
    switch (node) {
      case RopeLeaf(:final text):
        return RopeLeaf(text.substring(from, to));
      case RopeBranch(:final left, :final right):
        final leftLen = left.length;
        if (to <= leftLen) {
          return _extractNode(left, from, to);
        } else if (from >= leftLen) {
          return _extractNode(right, from - leftLen, to - leftLen);
        } else {
          return RopeBranch(
            _extractNode(left, from, leftLen),
            _extractNode(right, 0, to - leftLen),
          );
        }
    }
  }

  static RopeNode _mergeNodes(List<RopeNode> nodes) {
    if (nodes.length == 1) return nodes[0];
    final mid = nodes.length ~/ 2;
    return RopeBranch(
      _mergeNodes(nodes.sublist(0, mid)),
      _mergeNodes(nodes.sublist(mid)),
    );
  }
}
```

- [ ] **Step 5: Add exports to barrel**

In `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`, add:

```dart
// Document model
export 'src/document/rope.dart' show RopeNode, RopeLeaf, RopeBranch, Rope;
export 'src/document/text.dart' show Line;
```

- [ ] **Step 6: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/document/rope_test.dart -r expanded
```

Expected: All tests pass.

- [ ] **Step 7: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

Expected: No issues found.

- [ ] **Step 8: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Rope data structure with immutable splice"
```

---

## Task 3: Position helpers

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/document/position.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Simple value types used throughout — no test file needed since they're trivially correct data classes.

- [ ] **Step 1: Create position.dart**

Create `packages/duskmoon_code_engine/lib/src/document/position.dart`:

```dart
/// A character offset position in a document.
typedef Pos = int;

/// A from/to range in a document.
class Range {
  const Range(this.from, [int? to]) : to = to ?? from;

  /// Start offset (inclusive).
  final int from;

  /// End offset (exclusive).
  final int to;

  /// Whether this range is collapsed (cursor, no selection).
  bool get isEmpty => from == to;

  /// Number of characters in this range.
  int get length => to - from;

  @override
  bool operator ==(Object other) =>
      other is Range && from == other.from && to == other.to;

  @override
  int get hashCode => Object.hash(from, to);

  @override
  String toString() => 'Range($from, $to)';
}
```

- [ ] **Step 2: Add export**

In barrel, add:

```dart
export 'src/document/position.dart' show Pos, Range;
```

- [ ] **Step 3: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Pos and Range position types"
```

---

## Task 4: ChangeSet

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/document/change.dart`
- Create: `packages/duskmoon_code_engine/test/src/document/change_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

ChangeSet is the core edit representation — a compact sequence of retained/inserted/deleted spans. Mirrors CM6's ChangeSet.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/document/change_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('ChangeSpec', () {
    test('insert creates spec with same from/to', () {
      final spec = ChangeSpec.insert(5, 'hello');
      expect(spec.from, 5);
      expect(spec.to, 5);
      expect(spec.insert, 'hello');
    });

    test('delete creates spec with no insert', () {
      final spec = ChangeSpec(from: 5, to: 10);
      expect(spec.from, 5);
      expect(spec.to, 10);
      expect(spec.insert, '');
    });

    test('replace creates spec with from, to, and insert', () {
      final spec = ChangeSpec(from: 5, to: 10, insert: 'new');
      expect(spec.from, 5);
      expect(spec.to, 10);
      expect(spec.insert, 'new');
    });
  });

  group('ChangeSet', () {
    group('of', () {
      test('creates changeset for single insertion', () {
        final cs = ChangeSet.of(10, [ChangeSpec.insert(5, 'abc')]);
        expect(cs.newLength, 13);
      });

      test('creates changeset for single deletion', () {
        final cs = ChangeSet.of(10, [ChangeSpec(from: 3, to: 7)]);
        expect(cs.newLength, 6);
      });

      test('creates changeset for replacement', () {
        final cs = ChangeSet.of(
          10,
          [ChangeSpec(from: 3, to: 7, insert: 'XY')],
        );
        expect(cs.newLength, 8);
      });

      test('identity changeset for no changes', () {
        final cs = ChangeSet.of(10, []);
        expect(cs.newLength, 10);
        expect(cs.docChanged, false);
      });
    });

    group('apply', () {
      test('applies insertion to rope', () {
        final rope = Rope.fromString('hello world');
        final cs = ChangeSet.of(
          11,
          [ChangeSpec.insert(5, ' beautiful')],
        );
        final result = cs.apply(rope);
        expect(result.sliceString(0), 'hello beautiful world');
      });

      test('applies deletion to rope', () {
        final rope = Rope.fromString('hello world');
        final cs = ChangeSet.of(11, [ChangeSpec(from: 5, to: 11)]);
        final result = cs.apply(rope);
        expect(result.sliceString(0), 'hello');
      });

      test('applies replacement to rope', () {
        final rope = Rope.fromString('hello world');
        final cs = ChangeSet.of(
          11,
          [ChangeSpec(from: 6, to: 11, insert: 'dart')],
        );
        final result = cs.apply(rope);
        expect(result.sliceString(0), 'hello dart');
      });

      test('applies multiple changes (sorted order)', () {
        final rope = Rope.fromString('abcdefghij');
        final cs = ChangeSet.of(10, [
          ChangeSpec(from: 2, to: 4, insert: 'XX'),
          ChangeSpec(from: 7, to: 9, insert: 'YY'),
        ]);
        final result = cs.apply(rope);
        expect(result.sliceString(0), 'abXXefgYYj');
      });
    });

    group('mapPos', () {
      test('maps position before change', () {
        final cs = ChangeSet.of(10, [ChangeSpec.insert(5, 'abc')]);
        expect(cs.mapPos(3), 3);
      });

      test('maps position after insertion', () {
        final cs = ChangeSet.of(10, [ChangeSpec.insert(5, 'abc')]);
        expect(cs.mapPos(7), 10);
      });

      test('maps position at insertion point defaults to after', () {
        final cs = ChangeSet.of(10, [ChangeSpec.insert(5, 'abc')]);
        // Default assoc = 1 (map to after insertion)
        expect(cs.mapPos(5), 8);
      });

      test('maps position at insertion point with assoc=-1 to before', () {
        final cs = ChangeSet.of(10, [ChangeSpec.insert(5, 'abc')]);
        expect(cs.mapPos(5, assoc: -1), 5);
      });

      test('maps position after deletion', () {
        final cs = ChangeSet.of(10, [ChangeSpec(from: 3, to: 7)]);
        expect(cs.mapPos(8), 4);
      });

      test('maps position inside deleted range to from', () {
        final cs = ChangeSet.of(10, [ChangeSpec(from: 3, to: 7)]);
        expect(cs.mapPos(5), 3);
      });
    });

    group('compose', () {
      test('composes two sequential insertions', () {
        final rope = Rope.fromString('hello');
        final cs1 = ChangeSet.of(5, [ChangeSpec.insert(5, ' world')]);
        final cs2 = ChangeSet.of(11, [ChangeSpec.insert(11, '!')]);
        final composed = cs1.compose(cs2);
        final result = composed.apply(rope);
        expect(result.sliceString(0), 'hello world!');
      });

      test('composes insertion then deletion', () {
        final rope = Rope.fromString('hello world');
        final cs1 = ChangeSet.of(11, [ChangeSpec.insert(5, ' beautiful')]);
        // After cs1: "hello beautiful world" (21 chars)
        // Delete " beautiful" (pos 5..15)
        final cs2 = ChangeSet.of(21, [ChangeSpec(from: 5, to: 15)]);
        final composed = cs1.compose(cs2);
        final result = composed.apply(rope);
        expect(result.sliceString(0), 'hello world');
      });
    });

    group('invert', () {
      test('inverts an insertion (becomes deletion)', () {
        final rope = Rope.fromString('hello');
        final cs = ChangeSet.of(5, [ChangeSpec.insert(5, ' world')]);
        final newRope = cs.apply(rope);
        final inverted = cs.invert(rope);
        final restored = inverted.apply(newRope);
        expect(restored.sliceString(0), 'hello');
      });

      test('inverts a deletion (becomes insertion)', () {
        final rope = Rope.fromString('hello world');
        final cs = ChangeSet.of(11, [ChangeSpec(from: 5, to: 11)]);
        final newRope = cs.apply(rope);
        final inverted = cs.invert(rope);
        final restored = inverted.apply(newRope);
        expect(restored.sliceString(0), 'hello world');
      });

      test('inverts a replacement', () {
        final rope = Rope.fromString('hello world');
        final cs = ChangeSet.of(
          11,
          [ChangeSpec(from: 6, to: 11, insert: 'dart')],
        );
        final newRope = cs.apply(rope);
        final inverted = cs.invert(rope);
        final restored = inverted.apply(newRope);
        expect(restored.sliceString(0), 'hello world');
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/document/change_test.dart
```

Expected: Compilation errors — `ChangeSpec`, `ChangeSet` not defined.

- [ ] **Step 3: Implement ChangeSpec and ChangeSet**

Create `packages/duskmoon_code_engine/lib/src/document/change.dart`:

```dart
import 'rope.dart';

/// Describes a single change: replace [from]..[to] with [insert].
class ChangeSpec {
  const ChangeSpec({required this.from, int? to, this.insert = ''})
      : to = to ?? from;

  /// Shorthand for pure insertion at [pos].
  const ChangeSpec.insert(int pos, String text)
      : from = pos,
        to = pos,
        insert = text;

  final int from;
  final int to;
  final String insert;

  /// Number of characters deleted.
  int get deleteLen => to - from;
}

/// A compact representation of a document edit as a sequence of
/// retained/inserted/deleted spans. Mirrors CM6's ChangeSet.
///
/// Internally stored as [_sections]: a list of integers where
/// positive values mean "retain N chars" and negative values mean
/// "delete N chars". [_inserted] is aligned to sections — each
/// section that deletes (or replaces) has a corresponding inserted
/// string (empty string for pure deletion).
class ChangeSet {
  ChangeSet._(this._sections, this._inserted, this._oldLength);

  final List<int> _sections;
  final List<String> _inserted;
  final int _oldLength;

  /// The document length before this change.
  int get oldLength => _oldLength;

  /// The document length after this change.
  int get newLength {
    var len = 0;
    var insertIdx = 0;
    for (final sec in _sections) {
      if (sec > 0) {
        len += sec;
      } else {
        len += _inserted[insertIdx].length;
        insertIdx++;
      }
    }
    return len;
  }

  /// Whether this changeset modifies the document.
  bool get docChanged =>
      _sections.any((s) => s < 0) || _inserted.any((s) => s.isNotEmpty);

  /// Create a ChangeSet from a list of [ChangeSpec]s applied to a
  /// document of [docLength]. Specs must be in document order and
  /// non-overlapping.
  factory ChangeSet.of(int docLength, List<ChangeSpec> changes) {
    if (changes.isEmpty) {
      return ChangeSet._([docLength], [], docLength);
    }

    final sections = <int>[];
    final inserted = <String>[];
    var pos = 0;

    for (final change in changes) {
      // Retain everything before this change
      if (change.from > pos) {
        sections.add(change.from - pos);
      }

      // Record the deletion (negative) and insertion
      final deleteLen = change.to - change.from;
      if (deleteLen > 0 || change.insert.isNotEmpty) {
        sections.add(-deleteLen);
        inserted.add(change.insert);
      }

      pos = change.to;
    }

    // Retain everything after the last change
    if (pos < docLength) {
      sections.add(docLength - pos);
    }

    return ChangeSet._(sections, inserted, docLength);
  }

  /// Apply this changeset to a [Rope], producing a new Rope.
  Rope apply(Rope rope) {
    assert(rope.length == _oldLength);
    var result = rope;
    var posInOld = 0;
    var posInNew = 0;
    var insertIdx = 0;
    // We need to track cumulative offset shift
    var offset = 0;

    for (final sec in _sections) {
      if (sec > 0) {
        // Retain
        posInOld += sec;
        posInNew += sec;
      } else {
        // Delete -sec chars, insert _inserted[insertIdx]
        final deleteLen = -sec;
        final ins = _inserted[insertIdx];
        insertIdx++;
        result = result.splice(
          posInOld + offset,
          posInOld + offset + deleteLen,
          ins,
        );
        offset += ins.length - deleteLen;
        posInOld += deleteLen;
        posInNew += ins.length;
      }
    }
    return result;
  }

  /// Map a position through this change.
  /// [assoc] determines where positions at insertion boundaries land:
  /// 1 (default) maps to after the insertion, -1 maps to before.
  int mapPos(int pos, {int assoc = 1}) {
    var oldPos = 0;
    var newPos = 0;
    var insertIdx = 0;

    for (final sec in _sections) {
      if (sec > 0) {
        // Retain
        if (pos <= oldPos + sec) {
          return newPos + (pos - oldPos);
        }
        oldPos += sec;
        newPos += sec;
      } else {
        final deleteLen = -sec;
        final ins = _inserted[insertIdx];
        insertIdx++;

        if (pos <= oldPos) {
          // Position is before this change
          return newPos + (assoc < 0 ? 0 : ins.length);
        }
        if (pos < oldPos + deleteLen) {
          // Position is inside deleted range
          return newPos + (assoc < 0 ? 0 : ins.length);
        }
        if (pos == oldPos + deleteLen && pos == oldPos) {
          // Pure insertion at this exact position
          return newPos + (assoc < 0 ? 0 : ins.length);
        }

        oldPos += deleteLen;
        newPos += ins.length;
      }
    }

    return newPos;
  }

  /// Compose this changeset with [other] (applied sequentially after this).
  /// Returns a single changeset equivalent to applying both.
  ChangeSet compose(ChangeSet other) {
    assert(newLength == other._oldLength);
    // Simple implementation: apply both to track position mapping
    // Build a new changeset from original doc to final doc
    final sections = <int>[];
    final inserted = <String>[];

    var posA = 0; // position in original doc
    var posB = 0; // position in intermediate doc
    var idxA = 0; // section index in this
    var idxB = 0; // section index in other
    var insIdxA = 0;
    var insIdxB = 0;

    // Remaining length in current section of A and B
    var remA = idxA < _sections.length ? _sections[idxA] : 0;
    var remB = idxB < other._sections.length ? other._sections[idxB] : 0;

    void advanceA() {
      idxA++;
      if (idxA < _sections.length) {
        remA = _sections[idxA];
      } else {
        remA = 0;
      }
    }

    void advanceB() {
      idxB++;
      if (idxB < other._sections.length) {
        remB = other._sections[idxB];
      } else {
        remB = 0;
      }
    }

    // Bootstrap: load first sections
    if (_sections.isNotEmpty) remA = _sections[0];
    if (other._sections.isNotEmpty) remB = other._sections[0];

    while (idxA < _sections.length || idxB < other._sections.length) {
      if (remA == 0 && idxA < _sections.length) {
        advanceA();
        continue;
      }
      if (remB == 0 && idxB < other._sections.length) {
        advanceB();
        continue;
      }
      if (idxA >= _sections.length && idxB >= other._sections.length) break;

      if (remA > 0 && remB > 0) {
        // Both retaining — take the minimum
        final take = remA < remB ? remA : remB;
        sections.add(take);
        remA -= take;
        remB -= take;
      } else if (remA < 0 && remB > 0) {
        // A deletes, B retains through A's insertion
        final aIns = _inserted[insIdxA];
        if (aIns.isEmpty) {
          // Pure deletion in A — consume from A, doesn't interact with B
          sections.add(remA); // pass through the deletion
          inserted.add('');
          insIdxA++;
          remA = 0;
        } else {
          // A replaces/inserts text that B retains
          final take = remB < aIns.length ? remB : aIns.length;
          sections.add(_sections[idxA]);
          inserted.add(aIns);
          insIdxA++;
          remA = 0;
          remB -= aIns.length;
        }
      } else if (remA > 0 && remB < 0) {
        // A retains, B deletes — take from the retained portion
        final deleteLen = -remB;
        final take = remA < deleteLen ? remA : deleteLen;
        sections.add(-take);
        inserted.add(other._inserted[insIdxB]);
        insIdxB++;
        remA -= take;
        remB = 0;
      } else {
        // Both negative — this gets complex; use simple approach
        // Just record A's deletion and B's deletion
        if (remA < 0) {
          sections.add(remA);
          inserted.add(_inserted[insIdxA]);
          insIdxA++;
          remA = 0;
        }
        if (remB < 0) {
          sections.add(remB);
          inserted.add(other._inserted[insIdxB]);
          insIdxB++;
          remB = 0;
        }
      }
    }

    return ChangeSet._(sections, inserted, _oldLength);
  }

  /// Create the inverse of this changeset, given the original document.
  /// Applying the inverse to the changed document restores the original.
  ChangeSet invert(Rope originalDoc) {
    final sections = <int>[];
    final inv = <String>[];
    var pos = 0;
    var insertIdx = 0;

    for (final sec in _sections) {
      if (sec > 0) {
        sections.add(sec);
        pos += sec;
      } else {
        final deleteLen = -sec;
        final insText = _inserted[insertIdx];
        insertIdx++;
        // Original text that was deleted
        final deleted = originalDoc.sliceString(pos, pos + deleteLen);
        // Inverse: delete the inserted text, insert the original text
        sections.add(-insText.length);
        inv.add(deleted);
        pos += deleteLen;
      }
    }

    return ChangeSet._(sections, inv, newLength);
  }
}
```

- [ ] **Step 4: Add exports to barrel**

In barrel, add:

```dart
export 'src/document/change.dart' show ChangeSpec, ChangeSet;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/document/change_test.dart -r expanded
```

Expected: All tests pass.

- [ ] **Step 6: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add ChangeSet with apply, mapPos, compose, invert"
```

---

## Task 5: Document (immutable facade)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/document/document.dart`
- Create: `packages/duskmoon_code_engine/test/src/document/document_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Document wraps Rope and ChangeSet into the public API surface for document manipulation.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/document/document_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('Document', () {
    group('creation', () {
      test('creates from string', () {
        final doc = Document.fromString('hello world');
        expect(doc.length, 11);
        expect(doc.lineCount, 1);
      });

      test('creates empty document', () {
        final doc = Document.empty;
        expect(doc.length, 0);
        expect(doc.lineCount, 1);
      });

      test('multi-line document', () {
        final doc = Document.fromString('line1\nline2\nline3');
        expect(doc.lineCount, 3);
      });
    });

    group('sliceString', () {
      test('extracts substring', () {
        final doc = Document.fromString('hello world');
        expect(doc.sliceString(0, 5), 'hello');
        expect(doc.sliceString(6), 'world');
      });
    });

    group('lineAt', () {
      test('returns line by number', () {
        final doc = Document.fromString('aaa\nbbb\nccc');
        final line = doc.lineAt(2);
        expect(line.text, 'bbb');
        expect(line.number, 2);
        expect(line.from, 4);
        expect(line.to, 7);
      });
    });

    group('lineAtOffset', () {
      test('returns line containing offset', () {
        final doc = Document.fromString('aaa\nbbb\nccc');
        expect(doc.lineAtOffset(0).number, 1);
        expect(doc.lineAtOffset(4).number, 2);
        expect(doc.lineAtOffset(8).number, 3);
      });
    });

    group('replace', () {
      test('applies changeset and returns new document', () {
        final doc = Document.fromString('hello world');
        final cs = ChangeSet.of(
          11,
          [ChangeSpec(from: 6, to: 11, insert: 'dart')],
        );
        final newDoc = doc.replace(cs);
        expect(newDoc.sliceString(0), 'hello dart');
        // Original is unchanged (immutable)
        expect(doc.sliceString(0), 'hello world');
      });
    });

    group('linesInRange', () {
      test('iterates lines in range', () {
        final doc = Document.fromString('aaa\nbbb\nccc\nddd');
        final lines = doc.linesInRange(2, 3).toList();
        expect(lines.length, 2);
        expect(lines[0].text, 'bbb');
        expect(lines[1].text, 'ccc');
      });
    });

    group('toString', () {
      test('returns full document text', () {
        final doc = Document.fromString('hello\nworld');
        expect(doc.toString(), 'hello\nworld');
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/document/document_test.dart
```

Expected: Compilation error — `Document` not defined.

- [ ] **Step 3: Implement Document**

Create `packages/duskmoon_code_engine/lib/src/document/document.dart`:

```dart
import 'change.dart';
import 'rope.dart';
import 'text.dart';

/// Immutable document backed by a [Rope].
/// Every edit produces a new Document via [replace].
class Document {
  const Document._(this._rope);

  final Rope _rope;

  /// Create a document from a plain string.
  factory Document.fromString(String text) => Document._(Rope.fromString(text));

  /// An empty document.
  static final Document empty = Document.fromString('');

  /// Total character length.
  int get length => _rope.length;

  /// Number of lines (always >= 1).
  int get lineCount => _rope.lineCount;

  /// Get line by 1-based [lineNumber].
  Line lineAt(int lineNumber) => _rope.lineAt(lineNumber);

  /// Get the line containing character [offset].
  Line lineAtOffset(int offset) => _rope.lineAtOffset(offset);

  /// Extract substring from [from] to [to].
  /// If [to] is omitted, extracts to end.
  String sliceString(int from, [int? to]) => _rope.sliceString(from, to);

  /// Apply a [ChangeSet], return a new Document.
  Document replace(ChangeSet changes) => Document._(changes.apply(_rope));

  /// Iterate lines in range [fromLine]..[toLine] (1-based, inclusive).
  Iterable<Line> linesInRange(int fromLine, int toLine) =>
      _rope.linesInRange(fromLine, toLine);

  /// Full document text.
  @override
  String toString() => _rope.sliceString(0);
}
```

- [ ] **Step 4: Add export**

In barrel, add:

```dart
export 'src/document/document.dart' show Document;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/document/document_test.dart -r expanded
```

Expected: All tests pass.

- [ ] **Step 6: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add immutable Document facade over Rope"
```

---

## Task 6: Extension and Precedence types

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/state/extension.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Extension is the base type for all editor configuration. Precedence controls ordering.

- [ ] **Step 1: Create extension.dart**

Create `packages/duskmoon_code_engine/lib/src/state/extension.dart`:

```dart
/// The base type for all editor extensions.
///
/// Extensions configure the editor by providing values to [Facet]s,
/// registering [StateField]s, or bundling other extensions.
sealed class Extension {
  const Extension();
}

/// An extension that bundles multiple child extensions.
class ExtensionGroup extends Extension {
  const ExtensionGroup(this.extensions);

  final List<Extension> extensions;
}

/// An extension wrapped with a precedence level.
class PrecedenceExtension extends Extension {
  const PrecedenceExtension(this.inner, this.precedence);

  final Extension inner;
  final Precedence precedence;
}

/// Precedence levels for extension ordering.
/// Higher precedence extensions take priority.
enum Precedence {
  /// Lowest precedence — fallback/default values.
  fallback,

  /// Default precedence — most extensions use this.
  base,

  /// Extensions that should override base-level ones.
  extend,

  /// Highest precedence — overrides everything.
  override_,
}

/// Wrap an extension with a precedence level.
Extension prec(Precedence p, Extension ext) =>
    PrecedenceExtension(ext, p);
```

- [ ] **Step 2: Add export**

In barrel, add:

```dart
// State system
export 'src/state/extension.dart'
    show Extension, ExtensionGroup, PrecedenceExtension, Precedence, prec;
```

- [ ] **Step 3: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Extension type and Precedence enum"
```

---

## Task 7: StateEffect and Annotation

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/state/state_effect.dart`
- Create: `packages/duskmoon_code_engine/lib/src/state/annotation.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

These are simple typed wrappers used in transactions.

- [ ] **Step 1: Create state_effect.dart**

Create `packages/duskmoon_code_engine/lib/src/state/state_effect.dart`:

```dart
/// Typed marker for describing side effects in transactions.
///
/// Effects don't directly modify state — they are consumed by
/// [StateField.update] functions or [ViewPlugin]s.
class StateEffectType<T> {
  const StateEffectType();

  /// Create an effect instance with a value.
  StateEffect<T> of(T value) => StateEffect<T>(this, value);
}

/// An effect instance carrying a typed value.
class StateEffect<T> {
  const StateEffect(this.type, this.value);

  final StateEffectType<T> type;
  final T value;

  /// Check if this effect matches a given type.
  bool is_(StateEffectType<T> type) => this.type == type;
}
```

- [ ] **Step 2: Create annotation.dart**

Create `packages/duskmoon_code_engine/lib/src/state/annotation.dart`:

```dart
/// Typed key for attaching metadata to transactions.
///
/// Annotations describe properties of a transaction (e.g., "this is
/// an undo", "this came from a remote source") without modifying state.
class AnnotationType<T> {
  const AnnotationType();
}

/// An annotation instance carrying a typed value.
class Annotation<T> {
  const Annotation(this.type, this.value);

  final AnnotationType<T> type;
  final T value;
}

/// Well-known annotations used by the core system.
abstract final class Annotations {
  /// Marks a transaction as coming from user input.
  static const userEvent = AnnotationType<String>();

  /// Marks a transaction as addToHistory or not.
  static const addToHistory = AnnotationType<bool>();

  /// Marks a transaction as remote (from collaboration).
  static const remote = AnnotationType<bool>();
}
```

- [ ] **Step 3: Add exports**

In barrel, add:

```dart
export 'src/state/state_effect.dart' show StateEffectType, StateEffect;
export 'src/state/annotation.dart'
    show AnnotationType, Annotation, Annotations;
```

- [ ] **Step 4: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add StateEffect and Annotation types"
```

---

## Task 8: EditorSelection

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/state/selection.dart`
- Create: `packages/duskmoon_code_engine/test/src/state/selection_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/state/selection_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('SelectionRange', () {
    test('cursor creates collapsed range', () {
      final range = SelectionRange.cursor(5);
      expect(range.from, 5);
      expect(range.to, 5);
      expect(range.head, 5);
      expect(range.anchor, 5);
      expect(range.isEmpty, true);
    });

    test('range with anchor before head', () {
      final range = SelectionRange(anchor: 3, head: 8);
      expect(range.from, 3);
      expect(range.to, 8);
      expect(range.isEmpty, false);
    });

    test('range with head before anchor', () {
      final range = SelectionRange(anchor: 8, head: 3);
      expect(range.from, 3);
      expect(range.to, 8);
      expect(range.head, 3);
      expect(range.anchor, 8);
    });

    test('map through changeset', () {
      final range = SelectionRange.cursor(5);
      final cs = ChangeSet.of(10, [ChangeSpec.insert(3, 'XX')]);
      final mapped = range.map(cs);
      expect(mapped.head, 7);
    });
  });

  group('EditorSelection', () {
    test('single cursor', () {
      final sel = EditorSelection.cursor(5);
      expect(sel.ranges.length, 1);
      expect(sel.main.head, 5);
      expect(sel.mainIndex, 0);
    });

    test('single range', () {
      final sel = EditorSelection.single(anchor: 3, head: 8);
      expect(sel.ranges.length, 1);
      expect(sel.main.from, 3);
      expect(sel.main.to, 8);
    });

    test('multiple ranges with main index', () {
      final sel = EditorSelection(
        ranges: [
          SelectionRange.cursor(5),
          SelectionRange.cursor(10),
          SelectionRange.cursor(15),
        ],
        mainIndex: 1,
      );
      expect(sel.ranges.length, 3);
      expect(sel.main.head, 10);
      expect(sel.mainIndex, 1);
    });

    test('map through changeset', () {
      final sel = EditorSelection.cursor(5);
      final cs = ChangeSet.of(10, [ChangeSpec.insert(3, 'XX')]);
      final mapped = sel.map(cs);
      expect(mapped.main.head, 7);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/state/selection_test.dart
```

Expected: Compilation errors.

- [ ] **Step 3: Implement EditorSelection**

Create `packages/duskmoon_code_engine/lib/src/state/selection.dart`:

```dart
import 'dart:math' as math;

import '../document/change.dart';

/// A single selection range with an anchor and head (cursor position).
class SelectionRange {
  const SelectionRange({required this.anchor, required this.head});

  /// Create a collapsed (cursor) selection.
  const SelectionRange.cursor(int pos) : anchor = pos, head = pos;

  /// The fixed end of the selection.
  final int anchor;

  /// The moving end (cursor position).
  final int head;

  /// Start of the range (min of anchor, head).
  int get from => math.min(anchor, head);

  /// End of the range (max of anchor, head).
  int get to => math.max(anchor, head);

  /// Whether this is a cursor (no selection).
  bool get isEmpty => anchor == head;

  /// Map this range through a [ChangeSet].
  SelectionRange map(ChangeSet changes) => SelectionRange(
        anchor: changes.mapPos(anchor, assoc: -1),
        head: changes.mapPos(head),
      );

  @override
  bool operator ==(Object other) =>
      other is SelectionRange &&
      anchor == other.anchor &&
      head == other.head;

  @override
  int get hashCode => Object.hash(anchor, head);

  @override
  String toString() =>
      isEmpty ? 'Cursor($head)' : 'Selection($anchor→$head)';
}

/// The editor's selection state: one or more [SelectionRange]s.
class EditorSelection {
  const EditorSelection({
    required this.ranges,
    this.mainIndex = 0,
  });

  /// Create a selection with a single cursor.
  factory EditorSelection.cursor(int pos) => EditorSelection(
        ranges: [SelectionRange.cursor(pos)],
      );

  /// Create a selection with a single range.
  factory EditorSelection.single({required int anchor, required int head}) =>
      EditorSelection(
        ranges: [SelectionRange(anchor: anchor, head: head)],
      );

  /// All selection ranges (multi-cursor support).
  final List<SelectionRange> ranges;

  /// Index of the primary ("main") range.
  final int mainIndex;

  /// The primary selection range.
  SelectionRange get main => ranges[mainIndex];

  /// Map all ranges through a [ChangeSet].
  EditorSelection map(ChangeSet changes) => EditorSelection(
        ranges: ranges.map((r) => r.map(changes)).toList(),
        mainIndex: mainIndex,
      );

  @override
  bool operator ==(Object other) =>
      other is EditorSelection &&
      mainIndex == other.mainIndex &&
      _rangesEqual(ranges, other.ranges);

  @override
  int get hashCode => Object.hash(mainIndex, Object.hashAll(ranges));

  static bool _rangesEqual(
    List<SelectionRange> a,
    List<SelectionRange> b,
  ) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  String toString() =>
      'EditorSelection(main=$mainIndex, ranges=$ranges)';
}
```

- [ ] **Step 4: Add export**

In barrel, add:

```dart
export 'src/state/selection.dart' show SelectionRange, EditorSelection;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/state/selection_test.dart -r expanded
```

Expected: All tests pass.

- [ ] **Step 6: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add EditorSelection with multi-cursor support"
```

---

## Task 9: Facet system

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/state/facet.dart`
- Create: `packages/duskmoon_code_engine/test/src/state/facet_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Facets are the core composability mechanism — typed extension points where multiple providers contribute values combined by a reduce function.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/state/facet_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('Facet', () {
    test('static facet combines multiple values', () {
      // A facet that collects all strings into a joined result
      final facet = Facet<String, String>(
        combine: (values) => values.join(', '),
      );

      final ext1 = facet.of('hello');
      final ext2 = facet.of('world');

      final store = FacetStore.resolve([ext1, ext2]);
      expect(store.read(facet), 'hello, world');
    });

    test('facet with no providers returns combine of empty list', () {
      final facet = Facet<String, String>(
        combine: (values) => values.isEmpty ? '<empty>' : values.join(', '),
      );

      final store = FacetStore.resolve([]);
      expect(store.read(facet), '<empty>');
    });

    test('facet with single provider', () {
      final facet = Facet<int, int>(
        combine: (values) => values.fold(0, (a, b) => a + b),
      );

      final ext = facet.of(42);
      final store = FacetStore.resolve([ext]);
      expect(store.read(facet), 42);
    });

    test('numeric facet sums values', () {
      final tabSize = Facet<int, int>(
        combine: (values) => values.isEmpty ? 4 : values.last,
      );

      final ext1 = tabSize.of(2);
      final ext2 = tabSize.of(8);

      final store = FacetStore.resolve([ext1, ext2]);
      // Last wins
      expect(store.read(tabSize), 8);
    });

    test('boolean facet with any-true combine', () {
      final readOnly = Facet<bool, bool>(
        combine: (values) => values.any((v) => v),
      );

      final ext1 = readOnly.of(false);
      final ext2 = readOnly.of(true);

      final store = FacetStore.resolve([ext1, ext2]);
      expect(store.read(readOnly), true);
    });

    test('extension group flattens nested extensions', () {
      final facet = Facet<String, String>(
        combine: (values) => values.join('+'),
      );

      final group = ExtensionGroup([
        facet.of('a'),
        facet.of('b'),
      ]);

      final store = FacetStore.resolve([group, facet.of('c')]);
      expect(store.read(facet), 'a+b+c');
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/state/facet_test.dart
```

Expected: Compilation errors.

- [ ] **Step 3: Implement Facet and FacetStore**

Create `packages/duskmoon_code_engine/lib/src/state/facet.dart`:

```dart
import 'extension.dart';

/// A typed extension point that collects values from multiple providers
/// and reduces them with a [combine] function.
class Facet<Input, Output> {
  const Facet({required this.combine});

  /// Reduce function: combines all provided values into a single output.
  final Output Function(List<Input>) combine;

  /// Create an extension that provides [value] to this facet.
  FacetExtension<Input, Output> of(Input value) =>
      FacetExtension<Input, Output>(this, value);
}

/// An extension that provides a value to a [Facet].
class FacetExtension<Input, Output> extends Extension {
  const FacetExtension(this.facet, this.value);

  final Facet<Input, Output> facet;
  final Input value;
}

/// Resolved facet values from a set of extensions.
class FacetStore {
  FacetStore._(this._values);

  final Map<Facet<dynamic, dynamic>, dynamic> _values;

  /// Resolve all facet values from a list of extensions.
  factory FacetStore.resolve(List<Extension> extensions) {
    final providers = <Facet<dynamic, dynamic>, List<dynamic>>{};

    void collect(Extension ext) {
      switch (ext) {
        case FacetExtension<dynamic, dynamic>():
          providers.putIfAbsent(ext.facet, () => []).add(ext.value);
        case ExtensionGroup():
          for (final child in ext.extensions) {
            collect(child);
          }
        case PrecedenceExtension():
          collect(ext.inner);
        default:
          break;
      }
    }

    for (final ext in extensions) {
      collect(ext);
    }

    final values = <Facet<dynamic, dynamic>, dynamic>{};
    for (final entry in providers.entries) {
      values[entry.key] = entry.key.combine(entry.value);
    }

    return FacetStore._(values);
  }

  /// Read the resolved value of a facet.
  Output read<Input, Output>(Facet<Input, Output> facet) {
    if (_values.containsKey(facet)) {
      return _values[facet] as Output;
    }
    return facet.combine([]);
  }
}
```

- [ ] **Step 4: Add export**

In barrel, add:

```dart
export 'src/state/facet.dart' show Facet, FacetExtension, FacetStore;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/state/facet_test.dart -r expanded
```

Expected: All tests pass.

- [ ] **Step 6: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Facet system with FacetStore resolution"
```

---

## Task 10: StateField

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/state/state_field.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

StateField attaches persistent state to EditorState, updated per transaction. Implementation is minimal now — full integration tested with EditorState in Task 12.

- [ ] **Step 1: Create state_field.dart**

Create `packages/duskmoon_code_engine/lib/src/state/state_field.dart`:

```dart
import 'extension.dart';

/// Persistent state attached to [EditorState], updated per transaction.
///
/// Create functions receive the initial [EditorState].
/// Update functions receive the [Transaction] and previous value.
///
/// Type parameters are erased at runtime, so each StateField instance
/// is identified by reference identity.
class StateField<T> extends Extension {
  const StateField({
    required this.create,
    required this.update,
  });

  /// Create the initial value from the starting state.
  /// The [state] parameter type is `dynamic` to avoid circular dependency —
  /// callers receive an `EditorState`.
  final T Function(dynamic state) create;

  /// Update the value for a transaction.
  /// The [transaction] parameter type is `dynamic` — callers receive a
  /// `Transaction`.
  final T Function(dynamic transaction, T value) update;
}
```

- [ ] **Step 2: Add export**

In barrel, add:

```dart
export 'src/state/state_field.dart' show StateField;
```

- [ ] **Step 3: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add StateField for persistent editor state"
```

---

## Task 11: Compartment

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/state/compartment.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Compartment enables dynamic reconfiguration — wrap extensions in a compartment to swap them at runtime via StateEffect.

- [ ] **Step 1: Create compartment.dart**

Create `packages/duskmoon_code_engine/lib/src/state/compartment.dart`:

```dart
import 'extension.dart';
import 'state_effect.dart';

/// Dynamic reconfiguration boundary.
///
/// Wrap an extension in a compartment so it can be replaced at runtime
/// via a [reconfigure] effect dispatched in a transaction.
///
/// Primary use case: swapping the language extension at runtime.
class Compartment {
  Compartment();

  /// Wrap an extension in this compartment.
  CompartmentExtension of(Extension ext) =>
      CompartmentExtension(this, ext);

  /// Create an effect that reconfigures this compartment.
  StateEffect<Extension> reconfigure(Extension ext) =>
      _reconfigureType.of(ext);

  /// The effect type used to reconfigure compartments.
  final _reconfigureType = StateEffectType<Extension>();
}

/// An extension wrapped in a [Compartment] for dynamic reconfiguration.
class CompartmentExtension extends Extension {
  const CompartmentExtension(this.compartment, this.inner);

  final Compartment compartment;
  final Extension inner;
}
```

- [ ] **Step 2: Add export**

In barrel, add:

```dart
export 'src/state/compartment.dart' show Compartment, CompartmentExtension;
```

- [ ] **Step 3: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Compartment for dynamic reconfiguration"
```

---

## Task 12: EditorState and Transaction

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/state/transaction.dart`
- Create: `packages/duskmoon_code_engine/lib/src/state/editor_state.dart`
- Create: `packages/duskmoon_code_engine/test/src/state/editor_state_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

This is the culminating task — the immutable state snapshot and transaction pipeline that ties everything together.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/state/editor_state_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('EditorState', () {
    group('creation', () {
      test('creates with default empty document', () {
        final state = EditorState.create();
        expect(state.doc.length, 0);
        expect(state.selection.main.head, 0);
      });

      test('creates with string document', () {
        final state = EditorState.create(docString: 'hello world');
        expect(state.doc.length, 11);
        expect(state.doc.sliceString(0), 'hello world');
      });

      test('creates with Document object', () {
        final doc = Document.fromString('hello');
        final state = EditorState.create(doc: doc);
        expect(state.doc.length, 5);
      });

      test('creates with initial selection', () {
        final state = EditorState.create(
          docString: 'hello',
          selection: EditorSelection.cursor(3),
        );
        expect(state.selection.main.head, 3);
      });

      test('creates with extensions', () {
        final tabSize = Facet<int, int>(
          combine: (values) => values.isEmpty ? 4 : values.last,
        );
        final state = EditorState.create(
          extensions: [tabSize.of(2)],
        );
        expect(state.facet(tabSize), 2);
      });
    });

    group('facet', () {
      test('reads facet with no provider returns default', () {
        final tabSize = Facet<int, int>(
          combine: (values) => values.isEmpty ? 4 : values.last,
        );
        final state = EditorState.create();
        expect(state.facet(tabSize), 4);
      });

      test('reads facet with provider returns combined value', () {
        final tags = Facet<String, List<String>>(
          combine: (values) => values,
        );
        final state = EditorState.create(
          extensions: [tags.of('a'), tags.of('b')],
        );
        expect(state.facet(tags), ['a', 'b']);
      });
    });

    group('field', () {
      test('reads state field created during initialization', () {
        final counter = StateField<int>(
          create: (_) => 0,
          update: (tr, val) => val,
        );
        final state = EditorState.create(extensions: [counter]);
        expect(state.field(counter), 0);
      });

      test('state field updates through transaction', () {
        final counter = StateField<int>(
          create: (_) => 0,
          update: (tr, val) => val + 1,
        );
        final state = EditorState.create(
          docString: 'hello',
          extensions: [counter],
        );
        expect(state.field(counter), 0);

        final tr = state.update(TransactionSpec());
        final newState = state.applyTransaction(tr);
        expect(newState.field(counter), 1);
      });
    });
  });

  group('Transaction', () {
    test('creates transaction with text change', () {
      final state = EditorState.create(docString: 'hello world');
      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(
          11,
          [ChangeSpec(from: 6, to: 11, insert: 'dart')],
        ),
      ));
      expect(tr.docChanged, true);
      expect(tr.state.doc.sliceString(0), 'hello dart');
    });

    test('maps selection through changes', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(11), // end of doc
      );
      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(
          11,
          [ChangeSpec.insert(5, ' beautiful')],
        ),
      ));
      // Cursor was at 11, insertion at 5 added 10 chars → cursor at 21
      expect(tr.state.selection.main.head, 21);
    });

    test('explicit selection overrides mapping', () {
      final state = EditorState.create(
        docString: 'hello world',
        selection: EditorSelection.cursor(11),
      );
      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(
          11,
          [ChangeSpec.insert(5, ' beautiful')],
        ),
        selection: EditorSelection.cursor(0),
      ));
      expect(tr.state.selection.main.head, 0);
    });

    test('no-change transaction preserves doc', () {
      final state = EditorState.create(docString: 'hello');
      final tr = state.update(TransactionSpec());
      expect(tr.docChanged, false);
      expect(tr.state.doc.sliceString(0), 'hello');
    });

    test('transaction with effects', () {
      final effectType = StateEffectType<String>();
      final state = EditorState.create(docString: 'hello');
      final tr = state.update(TransactionSpec(
        effects: [effectType.of('test-value')],
      ));
      expect(tr.effects.length, 1);
      expect(tr.effects.first.value, 'test-value');
    });

    test('transaction with annotations', () {
      final state = EditorState.create(docString: 'hello');
      final tr = state.update(TransactionSpec(
        annotations: [Annotation(Annotations.userEvent, 'input')],
      ));
      expect(tr.annotation(Annotations.userEvent), 'input');
    });

    test('applying transaction produces immutable new state', () {
      final state = EditorState.create(docString: 'hello');
      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(5, [ChangeSpec.insert(5, ' world')]),
      ));
      final newState = state.applyTransaction(tr);
      // Original unchanged
      expect(state.doc.sliceString(0), 'hello');
      // New state has changes
      expect(newState.doc.sliceString(0), 'hello world');
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/state/editor_state_test.dart
```

Expected: Compilation errors.

- [ ] **Step 3: Implement TransactionSpec and Transaction**

Create `packages/duskmoon_code_engine/lib/src/state/transaction.dart`:

```dart
import '../document/change.dart';
import 'annotation.dart';
import 'selection.dart';
import 'state_effect.dart';

/// Specification for creating a [Transaction].
class TransactionSpec {
  const TransactionSpec({
    this.changes,
    this.selection,
    this.effects = const [],
    this.annotations = const [],
    this.scrollIntoView = false,
  });

  final ChangeSet? changes;
  final EditorSelection? selection;
  final List<StateEffect<dynamic>> effects;
  final List<Annotation<dynamic>> annotations;
  final bool scrollIntoView;
}

/// A state transition: the changes, effects, and annotations that
/// transform one [EditorState] into another.
class Transaction {
  Transaction._({
    required this.startState,
    required this.changes,
    required this.selection,
    required this.effects,
    required this.annotations,
    required this.scrollIntoView,
    required dynamic Function() buildNewState,
  }) : _buildNewState = buildNewState;

  /// The state before this transaction.
  final dynamic startState;

  /// Document changes.
  final ChangeSet? changes;

  /// The selection after this transaction.
  final EditorSelection selection;

  /// Side effects.
  final List<StateEffect<dynamic>> effects;

  /// Metadata annotations.
  final List<Annotation<dynamic>> annotations;

  /// Whether the view should scroll the cursor into view.
  final bool scrollIntoView;

  final dynamic Function() _buildNewState;
  dynamic _cachedState;

  /// The new state after applying this transaction.
  dynamic get state => _cachedState ??= _buildNewState();

  /// Whether the document changed.
  bool get docChanged => changes != null && changes!.docChanged;

  /// Whether the selection changed.
  bool get selectionChanged => selection != (startState as dynamic).selection;

  /// Read an annotation value, or null if not present.
  T? annotation<T>(AnnotationType<T> type) {
    for (final ann in annotations) {
      if (ann.type == type) return ann.value as T;
    }
    return null;
  }
}
```

- [ ] **Step 4: Implement EditorState**

Create `packages/duskmoon_code_engine/lib/src/state/editor_state.dart`:

```dart
import '../document/change.dart';
import '../document/document.dart';
import 'annotation.dart';
import 'extension.dart';
import 'facet.dart';
import 'selection.dart';
import 'state_effect.dart';
import 'state_field.dart';
import 'transaction.dart';

/// Immutable editor state snapshot.
///
/// Holds the document, selection, facet values, and state field values.
/// All mutations go through [update] → [Transaction] → [applyTransaction].
class EditorState {
  EditorState._({
    required this.doc,
    required this.selection,
    required FacetStore facets,
    required Map<StateField<dynamic>, dynamic> fieldValues,
    required List<Extension> extensions,
  })  : _facets = facets,
        _fieldValues = fieldValues,
        _extensions = extensions;

  final Document doc;
  final EditorSelection selection;
  final FacetStore _facets;
  final Map<StateField<dynamic>, dynamic> _fieldValues;
  final List<Extension> _extensions;

  /// Create an initial editor state.
  factory EditorState.create({
    Document? doc,
    String? docString,
    EditorSelection? selection,
    List<Extension> extensions = const [],
  }) {
    final document =
        doc ?? (docString != null ? Document.fromString(docString) : Document.empty);
    final sel = selection ?? EditorSelection.cursor(0);
    final facets = FacetStore.resolve(extensions);

    // Initialize state fields
    final fieldValues = <StateField<dynamic>, dynamic>{};
    final state = EditorState._(
      doc: document,
      selection: sel,
      facets: facets,
      fieldValues: fieldValues,
      extensions: extensions,
    );

    // Create initial field values
    _collectFields(extensions, (field) {
      fieldValues[field] = field.create(state);
    });

    return state;
  }

  /// Read a facet value.
  T facet<Input, Output>(Facet<Input, Output> f) => _facets.read(f);

  /// Read a state field value.
  T field<T>(StateField<T> f) {
    assert(_fieldValues.containsKey(f), 'StateField not registered');
    return _fieldValues[f] as T;
  }

  /// Create a transaction from a spec.
  Transaction update(TransactionSpec spec) {
    final changes = spec.changes;
    final newDoc = changes != null ? doc.replace(changes) : doc;
    final newSelection = spec.selection ??
        (changes != null ? selection.map(changes) : selection);

    return Transaction._(
      startState: this,
      changes: changes,
      selection: newSelection,
      effects: spec.effects,
      annotations: spec.annotations,
      scrollIntoView: spec.scrollIntoView,
      buildNewState: () => _applyImpl(
        newDoc: newDoc,
        newSelection: newSelection,
        changes: changes,
        effects: spec.effects,
        annotations: spec.annotations,
      ),
    );
  }

  /// Apply a transaction, produce a new state.
  EditorState applyTransaction(Transaction tr) {
    return tr.state as EditorState;
  }

  EditorState _applyImpl({
    required Document newDoc,
    required EditorSelection newSelection,
    required ChangeSet? changes,
    required List<StateEffect<dynamic>> effects,
    required List<Annotation<dynamic>> annotations,
  }) {
    // Create the new state first (without field values)
    final newFieldValues = <StateField<dynamic>, dynamic>{};
    final newState = EditorState._(
      doc: newDoc,
      selection: newSelection,
      facets: _facets, // facets are static in Phase 1
      fieldValues: newFieldValues,
      extensions: _extensions,
    );

    // Build a lightweight transaction-like object for field update
    final tr = Transaction._(
      startState: this,
      changes: changes,
      selection: newSelection,
      effects: effects,
      annotations: annotations,
      scrollIntoView: false,
      buildNewState: () => newState,
    );

    // Update field values
    for (final entry in _fieldValues.entries) {
      newFieldValues[entry.key] = entry.key.update(tr, entry.value);
    }

    return newState;
  }

  static void _collectFields(
    List<Extension> extensions,
    void Function(StateField<dynamic>) callback,
  ) {
    for (final ext in extensions) {
      switch (ext) {
        case StateField<dynamic>():
          callback(ext);
        case ExtensionGroup():
          _collectFields(ext.extensions, callback);
        case PrecedenceExtension():
          _collectFields([ext.inner], callback);
        default:
          break;
      }
    }
  }
}
```

- [ ] **Step 5: Add exports**

In barrel, add:

```dart
export 'src/state/transaction.dart' show TransactionSpec, Transaction;
export 'src/state/editor_state.dart' show EditorState;
```

- [ ] **Step 6: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/state/editor_state_test.dart -r expanded
```

Expected: All tests pass.

- [ ] **Step 7: Run full test suite and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

Expected: All tests pass, no analyzer issues.

- [ ] **Step 8: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add EditorState and Transaction pipeline"
```

---

## Task 13: Final integration test and barrel cleanup

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart` (final ordering)

- [ ] **Step 1: Verify barrel export is complete and ordered**

The final barrel (`packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`) should be:

```dart
/// Pure Dart code editor engine with incremental parsing.
///
/// A ground-up port of the CodeMirror 6 architecture for Flutter,
/// providing: document model, state management, incremental parser,
/// virtual-viewport rendering, and syntax highlighting.
library;

// Document model
export 'src/document/change.dart' show ChangeSpec, ChangeSet;
export 'src/document/document.dart' show Document;
export 'src/document/position.dart' show Pos, Range;
export 'src/document/rope.dart' show RopeNode, RopeLeaf, RopeBranch, Rope;
export 'src/document/text.dart' show Line;

// State system
export 'src/state/annotation.dart'
    show AnnotationType, Annotation, Annotations;
export 'src/state/compartment.dart' show Compartment, CompartmentExtension;
export 'src/state/editor_state.dart' show EditorState;
export 'src/state/extension.dart'
    show Extension, ExtensionGroup, PrecedenceExtension, Precedence, prec;
export 'src/state/facet.dart' show Facet, FacetExtension, FacetStore;
export 'src/state/selection.dart' show SelectionRange, EditorSelection;
export 'src/state/state_effect.dart' show StateEffectType, StateEffect;
export 'src/state/state_field.dart' show StateField;
export 'src/state/transaction.dart' show TransactionSpec, Transaction;
```

- [ ] **Step 2: Run full test suite**

```bash
cd packages/duskmoon_code_engine && flutter test -r expanded
```

Expected: All tests pass (rope_test, change_test, document_test, selection_test, facet_test, editor_state_test).

- [ ] **Step 3: Run analyzer on the full package**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

Expected: No issues found.

- [ ] **Step 4: Run workspace-wide analyzer**

```bash
melos run analyze
```

Expected: All packages clean.

- [ ] **Step 5: Commit final barrel**

```bash
git add packages/duskmoon_code_engine/
git commit -m "chore(duskmoon_code_engine): finalize barrel exports for Phase 1"
```

---

## Summary

Phase 1 delivers **13 tasks** producing:

| Component | Files | Tests |
|-----------|-------|-------|
| Package scaffold | pubspec, analysis_options, barrel | - |
| Rope | rope.dart, text.dart | rope_test.dart |
| Position | position.dart | - |
| ChangeSet | change.dart | change_test.dart |
| Document | document.dart | document_test.dart |
| Extension/Precedence | extension.dart | - |
| StateEffect/Annotation | state_effect.dart, annotation.dart | - |
| EditorSelection | selection.dart | selection_test.dart |
| Facet | facet.dart | facet_test.dart |
| StateField | state_field.dart | - |
| Compartment | compartment.dart | - |
| EditorState + Transaction | editor_state.dart, transaction.dart | editor_state_test.dart |

**Deliverable:** Can create state, apply changes, read facets, manage selections. No rendering. All foundation types ready for Phase 2 (Lezer runtime port).
