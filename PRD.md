# PRD: flutter_duskmoon_ui — Flutter Component Library

> **Version**: 1.1.0
> **Date**: 2026-03-28
> **Status**: Draft — Awaiting Review
> **Depends on**: `@duskmoon-dev/design` (PRD 1 — codegen Dart output)
> **Migration source**: `gsmlg-app/flutter-app-template` (widgets, settings, feedback only — themes are dropped)

---

## 1. Overview

### Problem

DuskMoonUI has no Flutter presence. Meanwhile, `gsmlg-app/flutter-app-template` contains production-quality adaptive widgets, a 3-platform settings UI, and feedback helpers — but they're tightly coupled to a specific app template rather than published as a reusable library.

### Solution

Extract widgets, settings, and feedback from `flutter-app-template` into a **melos-managed Flutter monorepo** with DuskMoon theming. The template's own theme system (Violet/Green/Fire/Wheat, `DynamicTheme.fromSeed`) is **not migrated** — `duskmoon_theme` is purely codegen-driven from `@duskmoon-dev/design` YAML tokens.

| Package | Source | Description |
|---|---|---|
| `duskmoon_theme` | Codegen only (no template code) | Pure ColorScheme + ThemeData + ThemeExtension from generated tokens |
| `duskmoon_theme_bloc` | `app_bloc/theme` (refactored) | BLoC for theme name + mode persistence — separate from core theme |
| `duskmoon_widgets` | `app_widget/adaptive` + new | Adaptive scaffold, action list, buttons, inputs, cards, navigation |
| `duskmoon_settings` | `third_party/settings_ui` | Settings list/section/tile with Material/Cupertino/Fluent rendering |
| `duskmoon_feedback` | `app_widget/feedback` | Dialog, snackbar, toast, bottom sheet — already adaptive |
| `duskmoon_ui` | — | Umbrella package re-exporting all above |

### What Migrates vs. What's Dropped

| Template Package | Action | Reason |
|---|---|---|
| `app_lib/theme` | **Dropped** | Violet/Green/Fire/Wheat color schemes replaced by codegen Sunshine/Moonlight |
| `app_lib/theme/extension.dart` | **Migrate** `ThemeModeExtension` only | Useful utility, no color dependency |
| `app_bloc/theme` | **Refactor** → `duskmoon_theme_bloc` | Decouple from specific `AppTheme`; operate on theme name strings |
| `app_widget/adaptive` | **Migrate** → `duskmoon_widgets` | Rename `App*` → `Dm*` |
| `app_widget/feedback` | **Migrate** → `duskmoon_feedback` | Rename, decouple `app_locale` |
| `third_party/settings_ui` | **Migrate** → `duskmoon_settings` | Rename package, unify platform enum |
| `third_party/flutter_adaptive_scaffold` | **Dependency** | Used by `duskmoon_widgets` |

---

## 2. Monorepo Structure

