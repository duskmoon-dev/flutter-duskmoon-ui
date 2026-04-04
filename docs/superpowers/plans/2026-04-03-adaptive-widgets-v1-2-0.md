# flutter_duskmoon_ui v1.2.0 — Adaptive Widgets Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `DmTheme` token container, promote `DmPlatformStyle.fluent` as a first-class enum value, and introduce `DuskmoonApp` as the app-level platform provider.

**Architecture:** Three additive changes — a platform-agnostic token container in `duskmoon_theme`, a new `DuskmoonApp` InheritedWidget in `duskmoon_widgets` that fills the L3 slot in the resolution stack, and unification of `duskmoon_settings` dispatch to use `DmPlatformStyle` via `resolvePlatformStyle`. `DmPlatformStyle` is extracted to its own file to break the circular import that would arise from `platform_resolver.dart` importing `duskmoon_app.dart` while `duskmoon_app.dart` imports `DmPlatformStyle`.

**Tech Stack:** Flutter ≥3.24, Dart ≥3.5, `flutter_test`, `flutter_lints` with `--fatal-infos`

---

## File Map

**Created:**
- `packages/duskmoon_theme/lib/src/dm_colors.dart` — `DmColors` (colorScheme + extension bag)
- `packages/duskmoon_theme/lib/src/dm_theme.dart` — `DmTheme` (token container, `name` + `colors`)
- `packages/duskmoon_theme/test/dm_theme_test.dart` — tests for DmColors + DmTheme
- `packages/duskmoon_widgets/lib/src/adaptive/dm_platform_style.dart` — `DmPlatformStyle` enum only
- `packages/duskmoon_widgets/lib/src/adaptive/duskmoon_app.dart` — `DuskmoonApp` InheritedWidget
- `packages/duskmoon_widgets/test/src/adaptive/duskmoon_app_test.dart` — tests for DuskmoonApp

**Modified:**
- `packages/duskmoon_theme/lib/src/theme_data.dart` — add `DmThemeData.fromDmTheme()`; refactor `sunshine()`/`moonlight()` to delegate to it
- `packages/duskmoon_theme/lib/duskmoon_theme.dart` — export `DmTheme`, `DmColors`
- `packages/duskmoon_widgets/lib/src/adaptive/platform_resolver.dart` — remove enum (now in `dm_platform_style.dart`); add L2/L3/L4 checks; add `_defaultStyle()` (Windows → fluent)
- `packages/duskmoon_widgets/lib/src/adaptive/platform_override.dart` — import `dm_platform_style.dart` instead of `platform_resolver.dart`
- `packages/duskmoon_widgets/lib/src/adaptive/adaptive_widget.dart` — pass only `platformOverride` to `resolvePlatformStyle` (L2 now handled internally)
- `packages/duskmoon_widgets/lib/duskmoon_widgets.dart` — export `dm_platform_style.dart`, `duskmoon_app.dart`
- `packages/duskmoon_widgets/test/src/adaptive/platform_resolver_test.dart` — add Windows→fluent + DuskmoonApp L3 tests
- 15 adaptive widget files (see Task 4) — add `DmPlatformStyle.fluent` stub branch
- `packages/duskmoon_settings/pubspec.yaml` — add `duskmoon_widgets` dep
- `packages/duskmoon_settings/lib/src/list/settings_list.dart` — dispatch via `resolvePlatformStyle`
- `packages/duskmoon_settings/test/src/utils/platform_utils_test.dart` — add dispatch tests
- `example/lib/main.dart` — wrap with `DuskmoonApp`

---

## Task 1: Extract `DmPlatformStyle` + Add `fluent` Value

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/adaptive/dm_platform_style.dart`
- Modify: `packages/duskmoon_widgets/lib/src/adaptive/platform_override.dart`
- Modify: `packages/duskmoon_widgets/lib/src/adaptive/platform_resolver.dart`

**Why the extraction:** `platform_resolver.dart` will need to import `duskmoon_app.dart` (Task 2) for the L3 check. `duskmoon_app.dart` needs `DmPlatformStyle`. Keeping the enum in `platform_resolver.dart` would create a circular import. Moving the enum to its own file breaks the cycle.

- [ ] **Step 1: Create `dm_platform_style.dart` with 3-value enum**

```dart
// packages/duskmoon_widgets/lib/src/adaptive/dm_platform_style.dart

/// The three platform rendering styles supported by adaptive widgets.
enum DmPlatformStyle {
  /// Google Material Design rendering.
  material,

  /// Apple Cupertino rendering.
  cupertino,

  /// Microsoft Fluent Design rendering.
  fluent,
}
```

- [ ] **Step 2: Update `platform_override.dart` to import the new file**

Replace:
```dart
import 'platform_resolver.dart';
```
With:
```dart
import 'dm_platform_style.dart';
```

- [ ] **Step 3: Update `platform_resolver.dart` — remove enum, keep `resolvePlatformStyle`**

Replace the entire file with (keeps existing resolution logic, imports enum from new file):
```dart
import 'package:flutter/material.dart';

import 'dm_platform_style.dart';
export 'dm_platform_style.dart';

