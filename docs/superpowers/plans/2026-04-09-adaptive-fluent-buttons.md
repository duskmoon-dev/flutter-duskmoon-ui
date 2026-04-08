# Adaptive Fluent Buttons Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace Material fallbacks with native `fluent_ui` widgets in `DmButton` and `DmIconButton` when `DmPlatformStyle.fluent` is resolved.

**Architecture:** Add `fluent_ui` as a dependency to `duskmoon_widgets`. Create a `FluentTheme` bridge helper so Fluent widgets work without consumers needing to set up `FluentTheme` themselves. Update `DmButton` and `DmIconButton` to render native Fluent button types. Improve `DmButton` Cupertino rendering for the `filled` variant. `DmFab` keeps its existing Material fallback.

**Tech Stack:** Flutter, `fluent_ui ^4.9.0`, `duskmoon_widgets` package

---

## File Map

| File | Action | Responsibility |
| --- | --- | --- |
| `packages/duskmoon_widgets/pubspec.yaml` | Modify | Add `fluent_ui` dependency |
| `packages/duskmoon_widgets/lib/src/adaptive/fluent_theme_bridge.dart` | Create | `wrapWithFluentTheme()` helper |
| `packages/duskmoon_widgets/lib/duskmoon_widgets.dart` | Modify | Export `fluent_theme_bridge.dart` |
| `packages/duskmoon_widgets/lib/src/buttons/dm_button.dart` | Modify | Add `_buildFluent()`, fix Cupertino `filled` |
| `packages/duskmoon_widgets/lib/src/buttons/dm_icon_button.dart` | Modify | Add `_buildFluent()` |
| `packages/duskmoon_widgets/test/src/buttons/dm_button_test.dart` | Modify | Add Fluent test group |
| `packages/duskmoon_widgets/test/src/buttons/dm_icon_button_test.dart` | Modify | Add Fluent test group |
| `packages/duskmoon_widgets/test/src/buttons/dm_fab_test.dart` | Modify | Add Fluent fallback test group |

---

### Task 1: Add `fluent_ui` dependency

**Files:**
- Modify: `packages/duskmoon_widgets/pubspec.yaml`

- [ ] **Step 1: Add `fluent_ui` to dependencies**

In `packages/duskmoon_widgets/pubspec.yaml`, add `fluent_ui` under `dependencies` after `duskmoon_adaptive_scaffold`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  duskmoon_theme: ^1.4.0
  duskmoon_code_engine: ^1.4.0
  duskmoon_adaptive_scaffold: ^1.4.0
  fluent_ui: ^4.9.0
  markdown: ^7.3.1
  highlighting: ^0.9.0+11.8.0
  flutter_math_fork: ^0.7.4
  url_launcher: ^6.3.0
```

- [ ] **Step 2: Resolve dependencies**

Run: `cd packages/duskmoon_widgets && dart pub get`
Expected: Dependencies resolve successfully with no version conflicts.

- [ ] **Step 3: Commit**

```bash
git add packages/duskmoon_widgets/pubspec.yaml
git commit -m "feat(duskmoon_widgets): add fluent_ui dependency"
```

---

### Task 2: Create FluentTheme bridge helper

**Files:**
- Create: `packages/duskmoon_widgets/lib/src/adaptive/fluent_theme_bridge.dart`
- Modify: `packages/duskmoon_widgets/lib/duskmoon_widgets.dart`

- [ ] **Step 1: Create `fluent_theme_bridge.dart`**

Create file `packages/duskmoon_widgets/lib/src/adaptive/fluent_theme_bridge.dart`:

```dart
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/material.dart';