```
flutter_duskmoon_ui/                  # Git root — duskmoon-dev/flutter_duskmoon_ui
├── melos.yaml
├── analysis_options.yaml
├── pubspec.yaml                      # Dart workspace root
│
├── packages/
│   ├── duskmoon_theme/               # Pure theme — codegen only, zero bloc deps
│   │   ├── lib/
│   │   │   ├── duskmoon_theme.dart
│   │   │   └── src/
│   │   │       ├── generated/        # ← codegen Dart output
│   │   │       │   ├── sunshine_tokens.g.dart
│   │   │       │   └── moonlight_tokens.g.dart
│   │   │       ├── color_scheme.dart  # DmColorScheme.sunshine() / .moonlight()
│   │   │       ├── theme_data.dart    # DmThemeData.sunshine() / .moonlight()
│   │   │       ├── text_theme.dart    # DmTextTheme
│   │   │       ├── extensions.dart    # DmColorExtension (non-ColorScheme tokens)
│   │   │       └── theme_mode_extension.dart
│   │   ├── test/
│   │   └── pubspec.yaml              # Depends on: flutter only
│   │
│   ├── duskmoon_theme_bloc/          # Optional BLoC for theme persistence
│   │   ├── lib/
│   │   │   ├── duskmoon_theme_bloc.dart
│   │   │   └── src/
│   │   │       ├── bloc.dart
│   │   │       ├── event.dart
│   │   │       └── state.dart
│   │   ├── test/
│   │   └── pubspec.yaml              # Depends on: duskmoon_theme, bloc, shared_preferences
│   │
│   ├── duskmoon_widgets/             # Adaptive widget library
│   │   ├── lib/
│   │   │   ├── duskmoon_widgets.dart
│   │   │   └── src/
│   │   │       ├── adaptive/
│   │   │       │   ├── platform_resolver.dart
│   │   │       │   ├── platform_override.dart
│   │   │       │   └── adaptive_widget.dart
│   │   │       ├── scaffold/         # ← from app_widget/adaptive
│   │   │       │   ├── dm_scaffold.dart
│   │   │       │   └── dm_action_list.dart
│   │   │       ├── buttons/
│   │   │       │   ├── dm_button.dart
│   │   │       │   ├── dm_icon_button.dart
│   │   │       │   └── dm_fab.dart
│   │   │       ├── inputs/
│   │   │       │   ├── dm_text_field.dart
│   │   │       │   ├── dm_checkbox.dart
│   │   │       │   ├── dm_switch.dart
│   │   │       │   └── dm_slider.dart
│   │   │       ├── layout/
│   │   │       │   ├── dm_card.dart
│   │   │       │   └── dm_divider.dart
│   │   │       ├── navigation/
│   │   │       │   ├── dm_app_bar.dart
│   │   │       │   ├── dm_bottom_nav.dart
│   │   │       │   ├── dm_tab_bar.dart
│   │   │       │   └── dm_drawer.dart
│   │   │       └── data_display/
│   │   │           ├── dm_badge.dart
│   │   │           ├── dm_chip.dart
│   │   │           └── dm_avatar.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── duskmoon_settings/            # ← from third_party/settings_ui
│   │   ├── lib/
│   │   │   ├── duskmoon_settings.dart
│   │   │   └── src/
│   │   │       ├── list/
│   │   │       │   ├── settings_list.dart
│   │   │       │   └── platforms/
│   │   │       ├── sections/
│   │   │       │   ├── settings_section.dart
│   │   │       │   └── platforms/
│   │   │       ├── tiles/
│   │   │       │   ├── settings_tile.dart
│   │   │       │   ├── platforms/
│   │   │       │   ├── input/
│   │   │       │   ├── slider/
│   │   │       │   ├── select/
│   │   │       │   ├── textarea/
│   │   │       │   ├── radio_group/
│   │   │       │   └── checkbox_group/
│   │   │       └── utils/
│   │   │           ├── platform_utils.dart
│   │   │           ├── settings_option.dart
│   │   │           └── settings_theme.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── duskmoon_feedback/            # ← from app_widget/feedback
│   │   ├── lib/
│   │   │   ├── duskmoon_feedback.dart
│   │   │   └── src/
│   │   │       ├── dialog.dart
│   │   │       ├── snackbar.dart
│   │   │       ├── toast.dart
│   │   │       ├── bottom_sheet.dart
│   │   │       └── fullscreen_dialog.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   └── duskmoon_ui/                  # Umbrella — re-exports all
│       ├── lib/duskmoon_ui.dart
│       ├── pubspec.yaml
│       └── README.md
│
├── example/                          # Showcase app
│   ├── lib/
│   │   ├── main.dart
│   │   └── pages/
│   │       ├── theme_page.dart
│   │       ├── button_page.dart
│   │       ├── settings_page.dart
│   │       ├── feedback_page.dart
│   │       └── scaffold_page.dart
│   └── pubspec.yaml
│
└── .github/workflows/
    ├── ci.yaml
    └── codegen.yaml
```

---

## 3. Package Details

### 3.1 duskmoon_theme

**Source**: Generated Dart tokens only. No code from `flutter-app-template`.
**Dependencies**: `flutter` SDK only — zero external packages.

#### Public API

```dart
library duskmoon_theme;

// Theme factories
export 'src/theme_data.dart' show DmThemeData, DmThemeEntry;
export 'src/color_scheme.dart' show DmColorScheme;
export 'src/text_theme.dart' show DmTextTheme;

// Extensions
export 'src/extensions.dart' show DmColorExtension;
export 'src/theme_mode_extension.dart' show ThemeModeExtension;

// Generated tokens (direct access)
export 'src/generated/sunshine_tokens.g.dart' show SunshineTokens;
export 'src/generated/moonlight_tokens.g.dart' show MoonlightTokens;
```

