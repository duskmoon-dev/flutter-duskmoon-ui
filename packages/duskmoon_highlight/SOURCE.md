# Source provenance

DuskMoon owns the Dart adapters, native bridge/build hook, capture styling and
curated query bundle. The previous Highlight.js/re_highlight-derived parser,
generated languages/styles and Lezer runtime/generator have been removed.

## Official runtime

- Tree-sitter C runtime **0.27.1**, copied unchanged from the official source
  archive into `vendor/tree-sitter/lib`, with its original MIT license.
- Source: https://github.com/tree-sitter/tree-sitter/tree/v0.27.1
- Archive: https://codeload.github.com/tree-sitter/tree-sitter/tar.gz/refs/tags/v0.27.1
- SHA-256: `982cd3d4d9eb7be18c243240a622423fd2e4ecb4bec2cd98832c2f3fa1f0f333`.
- Official `web-tree-sitter` **0.27.1** module and Wasm are copied byte-for-byte
  from https://registry.npmjs.org/web-tree-sitter/-/web-tree-sitter-0.27.1.tgz.
  Archive SHA-256: `7346db659eb870a5284242851ab7aedea41d7397b8c7e95ff8d9ec5b5a80270f`.
  The same upstream MIT license applies. The adjacent DuskMoon loader imports
  this module from the application's own package assets.

Both archives were downloaded again and all retained runtime files compared
byte-for-byte. Exact npm integrity and individual file hashes are in
`grammars.json`.

## Grammar source and queries

The initial discovery catalog was `kreuzberg-dev/tree-sitter-language-pack`,
commit `6af2fb0e3b01336567c6ce574dd15b712eb262bc`. Each of the 95 selected grammars
has an independent pinned upstream repository revision, source archive URL and
SHA-256 in `grammars.json`. The source closure includes original generated
headers/scanners, source grammars, query files and licenses. Runtime sources are
never fetched during a consumer build.

ABNF, GraphQL, LaTeX, Reason, SQL, Swift and XQuery lacked generated parsers in
their source archives; Less had an unsupported ABI 11 parser. These parsers were
generated/regenerated with Tree-sitter CLI **0.26.8**. The actual generated ABI
(13–15) is recorded per grammar. Source grammars and generation inputs remain
vendored. Some generators fall back to ABI 14 when upstream has no
`tree-sitter.json`; that output is supported by the official 0.27.1 runtime.

`queries/` contains the compiled highlight inputs. Upstream highlight queries
are combined with explicit inheritance and conservative structural captures
from each grammar's actual node types. The manifest records source query paths,
equivalent predicate/operator transformations and every omitted pattern.
Unsupported local-scope/ancestor predicates are omitted as whole patterns;
conditions are never silently removed. Invalid inherited patterns are omitted
with the official query compiler's error recorded. Native and web evaluate
text predicates over full query matches. Embedded-language injection and locals
analysis are not implemented.

Original license texts remain in each vendor closure and are collected in
`THIRD_PARTY_LICENSES`; `THIRD_PARTY_NOTICES` lists their paths. DuskMoon-owned
code is MIT. The hosted package includes vendor C/C++ source, the build hook,
manifest, curated queries, browser assets and all notices. Maintenance scripts
and tests are excluded from hosted archives.

Pub also omits repository metadata such as `.gitignore`, `.gitattributes` and
`.editorconfig` from the vendored source inventory. These are not build inputs;
all native sources, headers, scanners and license files remain in the archive.

Generated `parser.c` files remain unchanged in Git. Hosted archives include
deterministic, timestamp-free `parser.c.gz` copies instead, keeping the archive
below Pub's 256 MiB uncompressed-size limit without dropping any grammar. The
native build hook uses raw checkout sources when present; otherwise it streams
the packaged gzip into its build output and compiles those exact decoded bytes
against the grammar's original headers. No download is performed. The manifest
records both raw and compressed hashes, and `generate` / `verify` prove that
every decoded parser matches its retained source byte-for-byte.
The vendored AsciiDoc Git attributes mark these gzip files as binary to prevent
line-ending normalization from changing their bytes when committed.

## Explicit compatibility adaptations

- `patches/swift-wasm-oom.patch`: the Swift external scanner's allocation-failure
  path calls `__builtin_trap()` on Wasm, because the official runtime does not
  import stdio or process-exit symbols. Native behavior and successful scanning
  are unchanged.
- Nim and Vala retain their original C++ scanners. CLI 0.26.8 discovers only
  `scanner.c`, so the maintenance tool compiles parser C and scanner C++17
  separately with the same Wasm shared-module contract. The owned
  `src/wasm/cpp_scanner_support.cc` supplies malloc/free-backed allocation and
  traps on unrecoverable C++ library failures. No scanner algorithm is changed.
- The native hook compiles each grammar against its own generated `parser.h`;
  C++ scanners use separate archives. This preserves upstream header macros and
  avoids accidentally compiling C sources as C++.

## Toolchain and reproducibility

Wasm assets use CLI 0.26.8 and **WASI SDK 29.0** (LLVM 21.1.4), with the CLI's
`-Os` shared/PIC/no-entry compilation contract. The two C++ grammars additionally
use `-fno-exceptions -fno-rtti -DNDEBUG`. The manifest records the official WASI
SDK download digest and hashes every retained source, query, patch and asset.
Run `tool/grammars.py generate` then `verify` with Dart available to verify that
the embedded Dart query inventory and license collections match these inputs.

LLVM, Vim and x86asm were deliberately excluded from both native and web despite
working native parsers. Their generated lexer control flow makes LLVM Wasm
compilation consume excessive memory. Disabling the compiler's irreducible-CFG
pass allowed compilation, but normal V8 optimizing compilation then fatally
exhausted memory; those assets are not shipped. Groovy lacked a license grant
in the selected source; the PostgreSQL source contained an unresolved 97MB Git
LFS pointer. The complete supported/unsupported inventory is in
[LANGUAGES.md](LANGUAGES.md).
