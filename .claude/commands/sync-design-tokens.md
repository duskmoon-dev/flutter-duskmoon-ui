---
description: Fetch latest design tokens from duskmoon-dev/design and regenerate duskmoon_theme token files
---

# Sync Design Tokens

Fetch the latest design tokens from `github.com/duskmoon-dev/design` and regenerate the Dart token files in `duskmoon_theme`.

## Step 1: Fetch Latest Tokens

Clone or update the design token source:

```bash
DESIGN_REPO="/tmp/duskmoon-dev-design"
if [ -d "$DESIGN_REPO/.git" ]; then
  git -C "$DESIGN_REPO" fetch origin && git -C "$DESIGN_REPO" reset --hard origin/main
else
  rm -rf "$DESIGN_REPO"
  git clone --depth 1 https://github.com/duskmoon-dev/design.git "$DESIGN_REPO"
fi
```

## Step 2: Inspect Token Structure

Read the token files under `$DESIGN_REPO/tokens/` to understand the current token schema. Look for:
- Theme names (light/dark pairs — currently "sunshine" for light and "moonlight" for dark)
- Any **new** themes that have been added
- Color token categories: primary, secondary, tertiary, error, surface, outline, inverse, extended (accent, neutral, info, success, warning, base)
- Any new token categories or renamed fields

Compare the fetched tokens against the existing generated files:
- `packages/duskmoon_theme/lib/src/generated/sunshine_tokens.g.dart`
- `packages/duskmoon_theme/lib/src/generated/moonlight_tokens.g.dart`

## Step 3: Regenerate Token Files

For **each theme pair** found in the design tokens, generate a `*_tokens.g.dart` file in `packages/duskmoon_theme/lib/src/generated/`.

Each generated file must follow this exact format:

```dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// Generated from @duskmoon-dev/design tokens

import 'dart:ui' show Color;

abstract final class <ThemeName>Tokens {
  // <Category>
  static const Color <tokenName> = Color(0x<AARRGGBB>);
  // ...
}
```

Rules:
- Class name is PascalCase theme name + `Tokens` (e.g., `SunshineTokens`, `MoonlightTokens`)
- File name is snake_case theme name + `_tokens.g.dart`
- Group tokens by category with `// Category` comments
- All colors use `Color(0xAARRGGBB)` hex format with full alpha
- Preserve the existing field order and category grouping shown in current generated files

## Step 4: Wire Up New Themes (if any)

If new theme pairs were found beyond sunshine/moonlight:

1. Add a new static factory to `DmColorScheme` in `packages/duskmoon_theme/lib/src/color_scheme.dart` that maps the new tokens to a `ColorScheme`
2. Add a new static factory to `DmThemeData` in `packages/duskmoon_theme/lib/src/theme_data.dart` or `dm_theme.dart` that returns a complete `ThemeData`
3. Add a new `DmThemeEntry` if the project uses theme entries for registration
4. Export the new generated file from `packages/duskmoon_theme/lib/duskmoon_theme.dart`

## Step 5: Verify

Run these checks to ensure nothing is broken:

```bash
cd packages/duskmoon_theme && dart analyze --fatal-infos
cd packages/duskmoon_theme && flutter test
```

If analysis or tests fail, fix the generated files to match the expected structure.

## Important Rules

- Only modify files in `packages/duskmoon_theme/` — do not touch other packages
- Always preserve the `// GENERATED CODE - DO NOT MODIFY BY HAND` header
- Do not remove existing themes — only add or update
- If a token field was removed upstream, remove it from the generated file and check that no code references it before deleting
- Clean up the cloned repo when done: `rm -rf /tmp/duskmoon-dev-design`
