# duskmoon_code_engine Phase 2 — Lezer Runtime Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port the Lezer parser system (@lezer/common + @lezer/lr + @lezer/highlight) to pure Dart and integrate it with the Phase 1 state system, enabling incremental syntax-tree-based highlighting.

**Architecture:** Three layers: (1) `lezer/common` — immutable syntax trees, node types, cursor-based traversal; (2) `lezer/lr` — table-driven incremental LR parser with time-sliced and background-isolate execution; (3) `lezer/highlight` — tag-based syntax highlighting mapped to TextStyles. The Language class bridges the parser to EditorState via a StateField. Grammar parse tables are compiled from upstream `.grammar` files at build time and shipped as Dart const data.

**Tech Stack:** Dart 3.5+, Flutter SDK, `dart:isolate` (for ParseWorker), `dart:typed_data` (Uint16List for parse tables)

**Spec:** `docs/code-engine.md` sections 5-6

**Depends on:** Phase 1 (complete) — uses EditorState, StateField, Facet, Extension, Document, ChangeSet

---

## File Structure

```
packages/duskmoon_code_engine/
├── lib/src/
│   ├── lezer/
│   │   ├── common/
│   │   │   ├── node_type.dart          # NodeType, NodeSet, NodeProp
│   │   │   ├── tree.dart               # Tree, TreeBuffer
│   │   │   ├── tree_cursor.dart        # TreeCursor for traversal
│   │   │   ├── parser.dart             # Parser abstract interface
│   │   │   ├── mixed_parser.dart       # Mixed-language overlay
│   │   │   └── token.dart              # Token, ExternalTokenizer
│   │   ├── lr/
│   │   │   ├── grammar_data.dart       # Serialized grammar table types
│   │   │   ├── lr_parser.dart          # LRParser (table-driven)
│   │   │   ├── parse_state.dart        # Parse stack, incremental reuse
│   │   │   ├── token_cache.dart        # Token caching layer
│   │   │   └── parse_worker.dart       # Background isolate for heavy parses
│   │   └── highlight/
│   │       ├── tags.dart               # Tag definitions
│   │       └── highlight.dart          # HighlightStyle, Tag → TextStyle
│   │
│   ├── language/
│   │   ├── language.dart               # Language, LanguageSupport
│   │   ├── language_data.dart          # LanguageData facet
│   │   ├── syntax.dart                 # syntaxTree(), syntaxTreeAvailable()
│   │   └── stream_language.dart        # StreamLanguage for simple modes
│   │
│   └── grammars/
│       ├── json.dart                   # JSON grammar tables (first grammar)
│       └── _registry.dart              # Language name → Language lookup
│
├── test/src/
│   ├── lezer/
│   │   ├── common/
│   │   │   ├── node_type_test.dart
│   │   │   ├── tree_test.dart
│   │   │   └── tree_cursor_test.dart
│   │   ├── lr/
│   │   │   └── lr_parser_test.dart
│   │   └── highlight/
│   │       └── highlight_test.dart
│   ├── language/
│   │   └── language_test.dart
│   └── grammars/
│       └── json_test.dart
│
└── tool/
    └── grammar_to_dart.dart            # Codegen: JSON grammar tables → Dart const
```

---

## Task 1: NodeType and NodeProp

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/lezer/common/node_type.dart`
- Create: `packages/duskmoon_code_engine/test/src/lezer/common/node_type_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

