# duskmoon_adaptive_scaffold Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Vendor the modified `flutter_adaptive_scaffold` package into the monorepo as `duskmoon_adaptive_scaffold` and wire `duskmoon_widgets` to use it.

**Architecture:** Copy the source package verbatim, rename the package name and library file throughout, register it as a workspace member, then update `duskmoon_widgets` to drop the pub.dev dependency and use the local package instead.

**Tech Stack:** Dart/Flutter, Melos workspace, `flutter_adaptive_scaffold` v0.3.3+1 source

---

## File Map

**Create (new package `packages/duskmoon_adaptive_scaffold/`):**
- `pubspec.yaml` — package manifest (renamed, SDK adjusted)
- `lib/duskmoon_adaptive_scaffold.dart` — public library barrel (renamed from `flutter_adaptive_scaffold.dart`)
- `lib/src/adaptive_layout.dart` — copied verbatim
- `lib/src/adaptive_scaffold.dart` — copied verbatim
- `lib/src/breakpoints.dart` — copied, internal import updated
- `lib/src/slot_layout.dart` — copied verbatim
- `test/adaptive_layout_test.dart` — copied, package import updated
- `test/adaptive_scaffold_test.dart` — copied, package import updated
- `test/breakpoint_test.dart` — copied, package import updated
- `test/simulated_layout.dart` — copied, package import updated
- `test/slot_layout_test.dart` — copied, package import updated
- `test/test_breakpoints.dart` — copied, package import updated

**Modify:**
- `pubspec.yaml` (root) — add `packages/duskmoon_adaptive_scaffold` to `workspace:`
- `packages/duskmoon_widgets/pubspec.yaml` — swap `flutter_adaptive_scaffold` → `duskmoon_adaptive_scaffold`
- `packages/duskmoon_widgets/lib/src/scaffold/dm_scaffold.dart` — update import + export

---

### Task 1: Create the `duskmoon_adaptive_scaffold` package

**Files:**
- Create: `packages/duskmoon_adaptive_scaffold/pubspec.yaml`
- Create: `packages/duskmoon_adaptive_scaffold/lib/duskmoon_adaptive_scaffold.dart`
- Create: `packages/duskmoon_adaptive_scaffold/lib/src/adaptive_layout.dart`
- Create: `packages/duskmoon_adaptive_scaffold/lib/src/adaptive_scaffold.dart`
- Create: `packages/duskmoon_adaptive_scaffold/lib/src/breakpoints.dart`
- Create: `packages/duskmoon_adaptive_scaffold/lib/src/slot_layout.dart`

- [ ] **Step 1: Copy lib source files verbatim**

```bash
SOURCE=/home/gao/Workspace/gsmlg-app/flutter-app-template/third_party/flutter_adaptive_scaffold
DEST=/home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_adaptive_scaffold

mkdir -p "$DEST/lib/src" "$DEST/test"

cp "$SOURCE/lib/src/adaptive_layout.dart"  "$DEST/lib/src/adaptive_layout.dart"
cp "$SOURCE/lib/src/adaptive_scaffold.dart" "$DEST/lib/src/adaptive_scaffold.dart"
cp "$SOURCE/lib/src/breakpoints.dart"       "$DEST/lib/src/breakpoints.dart"
cp "$SOURCE/lib/src/slot_layout.dart"       "$DEST/lib/src/slot_layout.dart"
```

- [ ] **Step 2: Create the renamed library barrel file**

Create `packages/duskmoon_adaptive_scaffold/lib/duskmoon_adaptive_scaffold.dart`:

```dart
// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

export 'src/adaptive_layout.dart';
export 'src/adaptive_scaffold.dart';
export 'src/breakpoints.dart';
export 'src/slot_layout.dart';
```

- [ ] **Step 3: Fix the internal self-import in `breakpoints.dart`**

In `packages/duskmoon_adaptive_scaffold/lib/src/breakpoints.dart`, line 7:

Old:
```dart
import '../flutter_adaptive_scaffold.dart';
```

New:
```dart
import '../duskmoon_adaptive_scaffold.dart';
```

- [ ] **Step 4: Create `pubspec.yaml`**

Create `packages/duskmoon_adaptive_scaffold/pubspec.yaml`:

```yaml
name: duskmoon_adaptive_scaffold
description: Adaptive scaffold widgets for DuskMoon Design System, forked from flutter_adaptive_scaffold.
version: 0.3.3+1
publish_to: none

resolution: workspace

environment:
  sdk: ">=3.5.0 <4.0.0"
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

- [ ] **Step 5: Commit**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
git add packages/duskmoon_adaptive_scaffold/
git commit -m "feat(duskmoon_adaptive_scaffold): add vendored package from flutter_adaptive_scaffold 0.3.3+1"
```

---

### Task 2: Copy and fix test files

**Files:**
- Create: `packages/duskmoon_adaptive_scaffold/test/adaptive_layout_test.dart`
- Create: `packages/duskmoon_adaptive_scaffold/test/adaptive_scaffold_test.dart`
- Create: `packages/duskmoon_adaptive_scaffold/test/breakpoint_test.dart`
- Create: `packages/duskmoon_adaptive_scaffold/test/simulated_layout.dart`
- Create: `packages/duskmoon_adaptive_scaffold/test/slot_layout_test.dart`
- Create: `packages/duskmoon_adaptive_scaffold/test/test_breakpoints.dart`

- [ ] **Step 1: Copy all test files**

