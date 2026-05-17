import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart' hide DmCodeEditor;
import 'package:flutter/material.dart';

import '../../destination.dart';

class CodeEditorScreen extends StatelessWidget {
  static const name = 'Code Editor';
  static const path = 'code-editor';

  const CodeEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key('Widgets')),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        leading: const BackButton(),
        title: const Text('Code Editor'),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => const _CodeEditorBody(),
    );
  }
}

class _CodeEditorBody extends StatefulWidget {
  const _CodeEditorBody();

  @override
  State<_CodeEditorBody> createState() => _CodeEditorBodyState();
}

class _CodeEditorBodyState extends State<_CodeEditorBody> {
  late EditorViewController _controller;
  String _selectedLanguage = 'dart';

  static final _languages = <String, LanguageSupport Function()>{
    'dart': dartLanguageSupport,
    'javascript': javascriptLanguageSupport,
    'python': pythonLanguageSupport,
    'json': jsonLanguageSupport,
    'html': htmlLanguageSupport,
    'rust': rustLanguageSupport,
    'go': goLanguageSupport,
    'yaml': yamlLanguageSupport,
    'elixir': elixirLanguageSupport,
  };

  static const _sampleCode = <String, String>{
    'dart':
        'import \'package:flutter/material.dart\';\n\nvoid main() => runApp(const MyApp());\n\nclass MyApp extends StatelessWidget {\n  const MyApp({super.key});\n\n  @override\n  Widget build(BuildContext context) {\n    return MaterialApp(\n      title: \'DuskMoon\',\n      home: const Scaffold(\n        body: Center(child: Text(\'Hello\')),\n      ),\n    );\n  }\n}',
    'javascript':
        '// Fibonacci\nfunction fibonacci(n) {\n  if (n <= 1) return n;\n  return fibonacci(n - 1) + fibonacci(n - 2);\n}\n\nfor (let i = 0; i < 10; i++) {\n  console.log(fibonacci(i));\n}',
    'python':
        '# Quick sort\ndef quicksort(arr):\n    if len(arr) <= 1:\n        return arr\n    pivot = arr[0]\n    left = [x for x in arr[1:] if x < pivot]\n    right = [x for x in arr[1:] if x >= pivot]\n    return quicksort(left) + [pivot] + quicksort(right)\n\nprint(quicksort([3, 6, 8, 10, 1, 2, 1]))',
    'json':
        '{\n  "name": "duskmoon_code_engine",\n  "version": "0.1.0",\n  "languages": 19,\n  "features": ["highlighting", "undo", "search"]\n}',
    'html':
        '<!DOCTYPE html>\n<html lang="en">\n<head>\n  <meta charset="UTF-8">\n  <title>DuskMoon</title>\n</head>\n<body>\n  <h1>Hello World</h1>\n  <p>Welcome to DuskMoon.</p>\n</body>\n</html>',
    'rust':
        'fn main() {\n    let numbers = vec![1, 2, 3, 4, 5];\n    let sum: i32 = numbers.iter().sum();\n    println!("Sum: {}", sum);\n}',
    'go':
        'package main\n\nimport "fmt"\n\nfunc main() {\n\tx := 42\n\tfmt.Printf("Hello %d\\n", x)\n}',
    'yaml':
        'name: duskmoon\nversion: 0.1.0\ndependencies:\n  flutter:\n    sdk: flutter\n  duskmoon_theme: ^1.0.0',
    'elixir':
        'defmodule Hello do\n  @moduledoc "A greeting module"\n\n  def greet(name) do\n    "Hello, #{name}!"\n  end\nend\n\nIO.puts(Hello.greet("world"))',
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
      final sample = _sampleCode[lang];
      if (sample != null) _controller.text = sample;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    _controller.theme = isDark ? EditorTheme.dark() : EditorTheme.light();

    return DmCodeEditor(
      controller: _controller,
      theme: isDark ? EditorTheme.dark() : EditorTheme.light(),
      lineNumbers: true,
      highlightActiveLine: true,
      languageName: _selectedLanguage,
      topBar: _LanguageToolbar(
        controller: _controller,
        selectedLanguage: _selectedLanguage,
        languages: _languages.keys.toList(),
        onLanguageChanged: _switchLanguage,
      ),
    );
  }
}

/// Custom top bar with a language dropdown and editor action buttons.
class _LanguageToolbar extends StatelessWidget {
  const _LanguageToolbar({
    required this.controller,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageChanged,
  });

  final EditorViewController controller;
  final String selectedLanguage;
  final List<String> languages;
  final ValueChanged<String> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    final theme = controller.theme;
    final colorScheme = Theme.of(context).colorScheme;

    final bgColor = theme?.gutterBackground ?? colorScheme.surfaceContainerLow;
    final fgColor = theme?.gutterForeground ?? colorScheme.onSurfaceVariant;
    final titleColor = theme?.foreground ?? colorScheme.onSurface;
    final borderColor = theme != null
        ? Color.lerp(theme.gutterBackground, theme.foreground, 0.15)!
        : colorScheme.outlineVariant;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Text(
              'Language:',
              style: TextStyle(fontSize: 13, color: fgColor),
            ),
            const SizedBox(width: 8),
            DropdownButton<String>(
              value: selectedLanguage,
              underline: const SizedBox.shrink(),
              isDense: true,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: titleColor,
              ),
              dropdownColor: bgColor,
              items: languages
                  .map(
                    (lang) => DropdownMenuItem(value: lang, child: Text(lang)),
                  )
                  .toList(),
              onChanged: (lang) {
                if (lang != null) onLanguageChanged(lang);
              },
            ),
            const Spacer(),
            IconButton(
              icon: Icon(Icons.undo, size: 18, color: fgColor),
              tooltip: 'Undo',
              onPressed: () {
                final spec = EditorCommands.undo(controller.state);
                if (spec != null) controller.dispatch(spec);
              },
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
            IconButton(
              icon: Icon(Icons.redo, size: 18, color: fgColor),
              tooltip: 'Redo',
              onPressed: () {
                final spec = EditorCommands.redo(controller.state);
                if (spec != null) controller.dispatch(spec);
              },
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
            IconButton(
              icon: Icon(Icons.copy, size: 18, color: fgColor),
              tooltip: 'Copy',
              onPressed: () {
                final text =
                    ClipboardCommands.getSelectedText(controller.state);
                if (text.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Copied to clipboard'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              },
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
            ),
          ],
        ),
      ),
    );
  }
}
