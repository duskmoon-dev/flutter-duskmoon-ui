# Source provenance

This is a maintained source fork of Flutter's `flutter_adaptive_scaffold`.
It has no runtime dependency on the original Pub package.

- Upstream: https://github.com/flutter/packages/tree/main/packages/flutter_adaptive_scaffold
- Recorded version: **0.3.3+1**.
- Intermediate source: `gsmlg-app/flutter-app-template`,
  `third_party/flutter_adaptive_scaffold/`, already modified before this import.
- Local import: `01c8dcb99165e5f970b81380a797b852f9807156` (2026-04-03).
- Exact upstream and intermediate Git revisions: **unknown**; the import history
  and design specification do not record them. The local import commit is not
  an upstream revision.

The import renamed the package and imports, retaining the intermediate copy's
navigation rail padding and destination builder changes. Subsequent DuskMoon
maintenance includes collapsible/sidebar navigation and hinge/dual-screen
layout behavior. The original import is described in
`docs/superpowers/specs/2026-04-03-duskmoon-adaptive-scaffold-design.md`
in the repository root.

## Licenses

Flutter-derived source is BSD-3-Clause, Copyright 2013 The Flutter Authors.
`LICENSE` retains the full Flutter terms and the MIT terms for DuskMoon's own
modifications. `THIRD_PARTY_LICENSES` also contains the Flutter notice for
redistribution. The earlier local MIT text attributed to The Flutter Authors
was incorrect and has been replaced by the upstream BSD terms; it did not
relicense the Flutter source.
