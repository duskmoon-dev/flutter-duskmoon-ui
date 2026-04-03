import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EditorState creation', () {
    test('default empty document', () {
      final state = EditorState.create();
      expect(state.doc.length, 0);
      expect(state.doc.toString(), '');
      expect(state.selection, EditorSelection.cursor(0));
    });

    test('from docString', () {
      final state = EditorState.create(docString: 'hello world');
      expect(state.doc.toString(), 'hello world');
      expect(state.doc.length, 11);
    });

    test('from Document object', () {
      final doc = Document.fromString('abc');
      final state = EditorState.create(doc: doc);
      expect(state.doc.toString(), 'abc');
      expect(state.doc.length, 3);
    });

    test('with initial selection', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.single(anchor: 1, head: 3),
      );
      expect(state.selection.main.anchor, 1);
      expect(state.selection.main.head, 3);
    });

    test('with facet extensions (read facet value)', () {
      final tabSize = Facet<int, int>(
        combine: (values) => values.isEmpty ? 4 : values.last,
      );

      final state = EditorState.create(
        docString: 'code',
        extensions: [tabSize.of(2)],
      );

      expect(state.facet(tabSize), 2);
    });
  });

  group('EditorState.facet', () {
    test('no provider returns combine of empty list', () {
      final facet = Facet<String, String>(
        combine: (values) => values.isEmpty ? '<default>' : values.join(', '),
      );

      final state = EditorState.create();
      expect(state.facet(facet), '<default>');
    });

    test('with providers returns combined value', () {
      final facet = Facet<String, String>(
        combine: (values) => values.join('+'),
      );

      final state = EditorState.create(
        extensions: [facet.of('a'), facet.of('b'), facet.of('c')],
      );

      expect(state.facet(facet), 'a+b+c');
    });
  });

  group('EditorState.field', () {
    test('reads field created during init', () {
      final counter = StateField<int>(
        create: (_) => 0,
        update: (_, value) => value,
      );

      final state = EditorState.create(extensions: [counter]);
      expect(state.field(counter), 0);
    });

    test('field updates through transaction', () {
      // A counter that increments on every transaction.
      final counter = StateField<int>(
        create: (_) => 0,
        update: (_, value) => value + 1,
      );

      final state = EditorState.create(
        docString: 'hello',
        extensions: [counter],
      );
      expect(state.field(counter), 0);

      final tr = state.update(const TransactionSpec());
      final newState = state.applyTransaction(tr);
      expect(newState.field(counter), 1);

      // Second transaction increments again.
      final tr2 = newState.update(const TransactionSpec());
      final newState2 = newState.applyTransaction(tr2);
      expect(newState2.field(counter), 2);
    });
  });

  group('Transaction', () {
    test('text change (docChanged=true, new doc content)', () {
      final state = EditorState.create(docString: 'hello');

      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(5, [
          const ChangeSpec(from: 5, insert: ' world'),
        ]),
      ));

      expect(tr.docChanged, isTrue);
      final newState = state.applyTransaction(tr);
      expect(newState.doc.toString(), 'hello world');
    });

    test('maps selection through changes', () {
      // Cursor at position 5, insert text before it.
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(5),
      );

      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(5, [
          const ChangeSpec(from: 0, to: 0, insert: 'XX'),
        ]),
      ));

      // Cursor should move from 5 to 7 (shifted by 2-char insertion).
      expect(tr.selection.main.head, 7);
    });

    test('explicit selection overrides mapping', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(5),
      );

      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(5, [
          const ChangeSpec(from: 0, to: 0, insert: 'XX'),
        ]),
        selection: EditorSelection.cursor(0),
      ));

      // Explicit selection wins over mapping.
      expect(tr.selection.main.head, 0);
    });

    test('no-change transaction (docChanged=false)', () {
      final state = EditorState.create(docString: 'hello');

      final tr = state.update(const TransactionSpec());

      expect(tr.docChanged, isFalse);
      expect(tr.selectionChanged, isFalse);
      final newState = state.applyTransaction(tr);
      expect(newState.doc.toString(), 'hello');
    });

    test('transaction with effects', () {
      const effectType = StateEffectType<String>();
      final state = EditorState.create(docString: 'hello');

      final tr = state.update(TransactionSpec(
        effects: [effectType.of('test-value')],
      ));

      expect(tr.effects.length, 1);
      expect(tr.effects.first.type, effectType);
      expect(tr.effects.first.value, 'test-value');
    });

    test('transaction with annotations (read via annotation() method)', () {
      final state = EditorState.create(docString: 'hello');

      final tr = state.update(const TransactionSpec(
        annotations: [
          Annotation(Annotations.userEvent, 'input.type'),
          Annotation(Annotations.addToHistory, true),
        ],
      ));

      expect(tr.annotation(Annotations.userEvent), 'input.type');
      expect(tr.annotation(Annotations.addToHistory), isTrue);

      // Verify that a completely unrelated annotation type returns null.
      const unrelated = AnnotationType<double>();
      expect(tr.annotation(unrelated), isNull);
    });

    test('applying transaction produces new immutable state', () {
      final state = EditorState.create(docString: 'hello');

      final tr = state.update(TransactionSpec(
        changes: ChangeSet.of(5, [
          const ChangeSpec(from: 5, insert: '!'),
        ]),
      ));

      final newState = state.applyTransaction(tr);

      // Original state is unchanged.
      expect(state.doc.toString(), 'hello');
      expect(state.doc.length, 5);

      // New state has the change.
      expect(newState.doc.toString(), 'hello!');
      expect(newState.doc.length, 6);
    });

    test('selectionChanged is true when selection differs', () {
      final state = EditorState.create(
        docString: 'hello',
        selection: EditorSelection.cursor(0),
      );

      final tr = state.update(TransactionSpec(
        selection: EditorSelection.cursor(3),
      ));

      expect(tr.selectionChanged, isTrue);
    });

    test('state field receives transaction on update', () {
      // A field that tracks whether the last transaction had doc changes.
      final hadChanges = StateField<bool>(
        create: (_) => false,
        update: (tr, _) {
          final transaction = tr as Transaction;
          return transaction.docChanged;
        },
      );

      final state = EditorState.create(
        docString: 'hello',
        extensions: [hadChanges],
      );
      expect(state.field(hadChanges), isFalse);

      // Transaction with changes.
      final tr1 = state.update(TransactionSpec(
        changes: ChangeSet.of(5, [const ChangeSpec(from: 5, insert: '!')]),
      ));
      final s1 = state.applyTransaction(tr1);
      expect(s1.field(hadChanges), isTrue);

      // Transaction without changes.
      final tr2 = s1.update(const TransactionSpec());
      final s2 = s1.applyTransaction(tr2);
      expect(s2.field(hadChanges), isFalse);
    });
  });
}