#### DmThemeData

No `fromSeed`, no runtime custom themes. Only codegen themes.

```dart
abstract class DmThemeData {
  /// Sunshine (light) theme from codegen tokens.
  static ThemeData sunshine();

  /// Moonlight (dark) theme from codegen tokens.
  static ThemeData moonlight();

  /// All codegen themes as a list (for pickers in settings UI).
  static List<DmThemeEntry> get themes;
}

@immutable
class DmThemeEntry {
  final String name;        // "sunshine" | "moonlight"
  final ThemeData light;    // For themes with mode: light
  final ThemeData dark;     // For themes with mode: dark
}
```

Internal `_buildThemeData` mirrors the template's pattern for `NavigationRail`/`AppBar` styling, but colors come exclusively from generated token classes.

#### Token → ColorScheme Mapping

```
DuskMoon Token              Flutter ColorScheme
─────────────────────────── ─────────────────────
primary                     primary
primary-content             onPrimary
primary-container           primaryContainer
on-primary-container        onPrimaryContainer
secondary                   secondary
secondary-content           onSecondary
secondary-container         secondaryContainer
on-secondary-container      onSecondaryContainer
tertiary                    tertiary
tertiary-content            onTertiary
tertiary-container          tertiaryContainer
on-tertiary-container       onTertiaryContainer
surface                     surface
surface-container-*         surfaceContainer*
surface-dim                 surfaceDim
surface-bright              surfaceBright
on-surface                  onSurface
on-surface-variant          onSurfaceVariant
outline                     outline
outline-variant             outlineVariant
inverse-surface             inverseSurface
inverse-on-surface          onInverseSurface
inverse-primary             inversePrimary
shadow                      shadow
scrim                       scrim
error                       error
error-content               onError
error-container             errorContainer
on-error-container          onErrorContainer
```

#### DmColorExtension (non-ColorScheme tokens)

```dart
@immutable
class DmColorExtension extends ThemeExtension<DmColorExtension> {
  const DmColorExtension({
    required this.primaryFocus,
    required this.secondaryFocus,
    required this.tertiaryFocus,
    required this.accent,
    required this.accentFocus,
    required this.accentContent,
    required this.neutral,
    required this.neutralFocus,
    required this.neutralContent,
    required this.neutralVariant,
    required this.info,
    required this.infoContent,
    required this.success,
    required this.successContent,
    required this.warning,
    required this.warningContent,
    required this.base100,
    required this.base200,
    required this.base300,
    required this.baseContent,
  });
  // ... fields, copyWith, lerp
}
```

#### ThemeModeExtension (migrated utility)

```dart
/// Convenience extension on ThemeMode.
/// Migrated from app_lib/theme/extension.dart.
extension ThemeModeExtension on ThemeMode {
  static ThemeMode fromString(String? name);
  String get title;       // "System" | "Light" | "Dark"
  Widget get icon;        // Icons.brightness_auto | light_mode | dark_mode
  Widget get iconOutlined;
}
```

#### pubspec.yaml

```yaml
name: duskmoon_theme
description: DuskMoon Design System theme for Flutter — codegen-driven, zero dependencies
version: 0.1.0
publish_to: none

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

---

### 3.2 duskmoon_theme_bloc

**Source**: Refactored from `app_bloc/theme`.
**Key change**: Operates on theme name strings instead of `AppTheme` class. Looks up `DmThemeData.themes` by name.

#### Public API

```dart
library duskmoon_theme_bloc;

export 'src/bloc.dart' show DmThemeBloc;
export 'src/event.dart' show DmThemeEvent, DmSetTheme, DmSetThemeMode;
export 'src/state.dart' show DmThemeState;
```

#### DmThemeState

```dart
class DmThemeState extends Equatable {
  const DmThemeState({
    required this.themeName,      // "sunshine" | "moonlight"
    this.themeMode = ThemeMode.system,
  });

  final String themeName;
  final ThemeMode themeMode;

