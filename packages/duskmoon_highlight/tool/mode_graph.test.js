// Copyright (c) 2026 DuskMoon contributors. MIT licensed.
const assert = require('node:assert/strict');
const { test } = require('node:test');
const { ModeReference, normalizeGraph } = require('./mode_graph');

test('preserves shared mode targets and self/mutual cycles', () => {
  const child = { begin: 'child' };
  const mode = { contains: [child, child] };
  child.starts = mode;
  const { root, references } = normalizeGraph(mode);
  assert.equal(root.contains[1].path, '~contains~0');
  assert.equal(root.contains[0].starts.path, '~');
  assert.equal(references['~contains~0'], root.contains[0]);
  assert.equal(references['~'], root);
});

test('literal tilde, escapes and prototype-looking keys are not graph edges', () => {
  const mode = JSON.parse('{"begin":"~contains~0\\\\x7e","__proto__":{"end":"~"}}');
  const { root, references } = normalizeGraph(mode);
  assert.equal(root.begin, mode.begin);
  assert.equal(root.__proto__.end, '~');
  assert.deepEqual(Object.keys(references), []);
  assert.equal(Object.getPrototypeOf(root), Object.prototype);
  assert.equal(root.begin instanceof ModeReference, false);
});

test('replacer preserves regex text, callback markers and value-object copies', () => {
  const keywords = { keyword: 'if ~ else' };
  const mode = { contains: [{ begin: /[~\\]/, keywords }, { keywords }], 'on:begin': () => {} };
  const { root, references } = normalizeGraph(mode, (key, value) => {
    if (value instanceof RegExp) return value.source;
    if (key === 'on:begin') return 'callbackOnBegin';
    if (key === 'keywords') return { ...value };
    return value;
  });
  assert.equal(root.contains[0].begin, mode.contains[0].begin.source);
  assert.equal(root['on:begin'], 'callbackOnBegin');
  assert.deepEqual(root.contains[0].keywords, root.contains[1].keywords);
  assert.notEqual(root.contains[0].keywords, root.contains[1].keywords);
  assert.deepEqual(Object.keys(references), []);
});

test('shared arrays/cycles and escaped-key ref names remain deterministic', () => {
  const array = [];
  array.push(array);
  const mode = { 'a~b': array, shared: array };
  const first = normalizeGraph(mode);
  assert.equal(first.root.shared.path, '~a~0b');
  assert.equal(first.root['a~b'][0].path, '~a~0b');
  assert.equal(first.references['~a~0b'], first.root['a~b']);
  assert.equal(JSON.stringify(first), JSON.stringify(normalizeGraph(mode)));
});