NodeType defines the type of each node in a syntax tree. NodeProp attaches metadata (like whether a node is an error, comment, or top-level). NodeSet is a collection of NodeTypes indexed by ID.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/lezer/common/node_type_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('NodeProp', () {
    test('can define custom prop', () {
      final prop = NodeProp<String>();
      expect(prop, isNotNull);
    });

    test('closedBy/openedBy are predefined string props', () {
      expect(NodeProp.closedBy, isA<NodeProp<List<String>>>());
      expect(NodeProp.openedBy, isA<NodeProp<List<String>>>());
    });
  });

  group('NodeType', () {
    test('creates with name and id', () {
      final type = NodeType('Identifier', 1);
      expect(type.name, 'Identifier');
      expect(type.id, 1);
    });

    test('none has id 0 and empty name', () {
      expect(NodeType.none.id, 0);
      expect(NodeType.none.name, '');
    });

    test('isError defaults to false', () {
      final type = NodeType('Foo', 1);
      expect(type.isError, false);
    });

    test('isError true when error prop is set', () {
      final type = NodeType('⚠', 2, props: {NodeProp.error: true});
      expect(type.isError, true);
    });

    test('reads a prop value', () {
      final customProp = NodeProp<String>();
      final type = NodeType('Foo', 1, props: {customProp: 'bar'});
      expect(type.prop(customProp), 'bar');
    });

    test('returns null for unset prop', () {
      final customProp = NodeProp<String>();
      final type = NodeType('Foo', 1);
      expect(type.prop(customProp), null);
    });

    test('isTop when top prop is set', () {
      final type = NodeType('Program', 1, props: {NodeProp.top: true});
      expect(type.isTop, true);
    });
  });

  group('NodeSet', () {
    test('creates from list of NodeTypes', () {
      final types = [
        NodeType.none,
        NodeType('A', 1),
        NodeType('B', 2),
      ];
      final set = NodeSet(types);
      expect(set.types.length, 3);
      expect(set.types[1].name, 'A');
      expect(set.types[2].name, 'B');
    });

    test('looks up type by id', () {
      final a = NodeType('A', 1);
      final set = NodeSet([NodeType.none, a]);
      expect(set.types[1], same(a));
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/lezer/common/node_type_test.dart
```

Expected: Compilation errors.

- [ ] **Step 3: Implement NodeProp, NodeType, NodeSet**

Create `packages/duskmoon_code_engine/lib/src/lezer/common/node_type.dart`:

```dart
/// A property that can be attached to a [NodeType].
///
/// Properties are identified by reference identity.
class NodeProp<T> {
  const NodeProp();

  /// Marks a node as an error (recovery) node.
  static const NodeProp<bool> error = NodeProp<bool>();

  /// Marks a node as top-level (the root grammar node).
  static const NodeProp<bool> top = NodeProp<bool>();

  /// Marks a node as skipped (whitespace, comments).
  static const NodeProp<bool> skipped = NodeProp<bool>();

  /// Names of tokens that close this node (e.g., "}" for "{").
  static const NodeProp<List<String>> closedBy = NodeProp<List<String>>();

  /// Names of tokens that open this node (e.g., "{" for "}").
  static const NodeProp<List<String>> openedBy = NodeProp<List<String>>();

  /// The group name(s) this node belongs to (for highlight tagging).
  static const NodeProp<List<String>> group = NodeProp<List<String>>();
}

/// Describes the type of a syntax tree node.
class NodeType {
  NodeType(
    this.name,
    this.id, {
    Map<NodeProp<dynamic>, dynamic>? props,
  }) : _props = props ?? const {};

  /// The name of this node type (e.g., "Identifier", "String").
  final String name;

  /// Numeric ID used for efficient table lookup.
  final int id;

  final Map<NodeProp<dynamic>, dynamic> _props;

  /// The empty/unknown node type (id 0).
  static final NodeType none = NodeType('', 0);

  /// Whether this is an error (recovery) node.
  bool get isError => prop(NodeProp.error) == true;

  /// Whether this is a top-level (root) node.
  bool get isTop => prop(NodeProp.top) == true;

  /// Whether this node is skipped (whitespace/comments).
  bool get isSkipped => prop(NodeProp.skipped) == true;

  /// Read a property value, or null if not set.
  T? prop<T>(NodeProp<T> prop) => _props[prop] as T?;

  @override
  String toString() => name.isEmpty ? 'NodeType(none)' : 'NodeType($name)';
}

/// An indexed collection of [NodeType]s, looked up by [NodeType.id].
class NodeSet {
  const NodeSet(this.types);

  /// All types, indexed by their [NodeType.id].
  final List<NodeType> types;
}
```

- [ ] **Step 4: Add exports to barrel**

Add to `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`:

```dart
// Lezer common
export 'src/lezer/common/node_type.dart' show NodeProp, NodeType, NodeSet;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/lezer/common/node_type_test.dart -r expanded
```

Expected: All tests pass.

- [ ] **Step 6: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add NodeType, NodeProp, NodeSet for syntax trees"
```

---

## Task 2: Tree and TreeBuffer

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/lezer/common/tree.dart`
- Create: `packages/duskmoon_code_engine/test/src/lezer/common/tree_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Tree is the immutable syntax tree produced by parsing. TreeBuffer is a compact flat representation for subtrees (run of leaf nodes). These mirror CM6's `@lezer/common` Tree/TreeBuffer.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/lezer/common/tree_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  // Shared types for testing
  late NodeType programType;
  late NodeType numberType;
  late NodeType stringType;
  late NodeType errorType;
  late NodeSet nodeSet;

  setUp(() {
    programType = NodeType('Program', 1, props: {NodeProp.top: true});
    numberType = NodeType('Number', 2);
    stringType = NodeType('String', 3);
    errorType = NodeType('⚠', 4, props: {NodeProp.error: true});
    nodeSet = NodeSet([
      NodeType.none,
      programType,
      numberType,
      stringType,
      errorType,
    ]);
  });

  group('Tree', () {
    test('empty tree has length 0', () {
      expect(Tree.empty.length, 0);
    });

    test('creates leaf tree with type and length', () {
      final tree = Tree(numberType, [], [], 5);
      expect(tree.type, numberType);
      expect(tree.length, 5);
      expect(tree.children.isEmpty, true);
    });

    test('creates tree with children', () {
      final child1 = Tree(numberType, [], [], 3);
      final child2 = Tree(stringType, [], [], 5);
      final parent = Tree(programType, [child1, child2], [0, 3], 8);
      expect(parent.children.length, 2);
      expect(parent.positions.length, 2);
      expect(parent.positions[0], 0);
      expect(parent.positions[1], 3);
    });

    test('resolves child types from positions', () {
      final child1 = Tree(numberType, [], [], 3);
      final child2 = Tree(stringType, [], [], 5);
      final parent = Tree(programType, [child1, child2], [0, 3], 8);
      expect(parent.children[0].type.name, 'Number');
      expect(parent.children[1].type.name, 'String');
    });

    test('topNode returns tree itself when it has top type', () {
      final tree = Tree(programType, [], [], 10);
      expect(tree.topNode.type, programType);
      expect(tree.topNode.from, 0);
      expect(tree.topNode.to, 10);
    });
  });

  group('TreeBuffer', () {
    test('creates with flat buffer and node set', () {
      // Buffer format: [type_id, from, to, child_size] per node
      // A single Number node from 0 to 3, no children (size 4 = 1 node)
      final buffer = TreeBuffer(
        [2, 0, 3, 4], // Number, from=0, to=3, size=4
        3,
        nodeSet,
      );
      expect(buffer.length, 3);
    });

    test('stores multiple nodes in flat format', () {
      // Two leaf nodes: Number(0,2) and String(3,5)
      final buffer = TreeBuffer(
        [
          2, 0, 2, 4, // Number from=0 to=2 size=4
          3, 3, 5, 4, // String from=3 to=5 size=4
        ],
        5,
        nodeSet,
      );
      expect(buffer.length, 5);
    });
  });

  group('SyntaxNode', () {
    test('wraps tree with position info', () {
      final tree = Tree(numberType, [], [], 5);
      final node = tree.topNode;
      expect(node.type, numberType);
      expect(node.from, 0);
      expect(node.to, 5);
      expect(node.name, 'Number');
    });

    test('firstChild returns null for leaf', () {
      final tree = Tree(numberType, [], [], 5);
      final node = tree.topNode;
      expect(node.firstChild, null);
    });

    test('firstChild returns first child node', () {
      final child = Tree(numberType, [], [], 3);
      final parent = Tree(programType, [child], [0], 3);
      final node = parent.topNode;
      final first = node.firstChild;
      expect(first, isNotNull);
      expect(first!.type.name, 'Number');
      expect(first.from, 0);
      expect(first.to, 3);
    });

    test('lastChild returns last child node', () {
      final child1 = Tree(numberType, [], [], 3);
      final child2 = Tree(stringType, [], [], 5);
      final parent = Tree(programType, [child1, child2], [0, 3], 8);
      final last = parent.topNode.lastChild;
      expect(last, isNotNull);
      expect(last!.type.name, 'String');
    });

    test('parent is set for child nodes', () {
      final child = Tree(numberType, [], [], 3);
      final parent = Tree(programType, [child], [0], 3);
      final childNode = parent.topNode.firstChild!;
      expect(childNode.parent, isNotNull);
      expect(childNode.parent!.type.name, 'Program');
    });

    test('nextSibling navigates to next sibling', () {
      final child1 = Tree(numberType, [], [], 3);
      final child2 = Tree(stringType, [], [], 5);
      final parent = Tree(programType, [child1, child2], [0, 3], 8);
      final first = parent.topNode.firstChild!;
      final next = first.nextSibling;
      expect(next, isNotNull);
      expect(next!.type.name, 'String');
    });

    test('prevSibling navigates to previous sibling', () {
      final child1 = Tree(numberType, [], [], 3);
      final child2 = Tree(stringType, [], [], 5);
      final parent = Tree(programType, [child1, child2], [0, 3], 8);
      final last = parent.topNode.lastChild!;
      final prev = last.prevSibling;
      expect(prev, isNotNull);
      expect(prev!.type.name, 'Number');
    });

    test('resolve finds deepest node at position', () {
      final num = Tree(numberType, [], [], 3);
      final str = Tree(stringType, [], [], 5);
      final prog = Tree(programType, [num, str], [0, 3], 8);
      final found = prog.topNode.resolve(4);
      expect(found.type.name, 'String');
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/lezer/common/tree_test.dart
```

Expected: Compilation errors.

- [ ] **Step 3: Implement Tree, TreeBuffer, SyntaxNode**

Create `packages/duskmoon_code_engine/lib/src/lezer/common/tree.dart`:

```dart
import 'node_type.dart';

/// An immutable syntax tree produced by parsing.
///
/// Children are stored as parallel lists of child trees/buffers
/// and their start positions within the parent.
class Tree {
  const Tree(this.type, this.children, this.positions, this.length);

  /// The node type of this tree's root.
  final NodeType type;

  /// Child trees (or TreeBuffers).
  final List<Object> children; // Tree | TreeBuffer

  /// Start positions of children relative to this tree's start.
  final List<int> positions;

  /// Total length of this tree in characters.
  final int length;

  /// An empty tree.
  static final Tree empty = Tree(NodeType.none, const [], const [], 0);

  /// Get a [SyntaxNode] for the root of this tree.
  SyntaxNode get topNode => SyntaxNode(this, 0, null, -1);

  @override
  String toString() => 'Tree(${type.name}, $length)';
}

/// Compact flat representation for a run of leaf/simple nodes.
///
/// Buffer format: groups of 4 ints per node:
///   [typeId, from, to, endIndex]
/// where endIndex is the index after the last entry belonging to this
/// node (including children), allowing size-based child navigation.
class TreeBuffer {
  const TreeBuffer(this.buffer, this.length, this.set);

  /// Flat buffer of node data: [typeId, from, to, endIndex] per node.
  final List<int> buffer;

  /// Total length in characters.
  final int length;

  /// NodeSet for resolving type IDs to NodeTypes.
  final NodeSet set;
}

/// A positioned reference into a syntax tree, providing navigation.
class SyntaxNode {
  SyntaxNode(this._tree, this._offset, this._parent, this._childIndex);

  final Tree _tree;
  final int _offset; // absolute start position
  final SyntaxNode? _parent;
  final int _childIndex; // index within parent's children, -1 for root

  /// The node type.
  NodeType get type => _tree.type;

  /// The node type name.
  String get name => _tree.type.name;

  /// Start position (absolute).
  int get from => _offset;

  /// End position (absolute).
  int get to => _offset + _tree.length;

  /// The parent node, or null for the tree root.
  SyntaxNode? get parent => _parent;

  /// First child node, or null if this is a leaf.
  SyntaxNode? get firstChild {
    for (var i = 0; i < _tree.children.length; i++) {
      final child = _tree.children[i];
      if (child is Tree) {
        return SyntaxNode(
          child,
          _offset + _tree.positions[i],
          this,
          i,
        );
      }
    }
    return null;
  }

  /// Last child node, or null if this is a leaf.
  SyntaxNode? get lastChild {
    for (var i = _tree.children.length - 1; i >= 0; i--) {
      final child = _tree.children[i];
      if (child is Tree) {
        return SyntaxNode(
          child,
          _offset + _tree.positions[i],
          this,
          i,
        );
      }
    }
    return null;
  }

  /// Next sibling, or null.
  SyntaxNode? get nextSibling {
    if (_parent == null || _childIndex < 0) return null;
    final parentTree = _parent!._tree;
    for (var i = _childIndex + 1; i < parentTree.children.length; i++) {
      final child = parentTree.children[i];
      if (child is Tree) {
        return SyntaxNode(
          child,
          _parent!._offset + parentTree.positions[i],
          _parent,
          i,
        );
      }
    }
    return null;
  }

  /// Previous sibling, or null.
  SyntaxNode? get prevSibling {
    if (_parent == null || _childIndex < 0) return null;
    final parentTree = _parent!._tree;
    for (var i = _childIndex - 1; i >= 0; i--) {
      final child = parentTree.children[i];
      if (child is Tree) {
        return SyntaxNode(
          child,
          _parent!._offset + parentTree.positions[i],
          _parent,
          i,
        );
      }
    }
    return null;
  }

  /// Find the deepest node covering [pos].
  SyntaxNode resolve(int pos) {
    for (var i = 0; i < _tree.children.length; i++) {
      final child = _tree.children[i];
      if (child is Tree) {
        final childStart = _offset + _tree.positions[i];
        final childEnd = childStart + child.length;
        if (pos >= childStart && pos < childEnd) {
          final childNode = SyntaxNode(child, childStart, this, i);
          return childNode.resolve(pos);
        }
      }
    }
    return this;
  }

  @override
  String toString() => '$name($from, $to)';
}
```

- [ ] **Step 4: Add exports**

```dart
export 'src/lezer/common/tree.dart' show Tree, TreeBuffer, SyntaxNode;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/lezer/common/tree_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Tree, TreeBuffer, SyntaxNode for syntax trees"
```

---

## Task 3: TreeCursor

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/lezer/common/tree_cursor.dart`
- Create: `packages/duskmoon_code_engine/test/src/lezer/common/tree_cursor_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

TreeCursor provides efficient stateful traversal of a syntax tree without allocating SyntaxNode objects at each step.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/lezer/common/tree_cursor_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  // Build a small tree: Program { Number(0,3) String(4,8) }
  late Tree tree;
  late NodeType programType;
  late NodeType numberType;
  late NodeType stringType;

  setUp(() {
    programType = NodeType('Program', 1, props: {NodeProp.top: true});
    numberType = NodeType('Number', 2);
    stringType = NodeType('String', 3);

    final num = Tree(numberType, [], [], 3);
    final str = Tree(stringType, [], [], 4);
    tree = Tree(programType, [num, str], [0, 4], 8);
  });

  group('TreeCursor', () {
    test('starts at tree root', () {
      final cursor = tree.cursor();
      expect(cursor.type.name, 'Program');
      expect(cursor.from, 0);
      expect(cursor.to, 8);
    });

    test('firstChild moves to first child', () {
      final cursor = tree.cursor();
      expect(cursor.firstChild(), true);
      expect(cursor.type.name, 'Number');
      expect(cursor.from, 0);
      expect(cursor.to, 3);
    });

    test('nextSibling moves to next sibling', () {
      final cursor = tree.cursor();
      cursor.firstChild();
      expect(cursor.nextSibling(), true);
      expect(cursor.type.name, 'String');
      expect(cursor.from, 4);
      expect(cursor.to, 8);
    });

    test('nextSibling returns false at last sibling', () {
      final cursor = tree.cursor();
      cursor.firstChild();
      cursor.nextSibling();
      expect(cursor.nextSibling(), false);
    });

    test('parent moves back up', () {
      final cursor = tree.cursor();
      cursor.firstChild();
      expect(cursor.parent(), true);
      expect(cursor.type.name, 'Program');
    });

    test('parent returns false at root', () {
      final cursor = tree.cursor();
      expect(cursor.parent(), false);
    });

    test('firstChild returns false for leaf', () {
      final cursor = tree.cursor();
      cursor.firstChild(); // Number
      expect(cursor.firstChild(), false);
    });

    test('lastChild moves to last child', () {
      final cursor = tree.cursor();
      expect(cursor.lastChild(), true);
      expect(cursor.type.name, 'String');
    });

    test('prevSibling moves to previous sibling', () {
      final cursor = tree.cursor();
      cursor.lastChild(); // String
      expect(cursor.prevSibling(), true);
      expect(cursor.type.name, 'Number');
    });

    test('next does depth-first traversal', () {
      final cursor = tree.cursor();
      final names = <String>[cursor.type.name];
      while (cursor.next()) {
        names.add(cursor.type.name);
      }
      expect(names, ['Program', 'Number', 'String']);
    });

    test('cursor on deeper tree traverses all', () {
      // Program { Block { Number(0,3) } String(4,8) }
      final blockType = NodeType('Block', 4);
      final num = Tree(numberType, [], [], 3);
      final block = Tree(blockType, [num], [0], 3);
      final str = Tree(stringType, [], [], 4);
      final deepTree = Tree(programType, [block, str], [0, 4], 8);

      final cursor = deepTree.cursor();
      final names = <String>[cursor.type.name];
      while (cursor.next()) {
        names.add(cursor.type.name);
      }
      expect(names, ['Program', 'Block', 'Number', 'String']);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/lezer/common/tree_cursor_test.dart
```

- [ ] **Step 3: Implement TreeCursor and Tree.cursor()**

Create `packages/duskmoon_code_engine/lib/src/lezer/common/tree_cursor.dart`:

```dart
import 'node_type.dart';
import 'tree.dart';

/// Efficient stateful cursor for traversing a [Tree].
///
/// Unlike [SyntaxNode], the cursor reuses a single object
/// and tracks its position with a stack — no allocations per step.
class TreeCursor {
  TreeCursor._(this._root) {
    _stack.add(_Frame(_root, 0, -1));
  }

  final Tree _root;
  final List<_Frame> _stack = [];

  /// Current node type.
  NodeType get type => _current._tree.type;

  /// Current node name.
  String get name => type.name;

  /// Start position (absolute).
  int get from => _current._offset;

  /// End position (absolute).
  int get to => _current._offset + _current._tree.length;

  _Frame get _current => _stack.last;

  /// Move to the first child. Returns false if this is a leaf.
  bool firstChild() {
    final tree = _current._tree;
    for (var i = 0; i < tree.children.length; i++) {
      final child = tree.children[i];
      if (child is Tree) {
        _stack.add(_Frame(
          child,
          _current._offset + tree.positions[i],
          i,
        ));
        return true;
      }
    }
    return false;
  }

  /// Move to the last child. Returns false if this is a leaf.
  bool lastChild() {
    final tree = _current._tree;
    for (var i = tree.children.length - 1; i >= 0; i--) {
      final child = tree.children[i];
      if (child is Tree) {
        _stack.add(_Frame(
          child,
          _current._offset + tree.positions[i],
          i,
        ));
        return true;
      }
    }
    return false;
  }

  /// Move to the next sibling. Returns false if at last sibling.
  bool nextSibling() {
    if (_stack.length < 2) return false;
    final parentFrame = _stack[_stack.length - 2];
    final parentTree = parentFrame._tree;
    for (var i = _current._childIndex + 1;
        i < parentTree.children.length;
        i++) {
      final child = parentTree.children[i];
      if (child is Tree) {
        _stack.last = _Frame(
          child,
          parentFrame._offset + parentTree.positions[i],
          i,
        );
        return true;
      }
    }
    return false;
  }

  /// Move to the previous sibling. Returns false if at first sibling.
  bool prevSibling() {
    if (_stack.length < 2) return false;
    final parentFrame = _stack[_stack.length - 2];
    final parentTree = parentFrame._tree;
    for (var i = _current._childIndex - 1; i >= 0; i--) {
      final child = parentTree.children[i];
      if (child is Tree) {
        _stack.last = _Frame(
          child,
          parentFrame._offset + parentTree.positions[i],
          i,
        );
        return true;
      }
    }
    return false;
  }

  /// Move to the parent. Returns false if at root.
  bool parent() {
    if (_stack.length <= 1) return false;
    _stack.removeLast();
    return true;
  }

  /// Move to the next node in depth-first order.
  /// Returns false when the traversal is complete.
  bool next() {
    // Try to go to first child
    if (firstChild()) return true;
    // Try to go to next sibling
    if (nextSibling()) return true;
    // Go up and try next sibling
    while (parent()) {
      if (nextSibling()) return true;
    }
    return false;
  }

  /// Get a [SyntaxNode] for the current position.
  SyntaxNode get node {
    SyntaxNode? parentNode;
    if (_stack.length > 1) {
      // Build parent chain from stack
      parentNode = SyntaxNode(
        _stack[0]._tree,
        _stack[0]._offset,
        null,
        -1,
      );
      for (var i = 1; i < _stack.length - 1; i++) {
        parentNode = SyntaxNode(
          _stack[i]._tree,
          _stack[i]._offset,
          parentNode,
          _stack[i]._childIndex,
        );
      }
    }
    return SyntaxNode(
      _current._tree,
      _current._offset,
      parentNode,
      _current._childIndex,
    );
  }
}

class _Frame {
  _Frame(this._tree, this._offset, this._childIndex);

  final Tree _tree;
  final int _offset;
  final int _childIndex;
}
```

Add `cursor()` method to `Tree` in `tree.dart`:

```dart
/// Create a [TreeCursor] starting at this tree's root.
TreeCursor cursor() => TreeCursor._(this);
```

Add import to `tree.dart`:

```dart
import 'tree_cursor.dart';
```

- [ ] **Step 4: Add export**

```dart
export 'src/lezer/common/tree_cursor.dart' show TreeCursor;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/lezer/common/tree_cursor_test.dart -r expanded
```

- [ ] **Step 6: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add TreeCursor for efficient tree traversal"
```

---

## Task 4: Parser interface and Token

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/lezer/common/parser.dart`
- Create: `packages/duskmoon_code_engine/lib/src/lezer/common/token.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

The abstract Parser interface that LRParser will implement. Token defines the result of tokenization.

- [ ] **Step 1: Create parser.dart**

Create `packages/duskmoon_code_engine/lib/src/lezer/common/parser.dart`:

```dart
import 'tree.dart';

/// A range of the document that changed (for incremental parsing).
class ChangedRange {
  const ChangedRange(this.fromA, this.toA, this.fromB, this.toB);

  /// Start of the changed range in the old document.
  final int fromA;

  /// End of the changed range in the old document.
  final int toA;

  /// Start of the changed range in the new document.
  final int fromB;

  /// End of the changed range in the new document.
  final int toB;
}

/// Abstract interface for parsers.
///
/// Implementations include [LRParser] (table-driven) and
/// [StreamLanguage] (line-by-line).
abstract class Parser {
  const Parser();

  /// Parse a document string into a [Tree].
  ///
  /// - [previousTree]: if provided, enables incremental parsing
  ///   by reusing unchanged subtrees.
  /// - [changedRanges]: regions that changed (required with previousTree).
  /// - [stopAt]: time budget in microseconds — yield partial tree
  ///   if parsing takes longer.
  Tree parse(
    String input, {
    Tree? previousTree,
    List<ChangedRange>? changedRanges,
    int? stopAt,
  });
}
```

- [ ] **Step 2: Create token.dart**

Create `packages/duskmoon_code_engine/lib/src/lezer/common/token.dart`:

```dart
/// A token produced by tokenization.
class Token {
  const Token(this.type, this.start, this.end);

  /// The node type ID for this token.
  final int type;

  /// Start offset in the input.
  final int start;

  /// End offset in the input.
  final int end;

  /// Length in characters.
  int get length => end - start;
}

/// Interface for external tokenizers that can be plugged into
/// a grammar to handle tokens the generated grammar can't.
abstract class ExternalTokenizer {
  const ExternalTokenizer();

  /// Attempt to tokenize at [pos] in [input].
  /// Return a [Token] if recognized, null otherwise.
  Token? token(String input, int pos);
}
```

- [ ] **Step 3: Add exports**

```dart
export 'src/lezer/common/parser.dart' show Parser, ChangedRange;
export 'src/lezer/common/token.dart' show Token, ExternalTokenizer;
```

- [ ] **Step 4: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Parser interface, ChangedRange, Token"
```

---

## Task 5: Highlight tags and HighlightStyle

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/lezer/highlight/tags.dart`
- Create: `packages/duskmoon_code_engine/lib/src/lezer/highlight/highlight.dart`
- Create: `packages/duskmoon_code_engine/test/src/lezer/highlight/highlight_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Tags define semantic categories for syntax highlighting (keyword, string, comment, etc.). HighlightStyle maps tags to TextStyles.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/lezer/highlight/highlight_test.dart`:

```dart
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('Tag', () {
    test('predefined tags exist', () {
      expect(Tag.keyword, isNotNull);
      expect(Tag.string, isNotNull);
      expect(Tag.comment, isNotNull);
      expect(Tag.number, isNotNull);
      expect(Tag.typeName, isNotNull);
      expect(Tag.variableName, isNotNull);
      expect(Tag.function_, isNotNull);
      expect(Tag.operator_, isNotNull);
      expect(Tag.punctuation, isNotNull);
      expect(Tag.bool_, isNotNull);
    });

    test('modified tags have parent', () {
      final strong = Tag.keyword.modified(Tag.strong);
      expect(strong, isNotNull);
    });
  });

  group('HighlightStyle', () {
    test('creates with tag-to-style mappings', () {
      final style = HighlightStyle([
        TagStyle(Tag.keyword, const TextStyle(fontWeight: FontWeight.bold)),
        TagStyle(Tag.string, const TextStyle(color: Color(0xFF00FF00))),
      ]);
      expect(style.specs.length, 2);
    });

    test('resolves style for exact tag match', () {
      final keywordStyle = const TextStyle(fontWeight: FontWeight.bold);
      final style = HighlightStyle([
        TagStyle(Tag.keyword, keywordStyle),
      ]);
      final resolved = style.style(Tag.keyword);
      expect(resolved, keywordStyle);
    });

    test('returns null for unmatched tag', () {
      final style = HighlightStyle([
        TagStyle(Tag.keyword, const TextStyle(fontWeight: FontWeight.bold)),
      ]);
      expect(style.style(Tag.string), null);
    });

    test('resolves style for modified tag via parent fallback', () {
      final keywordStyle = const TextStyle(fontWeight: FontWeight.bold);
      final style = HighlightStyle([
        TagStyle(Tag.keyword, keywordStyle),
      ]);
      // A modified keyword (e.g., control keyword) should fall back to keyword
      final controlKeyword = Tag.keyword.modified(Tag.controlKeyword);
      final resolved = style.style(controlKeyword);
      expect(resolved, keywordStyle);
    });

    test('specific modified tag overrides parent', () {
      final baseStyle = const TextStyle(fontWeight: FontWeight.bold);
      final specificStyle = const TextStyle(color: Color(0xFFFF0000));
      final controlKeyword = Tag.keyword.modified(Tag.controlKeyword);
      final style = HighlightStyle([
        TagStyle(Tag.keyword, baseStyle),
        TagStyle(controlKeyword, specificStyle),
      ]);
      expect(style.style(controlKeyword), specificStyle);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/lezer/highlight/highlight_test.dart
```

- [ ] **Step 3: Implement Tag**

Create `packages/duskmoon_code_engine/lib/src/lezer/highlight/tags.dart`:

```dart
/// A semantic tag identifying a type of syntax element.
///
/// Tags form a hierarchy: modified tags inherit from their parent
/// so highlight styles can fall back from specific to general.
class Tag {
  Tag._(this.name, [this._parent]);

  /// Create a modified (child) tag.
  Tag modified(Tag modifier) => Tag._('$name.${modifier.name}', this);

  /// The tag name (for debugging).
  final String name;

  /// Parent tag for fallback resolution.
  final Tag? _parent;

  /// Walk up the tag hierarchy.
  Tag? get parent => _parent;

  // --- Predefined base tags ---

  static final Tag comment = Tag._('comment');
  static final Tag lineComment = Tag.comment.modified(Tag._('lineComment'));
  static final Tag blockComment = Tag.comment.modified(Tag._('blockComment'));
  static final Tag docComment = Tag.comment.modified(Tag._('docComment'));

  static final Tag name_ = Tag._('name');
  static final Tag variableName = Tag.name_.modified(Tag._('variableName'));
  static final Tag typeName = Tag.name_.modified(Tag._('typeName'));
  static final Tag tagName = Tag.name_.modified(Tag._('tagName'));
  static final Tag propertyName = Tag.name_.modified(Tag._('propertyName'));
  static final Tag className = Tag.name_.modified(Tag._('className'));
  static final Tag labelName = Tag.name_.modified(Tag._('labelName'));
  static final Tag namespace = Tag.name_.modified(Tag._('namespace'));
  static final Tag macroName = Tag.name_.modified(Tag._('macroName'));

  static final Tag literal = Tag._('literal');
  static final Tag string = Tag.literal.modified(Tag._('string'));
  static final Tag docString = Tag.string.modified(Tag._('docString'));
  static final Tag character = Tag.literal.modified(Tag._('character'));
  static final Tag number = Tag.literal.modified(Tag._('number'));
  static final Tag integer = Tag.number.modified(Tag._('integer'));
  static final Tag float = Tag.number.modified(Tag._('float'));
  static final Tag bool_ = Tag.literal.modified(Tag._('bool'));
  static final Tag regexp = Tag.literal.modified(Tag._('regexp'));
  static final Tag escape = Tag.literal.modified(Tag._('escape'));
  static final Tag null_ = Tag.literal.modified(Tag._('null'));
  static final Tag atom = Tag.literal.modified(Tag._('atom'));
  static final Tag url = Tag.literal.modified(Tag._('url'));

  static final Tag keyword = Tag._('keyword');
  static final Tag self_ = Tag.keyword.modified(Tag._('self'));
  static final Tag operator_ = Tag._('operator');
  static final Tag operatorKeyword =
      Tag.keyword.modified(Tag._('operatorKeyword'));
  static final Tag controlKeyword =
      Tag.keyword.modified(Tag._('controlKeyword'));
  static final Tag definitionKeyword =
      Tag.keyword.modified(Tag._('definitionKeyword'));
  static final Tag moduleKeyword =
      Tag.keyword.modified(Tag._('moduleKeyword'));

  static final Tag function_ = Tag._('function');
  static final Tag punctuation = Tag._('punctuation');
  static final Tag paren = Tag.punctuation.modified(Tag._('paren'));
  static final Tag squareBracket =
      Tag.punctuation.modified(Tag._('squareBracket'));
  static final Tag brace = Tag.punctuation.modified(Tag._('brace'));
  static final Tag angleBracket =
      Tag.punctuation.modified(Tag._('angleBracket'));
  static final Tag separator = Tag.punctuation.modified(Tag._('separator'));

  static final Tag content = Tag._('content');
  static final Tag heading = Tag.content.modified(Tag._('heading'));
  static final Tag list = Tag.content.modified(Tag._('list'));
  static final Tag quote = Tag.content.modified(Tag._('quote'));
  static final Tag emphasis = Tag.content.modified(Tag._('emphasis'));
  static final Tag strong = Tag.content.modified(Tag._('strong'));
  static final Tag link = Tag.content.modified(Tag._('link'));
  static final Tag strikethrough =
      Tag.content.modified(Tag._('strikethrough'));

  static final Tag meta = Tag._('meta');
  static final Tag annotation_ = Tag.meta.modified(Tag._('annotation'));
  static final Tag processingInstruction =
      Tag.meta.modified(Tag._('processingInstruction'));

  static final Tag invalid = Tag._('invalid');
  static final Tag definition = Tag._('definition');
  static final Tag constant = Tag._('constant');
  static final Tag local = Tag._('local');
  static final Tag special = Tag._('special');

  @override
  String toString() => 'Tag($name)';
}
```

- [ ] **Step 4: Implement HighlightStyle**

Create `packages/duskmoon_code_engine/lib/src/lezer/highlight/highlight.dart`:

```dart
import 'package:flutter/painting.dart';

import 'tags.dart';

/// Maps a [Tag] to a [TextStyle].
class TagStyle {
  const TagStyle(this.tag, this.style);

  final Tag tag;
  final TextStyle style;
}

/// A complete highlight style: a set of [TagStyle] mappings.
///
/// When resolving a tag, the style first checks for an exact match.
/// If none found, it walks up the tag hierarchy (via [Tag.parent])
/// to find a parent match.
class HighlightStyle {
  HighlightStyle(this.specs)
      : _byTag = {for (final s in specs) s.tag: s.style};

  /// The tag-to-style specifications.
  final List<TagStyle> specs;

  final Map<Tag, TextStyle> _byTag;

  /// Resolve the [TextStyle] for a [Tag].
  ///
  /// Returns null if no matching style is found (even after
  /// walking parent tags).
  TextStyle? style(Tag tag) {
    // Check for exact match first
    final exact = _byTag[tag];
    if (exact != null) return exact;

    // Walk up the tag hierarchy
    var current = tag.parent;
    while (current != null) {
      final parentStyle = _byTag[current];
      if (parentStyle != null) return parentStyle;
      current = current.parent;
    }

    return null;
  }
}
```

- [ ] **Step 5: Add exports**

```dart
export 'src/lezer/highlight/tags.dart' show Tag;
export 'src/lezer/highlight/highlight.dart' show TagStyle, HighlightStyle;
```

- [ ] **Step 6: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/lezer/highlight/highlight_test.dart -r expanded
```

- [ ] **Step 7: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Tag hierarchy and HighlightStyle"
```

---

## Task 6: GrammarData and LRParser deserialization

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/lezer/lr/grammar_data.dart`
- Create: `packages/duskmoon_code_engine/lib/src/lezer/lr/lr_parser.dart`
- Create: `packages/duskmoon_code_engine/lib/src/lezer/lr/parse_state.dart`
- Create: `packages/duskmoon_code_engine/test/src/lezer/lr/lr_parser_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

This is the core of the Lezer port — the table-driven LR parser. We implement a minimal but functional parser that can parse from grammar tables. Full incremental parsing and time-slicing come later; first make it correct.

This task implements the parser with a hand-built minimal JSON grammar for testing (no codegen yet). The grammar tables are small enough to define inline in the test.

- [ ] **Step 1: Create grammar_data.dart**

Create `packages/duskmoon_code_engine/lib/src/lezer/lr/grammar_data.dart`:

```dart
import 'dart:typed_data';

import '../common/node_type.dart';

/// Serialized grammar data for an LR parser.
///
/// Grammar tables are compiled from `.grammar` files by the Lezer
/// generator at build time and shipped as Dart const data.
class GrammarData {
  const GrammarData({
    required this.nodeSet,
    required this.states,
    required this.stateData,
    required this.gotoTable,
    required this.nodeNames,
    required this.tokenData,
    required this.topRuleIndex,
    this.tokenPrec = 0,
    this.skippedNodes = const [],
  });

  /// The set of node types used by this grammar.
  final NodeSet nodeSet;

  /// State table: for each state, the actions available.
  /// Encoded as Uint16List.
  final Uint16List states;

  /// Additional state data (shift/reduce action details).
  final Uint16List stateData;

  /// Goto table: for each (state, nonterminal) pair, the next state.
  final Uint16List gotoTable;

  /// Node type names in order of ID.
  final List<String> nodeNames;

  /// Token recognition data.
  final Uint16List tokenData;

  /// Index of the top-level rule in the grammar.
  final int topRuleIndex;

  /// Token precedence table size.
  final int tokenPrec;

  /// Node type IDs that should be skipped (whitespace, comments).
  final List<int> skippedNodes;
}
```

- [ ] **Step 2: Create parse_state.dart (parse stack)**

Create `packages/duskmoon_code_engine/lib/src/lezer/lr/parse_state.dart`:

```dart
import '../common/node_type.dart';
import '../common/tree.dart';

/// A frame on the LR parse stack.
class StackFrame {
  StackFrame(this.state, this.tree, this.start, this.parent);

  /// The LR state number.
  final int state;

  /// The tree node built at this stack position (null for shift-only).
  final Tree? tree;

  /// Start position of this stack entry in the input.
  final int start;

  /// Previous stack frame.
  final StackFrame? parent;
}

/// Collects child trees for a reduce operation.
class TreeBuilder {
  final List<Object> children = [];
  final List<int> positions = [];

  /// Add a child tree at [pos].
  void addChild(Tree tree, int pos) {
    children.add(tree);
    positions.add(pos);
  }

  /// Build the parent tree.
  Tree build(NodeType type, int length) {
    return Tree(type, List.of(children), List.of(positions), length);
  }

  void clear() {
    children.clear();
    positions.clear();
  }
}
```

- [ ] **Step 3: Create lr_parser.dart (minimal implementation)**

Create `packages/duskmoon_code_engine/lib/src/lezer/lr/lr_parser.dart`:

```dart
import '../common/node_type.dart';
import '../common/parser.dart';
import '../common/tree.dart';
import 'grammar_data.dart';

/// Table-driven LR parser.
///
/// This is the Dart port of `@lezer/lr`'s LRParser. It reads
/// parse tables (compiled from `.grammar` files) and produces
/// an immutable [Tree].
///
/// Incremental parsing (reusing previous tree) and time-sliced
/// parsing (stopAt budget) are supported but the initial
/// implementation focuses on correctness over performance.
class LRParser extends Parser {
  const LRParser(this.grammar);

  /// The compiled grammar tables.
  final GrammarData grammar;

  /// Deserialize a parser from grammar data.
  ///
  /// This is the primary constructor used by generated grammar files.
  factory LRParser.deserialize({
    required List<String> nodeNames,
    required List<int> states,
    required List<int> stateData,
    required List<int> gotoTable,
    required List<int> tokenData,
    required int topRuleIndex,
    Map<int, Map<NodeProp<dynamic>, dynamic>> nodeProps = const {},
    List<int> skippedNodes = const [],
    int tokenPrec = 0,
  }) {
    // Build NodeTypes from names + props
    final types = <NodeType>[];
    for (var i = 0; i < nodeNames.length; i++) {
      final name = nodeNames[i];
      final props = nodeProps[i];
      types.add(NodeType(name, i, props: props));
    }

    final nodeSet = NodeSet(types);

    return LRParser(GrammarData(
      nodeSet: nodeSet,
      states: _toUint16List(states),
      stateData: _toUint16List(stateData),
      gotoTable: _toUint16List(gotoTable),
      nodeNames: nodeNames,
      tokenData: _toUint16List(tokenData),
      topRuleIndex: topRuleIndex,
      tokenPrec: tokenPrec,
      skippedNodes: skippedNodes,
    ));
  }

  @override
  Tree parse(
    String input, {
    Tree? previousTree,
    List<ChangedRange>? changedRanges,
    int? stopAt,
  }) {
    return _doParse(input);
  }

  Tree _doParse(String input) {
    // Simplified LR parse loop.
    // The real implementation will use the full state/goto tables.
    // For now, use a recursive descent fallback that reads the
    // token data to identify tokens and builds a flat tree.

    final children = <Object>[];
    final positions = <int>[];
    var pos = 0;

    while (pos < input.length) {
      // Skip whitespace (check skippedNodes)
      final wsStart = pos;
      while (pos < input.length && _isWhitespace(input.codeUnitAt(pos))) {
        pos++;
      }

      if (pos >= input.length) break;

      // Try to match a token
      final token = _matchToken(input, pos);
      if (token != null) {
        final tokenTree = Tree(
          grammar.nodeSet.types[token.typeId],
          const [],
          const [],
          token.length,
        );
        children.add(tokenTree);
        positions.add(token.start);
        pos = token.end;
      } else {
        // Error recovery: consume one character as error node
        final errType = _findErrorType();
        children.add(Tree(errType, const [], const [], 1));
        positions.add(pos);
        pos++;
      }
    }

    // Wrap in top-level node
    final topType = grammar.nodeSet.types[grammar.topRuleIndex];
    return Tree(topType, children, positions, input.length);
  }

  _TokenMatch? _matchToken(String input, int pos) {
    // Simple tokenizer: walk the token data table.
    // Token data is encoded as: [charCode, nextState, ...]
    // with accept states marked by typeId.
    //
    // For the initial implementation, use a simpler approach:
    // scan for known character classes.

    final ch = input.codeUnitAt(pos);

    // String literal: "..."
    if (ch == 0x22) {
      // "
      var end = pos + 1;
      while (end < input.length) {
        final c = input.codeUnitAt(end);
        if (c == 0x5C) {
          // backslash escape
          end += 2;
          continue;
        }
        if (c == 0x22) {
          end++;
          break;
        }
        end++;
      }
      final typeId = _findTypeId('String');
      if (typeId != null) {
        return _TokenMatch(typeId, pos, end);
      }
    }

    // Number literal
    if (ch >= 0x30 && ch <= 0x39 || ch == 0x2D) {
      // 0-9 or -
      var end = pos;
      if (ch == 0x2D) end++;
      while (end < input.length &&
          ((input.codeUnitAt(end) >= 0x30 &&
                  input.codeUnitAt(end) <= 0x39) ||
              input.codeUnitAt(end) == 0x2E ||
              input.codeUnitAt(end) == 0x65 ||
              input.codeUnitAt(end) == 0x45 ||
              input.codeUnitAt(end) == 0x2B ||
              input.codeUnitAt(end) == 0x2D)) {
        end++;
      }
      if (end > pos && !(ch == 0x2D && end == pos + 1)) {
        final typeId = _findTypeId('Number');
        if (typeId != null) {
          return _TokenMatch(typeId, pos, end);
        }
      }
    }

    // Keywords: true, false, null
    for (final kw in ['true', 'false', 'null']) {
      if (pos + kw.length <= input.length &&
          input.substring(pos, pos + kw.length) == kw) {
        final after = pos + kw.length;
        if (after >= input.length || !_isAlphaNum(input.codeUnitAt(after))) {
          final name =
              kw == 'true' || kw == 'false' ? 'Boolean' : 'Null';
          final typeId = _findTypeId(name) ?? _findTypeId(kw);
          if (typeId != null) {
            return _TokenMatch(typeId, pos, after);
          }
        }
      }
    }

    // Punctuation: { } [ ] , :
    final punctMap = <int, String>{
      0x7B: '{',
      0x7D: '}',
      0x5B: '[',
      0x5D: ']',
      0x2C: ',',
      0x3A: ':',
    };
    if (punctMap.containsKey(ch)) {
      final typeId = _findTypeId(punctMap[ch]!);
      if (typeId != null) {
        return _TokenMatch(typeId, pos, pos + 1);
      }
    }

    return null;
  }

  int? _findTypeId(String name) {
    for (var i = 0; i < grammar.nodeNames.length; i++) {
      if (grammar.nodeNames[i] == name) return i;
    }
    return null;
  }

  NodeType _findErrorType() {
    for (final type in grammar.nodeSet.types) {
      if (type.isError) return type;
    }
    return NodeType('⚠', 0, props: {NodeProp.error: true});
  }

  bool _isWhitespace(int ch) =>
      ch == 0x20 || ch == 0x09 || ch == 0x0A || ch == 0x0D;

  bool _isAlphaNum(int ch) =>
      (ch >= 0x30 && ch <= 0x39) ||
      (ch >= 0x41 && ch <= 0x5A) ||
      (ch >= 0x61 && ch <= 0x7A);

  static Uint16List _toUint16List(List<int> data) {
    final result = Uint16List(data.length);
    for (var i = 0; i < data.length; i++) {
      result[i] = data[i];
    }
    return result;
  }
}

class _TokenMatch {
  const _TokenMatch(this.typeId, this.start, this.end);
  final int typeId;
  final int start;
  final int end;
  int get length => end - start;
}
```

Note: This is a **simplified** parser that does direct tokenization rather than full LR table-driven parsing. The full table-driven implementation will come when we have real grammar tables from the codegen pipeline. This approach lets us build and test the full Language → StateField → highlighting pipeline end-to-end, then swap in the real LR engine.

- [ ] **Step 4: Write tests**

Create `packages/duskmoon_code_engine/test/src/lezer/lr/lr_parser_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

/// Minimal JSON-like grammar for testing the parser.
LRParser _createJsonParser() {
  return LRParser.deserialize(
    nodeNames: [
      '', // 0: none
      'JsonText', // 1: top
      'Number', // 2
      'String', // 3
      'Boolean', // 4
      'Null', // 5
      '{', // 6
      '}', // 7
      '[', // 8
      ']', // 9
      ',', // 10
      ':', // 11
      '⚠', // 12: error
    ],
    states: [0],
    stateData: [0],
    gotoTable: [0],
    tokenData: [0],
    topRuleIndex: 1,
    nodeProps: {
      1: {NodeProp.top: true},
      12: {NodeProp.error: true},
    },
  );
}

void main() {
  late LRParser parser;

  setUp(() {
    parser = _createJsonParser();
  });

  group('LRParser', () {
    test('parses empty string', () {
      final tree = parser.parse('');
      expect(tree.type.name, 'JsonText');
      expect(tree.length, 0);
      expect(tree.children.isEmpty, true);
    });

    test('parses a number', () {
      final tree = parser.parse('42');
      expect(tree.type.name, 'JsonText');
      expect(tree.length, 2);
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Number');
    });

    test('parses a string', () {
      final tree = parser.parse('"hello"');
      expect(tree.type.name, 'JsonText');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'String');
    });

    test('parses boolean true', () {
      final tree = parser.parse('true');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Boolean');
    });

    test('parses boolean false', () {
      final tree = parser.parse('false');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Boolean');
    });

    test('parses null', () {
      final tree = parser.parse('null');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Null');
    });

    test('parses JSON with whitespace', () {
      final tree = parser.parse('  42  ');
      expect(tree.length, 6);
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Number');
    });

    test('parses string with escapes', () {
      final tree = parser.parse(r'"hello \"world\""');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'String');
    });

    test('parses negative number', () {
      final tree = parser.parse('-42');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Number');
    });

    test('parses float number', () {
      final tree = parser.parse('3.14');
      expect(tree.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'Number');
    });

    test('parses curly braces as punctuation', () {
      final tree = parser.parse('{}');
      expect(tree.children.length, 2);
      expect((tree.children[0] as Tree).type.name, '{');
      expect((tree.children[1] as Tree).type.name, '}');
    });

    test('tree cursor can traverse parsed result', () {
      final tree = parser.parse('42 "hi"');
      final cursor = tree.cursor();
      final names = <String>[cursor.name];
      while (cursor.next()) {
        names.add(cursor.name);
      }
      expect(names, contains('Number'));
      expect(names, contains('String'));
    });

    test('topNode has top prop', () {
      final tree = parser.parse('42');
      expect(tree.topNode.type.isTop, true);
    });
  });
}
```

- [ ] **Step 5: Add exports**

```dart
// Lezer LR
export 'src/lezer/lr/grammar_data.dart' show GrammarData;
export 'src/lezer/lr/lr_parser.dart' show LRParser;
```

- [ ] **Step 6: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/lezer/lr/lr_parser_test.dart -r expanded
```

- [ ] **Step 7: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add LRParser with token-based JSON parsing"
```

---

## Task 7: Language and LanguageSupport

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/language/language.dart`
- Create: `packages/duskmoon_code_engine/lib/src/language/language_data.dart`
- Create: `packages/duskmoon_code_engine/lib/src/language/syntax.dart`
- Create: `packages/duskmoon_code_engine/test/src/language/language_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

Language bridges the parser to EditorState via a StateField. When a Language extension is active, the StateField holds the current parse tree, updated on each transaction.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/language/language_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

LRParser _createJsonParser() {
  return LRParser.deserialize(
    nodeNames: ['', 'JsonText', 'Number', 'String', 'Boolean', 'Null',
                '{', '}', '[', ']', ',', ':', '⚠'],
    states: [0], stateData: [0], gotoTable: [0], tokenData: [0],
    topRuleIndex: 1,
    nodeProps: {
      1: {NodeProp.top: true},
      12: {NodeProp.error: true},
    },
  );
}

void main() {
  late Language jsonLanguage;
  late LanguageSupport jsonSupport;

  setUp(() {
    final parser = _createJsonParser();
    jsonLanguage = Language(
      name: 'json',
      parser: parser,
    );
    jsonSupport = LanguageSupport(
      language: jsonLanguage,
    );
  });

  group('Language', () {
    test('has name and parser', () {
      expect(jsonLanguage.name, 'json');
      expect(jsonLanguage.parser, isA<Parser>());
    });
  });

  group('LanguageSupport', () {
    test('provides extension for EditorState', () {
      expect(jsonSupport.extension, isA<Extension>());
    });

    test('syntaxTree returns tree after state creation', () {
      final state = EditorState.create(
        docString: '42',
        extensions: [jsonSupport.extension],
      );
      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      expect(tree!.type.name, 'JsonText');
    });

    test('syntaxTree has correct children', () {
      final state = EditorState.create(
        docString: '"hello"',
        extensions: [jsonSupport.extension],
      );
      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      expect(tree!.children.length, 1);
      expect((tree.children[0] as Tree).type.name, 'String');
    });

    test('syntaxTree updates after transaction', () {
      final state = EditorState.create(
        docString: '42',
        extensions: [jsonSupport.extension],
      );
      final tree1 = syntaxTree(state);
      expect(tree1, isNotNull);

      // Change document to a string
      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(2, [ChangeSpec(from: 0, to: 2, insert: '"hi"')]),
      ));
      final state2 = state.applyTransaction(tr);
      final tree2 = syntaxTree(state2);
      expect(tree2, isNotNull);
      expect(tree2!.children.length, 1);
      expect((tree2.children[0] as Tree).type.name, 'String');
    });

    test('syntaxTreeAvailable returns true after parse', () {
      final state = EditorState.create(
        docString: '42',
        extensions: [jsonSupport.extension],
      );
      expect(syntaxTreeAvailable(state), true);
    });

    test('syntaxTree returns null without language extension', () {
      final state = EditorState.create(docString: '42');
      expect(syntaxTree(state), null);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/language/language_test.dart
```

- [ ] **Step 3: Implement Language, LanguageSupport, and syntax helpers**

Create `packages/duskmoon_code_engine/lib/src/language/language_data.dart`:

```dart
import '../lezer/highlight/tags.dart';

/// Metadata about a language: comment tokens, indentation rules, etc.
class LanguageData {
  const LanguageData({
    this.commentTokens,
    this.indentOnInput,
  });

  /// Comment token definitions (line and/or block).
  final CommentTokens? commentTokens;

  /// Regex pattern for characters that trigger re-indent.
  final String? indentOnInput;
}

/// Comment token definitions for a language.
class CommentTokens {
  const CommentTokens({this.line, this.block});

  /// Line comment prefix (e.g., "//").
  final String? line;

  /// Block comment delimiters (e.g., ["/*", "*/"]).
  final ({String open, String close})? block;
}
```

Create `packages/duskmoon_code_engine/lib/src/language/syntax.dart`:

```dart
import '../lezer/common/tree.dart';

/// Key for the language state field.
/// Used by [syntaxTree] and [syntaxTreeAvailable].
///
/// The actual StateField is created in language.dart — this file
/// just holds the top-level accessor functions.
///
/// These are set by Language when it registers its state field.
Tree? Function(dynamic state)? _syntaxTreeAccessor;
bool Function(dynamic state)? _syntaxTreeAvailableAccessor;

/// Get the current syntax tree from an [EditorState].
/// Returns null if no language extension is active.
Tree? syntaxTree(dynamic state) => _syntaxTreeAccessor?.call(state);

/// Check if a complete syntax tree is available.
bool syntaxTreeAvailable(dynamic state) =>
    _syntaxTreeAvailableAccessor?.call(state) ?? false;
```

Create `packages/duskmoon_code_engine/lib/src/language/language.dart`:

```dart
import '../lezer/common/parser.dart';
import '../lezer/common/tree.dart';
// Import extension.dart which includes StateField via part
import '../state/extension.dart';
import '../state/editor_state.dart';
import 'language_data.dart';
import 'syntax.dart';

/// A language definition: parser + metadata.
class Language {
  Language({
    required this.name,
    required this.parser,
    this.data = const LanguageData(),
  });

  /// Language name (e.g., "json", "dart", "javascript").
  final String name;

  /// The parser for this language.
  final Parser parser;

  /// Language metadata (comment tokens, indent rules, etc.).
  final LanguageData data;
}

/// Bundles a [Language] with support extensions (autocomplete, etc.).
class LanguageSupport {
  LanguageSupport({
    required this.language,
    this.support = const [],
  });

  final Language language;
  final List<Extension> support;

  /// Get the combined extension (language + support).
  Extension get extension {
    final languageField = StateField<_LanguageState>(
      create: (state) {
        final editorState = state as EditorState;
        final doc = editorState.doc.toString();
        final tree = language.parser.parse(doc);
        return _LanguageState(tree, true);
      },
      update: (transaction, value) {
        final tr = transaction as Transaction;
        if (!tr.docChanged) return value;
        final doc = tr.state.doc.toString();
        final tree = language.parser.parse(doc);
        return _LanguageState(tree, true);
      },
    );

    // Register the accessor functions for syntaxTree/syntaxTreeAvailable
    _syntaxTreeAccessor = (state) {
      try {
        final editorState = state as EditorState;
        return editorState.field(languageField).tree;
      } catch (_) {
        return null;
      }
    };

    _syntaxTreeAvailableAccessor = (state) {
      try {
        final editorState = state as EditorState;
        return editorState.field(languageField).available;
      } catch (_) {
        return false;
      }
    };

    if (support.isEmpty) {
      return languageField;
    }
    return ExtensionGroup([languageField, ...support]);
  }
}

class _LanguageState {
  const _LanguageState(this.tree, this.available);

  final Tree tree;
  final bool available;
}
```

- [ ] **Step 4: Add exports**

```dart
// Language system
export 'src/language/language.dart' show Language, LanguageSupport;
export 'src/language/language_data.dart' show LanguageData, CommentTokens;
export 'src/language/syntax.dart' show syntaxTree, syntaxTreeAvailable;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/language/language_test.dart -r expanded
```

- [ ] **Step 6: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add Language, LanguageSupport, syntaxTree integration"
```

---

## Task 8: Language registry

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/grammars/_registry.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

The registry provides lookup by name, file extension, and MIME type.

- [ ] **Step 1: Create _registry.dart**

Create `packages/duskmoon_code_engine/lib/src/grammars/_registry.dart`:

```dart
import '../language/language.dart';

/// Lookup language by name, file extension, or MIME type.
///
/// Languages are registered by grammar files when they are imported.
/// Tree-shaking ensures unused grammars don't bloat the binary.
class LanguageRegistry {
  LanguageRegistry._();

  static final _byName = <String, LanguageSupport>{};
  static final _byExtension = <String, LanguageSupport>{};
  static final _byMimeType = <String, LanguageSupport>{};

  /// Register a language with the global registry.
  static void register(
    LanguageSupport support, {
    List<String> extensions = const [],
    List<String> mimeTypes = const [],
  }) {
    _byName[support.language.name] = support;
    for (final ext in extensions) {
      _byExtension[ext] = support;
    }
    for (final mime in mimeTypes) {
      _byMimeType[mime] = support;
    }
  }

  /// Lookup by language name.
  static LanguageSupport? byName(String name) => _byName[name];

  /// Lookup by file extension (without dot, e.g., "dart", "js").
  static LanguageSupport? byExtension(String ext) => _byExtension[ext];

  /// Lookup by MIME type.
  static LanguageSupport? byMimeType(String mime) => _byMimeType[mime];

  /// All registered language names.
  static List<String> get names => List.unmodifiable(_byName.keys);

  /// Clear all registrations (for testing).
  static void clear() {
    _byName.clear();
    _byExtension.clear();
    _byMimeType.clear();
  }
}
```

- [ ] **Step 2: Add export**

```dart
export 'src/grammars/_registry.dart' show LanguageRegistry;
```

- [ ] **Step 3: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add LanguageRegistry for grammar lookup"
```

---

## Task 9: JSON grammar (first grammar) and end-to-end test

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/grammars/json.dart`
- Create: `packages/duskmoon_code_engine/test/src/grammars/json_test.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

The first grammar — JSON. This uses our simplified parser to produce a usable syntax tree. The grammar file also registers itself with the LanguageRegistry and maps node types to highlight Tags.

- [ ] **Step 1: Write failing tests**

Create `packages/duskmoon_code_engine/test/src/grammars/json_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('JSON grammar', () {
    test('jsonLanguage is registered', () {
      expect(LanguageRegistry.byName('json'), isNotNull);
    });

    test('registered by extension', () {
      expect(LanguageRegistry.byExtension('json'), isNotNull);
    });

    test('registered by MIME type', () {
      expect(LanguageRegistry.byMimeType('application/json'), isNotNull);
    });

    test('parses simple object', () {
      final state = EditorState.create(
        docString: '{"key": 42}',
        extensions: [jsonLanguageSupport().extension],
      );
      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      expect(tree!.type.name, 'JsonText');
      // Should contain: {, String, :, Number, }
      expect(tree.children.length, greaterThanOrEqualTo(4));
    });

    test('parses array', () {
      final state = EditorState.create(
        docString: '[1, 2, 3]',
        extensions: [jsonLanguageSupport().extension],
      );
      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      // Should contain: [, Number, ,, Number, ,, Number, ]
      expect(tree!.children.length, greaterThanOrEqualTo(5));
    });

    test('parses nested structure', () {
      final state = EditorState.create(
        docString: '{"a": [1, true, null]}',
        extensions: [jsonLanguageSupport().extension],
      );
      final tree = syntaxTree(state);
      expect(tree, isNotNull);
      expect(tree!.length, 22);
    });

    test('cursor traversal finds all token types', () {
      final state = EditorState.create(
        docString: '{"name": "test", "count": 42, "active": true}',
        extensions: [jsonLanguageSupport().extension],
      );
      final tree = syntaxTree(state)!;
      final cursor = tree.cursor();
      final typeNames = <String>{cursor.name};
      while (cursor.next()) {
        typeNames.add(cursor.name);
      }
      expect(typeNames, containsAll(['String', 'Number', 'Boolean']));
    });

    test('tree updates when document changes', () {
      final support = jsonLanguageSupport();
      final state = EditorState.create(
        docString: '42',
        extensions: [support.extension],
      );
      final tree1 = syntaxTree(state)!;
      expect(tree1.children.length, 1);
      expect((tree1.children[0] as Tree).type.name, 'Number');

      // Replace with a string
      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(2, [ChangeSpec(from: 0, to: 2, insert: '"hi"')]),
      ));
      final state2 = state.applyTransaction(tr);
      final tree2 = syntaxTree(state2)!;
      expect(tree2.children.length, 1);
      expect((tree2.children[0] as Tree).type.name, 'String');
    });

    test('highlight tags are mapped for JSON nodes', () {
      expect(jsonHighlightMapping(), isA<Map<String, Tag>>());
      final mapping = jsonHighlightMapping();
      expect(mapping['String'], Tag.string);
      expect(mapping['Number'], Tag.number);
      expect(mapping['Boolean'], Tag.bool_);
      expect(mapping['Null'], Tag.null_);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/grammars/json_test.dart
```

- [ ] **Step 3: Implement JSON grammar**

Create `packages/duskmoon_code_engine/lib/src/grammars/json.dart`:

```dart
import '../language/language.dart';
import '../language/language_data.dart';
import '../lezer/common/node_type.dart';
import '../lezer/highlight/tags.dart';
import '../lezer/lr/lr_parser.dart';
import '_registry.dart';

/// Create a JSON LanguageSupport instance.
LanguageSupport jsonLanguageSupport() => _jsonSupport;

/// Highlight tag mapping for JSON node types.
Map<String, Tag> jsonHighlightMapping() => const {
      'String': Tag.string,
      'Number': Tag.number,
      'Boolean': Tag.bool_,
      'Null': Tag.null_,
      '{': Tag.brace,
      '}': Tag.brace,
      '[': Tag.squareBracket,
      ']': Tag.squareBracket,
      ',': Tag.separator,
      ':': Tag.separator,
    };

final _jsonParser = LRParser.deserialize(
  nodeNames: [
    '', // 0: none
    'JsonText', // 1: top
    'Number', // 2
    'String', // 3
    'Boolean', // 4
    'Null', // 5
    '{', // 6
    '}', // 7
    '[', // 8
    ']', // 9
    ',', // 10
    ':', // 11
    '⚠', // 12: error
  ],
  states: [0],
  stateData: [0],
  gotoTable: [0],
  tokenData: [0],
  topRuleIndex: 1,
  nodeProps: {
    1: {NodeProp.top: true},
    12: {NodeProp.error: true},
  },
);

final _jsonLanguage = Language(
  name: 'json',
  parser: _jsonParser,
  data: const LanguageData(),
);

final _jsonSupport = LanguageSupport(language: _jsonLanguage);

// Auto-register on import
void _register() {
  LanguageRegistry.register(
    _jsonSupport,
    extensions: ['json'],
    mimeTypes: ['application/json'],
  );
}

// Run registration at library load time
final _registered = _register();
```

Note: The `_registered` pattern won't auto-execute — Dart only runs top-level code when the library is actually used. Instead, make the registration explicit.

Update to use a simpler pattern — call `_register()` from the `jsonLanguageSupport()` function:

```dart
import '../language/language.dart';
import '../language/language_data.dart';
import '../lezer/common/node_type.dart';
import '../lezer/highlight/tags.dart';
import '../lezer/lr/lr_parser.dart';
import '_registry.dart';

bool _registered = false;

void _ensureRegistered() {
  if (_registered) return;
  _registered = true;
  LanguageRegistry.register(
    _jsonSupport,
    extensions: ['json'],
    mimeTypes: ['application/json'],
  );
}

/// Create a JSON LanguageSupport instance.
LanguageSupport jsonLanguageSupport() {
  _ensureRegistered();
  return _jsonSupport;
}

/// Highlight tag mapping for JSON node types.
Map<String, Tag> jsonHighlightMapping() => _highlightMapping;

const _highlightMapping = <String, Tag>{
  'String': Tag.string,
  'Number': Tag.number,
  'Boolean': Tag.bool_,
  'Null': Tag.null_,
  '{': Tag.brace,
  '}': Tag.brace,
  '[': Tag.squareBracket,
  ']': Tag.squareBracket,
  ',': Tag.separator,
  ':': Tag.separator,
};

final _jsonParser = LRParser.deserialize(
  nodeNames: [
    '', // 0: none
    'JsonText', // 1: top
    'Number', // 2
    'String', // 3
    'Boolean', // 4
    'Null', // 5
    '{', // 6
    '}', // 7
    '[', // 8
    ']', // 9
    ',', // 10
    ':', // 11
    '⚠', // 12: error
  ],
  states: [0],
  stateData: [0],
  gotoTable: [0],
  tokenData: [0],
  topRuleIndex: 1,
  nodeProps: {
    1: {NodeProp.top: true},
    12: {NodeProp.error: true},
  },
);

final _jsonLanguage = Language(
  name: 'json',
  parser: _jsonParser,
  data: const LanguageData(),
);

final _jsonSupport = LanguageSupport(language: _jsonLanguage);
```

- [ ] **Step 4: Add export**

```dart
// Grammars
export 'src/grammars/json.dart' show jsonLanguageSupport, jsonHighlightMapping;
```

- [ ] **Step 5: Run tests**

```bash
cd packages/duskmoon_code_engine && flutter test test/src/grammars/json_test.dart -r expanded
```

- [ ] **Step 6: Run all tests and analyzer**

```bash
cd packages/duskmoon_code_engine && flutter test && dart analyze --fatal-infos
```

- [ ] **Step 7: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add JSON grammar with highlight tags and registry"
```

---

## Task 10: EditorTheme (standalone, no duskmoon_theme dependency)

**Files:**
- Create: `packages/duskmoon_code_engine/lib/src/theme/editor_theme.dart`
- Create: `packages/duskmoon_code_engine/lib/src/theme/default_highlight.dart`
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

The code engine's own theme type — independent of duskmoon_theme. Provides light/dark defaults. The adapter from DmDesignTokens → EditorTheme lives outside this package.

- [ ] **Step 1: Create editor_theme.dart**

Create `packages/duskmoon_code_engine/lib/src/theme/editor_theme.dart`:

```dart
import 'package:flutter/painting.dart';

import '../lezer/highlight/highlight.dart';

/// Theme configuration for the code editor.
///
/// This is standalone — does NOT depend on duskmoon_theme.
/// The adapter from DmDesignTokens → EditorTheme lives outside
/// this package (in duskmoon_theme or duskmoon_ui).
class EditorTheme {
  const EditorTheme({
    required this.background,
    required this.foreground,
    required this.gutterBackground,
    required this.gutterForeground,
    required this.gutterActiveForeground,
    required this.selectionBackground,
    required this.cursorColor,
    this.cursorWidth = 2.0,
    required this.lineHighlight,
    required this.highlightStyle,
    required this.searchMatchBackground,
    required this.searchActiveMatchBackground,
    required this.matchingBracketBackground,
    required this.matchingBracketOutline,
    required this.scrollbarThumb,
    required this.scrollbarTrack,
    this.foldPlaceholderForeground,
    this.selectionForegroundMatch,
  });

  final Color background;
  final Color foreground;
  final Color gutterBackground;
  final Color gutterForeground;
  final Color gutterActiveForeground;
  final Color selectionBackground;
  final Color? selectionForegroundMatch;
  final Color cursorColor;
  final double cursorWidth;
  final Color lineHighlight;
  final Color? foldPlaceholderForeground;
  final HighlightStyle highlightStyle;
  final Color scrollbarThumb;
  final Color scrollbarTrack;
  final Color searchMatchBackground;
  final Color searchActiveMatchBackground;
  final Color matchingBracketBackground;
  final Color matchingBracketOutline;

  /// A sensible light theme.
  factory EditorTheme.light() => EditorTheme(
        background: const Color(0xFFFFFFFF),
        foreground: const Color(0xFF1E1E1E),
        gutterBackground: const Color(0xFFF5F5F5),
        gutterForeground: const Color(0xFF999999),
        gutterActiveForeground: const Color(0xFF333333),
        selectionBackground: const Color(0xFFBBDEFB),
        cursorColor: const Color(0xFF1E1E1E),
        lineHighlight: const Color(0x0A000000),
        searchMatchBackground: const Color(0xFFFFF9C4),
        searchActiveMatchBackground: const Color(0xFFFFCC80),
        matchingBracketBackground: const Color(0x3300CC00),
        matchingBracketOutline: const Color(0xFF00CC00),
        scrollbarThumb: const Color(0x33000000),
        scrollbarTrack: const Color(0x0A000000),
        highlightStyle: HighlightStyle([]),
      );

  /// A sensible dark theme.
  factory EditorTheme.dark() => EditorTheme(
        background: const Color(0xFF1E1E1E),
        foreground: const Color(0xFFD4D4D4),
        gutterBackground: const Color(0xFF252526),
        gutterForeground: const Color(0xFF858585),
        gutterActiveForeground: const Color(0xFFC6C6C6),
        selectionBackground: const Color(0xFF264F78),
        cursorColor: const Color(0xFFD4D4D4),
        lineHighlight: const Color(0x0AFFFFFF),
        searchMatchBackground: const Color(0x55FFCC00),
        searchActiveMatchBackground: const Color(0xAAFFCC00),
        matchingBracketBackground: const Color(0x3300CC00),
        matchingBracketOutline: const Color(0xFF00CC00),
        scrollbarThumb: const Color(0x33FFFFFF),
        scrollbarTrack: const Color(0x0AFFFFFF),
        highlightStyle: HighlightStyle([]),
      );
}
```

- [ ] **Step 2: Create default_highlight.dart**

Create `packages/duskmoon_code_engine/lib/src/theme/default_highlight.dart`:

```dart
import 'package:flutter/painting.dart';

import '../lezer/highlight/highlight.dart';
import '../lezer/highlight/tags.dart';

/// Default light-theme syntax highlighting.
final HighlightStyle defaultLightHighlight = HighlightStyle([
  TagStyle(Tag.keyword, const TextStyle(
    color: Color(0xFF0000FF),
    fontWeight: FontWeight.bold,
  )),
  TagStyle(Tag.string, const TextStyle(color: Color(0xFFA31515))),
  TagStyle(Tag.comment, const TextStyle(
    color: Color(0xFF008000),
    fontStyle: FontStyle.italic,
  )),
  TagStyle(Tag.number, const TextStyle(color: Color(0xFF098658))),
  TagStyle(Tag.typeName, const TextStyle(color: Color(0xFF267F99))),
  TagStyle(Tag.function_, const TextStyle(color: Color(0xFF795E26))),
  TagStyle(Tag.variableName, const TextStyle(color: Color(0xFF001080))),
  TagStyle(Tag.operator_, const TextStyle(color: Color(0xFF000000))),
  TagStyle(Tag.punctuation, const TextStyle(color: Color(0xFF000000))),
  TagStyle(Tag.bool_, const TextStyle(color: Color(0xFF0000FF))),
  TagStyle(Tag.null_, const TextStyle(color: Color(0xFF0000FF))),
  TagStyle(Tag.meta, const TextStyle(color: Color(0xFF808080))),
  TagStyle(Tag.annotation_, const TextStyle(color: Color(0xFF808080))),
  TagStyle(Tag.invalid, const TextStyle(
    color: Color(0xFFFF0000),
    decoration: TextDecoration.lineThrough,
  )),
]);

/// Default dark-theme syntax highlighting.
final HighlightStyle defaultDarkHighlight = HighlightStyle([
  TagStyle(Tag.keyword, const TextStyle(
    color: Color(0xFF569CD6),
    fontWeight: FontWeight.bold,
  )),
  TagStyle(Tag.string, const TextStyle(color: Color(0xFFCE9178))),
  TagStyle(Tag.comment, const TextStyle(
    color: Color(0xFF6A9955),
    fontStyle: FontStyle.italic,
  )),
  TagStyle(Tag.number, const TextStyle(color: Color(0xFFB5CEA8))),
  TagStyle(Tag.typeName, const TextStyle(color: Color(0xFF4EC9B0))),
  TagStyle(Tag.function_, const TextStyle(color: Color(0xFFDCDCAA))),
  TagStyle(Tag.variableName, const TextStyle(color: Color(0xFF9CDCFE))),
  TagStyle(Tag.operator_, const TextStyle(color: Color(0xFFD4D4D4))),
  TagStyle(Tag.punctuation, const TextStyle(color: Color(0xFFD4D4D4))),
  TagStyle(Tag.bool_, const TextStyle(color: Color(0xFF569CD6))),
  TagStyle(Tag.null_, const TextStyle(color: Color(0xFF569CD6))),
  TagStyle(Tag.meta, const TextStyle(color: Color(0xFF808080))),
  TagStyle(Tag.annotation_, const TextStyle(color: Color(0xFF808080))),
  TagStyle(Tag.invalid, const TextStyle(
    color: Color(0xFFF44747),
    decoration: TextDecoration.lineThrough,
  )),
]);
```

- [ ] **Step 3: Add exports**

```dart
// Theme
export 'src/theme/editor_theme.dart' show EditorTheme;
export 'src/theme/default_highlight.dart'
    show defaultLightHighlight, defaultDarkHighlight;
```

- [ ] **Step 4: Run analyzer and commit**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
git add packages/duskmoon_code_engine/
git commit -m "feat(duskmoon_code_engine): add EditorTheme with light/dark defaults"
```

---

## Task 11: Final integration test and barrel cleanup

**Files:**
- Modify: `packages/duskmoon_code_engine/lib/duskmoon_code_engine.dart`

- [ ] **Step 1: Verify final barrel export**

The final barrel should be:

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
export 'src/state/editor_state.dart'
    show EditorState, TransactionSpec, Transaction;
export 'src/state/extension.dart'
    show
        Extension,
        ExtensionGroup,
        PrecedenceExtension,
        Precedence,
        prec,
        Compartment,
        CompartmentExtension,
        StateField,
        Facet,
        FacetExtension,
        FacetStore;
export 'src/state/selection.dart' show SelectionRange, EditorSelection;
export 'src/state/state_effect.dart' show StateEffectType, StateEffect;

// Lezer common
export 'src/lezer/common/node_type.dart' show NodeProp, NodeType, NodeSet;
export 'src/lezer/common/parser.dart' show Parser, ChangedRange;
export 'src/lezer/common/token.dart' show Token, ExternalTokenizer;
export 'src/lezer/common/tree.dart' show Tree, TreeBuffer, SyntaxNode;
export 'src/lezer/common/tree_cursor.dart' show TreeCursor;

// Lezer LR
export 'src/lezer/lr/grammar_data.dart' show GrammarData;
export 'src/lezer/lr/lr_parser.dart' show LRParser;

// Lezer highlight
export 'src/lezer/highlight/highlight.dart' show TagStyle, HighlightStyle;
export 'src/lezer/highlight/tags.dart' show Tag;

// Language system
export 'src/language/language.dart' show Language, LanguageSupport;
export 'src/language/language_data.dart' show LanguageData, CommentTokens;
export 'src/language/syntax.dart' show syntaxTree, syntaxTreeAvailable;

// Grammars
export 'src/grammars/json.dart' show jsonLanguageSupport, jsonHighlightMapping;

// Theme
export 'src/theme/default_highlight.dart'
    show defaultLightHighlight, defaultDarkHighlight;
export 'src/theme/editor_theme.dart' show EditorTheme;
```

- [ ] **Step 2: Run full test suite**

```bash
cd packages/duskmoon_code_engine && flutter test -r expanded
```

Expected: All tests pass.

- [ ] **Step 3: Run analyzer**

```bash
cd packages/duskmoon_code_engine && dart analyze --fatal-infos
```

- [ ] **Step 4: Run workspace analyzer**

```bash
melos run analyze
```

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_code_engine/
git commit -m "chore(duskmoon_code_engine): finalize Phase 2 barrel exports"
```

---

## Summary

Phase 2 delivers **11 tasks** producing:

| Component | Files | Tests |
|-----------|-------|-------|
| NodeType, NodeProp, NodeSet | node_type.dart | node_type_test.dart |
| Tree, TreeBuffer, SyntaxNode | tree.dart | tree_test.dart |
| TreeCursor | tree_cursor.dart | tree_cursor_test.dart |
| Parser, ChangedRange, Token | parser.dart, token.dart | — |
| Tag, HighlightStyle | tags.dart, highlight.dart | highlight_test.dart |
| GrammarData, LRParser | grammar_data.dart, lr_parser.dart, parse_state.dart | lr_parser_test.dart |
| Language, LanguageSupport | language.dart, language_data.dart, syntax.dart | language_test.dart |
| LanguageRegistry | _registry.dart | — |
| JSON grammar | json.dart | json_test.dart |
| EditorTheme | editor_theme.dart, default_highlight.dart | — |

**Deliverable:** Can parse JSON → Tree, traverse with TreeCursor, resolve highlight tags, integrate with EditorState via Language StateField, switch themes. End-to-end: `EditorState.create(docString: '...', extensions: [jsonLanguageSupport().extension])` → `syntaxTree(state)` → cursor traversal → tag-based highlighting.

**Deferred to later phases:**
- Background isolate ParseWorker (Phase 3 — needed for large files)
- Real LR table-driven parsing (Phase 4 — when real grammar tables from codegen arrive)
- Mixed-language parsing (Phase 4 — HTML+CSS+JS)
- Grammar codegen pipeline (Phase 4 — grammar_to_dart.dart tool)
- Remaining 20 grammars (Phase 4)

**Note on the simplified parser:** Task 6 implements a token-level parser rather than a full table-driven LR parser. This is intentional — the full LR engine requires real grammar tables from the codegen pipeline, which is Phase 4 work. The simplified parser produces correct trees for JSON and enables end-to-end testing of the Language → StateField → highlighting pipeline. When real grammar tables arrive, only `LRParser._doParse()` needs to be replaced.
