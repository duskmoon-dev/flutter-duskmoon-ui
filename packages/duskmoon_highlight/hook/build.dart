// @dart=3.10
import 'dart:convert';
import 'dart:io';

import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';
import 'package:native_toolchain_c/native_toolchain_c.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;
    final manifestFile = File.fromUri(
      input.packageRoot.resolve('grammars.json'),
    );
    final manifest = jsonDecode(await manifestFile.readAsString()) as Map;
    final grammars = manifest['grammars'] as List;
    final bridge = File.fromUri(input.outputDirectory.resolve('languages.c'));
    final generatedSources = <Uri>{bridge.uri};
    final nativeOutput = BuildOutputBuilder();
    await bridge.parent.create(recursive: true);
    final dispatch = StringBuffer(
      '#include <string.h>\n#include <tree_sitter/api.h>\n',
    );
    for (final grammar in grammars.cast<Map>()) {
      dispatch.writeln('extern const TSLanguage *${grammar['symbol']}(void);');
    }
    dispatch.writeln('const TSLanguage *dmh_language(const char *name) {');
    for (final grammar in grammars.cast<Map>()) {
      dispatch.writeln(
        'if (!strcmp(name, "${grammar['id']}")) return ${grammar['symbol']}();',
      );
    }
    dispatch.writeln('return NULL;\n}');
    await bridge.writeAsString(dispatch.toString());
    output.dependencies.add(manifestFile.uri);
    // Track included scanner/runtime headers as well as the directly compiled C.
    for (final directory in [
      'vendor/tree-sitter',
      'vendor/grammars',
      'src/native',
    ]) {
      final root = Directory.fromUri(input.packageRoot.resolve(directory));
      if (await root.exists()) {
        await for (final file in root.list(recursive: true)) {
          if (file is File) output.dependencies.add(file.uri);
        }
      }
    }
    final target = input.config.code.targetOS;
    Future<String> buildSource(String source) async {
      final original = File.fromUri(input.packageRoot.resolve(source));
      if (await original.exists() || !source.endsWith('/parser.c')) {
        return source;
      }
      // Hosted archives retain exact parser bytes as gzip to fit Pub's
      // uncompressed-size limit. Checkout builds use the original C directly.
      final compressed = File.fromUri(input.packageRoot.resolve('$source.gz'));
      output.dependencies.add(compressed.uri);
      final decoded = File.fromUri(
        input.outputDirectory.resolve('sources/$source'),
      );
      generatedSources.add(decoded.uri);
      await decoded.parent.create(recursive: true);
      await compressed
          .openRead()
          .transform(gzip.decoder)
          .pipe(decoded.openWrite());
      return decoded.path;
    }

    Future<void> removeOldArchive(String name) async {
      final file = File.fromUri(
        input.outputDirectory.resolve(
          target.libraryFileName(name, StaticLinking()),
        ),
      );
      // ar updates existing members, leaving stale objects when a grammar's
      // source list shrinks. Always create this hook's own archives afresh.
      if (await file.exists()) await file.delete();
    }

    final grammarLibraries = <String>[];
    final scannerLibraries = <String>[];
    var hasCpp = false;
    for (final grammar in grammars.cast<Map>()) {
      final id = grammar['id'] as String;
      final grammarSources = <String>[];
      for (final source in (grammar['sources'] as List).cast<String>()) {
        grammarSources.add(await buildSource(source));
      }
      final cpp = grammarSources
          .where((source) => source.endsWith('.cc') || source.endsWith('.cpp'))
          .toList();
      final includes = <String>{
        ...((grammar['includeDirectories'] as List?) ?? []).cast<String>(),
        'vendor/tree-sitter/lib/include',
      }.toList();
      final name = 'duskmoon_grammar_${id.replaceAll('-', '_')}';
      await removeOldArchive(name);
      // Keep each grammar's generated parser.h private to that grammar. Some
      // upstream sources use angle includes and different macro versions.
      await CBuilder.library(
        name: name,
        sources: grammarSources
            .where((source) => !cpp.contains(source))
            .toList(),
        includes: includes,
        linkModePreference: LinkModePreference.static,
        std: target == OS.windows ? 'c11' : null,
        defines: {'_DEFAULT_SOURCE': null},
      ).run(input: input, output: nativeOutput, routing: []);
      grammarLibraries.add(name);
      if (cpp.isNotEmpty) {
        hasCpp = true;
        final scanners = '${name}_scanners';
        await removeOldArchive(scanners);
        await CBuilder.library(
          name: scanners,
          sources: cpp,
          includes: includes,
          language: Language.cpp,
          std: 'c++17',
          linkModePreference: LinkModePreference.static,
        ).run(input: input, output: nativeOutput, routing: []);
        scannerLibraries.add(scanners);
      }
    }
    await CBuilder.library(
      name: 'duskmoon_tree_sitter',
      assetName: 'src/tree_sitter/native.dart',
      sources: [
        'vendor/tree-sitter/lib/src/lib.c',
        'src/native/bridge.c',
        bridge.path,
      ],
      includes: [
        'vendor/tree-sitter/lib/include',
        'vendor/tree-sitter/lib/src',
      ],
      defines: {'_DEFAULT_SOURCE': null},
      std: target == OS.windows ? 'c11' : null,
      // One bundled library owns the complete C/parser/C++ scanner closure.
      linkModePreference: LinkModePreference.dynamic,
      libraryDirectories: [input.outputDirectory.toFilePath()],
      libraries: [
        ...grammarLibraries,
        ...scannerLibraries,
        if (hasCpp && target == OS.linux) 'stdc++',
        if (hasCpp && (target == OS.macOS || target == OS.iOS)) 'c++',
      ],
      flags: [
        if (target == OS.linux || target == OS.android) '-Wl,--no-undefined',
        // The NDK libc++.a linker script includes libc++abi as well. Bundle
        // the static runtime so Android consumers need no extra shared asset.
        if (hasCpp && target == OS.android) ...[
          '-Wl,-Bstatic',
          '-lc++',
          '-Wl,-Bdynamic',
        ],
      ],
    ).run(input: input, output: nativeOutput);
    final nativeBuild = nativeOutput.build();
    // CBuilder also reports generated C as dependencies. Only stable package
    // inputs may invalidate this hook: languages.c comes from grammars.json,
    // and decoded parsers come from the compressed sources tracked above.
    output.dependencies.addAll(
      nativeBuild.dependencies.where((uri) => !generatedSources.contains(uri)),
    );
    output.assets.code.addAll(nativeBuild.assets.code);
  });
}