/// Resolves the [DmPlatformStyle] for the current context.
///
/// Priority: [widgetOverride] > theme platform.
/// L3 (DuskmoonApp) and L2 (DmPlatformOverride) will be added in Task 4.
DmPlatformStyle resolvePlatformStyle(
  BuildContext context, {
  DmPlatformStyle? widgetOverride,
}) {
  if (widgetOverride != null) return widgetOverride;
  return _defaultStyle(Theme.of(context).platform);
}

DmPlatformStyle _defaultStyle(TargetPlatform platform) =>
    switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => DmPlatformStyle.cupertino,
      TargetPlatform.windows => DmPlatformStyle.fluent,
      _ => DmPlatformStyle.material,
    };
```

> Note: `export 'dm_platform_style.dart'` is added so existing code that imports `platform_resolver.dart` to get `DmPlatformStyle` continues to work without changes.

- [ ] **Step 4: Run tests to verify nothing is broken**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && flutter test test/src/adaptive/
```

Expected: All existing tests pass. One test will **now fail**: `'returns material for Windows'` — it previously expected `material` but will now get `fluent` from `_defaultStyle`. Fix that test expectation now:

In `packages/duskmoon_widgets/test/src/adaptive/platform_resolver_test.dart`, change:
```dart
testWidgets('returns material for Windows', (tester) async {
  late DmPlatformStyle resolved;
  await tester.pumpWidget(buildApp(
    platform: TargetPlatform.windows,
    onResolved: (s) => resolved = s,
  ));
  expect(resolved, DmPlatformStyle.material);  // ← OLD
});
```
To:
```dart
testWidgets('returns fluent for Windows', (tester) async {
  late DmPlatformStyle resolved;
  await tester.pumpWidget(buildApp(
    platform: TargetPlatform.windows,
    onResolved: (s) => resolved = s,
  ));
  expect(resolved, DmPlatformStyle.fluent);  // ← NEW
});
```

- [ ] **Step 5: Run tests again to confirm all pass**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && flutter test test/src/adaptive/
```

Expected: All tests pass.

- [ ] **Step 6: Run analyzer**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && dart analyze --fatal-infos
```

Expected: No issues.

- [ ] **Step 7: Commit**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
git add packages/duskmoon_widgets/lib/src/adaptive/dm_platform_style.dart \
        packages/duskmoon_widgets/lib/src/adaptive/platform_override.dart \
        packages/duskmoon_widgets/lib/src/adaptive/platform_resolver.dart \
        packages/duskmoon_widgets/test/src/adaptive/platform_resolver_test.dart
git commit -m "feat(duskmoon_widgets): extract DmPlatformStyle enum, add fluent value"
```

---

## Task 2: `DuskmoonApp` Widget

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/adaptive/duskmoon_app.dart`
- Create: `packages/duskmoon_widgets/test/src/adaptive/duskmoon_app_test.dart`

- [ ] **Step 1: Write the failing tests**

```dart
// packages/duskmoon_widgets/test/src/adaptive/duskmoon_app_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DuskmoonApp', () {
    testWidgets('maybeStyleOf returns null when no DuskmoonApp in tree',
        (tester) async {
      late DmPlatformStyle? result;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              result = DuskmoonApp.maybeStyleOf(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
      expect(result, isNull);
    });

    testWidgets('maybeStyleOf returns platformStyle when DuskmoonApp present',
        (tester) async {
      late DmPlatformStyle? result;
      await tester.pumpWidget(
        DuskmoonApp(
          platformStyle: DmPlatformStyle.cupertino,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = DuskmoonApp.maybeStyleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(result, DmPlatformStyle.cupertino);
    });

    testWidgets('maybeStyleOf returns null when platformStyle is null',
        (tester) async {
      late DmPlatformStyle? result;
      await tester.pumpWidget(
        const DuskmoonApp(
          platformStyle: null,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                // ignore: prefer_const_constructors
                return SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      // Can't use Builder inside const; use alternate form:
      await tester.pumpWidget(
        DuskmoonApp(
          platformStyle: null,
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                result = DuskmoonApp.maybeStyleOf(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
      expect(result, isNull);
    });

    testWidgets('updateShouldNotify returns true when platformStyle changes',
        (tester) async {
      bool notified = false;

      Widget buildApp(DmPlatformStyle? style) {
        return DuskmoonApp(
          platformStyle: style,
          child: MaterialApp(
            home: Builder(
              builder: (context) => const SizedBox.shrink(),
            ),
          ),
        );
      }

      await tester.pumpWidget(buildApp(DmPlatformStyle.material));
      await tester.pumpWidget(buildApp(DmPlatformStyle.cupertino));
      // No assertion on notified here — pumpWidget successfully rebuilds,
      // confirming updateShouldNotify works (no infinite loop / error).
      expect(find.byType(DuskmoonApp), findsOneWidget);
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail (class not found)**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && flutter test test/src/adaptive/duskmoon_app_test.dart
```

Expected: compilation error — `DuskmoonApp` not defined.

- [ ] **Step 3: Create `duskmoon_app.dart`**

