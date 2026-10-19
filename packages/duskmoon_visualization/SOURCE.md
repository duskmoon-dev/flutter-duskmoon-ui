# Source provenance

This package maintains the imported `data_visualization` workspace source under
`lib/src/vendor/dv_*`, including zoom, map, geographic, scale, geometry, chart
and interaction modules. These are source forks maintained here rather than
runtime dependencies on separate `dv_*` packages.

- Upstream: https://github.com/gsmlg-app/data_visualization.
- Original workspace path, recorded in `docs/visualization-migration.md`:
  `/home/gao/Workspace/gsmlg-app/data_visualization`.
- Local import: `b41cf0b41c24ae64e88f3819adfec61871c3bbd2` (2026-04-02).
- Imported upstream Git revision and per-package versions: **unknown**.
  The import did not pin them. The reference snapshot below documents the
  generator; it is not asserted to be the imported source baseline.
- Source-code license: MIT, Copyright (c) 2026 GSMLG Limited, retained in
  `THIRD_PARTY_LICENSES`. The package `LICENSE` retains DuskMoon's own MIT notice.

The migration rewrote `package:dv_*` imports to internal imports. DuskMoon adds
curated wrappers and theme integration while retaining lower-level exports in
`duskmoon_visualization_compat.dart`.

## Embedded map data

The upstream `packages/dv_map/README.md` identifies Natural Earth Admin 0 —
Countries as the source of its boundary data:

- https://naciscdn.org/naturalearth/110m/cultural/ne_110m_admin_0_countries.zip
- https://naciscdn.org/naturalearth/50m/cultural/ne_50m_admin_0_countries.zip
- https://naciscdn.org/naturalearth/10m/cultural/ne_10m_admin_0_countries.zip

Dataset terms: https://www.naturalearthdata.com/about/terms-of-use/.
The embedded data's Natural Earth release, original download hashes, exact
shapefile-to-GeoJSON conversion and imported asset hashes are **unknown**.
The URLs above do not pin a release, and the program code's MIT license does
not establish those missing data records.

Generated files under `lib/src/vendor/dv_map/maps/` retain original asset paths,
for example `assets/world.110m.json`, and embed gzip-compressed, base64-encoded
GeoJSON. Original GeoJSON assets and their generator were not imported into
this package.

## Known upstream generation process

The following reference snapshot was inspected during the provenance review:

- Revision: `b282b661ba6161dd4f71b7a4a79c7b9ea318688b`.
- Script: https://github.com/gsmlg-app/data_visualization/blob/b282b661ba6161dd4f71b7a4a79c7b9ea318688b/packages/dv_map/scripts/generate_map_widgets.dart.
- Data documentation: https://github.com/gsmlg-app/data_visualization/blob/b282b661ba6161dd4f71b7a4a79c7b9ea318688b/packages/dv_map/README.md.

From that upstream checkout, the documented command is:

```sh
cd packages/dv_map
dart scripts/generate_map_widgets.dart
```

The script reads `assets/**/*.json`, skips `.10m.json` files, UTF-8 encodes each
file, gzip-compresses and base64-encodes its bytes, then generates data getters,
map widgets and export indexes in `lib/maps/`. It rebuilds that output
directory. This records the available upstream process, not a byte-reproduction
claim for this repository's historical embedded assets. A future data refresh
must first pin the source dataset and conversion inputs, then apply this
workspace's internal import paths to the generated output.