  /// Resolved ThemeData for the current name + brightness.
  ThemeData resolveTheme(Brightness platformBrightness) {
    final entry = DmThemeData.themes.firstWhere(
      (t) => t.name == themeName,
      orElse: () => DmThemeData.themes.first,
    );
    return switch (themeMode) {
      ThemeMode.light => entry.light,
      ThemeMode.dark => entry.dark,
      ThemeMode.system => platformBrightness == Brightness.dark
          ? entry.dark
          : entry.light,
    };
  }

  factory DmThemeState.fromPrefs(SharedPreferences prefs);
  Future<void> persist(SharedPreferences prefs);

  @override
  List<Object> get props => [themeName, themeMode];
}
```

#### pubspec.yaml

```yaml
name: duskmoon_theme_bloc
description: BLoC for DuskMoon theme persistence (theme name + mode)
version: 0.1.0
publish_to: none

environment:
  sdk: ">=3.5.0 <4.0.0"
  flutter: ">=3.24.0"

dependencies:
  flutter:
    sdk: flutter
  duskmoon_theme:
    path: ../duskmoon_theme
  bloc: ^9.0.0
  flutter_bloc: ^9.0.0
  equatable: ^2.0.7
  shared_preferences: ^2.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

### 3.3 duskmoon_widgets

**Migrates from**: `app_widget/adaptive` (scaffold, action list)
**New widgets**: Adaptive buttons, inputs, layout, navigation, data display

#### Platform Resolution

Unifies the `switch (theme.platform)` pattern already used in `AppDialogAction` and `SettingsTile`:

```dart
enum DmPlatformStyle { material, cupertino }

/// Resolution order:
/// 1. Widget-level override
/// 2. DmPlatformOverride InheritedWidget (app-level)
/// 3. Theme.of(context).platform detection
DmPlatformStyle resolvePlatformStyle(BuildContext context, {
  DmPlatformStyle? widgetOverride,
});
```

#### DmScaffold (from AppAdaptiveScaffold)

Rename + retheme. Keeps the `flutter_adaptive_scaffold` dependency.

```dart
/// Responsive scaffold: NavigationRail (desktop) / BottomNav (mobile).
/// Migrated from AppAdaptiveScaffold — all params preserved.
class DmScaffold extends StatelessWidget { /* ... */ }
```

#### DmActionList (from AppAdaptiveActionList)

```dart
/// Renders actions as popup menu (small), icon buttons (medium),
/// or text buttons with icons (large).
class DmActionList extends StatelessWidget { /* ... */ }
```

#### Adaptive Widget Pattern

```dart
class DmButton extends StatelessWidget with AdaptiveWidget {
  const DmButton({
    required this.onPressed,
    required this.child,
    this.variant = DmButtonVariant.filled,
    this.color = DmColorRole.primary,
    this.size = DmSize.md,
    this.platformOverride,
  });

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => _buildMaterial(context),
      DmPlatformStyle.cupertino => _buildCupertino(context),
    };
  }
}

enum DmButtonVariant { filled, outlined, text, tonal }
enum DmColorRole { primary, secondary, tertiary, error }
enum DmSize { xs, sm, md, lg, xl }
```

#### Widget Coverage (MVP — 18 widgets)

| Category | Widget | Material | Cupertino |
|---|---|---|---|
| Scaffold | `DmScaffold` | `AdaptiveScaffold` | `AdaptiveScaffold` |
| Scaffold | `DmActionList` | `IconButton`/`TextButton.icon` | same |
| Buttons | `DmButton` | `FilledButton`/`OutlinedButton`/`TextButton` | `CupertinoButton` |
| Buttons | `DmIconButton` | `IconButton` | `CupertinoButton` |
| Buttons | `DmFab` | `FloatingActionButton` | Custom |
| Inputs | `DmTextField` | `TextField` | `CupertinoTextField` |
| Inputs | `DmCheckbox` | `Checkbox` | `CupertinoCheckbox` |
| Inputs | `DmSwitch` | `Switch` | `CupertinoSwitch` |
| Inputs | `DmSlider` | `Slider` | `CupertinoSlider` |
| Layout | `DmCard` | `Card` | Custom |
| Layout | `DmDivider` | `Divider` | Custom |
| Navigation | `DmAppBar` | `AppBar` | `CupertinoNavigationBar` |
| Navigation | `DmBottomNav` | `NavigationBar` | `CupertinoTabBar` |
| Navigation | `DmTabBar` | `TabBar` | `CupertinoSlidingSegmentedControl` |
| Navigation | `DmDrawer` | `Drawer` | Custom |
| Data Display | `DmBadge` | `Badge` | Custom |
| Data Display | `DmChip` | `Chip`/`FilterChip` | Custom |
| Data Display | `DmAvatar` | `CircleAvatar` | Custom |