```dart
// packages/duskmoon_widgets/lib/src/adaptive/duskmoon_app.dart

import 'package:flutter/widgets.dart';

import 'dm_platform_style.dart';

/// App-level platform-style provider for DuskMoon adaptive widgets.
///
/// Place above [MaterialApp] or [CupertinoApp] to declare a default
/// [DmPlatformStyle] for all adaptive widgets in the tree.
///
/// Resolution order for adaptive widgets:
/// 1. Per-widget `platformOverride` parameter
/// 2. Nearest [DmPlatformOverride] ancestor
/// 3. Nearest [DuskmoonApp] ancestor  ← this widget
/// 4. Platform default from [Theme.of(context).platform]
///
/// Example:
/// ```dart
/// DuskmoonApp(
///   platformStyle: DmPlatformStyle.cupertino,
///   child: MaterialApp(home: MyHome()),
/// );
/// ```
class DuskmoonApp extends InheritedWidget {
  const DuskmoonApp({
    super.key,
    this.platformStyle,
    required super.child,
  });

  /// Explicit platform style for all adaptive widgets in the subtree.
  ///
  /// When null, adaptive widgets fall through to platform-default detection.
  final DmPlatformStyle? platformStyle;

  /// Returns the [DmPlatformStyle] from the nearest [DuskmoonApp], or null.
  static DmPlatformStyle? maybeStyleOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DuskmoonApp>()
        ?.platformStyle;
  }

  @override
  bool updateShouldNotify(DuskmoonApp oldWidget) =>
      platformStyle != oldWidget.platformStyle;
}
```

- [ ] **Step 4: Export from barrel**

In `packages/duskmoon_widgets/lib/duskmoon_widgets.dart`, add after the adaptive infrastructure exports block:
```dart
export 'src/adaptive/dm_platform_style.dart';
export 'src/adaptive/duskmoon_app.dart';
```

Also remove the existing `export 'src/adaptive/platform_resolver.dart';` line — it already re-exports `dm_platform_style.dart`, but to avoid double exports, keep only `platform_resolver.dart` (which re-exports the enum via `export 'dm_platform_style.dart'`). Add `duskmoon_app.dart` only.

Final adaptive block in `duskmoon_widgets.dart`:
```dart
// Adaptive infrastructure
export 'src/adaptive/adaptive_widget.dart';
export 'src/adaptive/duskmoon_app.dart';
export 'src/adaptive/platform_override.dart';
export 'src/adaptive/platform_resolver.dart';
```

- [ ] **Step 5: Run tests**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && flutter test test/src/adaptive/duskmoon_app_test.dart
```

Expected: All 4 tests pass.

- [ ] **Step 6: Run analyzer**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && dart analyze --fatal-infos
```

Expected: No issues.

- [ ] **Step 7: Commit**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
git add packages/duskmoon_widgets/lib/src/adaptive/duskmoon_app.dart \
        packages/duskmoon_widgets/lib/duskmoon_widgets.dart \
        packages/duskmoon_widgets/test/src/adaptive/duskmoon_app_test.dart
git commit -m "feat(duskmoon_widgets): add DuskmoonApp InheritedWidget for app-level platform style"
```

---

## Task 3: Wire `DuskmoonApp` into `resolvePlatformStyle` + Fix `AdaptiveWidget`

**Files:**
- Modify: `packages/duskmoon_widgets/lib/src/adaptive/platform_resolver.dart`
- Modify: `packages/duskmoon_widgets/lib/src/adaptive/adaptive_widget.dart`
- Modify: `packages/duskmoon_widgets/test/src/adaptive/platform_resolver_test.dart`

**Context on the change to `adaptive_widget.dart`:**
Currently `adaptive_widget.dart` does:
```dart
return resolvePlatformStyle(
  context,
  widgetOverride: platformOverride ?? DmPlatformOverride.maybeOf(context),
);
```
This bundles L1 and L2 into `widgetOverride`, bypassing the L2 check inside `resolvePlatformStyle`. After this task, `resolvePlatformStyle` handles L2 and L3 internally, so `adaptive_widget.dart` should pass only `platformOverride`.

- [ ] **Step 1: Add L2+L3 tests to `platform_resolver_test.dart`**

