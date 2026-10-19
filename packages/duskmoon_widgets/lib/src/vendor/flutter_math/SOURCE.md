# Owned Flutter math renderer

Imported from `flutter_math_fork 0.7.4` on 2026-10-19.

- Source: https://github.com/simpleclub/flutter_math
- Published archive: https://pub.dev/api/archives/flutter_math_fork-0.7.4.tar.gz
- Archive SHA-256: `6d5f2f1aa57ae539ffb0a04bb39d2da67af74601d685a161aff7ce5bda5fa407`
- Original manifest: `UPSTREAM_PUBSPEC.yaml`
- Original Apache-2.0 license: `LICENSE`
- KaTeX font MIT notice: `katex_fonts/LICENSE`

The published non-selectable renderer, parser and encoder dependency closure
is retained, including per-file MIT notices. Unused selection/editing and
CanvasKit JavaScript integration are omitted.
DuskMoon maintains this renderer as private source; its types are not exported
from the public widget library. Relative source imports are unchanged. Each imported Dart file retains the
upstream Dart 3.0 language semantics through a language-version marker.
Modern Flutter color/text-scaling APIs and Dart nonNulls replace deprecated
accessors; exhaustive enum switches omit unreachable default clauses.
The shared AST widget cache is invalidated when font size or logical PPI changes,
so changes to the system text scaler rebuild the equation's glyphs and layout.
The font family package prefix in `src/render/symbols/make_symbol.dart` is
changed from `flutter_math_fork` to `duskmoon_widgets`; the matching font files
are declared by `duskmoon_widgets/pubspec.yaml`.

Upstream parser tests are retained under `test/vendor/flutter_math/`, with only
package import URIs, font paths and deprecated test-view APIs adapted. Local integration tests
exercise inline/display math, invalid-input fallback and bundled font loading.

For a future source refresh, verify the published archive digest, review Flutter
render-object API changes, preserve source/font licenses, and rerun the parser
and widget tests plus the example Web/Wasm builds.

Dart source excluded from the imported runtime closure:

- `src/utils/canvas_kit/canvas_kit_stub.dart`
- `src/utils/canvas_kit/canvas_kit.dart`
- `src/utils/canvas_kit/canvas_kit_web.dart`
- `src/render/svg/draw_svg_root.dart`
- `src/render/layout/remove_baseline.dart`
- `src/widgets/selectable.dart`
- `src/widgets/controller.dart`
- `src/utils/wrapper.dart`
- `src/utils/text_extension.dart`
- `src/utils/render_box_extensions.dart`
- `src/widgets/selection/gesture_detector_builder_selectable.dart`
- `src/widgets/selection/gesture_detector_builder.dart`
- `src/widgets/selection/overlay_manager.dart`
- `src/widgets/selection/overlay.dart`
- `src/widgets/selection/selection_manager.dart`
- `src/widgets/selection/focus_manager.dart`
- `src/widgets/selection/handle_overlay.dart`
- `src/widgets/selection/web_selection_manager.dart`
- `src/widgets/selection/cursor_timer_manager.dart`
- `src/render/layout/line_editable.dart`

The selection/editing branch of EquationRowNode.buildWidget is intentionally
removed; DuskMoon uses the original view-mode Line rendering only.
The SelectableMath export and its documentation-only import are omitted.