#### pubspec.yaml

```yaml
name: duskmoon_widgets
version: 0.1.0
publish_to: none

dependencies:
  flutter: { sdk: flutter }
  duskmoon_theme: { path: ../duskmoon_theme }
  flutter_adaptive_scaffold: ^0.3.1
```

---

### 3.4 duskmoon_settings

**Migrates from**: `third_party/settings_ui` (forked library, ~264K source)

#### Existing Architecture (preserved)

3-tier platform rendering — this is the most mature adaptive code in the template:

| Platform | Renderer | Covers |
|---|---|---|
| Material | `MaterialSettingsTile/Section/List` | Android, Linux, Web, Fuchsia |
| Cupertino | `CupertinoSettingsTile/Section/List` | iOS, macOS |
| Fluent | `FluentSettingsTile/Section/List` | Windows |

#### 10 Tile Types (all preserved)

| Constructor | Use Case |
|---|---|
| `SettingsTile()` | Simple display tile |
| `SettingsTile.navigation()` | Chevron tile linking to sub-page |
| `SettingsTile.switchTile()` | On/off toggle |
| `SettingsTile.checkTile()` | Checkmark tile |
| `SettingsTile.input()` | Single-line text input |
| `SettingsTile.slider()` | Numeric slider |
| `SettingsTile.select()` | Dropdown/picker selection |
| `SettingsTile.textarea()` | Multi-line text input |
| `SettingsTile.radioGroup()` | Single-choice radio group |
| `SettingsTile.checkboxGroup()` | Multi-choice checkbox group |

#### SettingsTheme (preserved)

`SettingsThemeData` auto-derives from `ColorScheme`. DuskMoon tokens flow through since `DmThemeData` sets the `ColorScheme`:

```dart
// Existing — works unchanged with DuskMoon themes
SettingsThemeData.withContext(context, platform);
// Internally: Theme.of(context).colorScheme → platform-specific styling
```

#### Migration Changes

| Change | Reason |
|---|---|
| Rename `settings_ui` → `duskmoon_settings` | Namespace |
| Replace `DevicePlatform.detect()` (uses `dart:io` `Platform`) | Use `Theme.of(context).platform` for web compat |
| Update `SettingsThemeData` to optionally read `DmColorExtension` | Access semantic colors (info, success, warning) |

#### pubspec.yaml

```yaml
name: duskmoon_settings
version: 0.1.0
publish_to: none

dependencies:
  flutter: { sdk: flutter }
  duskmoon_theme: { path: ../duskmoon_theme }
```

---

### 3.5 duskmoon_feedback

**Migrates from**: `app_widget/feedback`

#### Existing Code

| Function/Widget | Adaptive? | Notes |
|---|---|---|
| `AppDialogAction` | **Yes** — `switch (theme.platform)` | Material `TextButton` ↔ `CupertinoDialogAction` |
| `showAppDialog<T>()` | **Yes** — `AlertDialog.adaptive` | |
| `showSnackbar()` | Material only | Add Cupertino toast alternative |
| `showUndoSnackbar()` | Material only | Remove `app_locale` dep; accept label param |
| `showToast()` | TBD | |
| `showBottomSheetAction()` | TBD | |
| `showFullscreenDialog()` | TBD | |

#### Migration Changes

| Change | Reason |
|---|---|
| Rename `App*` → `Dm*` | Namespace |
| Remove `app_locale` dependency | Library shouldn't depend on app l10n; accept `undoLabel` param |
| Add Cupertino toast for iOS/macOS | `SnackBar` is a Material concept |

#### Public API

```dart
library duskmoon_feedback;

export 'src/dialog.dart' show DmDialogAction, showDmDialog;
export 'src/snackbar.dart' show showDmSnackbar, showDmUndoSnackbar;
export 'src/toast.dart' show showDmToast;
export 'src/bottom_sheet.dart' show showDmBottomSheet;
export 'src/fullscreen_dialog.dart' show showDmFullscreenDialog;
```