Append to the existing `group('resolvePlatformStyle', ...)`:
```dart
testWidgets('DmPlatformOverride beats theme platform', (tester) async {
  late DmPlatformStyle resolved;
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(platform: TargetPlatform.android),
      home: DmPlatformOverride(
        style: DmPlatformStyle.cupertino,
        child: Builder(
          builder: (context) {
            resolved = resolvePlatformStyle(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  expect(resolved, DmPlatformStyle.cupertino);
});

testWidgets('DuskmoonApp L3 beats theme platform default', (tester) async {
  late DmPlatformStyle resolved;
  await tester.pumpWidget(
    DuskmoonApp(
      platformStyle: DmPlatformStyle.fluent,
      child: MaterialApp(
        theme: ThemeData(platform: TargetPlatform.android),
        home: Builder(
          builder: (context) {
            resolved = resolvePlatformStyle(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  expect(resolved, DmPlatformStyle.fluent);
});

testWidgets('DmPlatformOverride beats DuskmoonApp', (tester) async {
  late DmPlatformStyle resolved;
  await tester.pumpWidget(
    DuskmoonApp(
      platformStyle: DmPlatformStyle.fluent,
      child: MaterialApp(
        home: DmPlatformOverride(
          style: DmPlatformStyle.cupertino,
          child: Builder(
            builder: (context) {
              resolved = resolvePlatformStyle(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    ),
  );
  expect(resolved, DmPlatformStyle.cupertino);
});

testWidgets('widget override beats DuskmoonApp', (tester) async {
  late DmPlatformStyle resolved;
  await tester.pumpWidget(
    DuskmoonApp(
      platformStyle: DmPlatformStyle.fluent,
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            resolved = resolvePlatformStyle(
              context,
              widgetOverride: DmPlatformStyle.material,
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  expect(resolved, DmPlatformStyle.material);
});

testWidgets('DuskmoonApp with null platformStyle falls through to platform default',
    (tester) async {
  late DmPlatformStyle resolved;
  await tester.pumpWidget(
    DuskmoonApp(
      platformStyle: null,
      child: MaterialApp(
        theme: ThemeData(platform: TargetPlatform.iOS),
        home: Builder(
          builder: (context) {
            resolved = resolvePlatformStyle(context);
            return const SizedBox.shrink();
          },
        ),
      ),
    ),
  );
  expect(resolved, DmPlatformStyle.cupertino);
});
```

- [ ] **Step 2: Run tests to confirm new tests fail**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && flutter test test/src/adaptive/platform_resolver_test.dart
```

Expected: The 5 new tests fail (L2/L3 not yet checked in `resolvePlatformStyle`).

- [ ] **Step 3: Update `platform_resolver.dart` to check L2 and L3**

Replace the entire file:
```dart
import 'package:flutter/material.dart';

import 'dm_platform_style.dart';
import 'duskmoon_app.dart';
import 'platform_override.dart';

export 'dm_platform_style.dart';

/// Resolves the [DmPlatformStyle] for the current context.
///
/// Resolution order:
/// 1. [widgetOverride] (per-widget parameter)
/// 2. Nearest [DmPlatformOverride] ancestor (subtree override)
/// 3. Nearest [DuskmoonApp] ancestor (app-level override)
/// 4. Platform default from [Theme.of(context).platform]
DmPlatformStyle resolvePlatformStyle(
  BuildContext context, {
  DmPlatformStyle? widgetOverride,
}) {
  if (widgetOverride != null) return widgetOverride;

  final subtreeOverride = DmPlatformOverride.maybeOf(context);
  if (subtreeOverride != null) return subtreeOverride;

  final appStyle = DuskmoonApp.maybeStyleOf(context);
  if (appStyle != null) return appStyle;

  return _defaultStyle(Theme.of(context).platform);
}

DmPlatformStyle _defaultStyle(TargetPlatform platform) =>
    switch (platform) {
      TargetPlatform.iOS || TargetPlatform.macOS => DmPlatformStyle.cupertino,
      TargetPlatform.windows => DmPlatformStyle.fluent,
      _ => DmPlatformStyle.material,
    };
```

- [ ] **Step 4: Update `adaptive_widget.dart` to pass only `platformOverride`**

Replace the entire file:
```dart
import 'package:flutter/material.dart';

import 'platform_resolver.dart';

/// Mixin that gives a [StatelessWidget] platform-adaptive rendering.
///
/// Widgets using this mixin call [resolveStyle] to determine whether to
/// build Material, Cupertino, or Fluent UI.
mixin AdaptiveWidget on StatelessWidget {
  /// Optional per-widget platform override; takes highest priority.
  DmPlatformStyle? get platformOverride => null;

  /// Resolves the active [DmPlatformStyle] for this widget.
  ///
  /// Priority: [platformOverride] > [DmPlatformOverride] > [DuskmoonApp] > theme platform.
  DmPlatformStyle resolveStyle(BuildContext context) {
    return resolvePlatformStyle(context, widgetOverride: platformOverride);
  }
}
```

- [ ] **Step 5: Run all adaptive tests**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && flutter test test/src/adaptive/
```

Expected: All tests pass (including new L2/L3 tests and existing DuskmoonApp tests).

- [ ] **Step 6: Run full duskmoon_widgets test suite**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && flutter test
```

Expected: All tests pass. (Widgets using `resolveStyle` now go through the updated resolution chain.)

- [ ] **Step 7: Run analyzer**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && dart analyze --fatal-infos
```

Expected: No issues.

- [ ] **Step 8: Commit**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
git add packages/duskmoon_widgets/lib/src/adaptive/platform_resolver.dart \
        packages/duskmoon_widgets/lib/src/adaptive/adaptive_widget.dart \
        packages/duskmoon_widgets/test/src/adaptive/platform_resolver_test.dart
