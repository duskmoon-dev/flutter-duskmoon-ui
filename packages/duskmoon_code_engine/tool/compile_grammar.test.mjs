import assert from 'node:assert/strict';
import { execFileSync, spawnSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';
import { test } from 'node:test';
import { buildParser } from '@lezer/generator';

const compiler = fileURLToPath(new URL('./compile_grammar.mjs', import.meta.url));
const grammar = fileURLToPath(new URL('./fixtures/expression.grammar', import.meta.url));

test('compiled tables reproduce the pinned parser and generation is deterministic', () => {
  const directory = mkdtempSync(join(tmpdir(), 'duskmoon-lezer-'));
  try {
    const first = join(directory, 'first.json');
    const second = join(directory, 'second.json');
    execFileSync(process.execPath, [compiler, grammar, first]);
    execFileSync(process.execPath, [compiler, grammar, second]);
    assert.equal(readFileSync(first, 'utf8'), readFileSync(second, 'utf8'));

    const tables = JSON.parse(readFileSync(first, 'utf8'));
    const parser = buildParser(readFileSync(grammar, 'utf8'));
    assert.equal(parser.parse('12 + 34 + 5').toString(),
      'Program(Expression(Number,Number,Number))');
    assert.match(parser.parse('12 + ?').toString(), /⚠/);
    assert.deepEqual(tables.nodeNames, parser.nodeSet.types.map(type => type.name));
    const expected = {
      states: parser.states,
      stateData: parser.data,
      goto: parser.goto,
      tokenData: parser.tokenizers[0].data,
    };
    for (const field of Object.keys(expected)) {
      assert.ok(tables[field].length > 0, field);
      assert.deepEqual(tables[field], Array.from(expected[field]));
    }
    assert.equal(tables.nodeNames[tables.topRuleIndex], 'Program');
    assert.equal(tables.nodeProps[tables.topRuleIndex].top, true);
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
});

test('invalid grammar reports an error without writing output', () => {
  const directory = mkdtempSync(join(tmpdir(), 'duskmoon-lezer-invalid-'));
  try {
    const input = join(directory, 'invalid.grammar');
    writeFileSync(input, '@top Program { MissingRule }');
    const result = spawnSync(process.execPath, [compiler, input], { encoding: 'utf8' });
    assert.equal(result.status, 1);
    assert.match(result.stderr, /Reference to undefined rule 'MissingRule'/);
    assert.throws(() => readFileSync(join(directory, 'invalid.json')), { code: 'ENOENT' });
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
});
