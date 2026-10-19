// Build this probe as a Flutter web target; it also runs in Flutter Wasm.
import 'dart:async';
import 'dart:js_interop';

import 'package:duskmoon_code_engine/duskmoon_code_engine.dart' hide InlineSpan;
import 'package:duskmoon_widgets/src/markdown/_code_block_widget.dart';
import 'package:flutter/material.dart';

@JS('duskmoonWidgetProbe')
external set _result(JSAny? value);

final _key = GlobalKey<_ProbeState>();
const _dartSource = 'final message = "中文 😀";\r\n// original';
const _updatedSource = 'final message = "中文 😁 updated";\r\n// latest';
const _tsxSource = 'const View = (): JSX.Element => <div>中文 😀</div>;';
const _cppSource = 'template<typename T> class Box { T value; };';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _result = {'status': 'running'}.jsify();
  runApp(_Probe(key: _key));
  unawaited(_verify());
}

void _check(bool value, String message) {
  if (!value) throw StateError(message);
}

Future<void> _frame() async {
  await Future<void>.delayed(const Duration(milliseconds: 50));
  await WidgetsBinding.instance.endOfFrame;
}

List<RichText> _textWidgets() {
  final result = <RichText>[];
  void visit(Element element) {
    if (element.widget case final RichText text) result.add(text);
    element.visitChildren(visit);
  }

  _key.currentContext!.visitChildElements(visit);
  return result;
}

Color? _color(String source, String token) {
  final text =
      _textWidgets().singleWhere((text) => text.text.toPlainText() == source);
  final target = source.indexOf(token);
  var offset = 0;
  Color? result;
  void visit(InlineSpan span, TextStyle inherited) {
    final style = inherited.merge(span.style);
    if (span is TextSpan) {
      if (span.text case final String text) {
        if (target >= offset && target < offset + text.length) {
          result = style.color;
        }
        offset += text.length;
      }
      for (final child in span.children ?? <InlineSpan>[]) {
        visit(child, style);
      }
    }
  }

  visit(text.text, const TextStyle());
  return result;
}

Future<void> _verify() async {
  try {
    await _frame();
    final state = _key.currentState!;
    // Change text while the Markdown/editor loaders may still be pending.
    state.updateSource(_updatedSource);
    state.tsx.text = '$_tsxSource\n// edited before ready';
    await Future.wait([
      state.tsx.ready,
      state.cpp.ready,
      TreeSitterRuntime.ensureInitialized(languages: {'dart', 'sql'}),
    ]);
    await _frame();
    final tsxSnapshot = syntaxTree(state.tsx.state)!;
    _check(tsxSnapshot.language == 'tsx', 'distinct TSX grammar');
    _check(tsxSnapshot.source == '$_tsxSource\n// edited before ready',
        'editor edits during initialization');
    _check(
        syntaxTree(state.cpp.state)!.language == 'cpp', 'distinct C++ grammar');
    _check(
        tsxSnapshot.rootNode.to == tsxSnapshot.source.length, 'UTF16 editor');
    final light = _color(_updatedSource, 'final');
    _check(light == const Color(0xFFD73A49), 'automatic Markdown highlighting');
    _check(_color('SELECT name FROM users;', 'SELECT') == light,
        'simultaneous Markdown sessions');
    state.toggleTheme();
    await _frame();
    _check(_color(_updatedSource, 'final') != light, 'theme update');

    state.tsx.language = pythonLanguageSupport();
    state.tsx.text = 'def greet():\n    return "中文 😀"\n';
    await state.tsx.ready;
    await _frame();
    _check(syntaxTree(state.tsx.state)!.language == 'python',
        'language switch and pending initialization');
    _check(tsxSnapshot.source.contains('JSX.Element'), 'old snapshot lifetime');
    _check(syntaxTree(state.cpp.state)!.source == _cppSource,
        'independent editor state');

    state.useUnknownLanguage();
    await _frame();
    _check(
        _textWidgets().any((text) => text.text.toPlainText() == _updatedSource),
        'unknown language preserves source');
    final disposed = EditorViewController(
      text: 'const disposed = true;',
      language: javascriptLanguageSupport(),
    );
    final pending = disposed.ready;
    disposed.dispose();
    await pending;
    _result = {
      'status': 'passed',
      'automaticMarkdown': true,
      'sourceAndUnicode': true,
      'themeUpdates': true,
      'simultaneousEditors': true,
      'editsDuringInitialization': true,
      'languageSwitch': true,
      'disposeDuringInitialization': true,
    }.jsify();
  } catch (error, stack) {
    _result =
        {'status': 'failed', 'error': '$error', 'stack': '$stack'}.jsify();
  }
}

class _Probe extends StatefulWidget {
  const _Probe({super.key});
  @override
  State<_Probe> createState() => _ProbeState();
}

class _ProbeState extends State<_Probe> {
  late final tsx = EditorViewController(
    text: _tsxSource,
    language: tsxLanguageSupport(),
    extensions: [historyExtension()],
  );
  late final cpp = EditorViewController(
    text: _cppSource,
    language: cppLanguageSupport(),
  );
  var source = _dartSource;
  var dark = false;
  var unknown = false;
  void updateSource(String value) => setState(() => source = value);
  void toggleTheme() => setState(() => dark = !dark);
  void useUnknownLanguage() => setState(() => unknown = true);
  @override
  void dispose() {
    tsx.dispose();
    cpp.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        themeAnimationDuration: Duration.zero,
        theme: ThemeData(brightness: dark ? Brightness.dark : Brightness.light),
        home: Scaffold(
          appBar: AppBar(title: const Text('Tree-sitter migration probe')),
          body: ListView(padding: const EdgeInsets.all(16), children: [
            CodeBlockWidget(
                code: source, language: unknown ? 'unknown' : 'dart'),
            const CodeBlockWidget(
                code: 'SELECT name FROM users;', language: 'sql'),
            SizedBox(height: 180, child: CodeEditorWidget(controller: tsx)),
            const SizedBox(height: 12),
            SizedBox(height: 180, child: CodeEditorWidget(controller: cpp)),
          ]),
        ),
      );
}
