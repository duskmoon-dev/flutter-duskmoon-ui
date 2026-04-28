import 'package:duskmoon_chat/duskmoon_chat.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmMarkdown;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Tool call block expands and collapses input/output',
      (tester) async {
    final block = DmChatToolCallBlock(
      toolName: 'search_web',
      input: {'query': 'flutter'},
      output: 'Result: pub.dev',
      status: DmChatToolCallStatus.done,
    );

    await _pumpBlock(tester, block);

    expect(find.text('search_web'), findsOneWidget);
    expect(find.text('Input'), findsNothing);

    await tester.tap(find.text('search_web'));
    await tester.pumpAndSettle();

    expect(find.text('Input'), findsOneWidget);
    expect(find.text('Output'), findsOneWidget);

    await tester.tap(find.text('search_web'));
    await tester.pumpAndSettle();

    expect(find.text('Input'), findsNothing);
    expect(find.text('Output'), findsNothing);
    expect(find.byType(DmMarkdown), findsNothing);
  });

  testWidgets('Tool call block configures markdown input and output',
      (tester) async {
    final block = DmChatToolCallBlock(
      toolName: 'search_web',
      input: {'query': 'flutter'},
      output: 'Result: pub.dev',
      status: DmChatToolCallStatus.done,
    );

    await _pumpBlock(tester, block);
    await tester.tap(find.text('search_web'));
    await tester.pumpAndSettle();

    final markdown = tester.widgetList<DmMarkdown>(find.byType(DmMarkdown));

    expect(markdown, hasLength(2));
    expect(
      markdown.first.data,
      '```json\n{\n  "query": "flutter"\n}\n```',
    );
    expect(markdown.first.shrinkWrap, isTrue);
    expect(markdown.first.physics, isA<NeverScrollableScrollPhysics>());
    expect(markdown.last.data, 'Result: pub.dev');
    expect(markdown.last.shrinkWrap, isTrue);
    expect(markdown.last.physics, isA<NeverScrollableScrollPhysics>());
  });

  testWidgets('Tool call block renders error details', (tester) async {
    final block = DmChatToolCallBlock(
      toolName: 'read_file',
      input: {'path': 'missing.txt'},
      status: DmChatToolCallStatus.error,
      error: StateError('failed'),
    );

    await _pumpBlock(tester, block);
    await tester.tap(find.text('read_file'));
    await tester.pumpAndSettle();

    expect(find.text('Error'), findsOneWidget);
    expect(find.text('Bad state: failed'), findsOneWidget);
    expect(find.text('Output'), findsNothing);
  });

  testWidgets('Tool call block renders unprintable error without throwing',
      (tester) async {
    final block = DmChatToolCallBlock(
      toolName: 'read_file',
      input: {'path': 'missing.txt'},
      status: DmChatToolCallStatus.error,
      error: _ThrowingToString(),
    );

    await _pumpBlock(tester, block);
    await tester.tap(find.text('read_file'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text('Error'), findsOneWidget);
    expect(find.textContaining('<unprintable'), findsOneWidget);
  });

  testWidgets('Tool call block renders non-json input without throwing',
      (tester) async {
    final block = DmChatToolCallBlock(
      toolName: 'inspect_value',
      input: {
        'when': DateTime.utc(2026, 1, 2, 3, 4, 5),
        'duration': const Duration(seconds: 90),
        'uri': Uri.parse('https://example.com'),
        'status': DmChatToolCallStatus.running,
        'set': {'a', 'b'},
        'nested': {1: Object()},
        'unprintable': _ThrowingToString(),
        'nan': double.nan,
        'infinity': double.infinity,
        'negativeInfinity': double.negativeInfinity,
      },
    );

    await _pumpBlock(tester, block);
    await tester.tap(find.text('inspect_value'));
    await tester.pumpAndSettle();

    final markdown = tester.widget<DmMarkdown>(find.byType(DmMarkdown));

    expect(tester.takeException(), isNull);
    expect(markdown.data, contains('"when": "2026-01-02T03:04:05.000Z"'));
    expect(markdown.data, contains('"duration": "0:01:30.000000"'));
    expect(markdown.data, contains('"uri": "https://example.com"'));
    expect(markdown.data, contains('"status": "running"'));
    expect(markdown.data, contains('"set": ['));
    expect(markdown.data, contains('"1": "Instance of'));
    expect(markdown.data, contains('"unprintable": "<unprintable'));
    expect(markdown.data, contains('"nan": "NaN"'));
    expect(markdown.data, contains('"infinity": "Infinity"'));
    expect(markdown.data, contains('"negativeInfinity": "-Infinity"'));
  });

  testWidgets('Tool call block header exposes disclosure semantics',
      (tester) async {
    final semantics = tester.ensureSemantics();

    final block = DmChatToolCallBlock(
      toolName: 'search_web',
      input: {'query': 'flutter'},
      status: DmChatToolCallStatus.running,
    );

    await _pumpBlock(tester, block);

    expect(
      tester.getSemantics(find.byKey(DmChatToolCallBlockView.headerKey)),
      matchesSemantics(
        label: 'search_web tool call',
        value: 'running',
        isButton: true,
        hasExpandedState: true,
        isExpanded: false,
        hasTapAction: true,
      ),
    );

    await tester.tap(find.text('search_web'));
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.byKey(DmChatToolCallBlockView.headerKey)),
      matchesSemantics(
        label: 'search_web tool call',
        value: 'running',
        isButton: true,
        hasExpandedState: true,
        isExpanded: true,
        hasTapAction: true,
      ),
    );

    semantics.dispose();
  });
}

class _ThrowingToString {
  @override
  String toString() {
    throw StateError('toString failed');
  }
}

Future<void> _pumpBlock(WidgetTester tester, DmChatToolCallBlock block) {
  return tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: DmChatToolCallBlockView(block: block),
      ),
    ),
  );
}
