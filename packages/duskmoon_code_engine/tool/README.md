# Grammar metadata tools

These tools compile Lezer grammars to JSON and generate Dart metadata consumed
by `LRParser.deserialize`. Dependencies are pinned in `package-lock.json`.

From the workspace root with Node/npm and Dart available:

```sh
npm ci --prefix packages/duskmoon_code_engine/tool --ignore-scripts --no-audit --no-fund
DART="$PWD/.devenv/profile/bin/dart" npm test --prefix packages/duskmoon_code_engine/tool
npm audit --prefix packages/duskmoon_code_engine/tool
```

`DART` selects the Dart executable for the generated-consumer test; it defaults
to `dart` on `PATH`. That test compiles a grammar with token precedence, generates
and compiles Dart, then checks metadata and node properties against the JSON,
including state values above 65535. The other tests verify deterministic JSON
generation, the JavaScript Lezer parser, and invalid grammar diagnostics.

Generate JSON with `node compile_grammar.mjs input.grammar output.json`, then run
`dart grammar_to_dart.dart output.json Language path/to/language_lr.g.dart` from
this directory. Generated Dart expects the output under `lib/src/grammars/` so
its relative imports resolve to `lib/src/lezer/`.

## Runtime limitation

The Dart LR runtime is currently a JSON tokenizer stub. It stores generated
tables but does not execute the LR/DFA tables or reproduce arbitrary grammar
parse trees. Successful code generation, compilation and metadata preservation
do not establish parsing parity with JavaScript Lezer.

`LRParser.deserialize` retains its `List<int>` inputs and accepts optional
`tokenPrec` metadata. `GrammarData.states` uses `Uint32List` to preserve Lezer's
32-bit states; callers constructing `GrammarData` directly must supply
`Uint32List` rather than the former `Uint16List`.
