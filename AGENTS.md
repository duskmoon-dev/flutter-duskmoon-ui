# Repository Guidelines

## Project Structure & Module Organization

This repository is a Dart native workspace managed with Melos 8 from the root `pubspec.yaml`. Reusable libraries live in `packages/`; each package keeps public exports in `lib/`, implementations in `lib/src/`, and tests in `test/`. `packages/duskmoon_ui` is the umbrella package. Theme, adaptive widget, settings, feedback, form, visualization, code-editor, scaffold, and Mermaid-renderer concerns remain in their named packages. The `example/` app is the interactive showcase, `docs/` contains architecture and package guides, and `.github/workflows/` owns CI and publishing.

Generated theme tokens live under `packages/duskmoon_theme/lib/src/generated/`. Regenerate them through the workspace command; do not hand-edit `*.g.dart` files.

## Build, Test, and Development Commands

Enter `devenv shell` when Dart and Flutter are not already on the host `PATH`.

```bash
dart pub get                    # Resolve the full workspace
melos run format                # Format and verify every member
melos run analyze               # Analyze with --fatal-infos
melos run test                  # Run all Flutter tests
melos run codegen               # Regenerate tokens from ../duskmoon-dev-design
```

Run the showcase with `cd example && flutter run -d chrome`. For focused work, enter one package and run `flutter test` or `dart analyze --fatal-infos`, for example `cd packages/duskmoon_theme`.

## Coding Style & Naming Conventions

Use `dart format` defaults (two-space indentation) and the repository's `flutter_lints` rules. Public UI types use the `Dm` prefix, such as `DmButton`; user-subclassable form BLoCs retain names such as `FormBloc`. Prefer `abstract final` classes for static factories. Adaptive widgets resolve style in this order: widget override, `DmPlatformOverride`, `DuskmoonApp`, then the platform theme. Keep changes package-local and avoid unrelated refactors.

## Testing Guidelines

Tests use `flutter_test` and files end in `_test.dart`. Mirror source areas under each package's `test/` tree. Add widget tests for rendering and interaction changes, parser/unit tests for pure logic, and golden tests for visual renderers. Theme token tests should assert exact generated colors. Run the affected package first, then the full workspace scripts before opening a PR.

## Commit & Pull Request Guidelines

History follows Conventional Commits, commonly `feat(scope): ...`, `fix(scope): ...`, `docs(scope): ...`, and `chore(release): ...`. Keep commits focused. PRs should explain the behavior change, link relevant issues, list validation commands, and include screenshots or recordings for visible UI changes.

## Agent Notes

After adding a feature, changing architecture, or fixing an issue, write an agent note with labels `project: duskmoon` and `variant: flutter`.