/// Wraps [child] in a [fluent.FluentTheme] derived from the nearest
/// Material [Theme], so that fluent_ui widgets render correctly without
/// requiring the consumer to set up a FluentTheme ancestor.
Widget wrapWithFluentTheme(BuildContext context, Widget child) {
  final colorScheme = Theme.of(context).colorScheme;
  final brightness = Theme.of(context).brightness;

  final primaryColor = colorScheme.primary;

  final fluentTheme = fluent.FluentThemeData(
    brightness: brightness,
    accentColor: fluent.AccentColor.swatch(<String, Color>{
      'darkest': Color.lerp(primaryColor, Colors.black, 0.3)!,
      'darker': Color.lerp(primaryColor, Colors.black, 0.2)!,
      'dark': Color.lerp(primaryColor, Colors.black, 0.1)!,
      'normal': primaryColor,
      'light': Color.lerp(primaryColor, Colors.white, 0.1)!,
      'lighter': Color.lerp(primaryColor, Colors.white, 0.2)!,
      'lightest': Color.lerp(primaryColor, Colors.white, 0.3)!,
    }),
    scaffoldBackgroundColor: colorScheme.surface,
  );

  return fluent.FluentTheme(
    data: fluentTheme,
    child: child,
  );
}
```

- [ ] **Step 2: Export the bridge from the barrel file**

In `packages/duskmoon_widgets/lib/duskmoon_widgets.dart`, add the export after the existing adaptive exports:

```dart
// Adaptive infrastructure
export 'src/adaptive/adaptive_widget.dart';
export 'src/adaptive/dm_platform_style.dart';
export 'src/adaptive/duskmoon_app.dart';
export 'src/adaptive/fluent_theme_bridge.dart';
export 'src/adaptive/platform_override.dart';
export 'src/adaptive/platform_resolver.dart';
```

- [ ] **Step 3: Verify it compiles**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos`
Expected: No errors or infos.

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/adaptive/fluent_theme_bridge.dart packages/duskmoon_widgets/lib/duskmoon_widgets.dart
git commit -m "feat(duskmoon_widgets): add FluentTheme bridge helper"
```

---

### Task 3: Update `DmButton` with Fluent and Cupertino improvements

**Files:**
- Modify: `packages/duskmoon_widgets/lib/src/buttons/dm_button.dart`
- Modify: `packages/duskmoon_widgets/test/src/buttons/dm_button_test.dart`

- [ ] **Step 1: Write failing tests for Fluent variants**

Add to `packages/duskmoon_widgets/test/src/buttons/dm_button_test.dart`:

```dart
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmButton', () {
    group('Material', () {
      testWidgets('filled variant renders FilledButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.filled,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(FilledButton), findsOneWidget);
      });

      testWidgets('outlined variant renders OutlinedButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.outlined,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(OutlinedButton), findsOneWidget);
      });
    });

    group('Cupertino', () {
      testWidgets('renders CupertinoButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(CupertinoButton), findsOneWidget);
      });

      testWidgets('filled variant renders CupertinoButton.filled',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.filled,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        final button =
            tester.widget<CupertinoButton>(find.byType(CupertinoButton));
        // CupertinoButton.filled sets a non-null color
        expect(button.color, isNotNull);
      });
    });

    group('Fluent', () {
      testWidgets('filled variant renders fluent FilledButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.filled,
                platformOverride: DmPlatformStyle.fluent,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(fluent.FilledButton), findsOneWidget);
      });

      testWidgets('outlined variant renders fluent OutlinedButton',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.outlined,
                platformOverride: DmPlatformStyle.fluent,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(fluent.OutlinedButton), findsOneWidget);
      });

      testWidgets('text variant renders fluent HyperlinkButton',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.text,
                platformOverride: DmPlatformStyle.fluent,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(fluent.HyperlinkButton), findsOneWidget);
      });

      testWidgets('tonal variant renders fluent Button', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmButton(
                onPressed: () {},
                variant: DmButtonVariant.tonal,
                platformOverride: DmPlatformStyle.fluent,
                child: const Text('Tap'),
              ),
            ),
          ),
        );
        expect(find.byType(fluent.Button), findsOneWidget);
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd packages/duskmoon_widgets && flutter test test/src/buttons/dm_button_test.dart`
Expected: Fluent tests FAIL (finding Material widgets instead of Fluent ones). Cupertino `filled` test may also fail.

- [ ] **Step 3: Update `dm_button.dart` implementation**

Replace `packages/duskmoon_widgets/lib/src/buttons/dm_button.dart` with:

```dart
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/fluent_theme_bridge.dart';
import '../adaptive/platform_resolver.dart';