#### pubspec.yaml

```yaml
name: duskmoon_feedback
version: 0.1.0
publish_to: none

dependencies:
  flutter: { sdk: flutter }
  duskmoon_theme: { path: ../duskmoon_theme }
```

---

### 3.6 duskmoon_ui (umbrella)

```dart
library duskmoon_ui;

export 'package:duskmoon_theme/duskmoon_theme.dart';
export 'package:duskmoon_widgets/duskmoon_widgets.dart';
export 'package:duskmoon_settings/duskmoon_settings.dart';
export 'package:duskmoon_feedback/duskmoon_feedback.dart';
// Note: duskmoon_theme_bloc intentionally NOT re-exported — opt-in for bloc users
```

---

## 4. Melos Configuration

```yaml
name: flutter_duskmoon_ui
repository: https://github.com/duskmoon-dev/flutter_duskmoon_ui

packages:
  - packages/*
  - example

command:
  bootstrap:
    environment:
      sdk: ">=3.5.0 <4.0.0"
      flutter: ">=3.24.0"

scripts:
  analyze:
    run: melos exec -- dart analyze --fatal-infos
  test:
    run: melos exec -- flutter test
  format:
    run: melos exec -- dart format --set-exit-if-changed .
  codegen:
    description: "Run duskmoon-codegen to update generated token files"
    run: |
      duskmoon-codegen generate --target dart \
        --input ../duskmoon-dev-design/tokens \
        --output packages/duskmoon_theme/lib/src/generated
```

---

## 5. Implementation Phases

### Phase 1 — Scaffold & Theme (2 weeks)

**Goal**: Monorepo running, `duskmoon_theme` producing valid `ThemeData` from codegen tokens.

- [ ] Init Flutter monorepo with melos
- [ ] Create all 7 package shells with pubspec.yaml
- [ ] Integrate codegen Dart output into `duskmoon_theme/lib/src/generated/`
- [ ] Implement `DmColorScheme.sunshine()` / `.moonlight()` from generated tokens
- [ ] Implement `DmThemeData.sunshine()` / `.moonlight()` — include `NavigationRail`/`AppBar` styling
- [ ] Implement `DmColorExtension` for non-ColorScheme tokens
- [ ] Implement `DmTextTheme`
- [ ] Migrate `ThemeModeExtension` utility
- [ ] Golden tests: ColorScheme values match token YAML
- [ ] Example app with theme switching (`ThemeMode.system`)

### Phase 2 — Theme BLoC (1 week)

**Goal**: `duskmoon_theme_bloc` persists theme name + mode.

- [ ] Refactor `app_bloc/theme` → `DmThemeBloc`
- [ ] Replace `AppTheme` references with `String themeName` + `DmThemeData.themes` lookup
- [ ] `DmThemeState.fromPrefs()` / `.persist()` via SharedPreferences
- [ ] Unit tests
- [ ] Wire into example app

### Phase 3 — Settings Migration (2 weeks)

**Goal**: `duskmoon_settings` fully functional.

- [ ] Copy `third_party/settings_ui/lib/src/` → `duskmoon_settings/lib/src/`
- [ ] Rename package references
- [ ] Replace `DevicePlatform.detect()` with `Theme.of(context).platform` resolver
- [ ] Verify all 10 tile types: simple, navigation, switch, check, input, slider, select, textarea, radioGroup, checkboxGroup
- [ ] Verify 3 platform renderers: Material, Cupertino, Fluent
- [ ] Update `SettingsThemeData` to optionally read `DmColorExtension`
- [ ] Migrate tests from `third_party/settings_ui/test/`
- [ ] Example settings page

### Phase 4 — Feedback Migration (1 week)

**Goal**: `duskmoon_feedback` extracted and decoupled.

- [ ] Copy `app_widget/feedback/lib/src/` → `duskmoon_feedback/lib/src/`
- [ ] Rename `App*` → `Dm*`
- [ ] Remove `app_locale` dep; accept string params
- [ ] Add Cupertino toast alternative
- [ ] Migrate tests
- [ ] Example feedback page

