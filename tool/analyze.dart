import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> paths) async {
  final result = await Process.run(Platform.resolvedExecutable, [
    'analyze',
    '--format=machine',
    ...paths,
  ]);

  var fatal = result.exitCode != 0;
  for (final line in const LineSplitter().convert(
    '${result.stdout}\n${result.stderr}',
  )) {
    if (line.isEmpty) continue;
    stdout.writeln(line);
    if (line.startsWith('INFO|') && !_sdkUiImport(line)) fatal = true;
  }
  exitCode = fatal ? (result.exitCode == 0 ? 1 : result.exitCode) : 0;
}

// The current public API uses SDK Material and Cupertino types. Hosted
// material_ui and cupertino_ui define different types. Keep these import
// diagnostics visible until the public API can migrate across a major version.
bool _sdkUiImport(String diagnostic) {
  final fields = diagnostic.split('|');
  if (fields.length < 8 || fields[2] != 'DEPRECATED_MEMBER_USE') return false;

  final message = fields[7];
  return message.startsWith("'package:flutter/material.dart' is deprecated") ||
      message.startsWith("'package:flutter/cupertino.dart' is deprecated");
}