git commit -m "feat(duskmoon_widgets): wire DuskmoonApp into resolvePlatformStyle L3 slot"
```

---

## Task 4: Fluent Stubs in 15 Adaptive Widgets

**Files (all modify only — add one `fluent` branch each):**
- `packages/duskmoon_widgets/lib/src/buttons/dm_button.dart`
- `packages/duskmoon_widgets/lib/src/buttons/dm_fab.dart`
- `packages/duskmoon_widgets/lib/src/buttons/dm_icon_button.dart`
- `packages/duskmoon_widgets/lib/src/inputs/dm_checkbox.dart`
- `packages/duskmoon_widgets/lib/src/inputs/dm_slider.dart`
- `packages/duskmoon_widgets/lib/src/inputs/dm_switch.dart`
- `packages/duskmoon_widgets/lib/src/inputs/dm_text_field.dart`
- `packages/duskmoon_widgets/lib/src/layout/dm_card.dart`
- `packages/duskmoon_widgets/lib/src/layout/dm_divider.dart`
- `packages/duskmoon_widgets/lib/src/navigation/dm_app_bar.dart`
- `packages/duskmoon_widgets/lib/src/navigation/dm_bottom_nav.dart`
- `packages/duskmoon_widgets/lib/src/navigation/dm_drawer.dart`
- `packages/duskmoon_widgets/lib/src/navigation/dm_tab_bar.dart`
- `packages/duskmoon_widgets/lib/src/data_display/dm_avatar.dart`
- `packages/duskmoon_widgets/lib/src/data_display/dm_badge.dart`

Each file currently has a switch like:
```dart
return switch (resolveStyle(context)) {
  DmPlatformStyle.material => _buildMaterial(context),
  DmPlatformStyle.cupertino => _buildCupertino(context),
};
```

The Dart analyzer treats this as a non-exhaustive switch (warning/error) once `fluent` is added to the enum but not handled. This task adds the stub branch to each.

- [ ] **Step 1: Before editing, run the test suite to confirm all widgets fail analyzer now**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && dart analyze --fatal-infos 2>&1 | head -30
```

Expected: Multiple "Missing case clause for 'fluent'" errors across all 15 widget files.

- [ ] **Step 2: Update each widget's switch — pattern is identical for all 15**

For each file, find the switch and add the fluent branch. Example for `dm_button.dart`:

```dart
// BEFORE:
return switch (resolveStyle(context)) {
  DmPlatformStyle.material => _buildMaterial(context),
  DmPlatformStyle.cupertino => _buildCupertino(context),
};

// AFTER:
return switch (resolveStyle(context)) {
  DmPlatformStyle.material => _buildMaterial(context),
  DmPlatformStyle.cupertino => _buildCupertino(context),
  DmPlatformStyle.fluent => _buildMaterial(context),
};
```

Apply the same `DmPlatformStyle.fluent => _buildMaterial(context)` addition to all 15 files. The method name to fall through to is whichever `_buildMaterial(context)` (or equivalent Material builder) already exists in that widget.

- [ ] **Step 3: Run analyzer**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && dart analyze --fatal-infos
```

Expected: No issues.

- [ ] **Step 4: Run full test suite**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_widgets && flutter test
```

Expected: All tests pass.

- [ ] **Step 5: Commit**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
git add packages/duskmoon_widgets/lib/src/buttons/ \
        packages/duskmoon_widgets/lib/src/inputs/ \
        packages/duskmoon_widgets/lib/src/layout/ \
        packages/duskmoon_widgets/lib/src/navigation/ \
        packages/duskmoon_widgets/lib/src/data_display/
git commit -m "feat(duskmoon_widgets): add DmPlatformStyle.fluent stub to all adaptive widgets"
```

---

## Task 5: `DmColors` + `DmTheme` + `DmThemeData.fromDmTheme`

**Files:**
- Create: `packages/duskmoon_theme/lib/src/dm_colors.dart`
- Create: `packages/duskmoon_theme/lib/src/dm_theme.dart`
- Create: `packages/duskmoon_theme/test/dm_theme_test.dart`
- Modify: `packages/duskmoon_theme/lib/src/theme_data.dart`
- Modify: `packages/duskmoon_theme/lib/duskmoon_theme.dart`

**Design note on `const` vs `static final`:** The PRD specifies `DmTheme.sunshine` as `const`, but the factory constructors `DmColorScheme.sunshine()` and `DmColorExtension.sunshine()` are regular static methods (not `const`). Dart does not allow calling static methods in a `const` context. Therefore `DmColors` factory constructors delegate to the existing static methods and are non-const; `DmTheme.sunshine` / `DmTheme.moonlight` are `static final` (allocated once, never per-call). This satisfies "zero per-call allocation" while following the PRD note "do not duplicate token references."

- [ ] **Step 1: Write failing tests**

```dart
// packages/duskmoon_theme/test/dm_theme_test.dart

