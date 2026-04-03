# Design: duskmoon_adaptive_scaffold

**Date:** 2026-04-03  
**Status:** Approved

## Summary

Vendor the modified `flutter_adaptive_scaffold` package (from `gsmlg-app/flutter-app-template/third_party/flutter_adaptive_scaffold`) into this monorepo as `duskmoon_adaptive_scaffold`, then update `duskmoon_widgets` to depend on it instead of pub.dev's `flutter_adaptive_scaffold`.

## Motivation

The upstream `flutter_adaptive_scaffold` package is discontinued (as of v0.3.1+1). The modified local copy adds `navigationRailPadding` support, a `NavigationRailDestinationBuilder` typedef, and other minor fixes at v0.3.3+1. Vendoring it into the duskmoon monorepo gives the team full control over future changes without depending on an abandoned pub.dev package.

## New Package: `duskmoon_adaptive_scaffold`

**Location:** `packages/duskmoon_adaptive_scaffold/`

**Source:** Copy of `third_party/flutter_adaptive_scaffold/` with renames applied.

**pubspec.yaml changes vs source:**
- `name`: `flutter_adaptive_scaffold` → `duskmoon_adaptive_scaffold`
- `version`: keep `0.3.3+1`
- `sdk` constraint: `>=3.8.0 <4.0.0` → `>=3.5.0 <4.0.0` (align with workspace minimum)
- Remove upstream `repository` and `issue_tracker` fields
- Add `publish_to: none` (standard for dev packages in this repo)
- `resolution: workspace` (already present, keep it)

**File renames:**
- `lib/flutter_adaptive_scaffold.dart` → `lib/duskmoon_adaptive_scaffold.dart`

**Internal import fixes:**
- `lib/src/breakpoints.dart`: `'../flutter_adaptive_scaffold.dart'` → `'../duskmoon_adaptive_scaffold.dart'`

**Test import fixes (all test files):**
- `package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart` → `package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart`
- `package:flutter_adaptive_scaffold/src/...` → `package:duskmoon_adaptive_scaffold/src/...`

**Test files included:** Yes — bring all 6 test files from the source package.

## Workspace Registration

Add `packages/duskmoon_adaptive_scaffold` to the `workspace:` list in root `pubspec.yaml`.

## `duskmoon_widgets` Updates

**pubspec.yaml:**
- Remove `flutter_adaptive_scaffold: ^0.3.1`
- Add `duskmoon_adaptive_scaffold: ^0.3.3+1` (resolved via workspace)

**`lib/src/scaffold/dm_scaffold.dart`:**
- `import 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart'` → `import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart'`
- `export 'package:flutter_adaptive_scaffold/flutter_adaptive_scaffold.dart'` → `export 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart'`

## Public API Impact

None. All types exported from `flutter_adaptive_scaffold` are re-exported verbatim. Consumers of `DmScaffold` from `duskmoon_widgets` see no change.
