---
description: Update skills and human-readable docs to reflect current codebase
---

# Update Project Documentation

You are updating two documentation targets to match the current state of the codebase:

1. **Skills** at `./skills/flutter-duskmoon/` — Claude Code skill files for AI consumption
2. **Docs** at `./docs/` — Human-readable documentation

## Step 1: Understand Current Skills

Read all files in `./skills/flutter-duskmoon/`:
- `SKILL.md` — main entry point and overview
- `duskmoon_theme.md` — theme system
- `duskmoon_widgets.md` — adaptive widgets
- `duskmoon_settings.md` — settings UI
- `duskmoon_feedback.md` — feedback helpers
- `duskmoon_theme_bloc.md` — BLoC theme persistence

## Step 2: Audit the Codebase for Changes

For each package, compare the skill docs against the actual source code. Use parallel agents to speed this up. Check:

- **duskmoon_theme**: `packages/duskmoon_theme/lib/` — new/changed/removed classes, factories, extensions, generated tokens
- **duskmoon_widgets**: `packages/duskmoon_widgets/lib/` — new/changed/removed widgets, constructor params, enum values
- **duskmoon_settings**: `packages/duskmoon_settings/lib/` — new/changed/removed tile types, options, theming
- **duskmoon_feedback**: `packages/duskmoon_feedback/lib/` — new/changed/removed dialog/snackbar/toast/sheet helpers
- **duskmoon_theme_bloc**: `packages/duskmoon_theme_bloc/lib/` — new/changed/removed events, states, bloc API
- **duskmoon_ui**: `packages/duskmoon_ui/lib/` — re-export changes

Also check:
- Root `pubspec.yaml` for workspace/melos config changes
- Each package's `pubspec.yaml` for dependency or version changes
- New packages that may have been added under `packages/`
- The `example/` app for new showcase pages

## Step 3: Update Skills

For each skill file that has drifted from the source code:
- Add documentation for new public APIs (classes, widgets, functions, enums, constructors)
- Update changed signatures, parameters, or behavior
- Remove documentation for deleted APIs
- Keep the same format and style as existing skill files
- Ensure code examples are accurate and runnable

Do NOT rewrite files that are already up to date — only edit what changed.

## Step 4: Create/Update Human-Readable Docs

Create or update files in `./docs/` with user-friendly documentation. These are for developers using the packages, not for AI.

Target structure:
```
docs/
├── index.md              — Overview, quick start, installation
├── theme.md              — Theme system guide
├── widgets.md            — Adaptive widgets catalog
├── settings.md           — Settings UI guide
├── feedback.md           — Feedback helpers guide
├── theme-bloc.md         — BLoC theme persistence guide
└── architecture.md       — Package dependency graph, design decisions, conventions
```

For each doc file:
- Write clear, concise prose aimed at Flutter developers
- Include installation instructions and import statements
- Show practical code examples (copy-pasteable)
- Document all public API surface with constructor signatures and parameter descriptions
- Add a table of contents for longer files
- Cross-link between docs where relevant (e.g., theme docs link to theme-bloc docs)
- Match content to the current skill files (which you just audited/updated)

If `./docs/` files already exist, diff them against the updated skills and only change what's needed.

## Important Rules

- Do NOT modify any source code — this command is documentation-only
- Do NOT create README.md files — only update `./skills/` and `./docs/`
- Use parallel agents whenever auditing multiple packages
- Keep skill files concise and code-heavy (for AI consumption)
- Keep docs files readable and prose-heavy (for human consumption)
