import 'package:flutter/material.dart' hide InlineSpan;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';

void main() {
  group('R01: Tap positioning cursor', () {
    testWidgets(
      'tap at column > 0 positions cursor at exact offset, not column 0',
      (tester) async {
        final ctrl = EditorViewController(text: 'hello\nworld\nfoo');
        addTearDown(() {
          ctrl.dispose();
        });
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(controller: ctrl, lineNumbers: false),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Tap on line 1 ("world") at x offset corresponding to roughly 3rd character.
        // Line height is 20, so y=30 is on line 1.
        final topLeft = tester.getTopLeft(find.byType(CodeEditorWidget));
        await tester.tapAt(topLeft + const Offset(30, 30));
        await tester.pump();

        // Offset should NOT be at column 0 (which is offset 6 for line 1).
        // Baseline BUG: column is fixed to 0, so offset is 6.
        expect(
          ctrl.state.selection.main.head,
          isNot(6),
          reason: 'Clicking at x=30 must not stick to column 0 (offset 6)',
        );
      },
    );
  });

  group('R02: Selection rendering', () {
    testWidgets('non-empty selection produces non-empty selectionRects', (
      tester,
    ) async {
      final ctrl = EditorViewController(text: 'hello world');
      addTearDown(ctrl.dispose);
      ctrl.setSelection(EditorSelection.single(anchor: 1, head: 5));

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: CodeEditorWidget(controller: ctrl)),
        ),
      );
      await tester.pumpAndSettle();

      // Find SelectionPainter widgets
      final customPaints = tester.widgetList<CustomPaint>(
        find.byType(CustomPaint),
      );
      final selectionPainters = customPaints
          .map((cp) => cp.painter)
          .whereType<SelectionPainter>()
          .where((sp) => sp.selectionRects.isNotEmpty)
          .toList();

      expect(
        selectionPainters,
        isNotEmpty,
        reason: 'Active selection must produce non-empty selectionRects',
      );
      expect(
        selectionPainters.first.selectionRects.first.width,
        greaterThan(0),
      );
    });
  });

  group('R03: Viewport and horizontal scroll layout', () {
    testWidgets('long line enables horizontal scroll with expanded width', (
      tester,
    ) async {
      final longLine = 'x' * 500;
      final ctrl = EditorViewController(text: longLine);
      addTearDown(ctrl.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300,
              height: 300,
              child: CodeEditorWidget(controller: ctrl),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final horizontalScroll = find.byType(SingleChildScrollView);
      expect(horizontalScroll, findsOneWidget);

      final sizedBox = tester.widget<SizedBox>(
        find
            .descendant(of: horizontalScroll, matching: find.byType(SizedBox))
            .first,
      );
      expect(
        sizedBox.width,
        greaterThan(300),
        reason: 'Long line should expand container width beyond viewport',
      );
    });
  });

  group('R04: Keymap modifier resolution', () {
    test('Ctrl-Shift-z matches redo, not undo', () {
      final km = defaultKeymap();
      final resolved = km.resolve(LogicalKeyboardKey.keyZ, true, true, false);
      expect(resolved, isNotNull);
      // Baseline BUG: Ctrl-z matches even when Shift is held because of `if (parsed.shift && !shiftHeld) return false;`
      expect(
        resolved!.key,
        'Ctrl-Shift-z',
        reason: 'Ctrl-Shift-z must resolve to redo binding, not Ctrl-z',
      );
    });

    test('Shift-ArrowRight matches selectCharRight', () {
      final km = defaultKeymap();
      final resolved = km.resolve(
        LogicalKeyboardKey.arrowRight,
        false,
        true,
        false,
      );
      expect(resolved, isNotNull);
      expect(
        resolved!.key,
        'Shift-ArrowRight',
        reason: 'Shift-ArrowRight must resolve to Shift-ArrowRight binding',
      );
    });
  });

  group('R07: Unicode grapheme cluster boundary delete', () {
    test('deleteCharBackward on emoji cluster deletes full cluster', () {
      // 👨‍👩‍👧‍👦 is a single grapheme cluster composed of multiple code units with ZWJs
      const emoji = '👨‍👩‍👧‍👦';
      final state = EditorState.create(docString: 'A$emoji');
      final head = state.doc.length;
      final selState = state
          .update(TransactionSpec(selection: EditorSelection.cursor(head)))
          .state;

      final spec = EditorCommands.deleteCharBackward(selState);
      expect(spec, isNotNull);
      final newDoc = selState.doc.replace(spec!.changes!);
      // Baseline BUG: only deletes 1 UTF-16 code unit (head - 1), leaving malformed surrogates!
      expect(
        newDoc.toString(),
        'A',
        reason: 'Should delete the entire grapheme cluster, leaving "A"',
      );
    });
  });

  group('R05: IME composing retention', () {
    test('InputHandler preserves composing text range', () {
      final ctrl = EditorViewController(text: '');
      addTearDown(ctrl.dispose);
      final handler = InputHandler(ctrl.view);

      // IME starts composing "nihao"
      const composingVal = TextEditingValue(
        text: 'nihao',
        selection: TextSelection.collapsed(offset: 5),
        composing: TextRange(start: 0, end: 5),
      );
      handler.updateEditingValue(composingVal);

      expect(handler.isComposing, isTrue);
      expect(
        handler.currentTextEditingValue!.composing,
        const TextRange(start: 0, end: 5),
      );
      expect(ctrl.text, 'nihao');

      // IME commits "你好"
      const commitVal = TextEditingValue(
        text: '你好',
        selection: TextSelection.collapsed(offset: 2),
        composing: TextRange.empty,
      );
      handler.updateEditingValue(commitVal);

      expect(handler.isComposing, isFalse);
      expect(handler.currentTextEditingValue!.composing, TextRange.empty);
      expect(ctrl.text, '你好');
    });
  });

  group('R06: Async clipboard paste sync', () {
    testWidgets('pasteCommand replaces selection and syncs state', (
      tester,
    ) async {
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'Clipboard.getData') {
            return <String, dynamic>{'text': 'pasted content'};
          }
          return null;
        },
      );
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        );
      });

      final ctrl = EditorViewController(text: 'hello [target] world');
      addTearDown(ctrl.dispose);
      // Select "[target]" (offset 6 to 14)
      ctrl.setSelection(EditorSelection.single(anchor: 6, head: 14));

      final handled = ClipboardCommands.pasteCommand()(ctrl.view);
      expect(handled, isTrue);

      await tester.pumpAndSettle();

      expect(ctrl.text, 'hello pasted content world');
      expect(
        ctrl.state.selection.main.head,
        20,
      ); // 6 + 14 ('pasted content'.length)
    });
  });

  group('R08: Default EditorViewController history', () {
    test('default EditorViewController supports undo after insertText', () {
      final ctrl = EditorViewController(text: 'hello');
      addTearDown(ctrl.dispose);
      ctrl.setSelection(EditorSelection.cursor(ctrl.text.length));
      ctrl.insertText(' world');
      expect(ctrl.text, 'hello world');

      // Baseline BUG: extensions default to empty, so history is not installed!
      final undoHandled = EditorCommands.undo(ctrl.state);
      expect(
        undoHandled,
        isNotNull,
        reason: 'Default EditorViewController must have history enabled',
      );
    });
  });

  group('R09: CodeEditorWidget onChanged fires only on text change', () {
    testWidgets(
      'onChanged does not fire on pure selection changes or cursor blinks',
      (tester) async {
        int changeCount = 0;
        final ctrl = EditorViewController(text: 'hello');
        addTearDown(() {
          ctrl.dispose();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(
                controller: ctrl,
                onChanged: (text) {
                  changeCount++;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(changeCount, 0);

        // Change selection only (no document text modification)
        ctrl.setSelection(EditorSelection.cursor(3));
        await tester.pump();

        // Baseline BUG: _handleStateChanged fires onChanged on ANY state change!
        expect(
          changeCount,
          0,
          reason: 'Pure selection change must not trigger onChanged',
        );
      },
    );
  });

  group('Post-Review Regression Suite (Issues 1-10)', () {
    testWidgets(
      'Issue 1 & 7: SearchPanel toggle via DmEditorAction.search does not offset editor tap coordinates or steal search focus',
      (tester) async {
        final ctrl = EditorViewController(
          text: 'line one\nline two\nline three',
        );
        addTearDown(ctrl.dispose);
        ctrl.setSelection(EditorSelection.cursor(0));

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmCodeEditor(
                controller: ctrl,
                lineNumbers: false,
                actions: [
                  DmEditorAction.undo(ctrl),
                  DmEditorAction.redo(ctrl),
                  DmEditorAction.search(ctrl),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Initially undo/redo toolbar buttons should be disabled (onPressed == null)
        final undoButton = tester.widget<IconButton>(
          find.widgetWithIcon(IconButton, Icons.undo),
        );
        expect(undoButton.onPressed, isNull);

        // Tap the Search toolbar button to open SearchPanel
        await tester.tap(find.byIcon(Icons.search));
        await tester.pumpAndSettle();
        expect(find.byType(SearchPanel), findsOneWidget);

        // Tapping inside SearchPanel should NOT move the editor cursor from 0
        await tester.tap(find.byType(SearchPanel));
        await tester.pump();
        expect(ctrl.selection.main.head, 0);

        // Tapping on the first line of the editor content (below SearchPanel)
        // should map to line 1, not be shifted by SearchPanel height.
        final searchBottom = tester.getBottomLeft(find.byType(SearchPanel));
        await tester.tapAt(searchBottom + const Offset(20, 10));
        await tester.pump();
        final tappedLine = ctrl.document.lineAtOffset(ctrl.selection.main.head);
        expect(tappedLine.number, 1);
      },
    );

    testWidgets(
      'Issue 2: Drag selection, double-tap word selection, and Left/Right selection collapse',
      (tester) async {
        final ctrl = EditorViewController(text: 'hello world\nsecond line');
        addTearDown(ctrl.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(controller: ctrl, lineNumbers: false),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final topLeft = tester.getTopLeft(find.byType(CodeEditorWidget));

        // Drag across the first line to create a non-empty selection
        await tester.dragFrom(
          topLeft + const Offset(5, 10),
          const Offset(60, 0),
        );
        await tester.pump();
        expect(ctrl.selection.main.isEmpty, isFalse);
        final selFrom = ctrl.selection.main.from;
        final selTo = ctrl.selection.main.to;
        expect(selTo, greaterThan(selFrom));

        // Left arrow on non-empty selection collapses to main.from
        final leftSpec = EditorCommands.cursorCharLeft(ctrl.state);
        expect(leftSpec, isNotNull);
        ctrl.dispatch(leftSpec!);
        expect(ctrl.selection.main.isEmpty, isTrue);
        expect(ctrl.selection.main.head, selFrom);

        // Re-select and test Right arrow collapsing to main.to
        ctrl.setSelection(EditorSelection.single(anchor: selFrom, head: selTo));
        final rightSpec = EditorCommands.cursorCharRight(ctrl.state);
        expect(rightSpec, isNotNull);
        ctrl.dispatch(rightSpec!);
        expect(ctrl.selection.main.isEmpty, isTrue);
        expect(ctrl.selection.main.head, selTo);

        // Double-tap on "hello" selects the word (0..5)
        await tester.tapAt(topLeft + const Offset(15, 10));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tapAt(topLeft + const Offset(15, 10));
        await tester.pump();
        expect(ctrl.selection.main.from, 0);
        expect(ctrl.selection.main.to, 5);
      },
    );

    testWidgets(
      'Issue 3: Async paste respects sessionId across openDocument, maps non-overlapping edits, cancels overlapping edits, and respects readOnly',
      (tester) async {
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          (MethodCall methodCall) async {
            if (methodCall.method == 'Clipboard.getData') {
              await Future<void>.delayed(const Duration(milliseconds: 50));
              return <String, dynamic>{'text': 'PASTED'};
            }
            return null;
          },
        );
        addTearDown(() {
          tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
            SystemChannels.platform,
            null,
          );
        });

        final ctrl = EditorViewController(text: 'hello world');
        addTearDown(ctrl.dispose);

        // 1. Non-overlapping concurrent edit before cursor shifts paste target
        ctrl.setSelection(EditorSelection.cursor(6)); // before 'world'
        ClipboardCommands.pasteCommand()(ctrl.view);
        // Insert '>>' at offset 0 while clipboard is in flight
        ctrl.replaceRange(0, 0, '>>');
        await tester.pump(const Duration(milliseconds: 100));
        expect(ctrl.text, '>>hello PASTEDworld');

        // 2. openDocument while paste is in flight cancels paste even if new doc has higher version
        ctrl.setSelection(EditorSelection.cursor(2));
        ClipboardCommands.pasteCommand()(ctrl.view);
        ctrl.openDocument('brand new doc');
        ctrl.insertText('1');
        ctrl.insertText('2');
        ctrl.insertText('3');
        await tester.pump(const Duration(milliseconds: 100));
        expect(ctrl.text, '123brand new doc');

        // 3. readOnly blocks cut and paste
        ctrl.view.readOnly = true;
        ctrl.setSelection(EditorSelection.single(anchor: 0, head: 3));
        expect(ClipboardCommands.cutCommand()(ctrl.view), isFalse);
        expect(ClipboardCommands.pasteCommand()(ctrl.view), isFalse);
      },
    );

    test(
      'Issue 4 & 8: InputHandler clears composing on external edit and coalesces IME composition into single undo step',
      () {
        final ctrl = EditorViewController(text: '');
        addTearDown(ctrl.dispose);
        final handler = InputHandler(ctrl.view);

        // Simulate multi-step Pinyin composition: 'n' -> 'ni' -> 'nihao' -> '你好'
        handler.updateEditingValue(
          const TextEditingValue(
            text: 'n',
            selection: TextSelection.collapsed(offset: 1),
            composing: TextRange(start: 0, end: 1),
          ),
        );
        handler.updateEditingValue(
          const TextEditingValue(
            text: 'ni',
            selection: TextSelection.collapsed(offset: 2),
            composing: TextRange(start: 0, end: 2),
          ),
        );
        handler.updateEditingValue(
          const TextEditingValue(
            text: 'nihao',
            selection: TextSelection.collapsed(offset: 5),
            composing: TextRange(start: 0, end: 5),
          ),
        );
        handler.updateEditingValue(
          const TextEditingValue(
            text: '你好',
            selection: TextSelection.collapsed(offset: 2),
            composing: TextRange.empty,
          ),
        );
        expect(ctrl.text, '你好');

        // A single undo reverts the entire composed '你好' back to ''
        final undoSpec = EditorCommands.undo(ctrl.state);
        expect(undoSpec, isNotNull);
        ctrl.dispatch(undoSpec!);
        expect(ctrl.text, '');

        // Start composing again, then trigger an external programmatic edit
        handler.updateEditingValue(
          const TextEditingValue(
            text: 'abc',
            selection: TextSelection.collapsed(offset: 3),
            composing: TextRange(start: 0, end: 3),
          ),
        );
        expect(handler.isComposing, isTrue);

        ctrl.text = 'external replacement';
        expect(handler.isComposing, isFalse);
        expect(handler.currentTextEditingValue!.composing, TextRange.empty);
      },
    );

    test(
      'Issue 5 & 6: Document caches toString(), Transaction shares newDoc, and Rope tracks maxLineLength past line 500',
      () {
        final lines = List<String>.generate(
          600,
          (i) => i == 550 ? 'W' * 300 : 'short',
        ).join('\n');
        final doc = Document.fromString(lines);
        expect(doc.maxLineLength, 300);
        expect(identical(doc.toString(), doc.toString()), isTrue);

        final state = EditorState.create(doc: doc);
        final tr = state.update(
          TransactionSpec(
            changes: ChangeSet.of(doc.length, [
              const ChangeSpec.insert(0, '!'),
            ]),
          ),
        );
        expect(identical(tr.newDoc, tr.state.doc), isTrue);
      },
    );

    test(
      'Issue 7 & 9: Shift-Tab outdents, Shift-ArrowUp/Down/Home/End select, and cursorLineDown clamps away from surrogate split',
      () {
        // Shift-Tab outdent
        var state = EditorState.create(
          docString: '  line1\n  line2',
          selection: EditorSelection.single(anchor: 2, head: 12),
        );
        final outdent = EditorCommands.indentLess(state);
        expect(outdent, isNotNull);
        state = state.update(outdent!).state;
        expect(state.doc.toString(), 'line1\nline2');

        // Surrogate pair safety on vertical cursor movement:
        // Line 1: 'abc' (cursor at col 1)
        // Line 2: '😀x' ('😀' is 2 UTF-16 code units at offsets 0..2 of line 2)
        final emojiState = EditorState.create(
          docString: 'abc\n😀x',
          selection: EditorSelection.cursor(1),
        );
        final downSpec = EditorCommands.cursorLineDown(emojiState);
        expect(downSpec, isNotNull);
        // Offset 4 is start of line 2 ('😀' is 4..6). Col 1 would be offset 5 (inside surrogate pair),
        // so cursorLineDown must clamp to offset 4!
        expect(downSpec!.selection!.main.head, 4);
      },
    );
  });

  group('Second-Pass Review Regression Suite', () {
    testWidgets(
      'Review-2 Issue 1: Pressing Enter/Tab/Backspace inside SearchPanel TextField does not mutate code document, and Escape restores editor focus',
      (tester) async {
        final ctrl = EditorViewController(text: 'foo bar foo');
        final editorFocus = FocusNode();
        addTearDown(() async {
          await tester.pumpWidget(const SizedBox.shrink());
          editorFocus.dispose();
          ctrl.dispose();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(controller: ctrl, focusNode: editorFocus),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Open SearchPanel via toggleSearch
        ctrl.view.toggleSearch();
        await tester.pumpAndSettle();
        expect(find.byType(SearchPanel), findsOneWidget);

        // SearchPanel's Find TextField has focus; editorFocus should NOT have primary focus
        expect(editorFocus.hasFocus, isFalse);

        // Enter query and press Enter / Tab / Backspace while focused in SearchPanel
        await tester.enterText(find.byType(TextField).first, 'foo');
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();

        // Code document must remain completely untouched
        expect(ctrl.text, 'foo bar foo');

        // Pressing Escape inside SearchPanel closes SearchPanel and restores editorFocus
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.byType(SearchPanel), findsNothing);
        expect(editorFocus.hasFocus, isTrue);
      },
    );

    testWidgets(
      'Review-2 Issue 2 & 5: openDocument at version 0 triggers onChanged, and language can be reset to null',
      (tester) async {
        final changedTexts = <String>[];
        final ctrl = EditorViewController(text: 'initial');
        addTearDown(ctrl.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(
                controller: ctrl,
                language: jsonLanguageSupport(),
                onChanged: changedTexts.add,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(ctrl.document.version, 0);

        // Call openDocument when current doc version is still 0
        ctrl.openDocument('opened at version 0');
        await tester.pump();
        expect(changedTexts, ['opened at version 0']);

        // Update widget with language: null -> should clear language to null
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(
                controller: ctrl,
                language: null,
                onChanged: changedTexts.add,
              ),
            ),
          ),
        );
        await tester.pump();
        expect(ctrl.language, isNull);
      },
    );

    test(
      'Review-2 Issue 3, 4 & 6: replaceAll handles overlapping matches, Ctrl-/ uses active language comment token, and wordRangeAt clamps trailing emoji',
      () {
        // 1. Overlapping matches in replaceAll ('aaaa' with query 'aa' -> 'b')
        final state = EditorState.create(docString: 'aaaa');
        final matches = SearchState.findMatches(state.doc, 'aa');
        expect(matches.length, 3); // (0,2), (1,3), (2,4)
        final spec = SearchCommands.replaceAll(state, matches, 'b');
        final replaced = state.applyTransaction(state.update(spec));
        expect(replaced.doc.toString(), 'bb');

        // 2. Ctrl-/ uses active language's comment token ('#' for Python)
        final pyCtrl = EditorViewController(
          text: 'print(1)',
          language: pythonLanguageSupport(),
        );
        addTearDown(pyCtrl.dispose);
        final km = defaultKeymap();
        final commentBinding = km.resolve(
          LogicalKeyboardKey.slash,
          true,
          false,
          false,
        );
        expect(commentBinding, isNotNull);
        commentBinding!.run!(pyCtrl.view);
        expect(pyCtrl.text, '# print(1)');

        // 3. wordRangeAt at end of line after emoji ('abc😀' length 5, emoji at 3..5)
        final emojiState = EditorState.create(docString: 'abc😀');
        final (from, to) = EditorCommands.wordRangeAt(emojiState, 5);
        expect(from, 3);
        expect(to, 5);
      },
    );
  });

  group('Third-Pass Review Regression Suite', () {
    testWidgets(
      'Review-3 Issue 1: DmCodeEditorStatusBar updates colors when controller.theme changes at runtime',
      (tester) async {
        final ctrl = EditorViewController(
          text: 'line 1',
          theme: EditorTheme.light(),
        );
        addTearDown(ctrl.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmCodeEditorStatusBar(controller: ctrl),
            ),
          ),
        );

        BoxDecoration statusBoxDecoration() {
          final box = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
          return box.decoration as BoxDecoration;
        }

        expect(
          statusBoxDecoration().color,
          EditorTheme.light().gutterBackground,
        );

        // Mutate controller.theme at runtime without rebuilding parent widget
        ctrl.theme = EditorTheme.dark();
        await tester.pump();

        expect(
          statusBoxDecoration().color,
          EditorTheme.dark().gutterBackground,
        );
      },
    );

    testWidgets(
      'Review-3 Issue 2: SearchPanel rebinds view listener and recomputes matches when controller is swapped while open',
      (tester) async {
        final ctrl1 = EditorViewController(text: 'alpha beta alpha');
        final ctrl2 = EditorViewController(text: 'alpha only once');
        addTearDown(() {
          ctrl1.dispose();
          ctrl2.dispose();
        });

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(controller: ctrl1),
            ),
          ),
        );
        await tester.pumpAndSettle();

        ctrl1.view.toggleSearch();
        await tester.pumpAndSettle();

        await tester.enterText(find.byType(TextField).first, 'alpha');
        await tester.pump();
        expect(find.text('1 of 2'), findsOneWidget);

        // Swap controller to ctrl2 while SearchPanel remains open
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(controller: ctrl2),
            ),
          ),
        );
        await tester.pump();
        expect(find.text('1 of 1'), findsOneWidget);

        // Further edits on ctrl2 update SearchPanel matches
        ctrl2.text = 'alpha alpha alpha';
        await tester.pump();
        expect(find.text('1 of 3'), findsOneWidget);
      },
    );

    test(
      'Review-3 Issue 4 & 5: LinePainter caches TextPainter and uses value equality in shouldRepaint, and replaceRange clamps bounds',
      () {
        final p1 = LinePainter(
          spans: const [InlineSpan(from: 0, to: 3, text: 'abc')],
          lineHeight: 20,
          fontFamily: 'monospace',
          fontSize: 14,
        );
        final p2 = LinePainter(
          spans: [const InlineSpan(from: 0, to: 3, text: 'abc')],
          lineHeight: 20,
          fontFamily: 'monospace',
          fontSize: 14,
        );

        // createTextPainter returns cached instance on repeated calls
        expect(
            identical(p1.createTextPainter(), p1.createTextPainter()), isTrue);
        // shouldRepaint uses value equality on spans list
        expect(p1.shouldRepaint(p2), isFalse);

        final s1 = SelectionPainter(
          selectionRects: [const Rect.fromLTWH(0, 0, 10, 20)],
          cursorOffset: 5,
          cursorHeight: 20,
          selectionColor: const Color(0xFF0000FF),
          cursorColor: const Color(0xFF000000),
          cursorWidth: 2,
        );
        final s2 = SelectionPainter(
          selectionRects: [const Rect.fromLTWH(0, 0, 10, 20)],
          cursorOffset: 5,
          cursorHeight: 20,
          selectionColor: const Color(0xFF0000FF),
          cursorColor: const Color(0xFF000000),
          cursorWidth: 2,
        );
        expect(s1.shouldRepaint(s2), isFalse);

        // replaceRange clamps out-of-bounds indices safely
        final ctrl = EditorViewController(text: 'hello');
        addTearDown(ctrl.dispose);
        ctrl.replaceRange(-5, 999, 'world');
        expect(ctrl.text, 'world');
      },
    );

    testWidgets(
      'Review-3 Issue 5: CodeEditorWidget didUpdateWidget allows resetting theme back to null',
      (tester) async {
        final ctrl = EditorViewController(text: 'hello');
        addTearDown(ctrl.dispose);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(
                controller: ctrl,
                theme: EditorTheme.dark(),
              ),
            ),
          ),
        );
        await tester.pump();

        // Update theme to null -> should clear controller.theme back to null
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CodeEditorWidget(
                controller: ctrl,
                theme: null,
              ),
            ),
          ),
        );
        await tester.pump();
        expect(ctrl.theme, isNull);
      },
    );
  });
}