```bash
SOURCE=/home/gao/Workspace/gsmlg-app/flutter-app-template/third_party/flutter_adaptive_scaffold
DEST=/home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_adaptive_scaffold

cp "$SOURCE/test/adaptive_layout_test.dart"  "$DEST/test/adaptive_layout_test.dart"
cp "$SOURCE/test/adaptive_scaffold_test.dart" "$DEST/test/adaptive_scaffold_test.dart"
cp "$SOURCE/test/breakpoint_test.dart"        "$DEST/test/breakpoint_test.dart"
cp "$SOURCE/test/simulated_layout.dart"       "$DEST/test/simulated_layout.dart"
cp "$SOURCE/test/slot_layout_test.dart"       "$DEST/test/slot_layout_test.dart"
cp "$SOURCE/test/test_breakpoints.dart"       "$DEST/test/test_breakpoints.dart"
```

- [ ] **Step 2: Replace all `package:flutter_adaptive_scaffold` references**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_adaptive_scaffold/test

# Replace package name in all test imports
sed -i 's|package:flutter_adaptive_scaffold/flutter_adaptive_scaffold\.dart|package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart|g' *.dart
sed -i 's|package:flutter_adaptive_scaffold/src/|package:duskmoon_adaptive_scaffold/src/|g' *.dart
```

- [ ] **Step 3: Verify no references to the old package name remain**

```bash
grep -r "flutter_adaptive_scaffold" /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_adaptive_scaffold/
```

Expected: no output (zero matches).

- [ ] **Step 4: Commit**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
git add packages/duskmoon_adaptive_scaffold/test/
git commit -m "test(duskmoon_adaptive_scaffold): add test suite ported from flutter_adaptive_scaffold"
```

---

### Task 3: Register in workspace and run bootstrap

**Files:**
- Modify: `pubspec.yaml` (root)

- [ ] **Step 1: Add the new package to the workspace list**

In `pubspec.yaml` (root), find the `workspace:` list and add the new entry. The full updated list:

```yaml
workspace:
  - packages/duskmoon_theme
  - packages/duskmoon_theme_bloc
  - packages/duskmoon_widgets
  - packages/duskmoon_settings
  - packages/duskmoon_feedback
  - packages/duskmoon_visualization
  - packages/duskmoon_ui
  - packages/duskmoon_form
  - packages/duskmoon_adaptive_scaffold
  - example
```

- [ ] **Step 2: Run workspace bootstrap**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
dart pub get
```

Expected: resolves without errors. `duskmoon_adaptive_scaffold` should appear in `.dart_tool/package_config.json`.

- [ ] **Step 3: Commit**

```bash
git add pubspec.yaml
git commit -m "chore: add duskmoon_adaptive_scaffold to workspace"
```

---

### Task 4: Wire `duskmoon_widgets` to the new package

**Files:**
- Modify: `packages/duskmoon_widgets/pubspec.yaml`
- Modify: `packages/duskmoon_widgets/lib/src/scaffold/dm_scaffold.dart`

- [ ] **Step 1: Swap the dependency in `duskmoon_widgets/pubspec.yaml`**

Remove:
```yaml
  flutter_adaptive_scaffold: ^0.3.1
```

Add:
```yaml
  duskmoon_adaptive_scaffold: ^0.3.3+1
```

The full `dependencies` block becomes:

```yaml
dependencies:
  flutter:
    sdk: flutter
  duskmoon_theme: ^1.0.3
  duskmoon_adaptive_scaffold: ^0.3.3+1
  markdown: ^7.3.1
  highlighting: ^0.9.0+11.8.0
  flutter_math_fork: ^0.7.4
  url_launcher: ^6.3.0
```

- [ ] **Step 2: Update imports in `dm_scaffold.dart`**

In `packages/duskmoon_widgets/lib/src/scaffold/dm_scaffold.dart`, replace both lines at the top:

Old:
```dart
import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';

export 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart';
```

New:
```dart
import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';

export 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';
```

- [ ] **Step 3: Re-run bootstrap to pick up the change**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
dart pub get
```

Expected: resolves without errors.

- [ ] **Step 4: Verify no remaining references to `flutter_adaptive_scaffold` in the whole repo**

```bash
grep -r "flutter_adaptive_scaffold" /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/ \
  --include="*.dart" --include="*.yaml" --include="*.md"
```

Expected: only the design spec and plan docs you just wrote (which is fine — they document history).

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_widgets/pubspec.yaml \
        packages/duskmoon_widgets/lib/src/scaffold/dm_scaffold.dart
git commit -m "feat(duskmoon_widgets): replace flutter_adaptive_scaffold with duskmoon_adaptive_scaffold"
```

---

### Task 5: Analyze and test everything

- [ ] **Step 1: Run analyzer across the workspace**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
melos run analyze
```

Expected: exits 0, no infos/warnings/errors.

- [ ] **Step 2: Run the new package's tests**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_adaptive_scaffold
flutter test
```

Expected: all tests pass.

- [ ] **Step 3: Run `duskmoon_widgets` tests**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets
flutter test
```

Expected: all tests pass.

- [ ] **Step 4: Run all workspace tests**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
melos run test
```

Expected: all packages pass.

- [ ] **Step 5: Commit if any lint fixes were needed**

If step 1 required any fixes, commit them:

```bash
git add -p
git commit -m "fix(duskmoon_adaptive_scaffold): resolve analyzer findings"
```

If step 1 was clean, skip this step.
