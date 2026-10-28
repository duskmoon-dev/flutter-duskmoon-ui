import 'dart:convert';
import 'dart:io';

import 'package:duskmoon_highlight/tree_sitter.dart';

/// Runs inside the generated Windows Release consumer in native CI.
Future<void> main() async {
  var resultCode = 0;
  late Map<String, Object?> report;
  try {
    final initialized = <String>[];
    for (final language in TreeSitterRuntime.languages) {
      await TreeSitterRuntime.ensureInitialized(languages: {language});
      final parser = TreeSitterSession(language: language);
      try {
        final snapshot = parser.parse('');
        if (snapshot.language != language ||
            snapshot.rootNode.from != 0 ||
            snapshot.rootNode.to != 0) {
          throw StateError('Unexpected syntax tree for $language');
        }
        initialized.add(language);
      } finally {
        parser.dispose();
      }
    }
    final parser = TreeSitterSession(language: 'crystal');
    final crystal = <String>[];
    try {
      for (final marker in [
        'EOF',
        List.filled(255, 'A').join(),
        'A${List.filled(84, '界').join()}ab',
      ]) {
        final source = 'value = <<-$marker\nhello\n$marker\n';
        if (parser.parse(source).rootNode.hasError) {
          throw StateError(
              'Crystal rejected a ${utf8.encode(marker).length}-byte '
              'heredoc identifier');
        }
        crystal.add('${utf8.encode(marker).length}-byte identifier');
      }
      const quoted = "value = <<-'α 𐐀'\nhello 😀\nα 𐐀\n";
      if (parser.parse(quoted).rootNode.hasError) {
        throw StateError('Crystal rejected the quoted Unicode heredoc');
      }
      crystal.add('quoted Unicode identifier');
    } finally {
      parser.dispose();
    }
    report = {
      'passed': true,
      'platform': Platform.operatingSystem,
      'grammars': initialized,
      'grammarCount': initialized.length,
      'crystalFixtures': crystal,
    };
  } catch (error, stack) {
    resultCode = 1;
    report = {'passed': false, 'error': '$error', 'stackTrace': '$stack'};
  }
  final content = const JsonEncoder.withIndent('  ').convert(report);
  final reportPath = Platform.environment['DUSKMOON_NATIVE_REPORT'];
  if (reportPath != null) {
    File(reportPath).writeAsStringSync('$content\n');
  } else {
    stdout.writeln(content);
  }
  exit(resultCode);
}
