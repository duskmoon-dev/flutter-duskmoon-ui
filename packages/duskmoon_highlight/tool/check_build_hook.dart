// Run with `dart --packages=.dart_tool/package_config.json
// packages/duskmoon_highlight/tool/check_build_hook.dart` from the workspace root.
// Direct Dart execution keeps this small native fixture independent of Flutter's
// full 95-grammar native hook build.
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

void check(bool condition, String message) {
  if (!condition) throw StateError(message);
}

Future<void> main() async {
  final packageConfig = await Isolate.packageConfig;
  check(packageConfig != null, 'Run with an explicit package configuration');
  final temporary = await Directory.systemTemp.createTemp('highlight-hook-');
  try {
    for (final hosted in [true, false]) {
      await checkBuild(temporary.uri.resolve(hosted ? 'hosted/' : 'checkout/'),
          hosted: hosted, packageConfig: packageConfig!);
    }
    stdout.writeln('PASS: checkout and hosted native dependency contracts');
  } finally {
    await temporary.delete(recursive: true);
  }
}

Future<void> checkBuild(Uri root,
    {required bool hosted, required Uri packageConfig}) async {
  Future<void> write(String path, String content) async {
    final file = File.fromUri(root.resolve(path));
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
  }

  const parser = 'vendor/grammars/fixture/src/parser.c';
  // Check raw UTF-8 source and ASCII Unicode escapes against explicit bytes.
  // Both must survive compilation of each C/C++ part of the native bundle.
  const utf8Check = r'memcmp("≠\u2265", "\xe2\x89\xa0\xe2\x89\xa5", 7) == 0';
  const parserSource = '''
#include <tree_sitter/api.h>
#include <string.h>
const TSLanguage *tree_sitter_fixture(void) { return 0; }
int fixture_parser(void) { return $utf8Check ? 4 : 0; }
''';
  await write(
      'grammars.json',
      jsonEncode({
        'grammars': [
          {
            'id': 'fixture',
            'symbol': 'tree_sitter_fixture',
            'sources': [parser, 'vendor/grammars/fixture/src/scanner.cc'],
            'includeDirectories': ['vendor/grammars/fixture/src'],
          }
        ],
      }));
  await write('vendor/tree-sitter/lib/include/tree_sitter/api.h',
      'typedef struct TSLanguage TSLanguage;\n');
  await write(
    'vendor/tree-sitter/lib/src/lib.c',
    '#include "runtime.h"\n#include <string.h>\n'
        'int fixture_runtime(void) { return $utf8Check ? FIXTURE : 0; }\n',
  );
  await write('vendor/tree-sitter/lib/src/runtime.h', '#define FIXTURE 1\n');
  await write('src/native/bridge.c', '''
#include "bridge.h"
#include <string.h>
extern int fixture_runtime(void);
extern int fixture_parser(void);
extern int fixture_scanner(void);
#ifdef _WIN32
__declspec(dllexport)
#else
__attribute__((visibility("default")))
#endif
int fixture_utf8(void) {
  return ($utf8Check ? BRIDGE : 0) + fixture_runtime() +
      fixture_parser() + fixture_scanner();
}
''');
  await write('src/native/bridge.h', '#define BRIDGE 2\n');
  await write(
    'vendor/grammars/fixture/src/scanner.cc',
    '#include "scanner.h"\n#include <string.h>\n'
        'extern "C" int fixture_scanner(void) '
        '{ return $utf8Check ? SCANNER : 0; }\n',
  );
  await write('vendor/grammars/fixture/src/scanner.h', '#define SCANNER 3\n');
  if (hosted) {
    final compressed = File.fromUri(root.resolve('$parser.gz'));
    await compressed.writeAsBytes(gzip.encode(utf8.encode(parserSource)));
  } else {
    await write(parser, parserSource);
  }

  final builder = BuildInputBuilder()
    ..setupShared(
      packageName: 'duskmoon_highlight',
      packageRoot: root,
      outputDirectoryShared: root.resolve('build/'),
      outputFile: root.resolve('output.json'),
    )
    ..config.setupBuild(linkingEnabled: false)
    ..addExtension(CodeAssetExtension(
      targetOS: OS.current,
      targetArchitecture: Architecture.current,
      linkModePreference: LinkModePreference.dynamic,
    ));
  final input = builder.build();
  final configFile = File.fromUri(root.resolve('input.json'));
  await configFile.writeAsString(jsonEncode(input.json));

  Future<BuildOutput> build() async {
    final result = await Process.run(Platform.resolvedExecutable, [
      '--packages=${packageConfig.toFilePath()}',
      Platform.script.resolve('../hook/build.dart').toFilePath(),
      '--config=${configFile.path}',
    ]);
    check(result.exitCode == 0,
        '$hosted: native hook failed: ${result.stdout}\n${result.stderr}');
    return BuildOutput(
        jsonDecode(await File.fromUri(input.outputFile).readAsString())
            as Map<String, Object?>);
  }

  final first = await build();
  final dependencies = first.dependencies.toSet();
  final generated = {
    input.outputDirectory.resolve('languages.c'),
    if (hosted) input.outputDirectory.resolve('sources/$parser'),
  };
  check(
      !dependencies.any(generated.contains),
      '$hosted: generated C outputs must not invalidate the native build: '
      '${dependencies.intersection(generated)}');
  check(!dependencies.any((uri) => uri.isIn(input.outputDirectory)),
      '$hosted: a build output was registered as an input');
  final expected = {
    'grammars.json',
    if (hosted) '$parser.gz' else parser,
    'vendor/grammars/fixture/src/scanner.cc',
    'vendor/grammars/fixture/src/scanner.h',
    'vendor/tree-sitter/lib/include/tree_sitter/api.h',
    'vendor/tree-sitter/lib/src/lib.c',
    'vendor/tree-sitter/lib/src/runtime.h',
    'src/native/bridge.c',
    'src/native/bridge.h',
  }.map(root.resolve).toSet();
  check(
      dependencies.containsAll(expected),
      '$hosted: missing stable source dependencies: '
      '${expected.difference(dependencies)}');
  check(first.assets.code.length == 1, '$hosted: expected one bundled asset');
  check(await File.fromUri(first.assets.code.single.file!).exists(),
      '$hosted: bundled native asset must exist');

  final library = DynamicLibrary.open(
    first.assets.code.single.file!.toFilePath(),
  );
  try {
    final utf8Result = library.lookupFunction<Int32 Function(), int Function()>(
      'fixture_utf8',
    );
    check(
      utf8Result() == 10,
      '$hosted: C parser, C++ scanner, runtime and bridge must preserve UTF-8',
    );
  } finally {
    library.close();
  }

  // Every stable source remains detectable after editing. Generated C files
  // deliberately do not participate in this input fingerprint.
  Future<String> fingerprint() async => jsonEncode([
        for (final uri in dependencies)
          [uri.toString(), base64Encode(await File.fromUri(uri).readAsBytes())],
      ]);
  final unchanged = await fingerprint();
  for (final uri in expected) {
    final file = File.fromUri(uri);
    final original = await file.readAsBytes();
    await file.writeAsBytes([...original, 10]);
    check(await fingerprint() != unchanged,
        '$hosted: changing $uri must invalidate the dependency fingerprint');
    await file.writeAsBytes(original);
  }
  final second = await build();
  final repeatedDependencies = second.dependencies.toSet();
  check(
      repeatedDependencies.length == dependencies.length &&
          repeatedDependencies.containsAll(dependencies),
      '$hosted: repeated native build changed its dependency contract');
  check(await fingerprint() == unchanged,
      '$hosted: rebuilding unchanged sources changed the dependency fingerprint');
  stdout.writeln('PASS: ${hosted ? 'hosted gzip' : 'checkout'}: '
      '${dependencies.length} stable inputs, one native asset, UTF-8 literals, '
      'repeated build');
}

extension on Uri {
  bool isIn(Uri directory) => toString().startsWith(directory.toString());
}
