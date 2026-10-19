import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdirSync, mkdtempSync, readFileSync, rmSync, symlinkSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { test } from 'node:test';

const packageRoot = fileURLToPath(new URL('../../', import.meta.url));
const dart = process.env.DART || 'dart';

test('generated Dart compiles and preserves precedence, node properties and 32-bit states', () => {
  const directory = mkdtempSync(join(tmpdir(), 'duskmoon-dart-consumer-'));
  try {
    const json = join(directory, 'precedence.json');
    const generated = join(directory, 'lib/src/grammars/precedence_lr.g.dart');
    mkdirSync(join(directory, 'lib/src/grammars'), { recursive: true });
    // Keep generated relative imports intact and exercise the real runtime.
    symlinkSync(join(packageRoot, 'lib/src/lezer'), join(directory, 'lib/src/lezer'), 'dir');
    execFileSync(process.execPath, [join(packageRoot, 'tool/compile_grammar.mjs'),
      join(packageRoot, 'tool/fixtures/precedence.grammar'), json]);
    const expected = JSON.parse(readFileSync(json, 'utf8'));
    assert.ok(expected.tokenPrec > 0, 'fixture must include token precedence');
    assert.ok(expected.states.some(value => value > 65535), 'fixture must require 32-bit states');
    execFileSync(dart, [join(packageRoot, 'tool/grammar_to_dart.dart'), json, 'Precedence', generated]);
    const consumer = join(directory, 'main.dart');
    writeFileSync(consumer, `
import 'dart:convert';
import 'lib/src/grammars/precedence_lr.g.dart';
void main() {
  final grammar = precedenceLRParser.grammar;
  print(jsonEncode({
    'nodeNames': grammar.nodeNames,
    'states': grammar.states,
    'stateData': grammar.stateData,
    'goto': grammar.gotoTable,
    'tokenData': grammar.tokenData,
    'tokenPrec': grammar.tokenPrec,
    'skippedNodes': grammar.skippedNodes,
    'nodeProps': {
      for (final type in grammar.nodeSet.types)
        if (type.isTop || type.isError || type.isSkipped)
          type.id.toString(): {
            if (type.isTop) 'top': true,
            if (type.isError) 'error': true,
            if (type.isSkipped) 'skipped': true,
          },
    },
  }));
}
`);
    const actual = JSON.parse(execFileSync(dart, [consumer], { encoding: 'utf8' }));
    for (const field of ['nodeNames', 'states', 'stateData', 'goto', 'tokenData',
      'tokenPrec', 'skippedNodes', 'nodeProps']) {
      assert.deepEqual(actual[field], expected[field], field);
    }
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
});
