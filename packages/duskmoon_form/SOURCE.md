# Source provenance

This package maintains imported form state management and widgets as owned
DuskMoon source. It does not depend on the original form or typeahead packages
at runtime.

## Form BLoCs and field widgets

- Upstream: https://github.com/GiancarloCode/form_bloc, originally
  `packages/form_bloc` and `packages/flutter_form_bloc`.
- Local import: `7a04a2daf6494036a7710720941f6730449e96d1` (2026-03-31),
  whose commit message records merging both packages.
- Imported upstream versions and Git revision: **unknown**. Neither the import
  commit nor the retained source pins them; current upstream releases are not
  evidence of the imported baseline.
- License: MIT, Copyright (c) 2019 GiancarloCode.

The fork keeps public BLoC names, adapts widgets to DuskMoon names/themes, and
maintains fields and dependency compatibility within this workspace.

## Embedded autocomplete

- Source: https://github.com/AbdulRahmanAlHamali/flutter_typeahead.
- Retained file: `lib/src/widgets/flutter_typeahead.dart`, included in the same
  local form import above.
- Imported version and upstream Git revision: **unknown**.
- License: BSD-2-Clause, Copyright (c) 2018 AbdulRahmanAlHamali. The original
  full notice remains in the source file and is reproduced in
  `THIRD_PARTY_LICENSES`.

The owned copy includes local keyboard visibility and Flutter animation
compatibility changes. Its legacy API names do not establish an exact
upstream version.

## Embedded Material Stepper

- Source: https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/material/stepper.dart.
- Retained file: `lib/src/widgets/stepper/stepper.dart`, whose header identifies
  the Flutter source and local modifications.
- Imported Flutter SDK version and Git revision: **unknown**.
- License: BSD-3-Clause, Copyright 2014 The Flutter Authors.

`THIRD_PARTY_LICENSES` retains all three upstream license texts. The package's
`LICENSE` continues to cover DuskMoon's own MIT-licensed modifications; it does
not replace these upstream notices.
