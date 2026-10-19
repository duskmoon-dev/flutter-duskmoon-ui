# Patched Markdown parser

This internal parser is based on the official `markdown` **7.3.1** hosted
archive, published on 2026-03-18, with three official unreleased fixes.
Last checked on 2026-10-19: Pub still lists 7.3.1 as the latest release.

- Upstream: <https://github.com/dart-lang/tools/tree/main/pkgs/markdown>
- Archive: <https://pub.dev/api/archives/markdown-7.3.1.tar.gz>
- Archive SHA-256:
  `ee85086ad7698b42522c6ad42fe195f1b9898e4d974a1af4576c1a3a176cada9`
- Copyright and BSD-3-Clause license: [LICENSE](LICENSE), [AUTHORS](AUTHORS).
- The original `lib/` files included here are recorded in
  [UPSTREAM_FILES.sha256](UPSTREAM_FILES.sha256). Paths in that manifest refer to
  the original archive, before patching. Generated case-folding, HTML-entity and
  emoji tables retain their upstream notices.

## Exact upstream patches

Applied in this order, restricted to runtime `lib/` changes:

1. [#2536](https://github.com/dart-lang/tools/pull/2536),
   [`cacb5a56366c49ec69d682cc8bf9743d338ce18d`](https://github.com/dart-lang/tools/commit/cacb5a56366c49ec69d682cc8bf9743d338ce18d),
   2026-09-02: avoid quadratic parsing of long unbroken words.
2. [#2662](https://github.com/dart-lang/tools/pull/2662),
   [`a55965844fbacd4277291f4b559bd1c5e2c88204`](https://github.com/dart-lang/tools/commit/a55965844fbacd4277291f4b559bd1c5e2c88204),
   2026-10-13: avoid quadratic parsing of consecutive reference definitions.
3. [#2631](https://github.com/dart-lang/tools/pull/2631),
   [`4eaf46babd833a48d638b154821aff9d676ab61a`](https://github.com/dart-lang/tools/commit/4eaf46babd833a48d638b154821aff9d676ab61a),
   2026-10-14: fix malformed-link EOF handling, retreating block syntaxes,
   unbalanced link destinations, and footnote/list AST errors.

The exact runtime diffs are retained in [patches/](patches/). They apply to the
original archive's `lib/` contents in the order above with `patch -p4` when that
contents directory is the working directory. Only the `document.dart` hunk line
numbers needed offsets; no patch semantics were rewritten.

## Local integration changes

- `markdown.dart` is a small internal barrel exposing only parser entry points
  and the shared AST. The CLI, HTML renderer, legacy emoji table, version
  constant, and unused fenced-blockquote syntax are not imported.
- **`src/ast.dart` re-exports the official hosted package's `Node`, `Element`,
  `Text`, `NodeVisitor`, `Resolver` and `UnparsedContent`.** There is one AST type
  identity, so `DmMarkdown.nodes`, existing visitors and custom builders remain
  compatible with `package:markdown/markdown.dart` values. Keep the hosted
  dependency for this compatibility boundary.
- Runtime source is formatted using the workspace's Dart 3.6 formatter setting.
  The original fingerprints and exact upstream patches above remain unchanged.
  Local import sites
  use this parser for `Document` and custom syntax classes; public AST-only
  imports continue using the official package.
- Regression tests in `test/src/markdown/patched_parser_test.dart` cover the
  upstream defects, bounded parser work, and hosted AST interoperability.

This directory is an internal implementation, not a replacement public Markdown
API. Once an official hosted release includes these fixes, verify the regression
and widget suites against it and remove the parser copy and import changes while
retaining the public AST contract.