### Phase 5 — Adaptive Widgets (3–4 weeks)

**Goal**: 18 adaptive widgets.

- [ ] Implement `PlatformResolver`, `DmPlatformOverride` InheritedWidget
- [ ] Migrate `AppAdaptiveScaffold` → `DmScaffold`
- [ ] Migrate `AppAdaptiveActionList` → `DmActionList`
- [ ] New: `DmButton`, `DmIconButton`, `DmFab`
- [ ] New: `DmTextField`, `DmCheckbox`, `DmSwitch`, `DmSlider`
- [ ] New: `DmCard`, `DmDivider`
- [ ] New: `DmAppBar`, `DmBottomNav`, `DmTabBar`, `DmDrawer`
- [ ] New: `DmBadge`, `DmChip`, `DmAvatar`
- [ ] Widget tests (Material + Cupertino paths)
- [ ] Example catalog per category

### Phase 6 — Polish & Publish Prep (2 weeks)

- [ ] Full melos CI pipeline
- [ ] dartdoc coverage
- [ ] README per package
- [ ] CHANGELOG
- [ ] pub.dev score optimization
- [ ] License (MIT)

---

## 6. Acceptance Criteria

### duskmoon_theme

- [ ] `DmThemeData.sunshine()` produces valid `ThemeData` matching all 30+ `ColorScheme` properties from sunshine tokens
- [ ] `DmThemeData.moonlight()` same for moonlight
- [ ] **No** `fromSeed`, **no** template color schemes (Violet/Green/Fire/Wheat)
- [ ] `DmColorExtension` accessible via `Theme.of(context).extension<DmColorExtension>()`
- [ ] `DmThemeData.themes` returns list of all codegen themes
- [ ] Zero external dependencies beyond Flutter SDK
- [ ] Theme switching (`ThemeMode.system`) works without flicker

### duskmoon_theme_bloc

- [ ] Persists theme name + mode to SharedPreferences
- [ ] `DmThemeState.resolveTheme()` returns correct `ThemeData` for name + mode + brightness
- [ ] Works with any codegen theme name (future themes auto-supported)
- [ ] Does not depend on specific theme constants — string-based lookup

### duskmoon_settings

- [ ] All 10 tile types render on Android, iOS, macOS, Windows, Web
- [ ] 3 platform renderers work: Material, Cupertino, Fluent
- [ ] `SettingsThemeData.withContext()` correctly derives from DuskMoon `ColorScheme`
- [ ] All existing tests pass after migration

### duskmoon_feedback

- [ ] `showDmDialog` uses `AlertDialog.adaptive`
- [ ] `DmDialogAction` platform-switches Material↔Cupertino
- [ ] `showDmSnackbar` / `showDmUndoSnackbar` work; no `app_locale` dependency
- [ ] Cupertino toast renders on iOS/macOS

### duskmoon_widgets

- [ ] All 18 widgets render on: Android, iOS, macOS, Web
- [ ] Auto-switch Material↔Cupertino based on platform
- [ ] `DmPlatformOverride` forces style for subtree
- [ ] Per-widget `platformOverride` param works
- [ ] `DmScaffold` matches `AppAdaptiveScaffold` behavior
- [ ] `DmActionList` matches `AppAdaptiveActionList` behavior
- [ ] `DmButton(color: DmColorRole.tertiary)` uses tertiary tokens

### General

- [ ] Zero `dart analyze` warnings
- [ ] All tests pass on CI
- [ ] Example app builds on Android, iOS, Web, macOS
- [ ] `duskmoon_ui` umbrella imports all packages cleanly

---

## 7. Open Questions

1. **Fluent in duskmoon_widgets** — `duskmoon_settings` has Fluent (Windows) rendering. Should `duskmoon_widgets` also add a Fluent path (3-way: Material/Cupertino/Fluent)?

2. **flutter_adaptive_scaffold** — Use the forked `third_party` version or the official pub package?

3. **Localization in feedback** — After removing `app_locale`, should the library provide default English strings with an override mechanism?

4. **Accessibility testing** — Add `accessibility_tools` to the example app?

5. **duskmoon_ui umbrella** — Should it re-export `duskmoon_theme_bloc`? Current decision: no, it's opt-in. Confirm.

---

*End of PRD 2*
