# DuskMoon Visualization Migration Checklist

This checklist tracks the migration of `/home/gao/Workspace/gsmlg-app/data_visualization` into this monorepo as `packages/duskmoon_visualization`.

## Decisions

- [ ] Confirm the target package is a single public package: `duskmoon_visualization`
- [ ] Decide whether the repo baseline moves from Dart `>=3.5.0` to `>=3.8.0`, or the imported code is backported
- [ ] Decide whether the first public API is compatibility-first or DuskMoon-renamed
- [ ] Decide which source examples become part of the existing `example/` app

## Scaffold

- [x] Create `packages/duskmoon_visualization`
- [x] Add package metadata: `pubspec.yaml`, `README.md`, `CHANGELOG.md`, `LICENSE`, `analysis_options.yaml`
- [x] Add a top-level library entrypoint: `lib/duskmoon_visualization.dart`
- [x] Add a minimal compilable source structure under `lib/src/`
- [x] Add a minimal package test
- [x] Add the package to the root workspace
- [x] Add the package to the `duskmoon_ui` umbrella export

## Source Import

- [x] Inventory all source workspace packages and group them by domain
- [x] Copy the selected source code into `packages/duskmoon_visualization/lib/src/vendor/`
- [x] Rewrite `package:dv_*` imports to internal package imports
- [ ] Copy any required assets and example data files
- [ ] Preserve source licenses and attribution where required
Current imported domains: core, scales, curves, stats, geo-core, delaunay, voronoi, group, glyph, gradient, pattern, clip-path, shape, text, axis, grid, legend, annotation, bounds, responsive, event, tooltip, drag, brush, zoom, xychart, threshold, heatmap, geo, map, network, mock-data

## API Shaping

Current default-exported curated types include chart models, network models, geo models, palette helpers, and six curated widgets: `DmVizLineChart`, `DmVizBarChart`, `DmVizScatterChart`, `DmVizHeatmap`, `DmVizNetworkGraph`, and `DmVizMapChart`.
Compatibility import for the full migrated surface: `package:duskmoon_visualization/duskmoon_visualization_compat.dart`
Current curated non-chart wrapper: `DmVizNetworkGraph`

- [x] Expose a first-pass compatibility umbrella from `duskmoon_visualization`
- [x] Review public symbols and hide low-value internals
- [x] Decide which `dv_*` types stay public temporarily
- [x] Add DuskMoon-facing wrappers, defaults, or renamed APIs where justified
- [x] Integrate DuskMoon theme defaults for chart styling

## Examples And Docs

- [x] Add a visualization page to the existing `example/` app
- [x] Port one representative XY chart example
- [x] Port one representative geographic or network example
- [x] Expand the package README with usage guidance
- [ ] Add repository docs for package architecture and migration notes

## Validation

- [ ] Run `dart pub get` at the workspace root
- [ ] Run `melos run analyze`
- [ ] Run focused tests for `packages/duskmoon_visualization`
- [ ] Add regression tests for imported math and layout primitives
- [x] Add widget smoke tests for the first exported visualization widgets
