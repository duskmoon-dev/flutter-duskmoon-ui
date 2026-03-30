# Adaptive Widgets

The `duskmoon_widgets` package provides 18 widgets that automatically render Material or Cupertino variants based on the current platform.

## Table of Contents

- [Installation](#installation)
- [Platform Resolution](#platform-resolution)
- [Buttons](#buttons)
- [Inputs](#inputs)
- [Navigation](#navigation)
- [Layout](#layout)
- [Data Display](#data-display)
- [Scaffold](#scaffold)
- [Custom Adaptive Widgets](#custom-adaptive-widgets)

## Installation

```yaml
dependencies:
  duskmoon_widgets: ^1.0.1
```

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
```

Or use the umbrella `duskmoon_ui` package.

## Platform Resolution

Widgets determine their rendering style using a three-tier priority system:

1. **Widget `platformOverride`** parameter — per-instance (highest priority)
2. **`DmPlatformOverride` InheritedWidget** — subtree-level
3. **`Theme.of(context).platform`** — theme default

### DmPlatformStyle

```dart
enum DmPlatformStyle { material, cupertino }
```

### Overriding platform for a subtree

```dart
DmPlatformOverride(
  style: DmPlatformStyle.cupertino,
  child: MyWidgetTree(), // All Dm* widgets below render Cupertino
)
```

### Overriding a single widget

```dart
DmButton(
  platformOverride: DmPlatformStyle.material,
  onPressed: () {},
  child: const Text('Always Material'),
)
```

## Buttons

### DmButton

Adaptive button with four visual variants.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onPressed` | `VoidCallback?` | required | Tap callback; `null` disables the button |
| `child` | `Widget` | required | Button content, typically `Text` |
| `variant` | `DmButtonVariant` | `filled` | `filled`, `outlined`, `text`, or `tonal` |
| `platformOverride` | `DmPlatformStyle?` | `null` | Per-widget platform override |

```dart
DmButton(
  onPressed: () {},
  child: const Text('Save'),
  variant: DmButtonVariant.tonal,
)
```

Material renders: `FilledButton`, `OutlinedButton`, `TextButton`, or `FilledButton.tonal`.
Cupertino renders: `CupertinoButton`.

### DmFab

Adaptive floating action button. When both `icon` and `label` are provided, renders an extended FAB on Material.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onPressed` | `VoidCallback?` | required | Tap callback |
| `child` | `Widget?` | `null` | Primary content (used when icon/label not set) |
| `icon` | `Widget?` | `null` | FAB icon |
| `label` | `Widget?` | `null` | Extended FAB label (requires icon) |

```dart
// Standard FAB
DmFab(onPressed: () {}, child: const Icon(Icons.add))

// Extended FAB
DmFab(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Create'))
```

### DmIconButton

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `icon` | `Widget` | required | Icon to display |
| `onPressed` | `VoidCallback?` | required | Tap callback |
| `tooltip` | `String?` | `null` | Tooltip text (Material only) |

```dart
DmIconButton(onPressed: () {}, icon: const Icon(Icons.search), tooltip: 'Search')
```

## Inputs

### DmTextField

Adaptive text input.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | `TextEditingController?` | `null` | Text controller |
| `placeholder` | `String?` | `null` | Hint text |
| `obscureText` | `bool` | `false` | Password mode |
| `onChanged` | `ValueChanged<String>?` | `null` | Value change callback |
| `onSubmitted` | `ValueChanged<String>?` | `null` | Submit callback |
| `enabled` | `bool` | `true` | Whether interactive |
| `keyboardType` | `TextInputType?` | `null` | Keyboard type |
| `maxLines` | `int?` | `1` | Max lines; `null` for unlimited |
| `decoration` | `InputDecoration?` | `null` | Material-only decoration override |
| `prefix` | `Widget?` | `null` | Leading widget |
| `suffix` | `Widget?` | `null` | Trailing widget |

Material: `TextField`. Cupertino: `CupertinoTextField`.

### DmSwitch

| Parameter | Type | Description |
|-----------|------|-------------|
| `value` | `bool` | Current on/off state |
| `onChanged` | `ValueChanged<bool>?` | Toggle callback; `null` disables |

Material: `Switch`. Cupertino: `CupertinoSwitch`.

### DmCheckbox

| Parameter | Type | Description |
|-----------|------|-------------|
| `value` | `bool` | Current checked state |
| `onChanged` | `ValueChanged<bool?>?` | Change callback; `null` disables |

Material: `Checkbox`. Cupertino: `CupertinoCheckbox`.

### DmSlider

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `value` | `double` | required | Current value |
| `onChanged` | `ValueChanged<double>?` | required | Change callback; `null` disables |
| `min` | `double` | `0.0` | Minimum value |
| `max` | `double` | `1.0` | Maximum value |
| `divisions` | `int?` | `null` | Number of discrete divisions |

Material: `Slider`. Cupertino: `CupertinoSlider`.

## Navigation

### DmAppBar

Adaptive app bar that implements `PreferredSizeWidget`, so it works with `Scaffold(appBar:)`.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `title` | `Widget?` | `null` | Title widget |
| `leading` | `Widget?` | `null` | Leading widget (back button, etc.) |
| `actions` | `List<Widget>?` | `null` | Trailing action widgets |
| `automaticallyImplyLeading` | `bool` | `true` | Auto-show back button |

Material: `AppBar`. Cupertino: `CupertinoNavigationBar`.

### DmTabBar

Adaptive tab bar.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `tabs` | `List<DmTab>` | required | Tab entries |
| `selectedIndex` | `int` | `0` | Currently selected tab |
| `onChanged` | `ValueChanged<int>?` | `null` | Selection callback |

`DmTab` has `label` (required) and `icon` (optional).

Material: `TabBar` inside `DefaultTabController`. Cupertino: `CupertinoSlidingSegmentedControl`.

### DmBottomNav

Adaptive bottom navigation bar.

| Parameter | Type | Description |
|-----------|------|-------------|
| `destinations` | `List<DmNavDestination>` | Navigation items |
| `selectedIndex` | `int` | Currently selected index |
| `onDestinationSelected` | `ValueChanged<int>` | Selection callback |

`DmNavDestination` has `icon` (required `Widget`), `label` (required `String`), and `selectedIcon` (optional `Widget`).

```dart
DmBottomNav(
  selectedIndex: 0,
  onDestinationSelected: (index) => setState(() => _index = index),
  destinations: [
    DmNavDestination(icon: Icon(Icons.home), label: 'Home'),
    DmNavDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ],
)
```

Material: `NavigationBar`. Cupertino: `CupertinoTabBar`.

### DmDrawer

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget?` | Drawer content |
| `width` | `double?` | Optional fixed width (default 304 on Cupertino) |

## Layout

### DmCard

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget?` | Card content |
| `elevation` | `double?` | Shadow depth |
| `margin` | `EdgeInsetsGeometry?` | Outer margin |
| `padding` | `EdgeInsetsGeometry?` | Inner padding applied to child |

Material: `Card`. Cupertino: `Container` with rounded corners and box shadow.

### DmDivider

| Parameter | Type | Description |
|-----------|------|-------------|
| `height` | `double?` | Total vertical space |
| `thickness` | `double?` | Line thickness |
| `indent` | `double?` | Leading indent |
| `endIndent` | `double?` | Trailing indent |
| `color` | `Color?` | Line color |

## Data Display

### DmAvatar

| Parameter | Type | Description |
|-----------|------|-------------|
| `child` | `Widget?` | Fallback content (e.g., initials) |
| `backgroundImage` | `ImageProvider?` | Background image |
| `backgroundColor` | `Color?` | Background color |
| `radius` | `double?` | Circle radius |

### DmBadge

| Parameter | Type | Description |
|-----------|------|-------------|
| `label` | `String?` | Badge text |
| `child` | `Widget?` | Widget the badge is attached to |
| `backgroundColor` | `Color?` | Badge color |
| `textColor` | `Color?` | Label text color |

### DmChip

Renders as a `FilterChip` when `onSelected` is provided, otherwise a plain `Chip`.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `label` | `Widget` | required | Chip content |
| `avatar` | `Widget?` | `null` | Leading avatar |
| `onDeleted` | `VoidCallback?` | `null` | Delete callback |
| `selected` | `bool` | `false` | Selection state |
| `onSelected` | `ValueChanged<bool>?` | `null` | Selection callback (enables filter mode) |

## Scaffold

### DmScaffold

A wrapper around `AdaptiveScaffold` from `flutter_adaptive_scaffold` that provides responsive navigation (bottom bar on small screens, rail on medium, extended rail on large).

```dart
DmScaffold(
  destinations: const [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ],
  selectedIndex: _index,
  onSelectedIndexChange: (i) => setState(() => _index = i),
  smallBody: (_) => const MobileView(),
  body: (_) => const TabletView(),
  largeBody: (_) => const DesktopView(),
  secondaryBody: (_) => const DetailPanel(),
  bodyRatio: 0.5,
)
```

Breakpoint constants: `DmScaffold.smallBreakpoint`, `.mediumBreakpoint`, `.mediumLargeBreakpoint`, `.largeBreakpoint`, `.extraLargeBreakpoint`, `.drawerBreakpoint`.

### DmActionList

Renders a list of `DmAction` items in one of three visual sizes.

| Size | Rendering |
|------|-----------|
| `DmActionSize.small` | `PopupMenuButton` overflow menu |
| `DmActionSize.medium` | Icon-only `IconButton`s |
| `DmActionSize.large` | `TextButton.icon` with labels |

```dart
DmActionList(
  size: DmActionSize.medium,
  actions: [
    DmAction(title: 'Edit', icon: Icons.edit, onPressed: () {}),
    DmAction(title: 'Delete', icon: Icons.delete, onPressed: () {}),
  ],
)
```

When `hideDisabled` is `true` (default), disabled actions are removed entirely.

## Custom Adaptive Widgets

Create your own adaptive widgets using the `AdaptiveWidget` mixin:

```dart
class MyWidget extends StatelessWidget with AdaptiveWidget {
  const MyWidget({super.key, this.platformOverride});

  @override
  final DmPlatformStyle? platformOverride;

  @override
  Widget build(BuildContext context) {
    return switch (resolveStyle(context)) {
      DmPlatformStyle.material => const Text('Material'),
      DmPlatformStyle.cupertino => const Text('Cupertino'),
    };
  }
}
```

The mixin provides `resolveStyle(context)` which handles the three-tier priority system automatically.
