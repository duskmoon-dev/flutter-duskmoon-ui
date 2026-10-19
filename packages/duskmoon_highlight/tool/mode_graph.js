// Copyright (c) 2026 DuskMoon contributors. MIT licensed.
// Typed references keep literal regex/keyword strings separate from graph edges.
class ModeReference {
  constructor(path) { this.path = path; }
}

function normalizeGraph(value, replacer = (_, item) => item) {
  const seen = new WeakMap();
  const references = Object.create(null);
  function visit(key, input, path) {
    const item = replacer(key, input);
    if (item === null || typeof item !== 'object') {
      return typeof item === 'function' ? undefined : item;
    }
    if (seen.has(item)) {
      const previous = seen.get(item);
      references[previous.path] = previous.output;
      return new ModeReference(previous.path);
    }
    const output = Array.isArray(item) ? [] : {};
    seen.set(item, { path, output });
    for (const [name, child] of Object.entries(item)) {
      const segment = name.replace(/~/g, '~0');
      const normalized = visit(name, child, `${path === '~' ? '' : path}~${segment}`);
      if (normalized !== undefined) {
        Object.defineProperty(output, name, {
          value: normalized, enumerable: true, writable: true, configurable: true,
        });
      } else if (Array.isArray(item)) {
        output[name] = null;
      }
    }
    return output;
  }
  return { root: visit('', value, '~'), references };
}

module.exports = { ModeReference, normalizeGraph };
