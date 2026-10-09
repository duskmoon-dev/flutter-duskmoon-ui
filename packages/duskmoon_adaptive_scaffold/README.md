# duskmoon_adaptive_scaffold

Adaptive scaffold widgets for the DuskMoon Design System, forked from `flutter_adaptive_scaffold`.

## Features

- `DmAdaptiveScaffold` — adaptive layout that adjusts to screen size using Material 3 navigation patterns
- `AdaptiveLayout` — low-level adaptive layout primitive
- `SlotLayout` — slot-based layout composition

## Getting started

```yaml
dependencies:
  duskmoon_adaptive_scaffold: ^1.1.0
```

## Usage

```dart
import 'package:duskmoon_adaptive_scaffold/duskmoon_adaptive_scaffold.dart';

DmAdaptiveScaffold(
  destinations: const [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ],
  body: (_) => const Center(child: Text('Body')),
)
```

## Foldable and companion displays

`DuoScreenPolicy.splitBody` places the body and secondary body on opposite
sides of a separating hinge or fold. Horizontal separators split top/bottom;
vertical separators mirror body reading order in RTL. A zero-width flat fold
does not split the layout. Half-open folds and physically occluding folds do.
Feature selection is deterministic: physical hinges take precedence over folds,
then bounds are ordered top-to-bottom and left-to-right.

`DuoScreenPolicy.navigationOnSecondary` moves navigation beside the secondary
body. It uses the regular adaptive layout when there is no separating feature
and `duoScreenRole` is `single`, so local navigation stays available.

```dart
DmAdaptiveScaffold(
  destinations: destinations,
  duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
  // Use primary only after the companion view has connected successfully.
  duoScreenRole: companionConnected
      ? DuoScreenRole.primary
      : DuoScreenRole.single,
  body: (_) => viewer,
  secondaryBody: (_) => controller,
)
```

Use `DuoScreenRole.secondary` in the companion view. It mounts navigation and
`secondaryBody` only; `primary` mounts the main body only. Top navigation belongs
to the primary view. Hidden slots are not built, focusable, or exposed in
semantics, and their state is disposed. Visible slots retain their identity when
the role changes. A narrow companion view uses bottom navigation; on a foldable,
secondary panes narrower than 600 logical pixels also use bottom navigation.

Hinge bounds are resolved in local layout coordinates, including AppBars and
ancestor padding. Pane boundaries align immediately to the physical separator;
size interpolation across a hinge is deliberately disabled. Slot fades and
navigation width changes remain bounded by pane clipping. View offset changes
are corrected after parent positioning, with physical hinge paint and hit-test
clipping protecting the first frame.

### Migrating `displayId`

`AdaptiveLayout` and `DmAdaptiveScaffold` retain the deprecated `displayId`
parameter until 2.0.0. Positive values still select the secondary role and take
precedence over `duoScreenRole`; zero defaults to `single`. Replace it with
`duoScreenRole`, and leave platform display identifiers in the plugin or app
integration layer. Roles only affect `navigationOnSecondary`.

The policy remains available to existing callers importing
`src/adaptive_layout.dart`. `DmScaffold` also forwards the additive
`duoScreenPolicy` and `duoScreenRole` parameters.

## Additional information

Part of the [DuskMoon UI](https://github.com/duskmoon-dev/flutter_duskmoon_ui) design system.