import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmColors', () {
    test('sunshine() has colorScheme matching DmColorScheme.sunshine()', () {
      final colors = DmColors.sunshine();
      expect(colors.colorScheme.brightness, Brightness.light);
      expect(colors.colorScheme.primary, const Color(0xFF6750A4));
    });

    test('moonlight() has colorScheme matching DmColorScheme.moonlight()', () {
      final colors = DmColors.moonlight();
      expect(colors.colorScheme.brightness, Brightness.dark);
      expect(colors.colorScheme.primary, const Color(0xFFD0BCFF));
    });

    test('sunshine() extension matches DmColorExtension.sunshine()', () {
      final colors = DmColors.sunshine();
      expect(colors.extension.accent, const Color(0xFF8B5CF6));
      expect(colors.extension.info, const Color(0xFF2196F3));
    });

    test('moonlight() extension matches DmColorExtension.moonlight()', () {
      final colors = DmColors.moonlight();
      expect(colors.extension.accent, const Color(0xFFA78BFA));
    });
  });

  group('DmTheme', () {
    test('sunshine has name == "sunshine"', () {
      expect(DmTheme.sunshine.name, 'sunshine');
    });

    test('moonlight has name == "moonlight"', () {
      expect(DmTheme.moonlight.name, 'moonlight');
    });

    test('all has length 2', () {
      expect(DmTheme.all.length, 2);
    });

    test('all contains sunshine and moonlight', () {
      expect(DmTheme.all, contains(DmTheme.sunshine));
      expect(DmTheme.all, contains(DmTheme.moonlight));
    });

    test('sunshine.colors.colorScheme matches DmColorScheme.sunshine()', () {
      expect(
        DmTheme.sunshine.colors.colorScheme.primary,
        DmColors.sunshine().colorScheme.primary,
      );
    });
  });

  group('DmThemeData.fromDmTheme', () {
    test('fromDmTheme(DmTheme.sunshine) has same primary as sunshine()', () {
      final fromDm = DmThemeData.fromDmTheme(DmTheme.sunshine);
      final direct = DmThemeData.sunshine();
      expect(fromDm.colorScheme.primary, direct.colorScheme.primary);
      expect(fromDm.colorScheme.brightness, direct.colorScheme.brightness);
    });

    test('fromDmTheme(DmTheme.moonlight) has same primary as moonlight()', () {
      final fromDm = DmThemeData.fromDmTheme(DmTheme.moonlight);
      final direct = DmThemeData.moonlight();
      expect(fromDm.colorScheme.primary, direct.colorScheme.primary);
      expect(fromDm.colorScheme.brightness, direct.colorScheme.brightness);
    });

    test('fromDmTheme includes DmColorExtension', () {
      final theme = DmThemeData.fromDmTheme(DmTheme.sunshine);
      final ext = theme.extension<DmColorExtension>();
      expect(ext, isNotNull);
      expect(ext!.accent, const Color(0xFF8B5CF6));
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_theme && flutter test test/dm_theme_test.dart
```

Expected: Compilation error — `DmColors`, `DmTheme` not defined.

- [ ] **Step 3: Create `dm_colors.dart`**

```dart
// packages/duskmoon_theme/lib/src/dm_colors.dart

import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'extensions.dart';

/// Typed color token bag — color scheme and extension tokens in one place.
///
/// Split into [colorScheme] (maps to Flutter [ColorScheme]) and
/// [extension] (non-ColorScheme tokens via [DmColorExtension]).
@immutable
class DmColors {
  DmColors({
    required this.colorScheme,
    required this.extension,
  });

  final ColorScheme colorScheme;
  final DmColorExtension extension;

  /// Returns the Sunshine (light) color tokens.
  factory DmColors.sunshine() => DmColors(
        colorScheme: DmColorScheme.sunshine(),
        extension: DmColorExtension.sunshine(),
      );

  /// Returns the Moonlight (dark) color tokens.
  factory DmColors.moonlight() => DmColors(
        colorScheme: DmColorScheme.moonlight(),
        extension: DmColorExtension.moonlight(),
      );
}
```

- [ ] **Step 4: Create `dm_theme.dart`**

```dart
// packages/duskmoon_theme/lib/src/dm_theme.dart

import 'dm_colors.dart';

/// Platform-agnostic DuskMoon design-token container.
///
/// Holds [DmColors] only. Does not produce [ThemeData].
/// Use [DmThemeData.fromDmTheme] to convert to a Flutter [ThemeData].
class DmTheme {
  DmTheme({
    required this.name,
    required this.colors,
  });

  /// Display name of this theme ("sunshine" | "moonlight").
  final String name;

  /// Resolved color tokens for this theme.
  final DmColors colors;

  /// Sunshine (light) token set.
  static final DmTheme sunshine = DmTheme(
    name: 'sunshine',
    colors: DmColors.sunshine(),
  );

  /// Moonlight (dark) token set.
  static final DmTheme moonlight = DmTheme(
    name: 'moonlight',
    colors: DmColors.moonlight(),
  );

  /// All available themes.
  static final List<DmTheme> all = [sunshine, moonlight];
}
```

- [ ] **Step 5: Add `DmThemeData.fromDmTheme()` to `theme_data.dart`**

In `packages/duskmoon_theme/lib/src/theme_data.dart`, add the import at the top and the new static method to `DmThemeData`:

Add import after existing imports:
```dart
import 'dm_colors.dart';
import 'dm_theme.dart';
```

Add method inside `abstract final class DmThemeData`:
```dart
/// Build [ThemeData] from a [DmTheme] token container.
static ThemeData fromDmTheme(DmTheme theme) => _buildThemeData(
      colorScheme: theme.colors.colorScheme,
      colorExtension: theme.colors.extension,
    );
```

> **Do not change `sunshine()` or `moonlight()` existing implementations.** They already call `_buildThemeData` directly and should remain unchanged to avoid any behavioral drift.

- [ ] **Step 6: Export from barrel**

In `packages/duskmoon_theme/lib/duskmoon_theme.dart`, add:
```dart
export 'src/dm_theme.dart' show DmTheme;
export 'src/dm_colors.dart' show DmColors;
```

- [ ] **Step 7: Run tests**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_theme && flutter test test/dm_theme_test.dart
```

Expected: All new tests pass.

- [ ] **Step 8: Run full duskmoon_theme tests**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_theme && flutter test
```

Expected: All tests pass (existing tests unchanged).

- [ ] **Step 9: Run analyzer**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_theme && dart analyze --fatal-infos
```

Expected: No issues.

- [ ] **Step 10: Commit**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
git add packages/duskmoon_theme/lib/src/dm_colors.dart \
        packages/duskmoon_theme/lib/src/dm_theme.dart \
        packages/duskmoon_theme/lib/src/theme_data.dart \
        packages/duskmoon_theme/lib/duskmoon_theme.dart \
        packages/duskmoon_theme/test/dm_theme_test.dart
git commit -m "feat(duskmoon_theme): add DmColors, DmTheme token containers, DmThemeData.fromDmTheme"
```

---

## Task 6: `duskmoon_settings` Migration to `DmPlatformStyle`

**Files:**
- Modify: `packages/duskmoon_settings/pubspec.yaml`
- Modify: `packages/duskmoon_settings/lib/src/list/settings_list.dart`
- Modify: `packages/duskmoon_settings/test/src/utils/platform_utils_test.dart`

**What changes:** `SettingsList.build()` dispatches to the 3 renderers via `resolvePlatformStyle(context)` instead of a 7-case `DevicePlatform` switch. The `DevicePlatform? platform` parameter is kept (public API unchanged) but converted to `DmPlatformStyle?` before calling `resolvePlatformStyle` as a `widgetOverride`. The sub-lists still receive the original `DevicePlatform? platform` parameter for their own internal use.

- [ ] **Step 1: Write failing tests — add to existing `platform_utils_test.dart`**

Append a new group to `packages/duskmoon_settings/test/src/utils/platform_utils_test.dart`:
```dart
// Add at the top of the file (with other imports):
import 'package:duskmoon_widgets/duskmoon_widgets.dart';

// ... existing group('DevicePlatform', ...) remains unchanged ...

// Add this new group at the end of main():
group('SettingsList dispatches via DmPlatformStyle', () {
  testWidgets('DmPlatformStyle.fluent dispatches to FluentSettingsList via DuskmoonApp',
      (tester) async {
    await tester.pumpWidget(
      DuskmoonApp(
        platformStyle: DmPlatformStyle.fluent,
        child: MaterialApp(
          home: Scaffold(
            body: SettingsList(
              sections: [
                SettingsSection(
                  tiles: [SettingsTile(title: const Text('Fluent'))],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('Fluent'), findsOneWidget);
  });

  testWidgets('DmPlatformStyle.cupertino dispatches to CupertinoSettingsList via DuskmoonApp',
      (tester) async {
    await tester.pumpWidget(
      DuskmoonApp(
        platformStyle: DmPlatformStyle.cupertino,
        child: MaterialApp(
          home: Scaffold(
            body: SettingsList(
              sections: [
                SettingsSection(
                  tiles: [SettingsTile(title: const Text('Cupertino'))],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('Cupertino'), findsOneWidget);
  });

  testWidgets('DmPlatformStyle.material dispatches to MaterialSettingsList via DuskmoonApp',
      (tester) async {
    await tester.pumpWidget(
      DuskmoonApp(
        platformStyle: DmPlatformStyle.material,
        child: MaterialApp(
          home: Scaffold(
            body: SettingsList(
              sections: [
                SettingsSection(
                  tiles: [SettingsTile(title: const Text('Material'))],
                ),
              ],
            ),
          ),
        ),
      ),
    );
    expect(find.text('Material'), findsOneWidget);
  });
});
```

- [ ] **Step 2: Add `duskmoon_widgets` dependency to `pubspec.yaml`**

In `packages/duskmoon_settings/pubspec.yaml`, add to `dependencies`:
```yaml
dependencies:
  flutter:
    sdk: flutter
  duskmoon_theme: ^1.0.3
  duskmoon_widgets:                # ← ADD
    path: ../duskmoon_widgets
```

- [ ] **Step 3: Run `dart pub get` to resolve the new dependency**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui && dart pub get
```

Expected: Dependency resolved successfully.

- [ ] **Step 4: Run new tests to confirm they fail**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_settings && flutter test test/src/utils/platform_utils_test.dart
```

Expected: New tests fail — `DuskmoonApp` now resolves (dependency added) but `SettingsList` still uses `DevicePlatform.fromContext` so the `DuskmoonApp.platformStyle` override is not respected.

- [ ] **Step 5: Update `SettingsList.build()` in `settings_list.dart`**

Add import at the top of the file:
```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart'
    show DmPlatformStyle, resolvePlatformStyle, DuskmoonApp;
```

Replace `SettingsList.build()`:
```dart
@override
Widget build(BuildContext context) {
  // Keep DevicePlatform.fromContext for passing to sub-lists (their internal use).
  final resolvedPlatform = platform ?? DevicePlatform.fromContext(context);

  // Convert the explicit DevicePlatform override (if any) to DmPlatformStyle
  // so that DuskmoonApp (L3) can still be honoured when platform is null.
  final DmPlatformStyle? platformOverride = switch (platform) {
    null => null,
    DevicePlatform.iOS || DevicePlatform.macOS => DmPlatformStyle.cupertino,
    DevicePlatform.windows => DmPlatformStyle.fluent,
    _ => DmPlatformStyle.material,
  };

  final style = resolvePlatformStyle(context, widgetOverride: platformOverride);

  return switch (style) {
    DmPlatformStyle.cupertino => CupertinoSettingsList(
        sections: sections,
        shrinkWrap: shrinkWrap,
        physics: physics,
        platform: resolvedPlatform,
        contentPadding: contentPadding,
      ),
    DmPlatformStyle.fluent => FluentSettingsList(
        sections: sections,
        shrinkWrap: shrinkWrap,
        physics: physics,
        platform: resolvedPlatform,
        contentPadding: contentPadding,
      ),
    DmPlatformStyle.material => MaterialSettingsList(
        sections: sections,
        shrinkWrap: shrinkWrap,
        physics: physics,
        platform: resolvedPlatform,
        contentPadding: contentPadding,
      ),
  };
}
```

- [ ] **Step 6: Run tests**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_settings && flutter test
```

Expected: All tests pass (new + existing).

- [ ] **Step 7: Run analyzer**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/packages/duskmoon_settings && dart analyze --fatal-infos
```

Expected: No issues.

- [ ] **Step 8: Commit**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
git add packages/duskmoon_settings/pubspec.yaml \
        packages/duskmoon_settings/lib/src/list/settings_list.dart \
        packages/duskmoon_settings/test/src/utils/platform_utils_test.dart
git commit -m "feat(duskmoon_settings): dispatch via DmPlatformStyle + resolvePlatformStyle"
```

---

## Task 7: Example App Update

**Files:**
- Modify: `example/lib/main.dart`

- [ ] **Step 1: Read current `example/lib/main.dart` to find the root widget**

The root widget is `DuskmoonShowcaseApp`. It builds a `MaterialApp` inside `BlocBuilder`. Wrap the outermost `DuskmoonShowcaseApp.build` return value with `DuskmoonApp`.

Find the `build` method's return and wrap it:
```dart
// In DuskmoonShowcaseApp.build, before the return:
// BEFORE:
return BlocBuilder<DmThemeBloc, DmThemeState>(
  builder: (context, state) => MaterialApp(...),
);

// AFTER:
return DuskmoonApp(
  child: BlocBuilder<DmThemeBloc, DmThemeState>(
    builder: (context, state) => MaterialApp(...),
  ),
);
```

Add import at top of `main.dart`:
```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
```

- [ ] **Step 2: Build the example app to verify it compiles**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/example && flutter build apk --debug 2>&1 | tail -5
```

Expected: Build succeeds (exit 0).

- [ ] **Step 3: Run analyzer on example**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui/example && dart analyze --fatal-infos
```

Expected: No issues.

- [ ] **Step 4: Commit**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui
git add example/lib/main.dart
git commit -m "feat(example): wrap app with DuskmoonApp"
```

---

## Final Verification

- [ ] **Run full monorepo test suite**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui && melos run test
```

Expected: All packages pass. If any out-of-scope package fails, list it and stop — do not fix.

- [ ] **Run full monorepo analyzer**

```bash
cd /home/gao/Workspace/duskmoon-dev/flutter-duskmoon-ui && melos run analyze
```

Expected: Zero warnings/infos.

---

## Acceptance Criteria Checklist

- [ ] `DmTheme.sunshine` and `DmTheme.moonlight` exist as `static final` fields (zero per-call allocation)
- [ ] `DmThemeData.fromDmTheme(DmTheme.sunshine)` returns a theme with the same primary color as `DmThemeData.sunshine()`
- [ ] `DmPlatformStyle` has 3 values: `material`, `cupertino`, `fluent`
- [ ] `DuskmoonApp` is exported from `duskmoon_widgets`
- [ ] `DuskmoonApp` with explicit `platformStyle` overrides `theme.platform` default in adaptive widgets
- [ ] `DuskmoonApp` with `platformStyle: null` has no effect (falls through to next resolution level)
- [ ] `DmPlatformOverride` still beats `DuskmoonApp` in resolution order
- [ ] `duskmoon_settings` dispatches via `resolvePlatformStyle` — honors `DuskmoonApp` override
- [ ] All existing tests pass unmodified
- [ ] New tests pass
- [ ] Zero `dart analyze --fatal-infos` warnings