/// Visual style variants for [DmButton].
enum DmButtonVariant {
  /// A solid filled button.
  filled,

  /// A button with an outline border.
  outlined,

  /// A plain text-only button.
  text,

  /// A tonally filled button using secondary container colors.
  tonal,
}

/// An adaptive button that renders Material, Cupertino, or Fluent styles.
class DmButton extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive button with the given [variant].
  const DmButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.variant = DmButtonVariant.filled,
    this.platformOverride,
  });

  /// Callback invoked when the button is tapped, or `null` to disable.
  final VoidCallback? onPressed;

  /// The button's content, typically a [Text] widget.
  final Widget child;

  /// The visual variant of the button.
  final DmButtonVariant variant;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => _buildMaterial(context),
      DmPlatformStyle.cupertino => _buildCupertino(context),
      DmPlatformStyle.fluent => _buildFluent(context),
    };
  }

  Widget _buildMaterial(BuildContext context) {
    return switch (variant) {
      DmButtonVariant.filled =>
        FilledButton(onPressed: onPressed, child: child),
      DmButtonVariant.outlined =>
        OutlinedButton(onPressed: onPressed, child: child),
      DmButtonVariant.text => TextButton(onPressed: onPressed, child: child),
      DmButtonVariant.tonal =>
        FilledButton.tonal(onPressed: onPressed, child: child),
    };
  }

  Widget _buildCupertino(BuildContext context) {
    return switch (variant) {
      DmButtonVariant.filled =>
        CupertinoButton.filled(onPressed: onPressed, child: child),
      _ => CupertinoButton(onPressed: onPressed, child: child),
    };
  }

  Widget _buildFluent(BuildContext context) {
    final fluentChild = switch (variant) {
      DmButtonVariant.filled =>
        fluent.FilledButton(onPressed: onPressed, child: child),
      DmButtonVariant.outlined =>
        fluent.OutlinedButton(onPressed: onPressed, child: child),
      DmButtonVariant.text =>
        fluent.HyperlinkButton(onPressed: onPressed, child: child),
      DmButtonVariant.tonal =>
        fluent.Button(onPressed: onPressed, child: child),
    };
    return wrapWithFluentTheme(context, fluentChild);
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd packages/duskmoon_widgets && flutter test test/src/buttons/dm_button_test.dart`
Expected: All tests PASS.

- [ ] **Step 5: Run analysis**

Run: `cd packages/duskmoon_widgets && dart analyze --fatal-infos`
Expected: No errors or infos.

- [ ] **Step 6: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/buttons/dm_button.dart packages/duskmoon_widgets/test/src/buttons/dm_button_test.dart
git commit -m "feat(duskmoon_widgets): add Fluent rendering to DmButton, improve Cupertino filled"
```

---

### Task 4: Update `DmIconButton` with Fluent rendering

**Files:**
- Modify: `packages/duskmoon_widgets/lib/src/buttons/dm_icon_button.dart`
- Modify: `packages/duskmoon_widgets/test/src/buttons/dm_icon_button_test.dart`

- [ ] **Step 1: Write failing test for Fluent rendering**

Replace `packages/duskmoon_widgets/test/src/buttons/dm_icon_button_test.dart` with:

```dart
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmIconButton', () {
    group('Material', () {
      testWidgets('renders IconButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmIconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ),
        );
        expect(find.byType(IconButton), findsOneWidget);
      });
    });

    group('Cupertino', () {
      testWidgets('renders CupertinoButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: Scaffold(
              body: DmIconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
              ),
            ),
          ),
        );
        expect(find.byType(CupertinoButton), findsOneWidget);
      });
    });

    group('Fluent', () {
      testWidgets('renders fluent IconButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmIconButton(
                icon: const Icon(Icons.add),
                onPressed: () {},
                platformOverride: DmPlatformStyle.fluent,
              ),
            ),
          ),
        );
        expect(find.byType(fluent.IconButton), findsOneWidget);
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify the Fluent test fails**

Run: `cd packages/duskmoon_widgets && flutter test test/src/buttons/dm_icon_button_test.dart`
Expected: Fluent test FAILS (finds Material `IconButton` instead).

- [ ] **Step 3: Update `dm_icon_button.dart` implementation**

Replace `packages/duskmoon_widgets/lib/src/buttons/dm_icon_button.dart` with:

```dart
import 'package:fluent_ui/fluent_ui.dart' as fluent;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../adaptive/adaptive_widget.dart';
import '../adaptive/fluent_theme_bridge.dart';
import '../adaptive/platform_resolver.dart';

/// An adaptive icon button that renders Material, Cupertino, or Fluent styles.
class DmIconButton extends StatelessWidget with AdaptiveWidget {
  /// Creates an adaptive icon button.
  const DmIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.platformOverride,
  });

  /// The icon widget to display.
  final Widget icon;

  /// Callback invoked when the button is tapped, or `null` to disable.
  final VoidCallback? onPressed;

  /// Optional tooltip text shown on long press (Material and Fluent).
  final String? tooltip;

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => IconButton(
          icon: icon,
          onPressed: onPressed,
          tooltip: tooltip,
        ),
      DmPlatformStyle.cupertino => CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: icon,
        ),
      DmPlatformStyle.fluent => wrapWithFluentTheme(
          context,
          fluent.IconButton(
            icon: icon,
            onPressed: onPressed,
          ),
        ),
    };
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd packages/duskmoon_widgets && flutter test test/src/buttons/dm_icon_button_test.dart`
Expected: All tests PASS.

- [ ] **Step 5: Commit**

```bash
git add packages/duskmoon_widgets/lib/src/buttons/dm_icon_button.dart packages/duskmoon_widgets/test/src/buttons/dm_icon_button_test.dart
git commit -m "feat(duskmoon_widgets): add Fluent rendering to DmIconButton"
```

---

### Task 5: Add Fluent fallback test for `DmFab`

**Files:**
- Modify: `packages/duskmoon_widgets/test/src/buttons/dm_fab_test.dart`

- [ ] **Step 1: Add Fluent fallback test**

Replace `packages/duskmoon_widgets/test/src/buttons/dm_fab_test.dart` with:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:duskmoon_widgets/duskmoon_widgets.dart';

void main() {
  group('DmFab', () {
    group('Material', () {
      testWidgets('renders FloatingActionButton', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmFab(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
          ),
        );
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });

      testWidgets('extended with icon and label', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: Scaffold(
              body: DmFab(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Create'),
              ),
            ),
          ),
        );
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.text('Create'), findsOneWidget);
        expect(find.byIcon(Icons.add), findsOneWidget);
      });
    });

    group('Fluent', () {
      testWidgets('falls back to Material FloatingActionButton',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: DmFab(
                onPressed: () {},
                platformOverride: DmPlatformStyle.fluent,
                child: const Icon(Icons.add),
              ),
            ),
          ),
        );
        expect(find.byType(FloatingActionButton), findsOneWidget);
      });
    });
  });
}
```

- [ ] **Step 2: Run tests to verify they pass**

Run: `cd packages/duskmoon_widgets && flutter test test/src/buttons/dm_fab_test.dart`
Expected: All tests PASS (no implementation change needed).

- [ ] **Step 3: Commit**

```bash
git add packages/duskmoon_widgets/test/src/buttons/dm_fab_test.dart
git commit -m "test(duskmoon_widgets): add Fluent fallback test for DmFab"
```

---

### Task 6: Final verification

- [ ] **Step 1: Run full test suite for duskmoon_widgets**

Run: `cd packages/duskmoon_widgets && flutter test`
Expected: All tests PASS.

- [ ] **Step 2: Run analysis across all packages**

Run: `melos run analyze`
Expected: No errors or infos in any package.

- [ ] **Step 3: Run format check**

Run: `melos run format`
Expected: All files formatted correctly.
