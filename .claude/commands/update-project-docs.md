---
description: Update skills and human-readable docs to reflect current codebase
---

# Update Project Documentation

You are updating two documentation targets to match the current state of the codebase:

1. **Skills** at `./skills/flutter-duskmoon/` — Claude Code skill files for AI consumption
2. **Docs** at `./docs/` — Human-readable documentation

## Step 1: Discover Packages and Understand Current Docs

First, list all packages under `packages/` to get the full set. Then read all existing skill and doc files:

**Skills** — read every `.md` file in `./skills/flutter-duskmoon/`:
- `SKILL.md` — main entry point and overview
- One skill file per package (e.g., `duskmoon_theme.md`, `duskmoon_widgets.md`, etc.)

**Docs** — read every `.md` file in `./docs/`.

## Step 2: Audit the Codebase for Changes

For **every** package under `packages/`, compare the skill/doc content against the actual source code. Use parallel agents to speed this up — one agent per package (or group small packages).

For each package, check:
- `lib/` — new/changed/removed public classes, widgets, functions, constructors, enums, extensions
- `pubspec.yaml` — version and dependency changes
- Barrel file (`lib/<package_name>.dart`) — new/changed/removed exports

Packages to audit (discover dynamically, but as of writing):
- **duskmoon_theme**: color schemes, theme factories, text themes, extensions, generated tokens
- **duskmoon_widgets**: adaptive widgets, markdown, code editor, scaffold, platform resolution
- **duskmoon_settings**: settings tiles, sections, lists, theming, platform renderers
- **duskmoon_feedback**: dialogs, snackbars, toasts, bottom sheets
- **duskmoon_form**: field BLoCs, form BLoC, widget builders, theming, validators
- **duskmoon_theme_bloc**: events, states, bloc API, persistence
- **duskmoon_code_engine**: document model, state system, parser, highlight, view layer, languages
- **duskmoon_visualization**: chart widgets, data models, palette
- **duskmoon_adaptive_scaffold**: adaptive scaffold, breakpoints, slot layout
- **duskmoon_ui**: umbrella re-exports, any internal APIs (e.g., DmEditorTheme)

Also check:
- Root `pubspec.yaml` for workspace/melos config changes
- New packages that may have been added under `packages/`
- The `example/` app for new showcase pages

## Step 3: Update Skills

For each skill file that has drifted from the source code:
- Add documentation for new public APIs (classes, widgets, functions, enums, constructors)
- Update changed signatures, parameters, or behavior
- Remove documentation for deleted APIs
- Keep the same format and style as existing skill files
- Ensure code examples are accurate and runnable

If a package has no skill file yet, create one following the pattern of existing skill files. Add it to the `SKILL.md` overview.

Do NOT rewrite files that are already up to date — only edit what changed.

## Step 4: Create/Update Human-Readable Docs

Create or update files in `./docs/` with user-friendly documentation. These are for developers using the packages, not for AI. Every package should have a corresponding doc file.

For each doc file:
- Write clear, concise prose aimed at Flutter developers
- Include installation instructions and import statements
- Show practical code examples (copy-pasteable)
- Document all public API surface with constructor signatures and parameter descriptions
- Add a table of contents for longer files
- Cross-link between docs where relevant (e.g., theme docs link to theme-bloc docs)
- Match content to the current skill files (which you just audited/updated)

If a package has no doc file yet, create one following the pattern of existing doc files. Add it to `docs/index.md`.

If `./docs/` files already exist, diff them against the updated skills and only change what's needed.

## Important Rules

- Do NOT modify any source code — this command is documentation-only
- Do NOT create README.md files — only update `./skills/` and `./docs/`
- Use parallel agents whenever auditing multiple packages
- Keep skill files concise and code-heavy (for AI consumption)
- Keep docs files readable and prose-heavy (for human consumption)
- Discover packages dynamically from `packages/` — do not rely on a hardcoded list
