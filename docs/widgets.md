# Adaptive Widgets

The `duskmoon_widgets` package provides 18 adaptive widgets plus Markdown and Code Editor widgets. The adaptive widgets automatically render Material, Cupertino, or Fluent variants based on the current platform.

## Table of Contents

- [Installation](#installation)
- [Platform Resolution](#platform-resolution)
- [Buttons](#buttons)
- [Inputs](#inputs)
- [Navigation](#navigation)
- [Layout](#layout)
- [Data Display](#data-display)
- [Scaffold](#scaffold)
- [Markdown](#markdown)
- [Code Editor](#code-editor)
- [Custom Adaptive Widgets](#custom-adaptive-widgets)

## Installation

```yaml
dependencies:
  duskmoon_widgets: ^1.3.0
```

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
```

Or use the umbrella `duskmoon_ui` package.

## Platform Resolution

Widgets determine their rendering style using a four-tier priority system:

1. **Widget `platformOverride`** parameter — per-instance (highest priority)
2. **`DmPlatformOverride` InheritedWidget** — subtree-level
3. **`DuskmoonApp` ancestor** — app-level platform style
4. **`Theme.of(context).platform`** — theme default

Windows defaults to `fluent`.

### DmPlatformStyle

```dart
enum DmPlatformStyle { material, cupertino, fluent }
```

### DuskmoonApp

App-level InheritedWidget that sets the default platform style for all descendant Dm* widgets.

```dart
DuskmoonApp(
  platformStyle: DmPlatformStyle.cupertino, // or null for auto-detect
  child: MaterialApp(...),
)
```

Static method: `DuskmoonApp.maybeStyleOf(context)` returns `DmPlatformStyle?`.

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

> **Note:** `DmChip` always uses Material widgets regardless of platform — it does not have a Cupertino variant.

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
  appBarBreakpoint: null,  // Optional: breakpoint above which the app bar is shown
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

## Markdown

### DmMarkdown

Read-only markdown renderer with GFM, KaTeX, Mermaid, and syntax highlighting support. Three input modes: `data` (String), `nodes` (List<md.Node>), and `stream` (Stream<String> for LLM output).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `String?` | `null` | Markdown source string |
| `nodes` | `List<md.Node>?` | `null` | Pre-parsed markdown nodes |
| `stream` | `Stream<String>?` | `null` | Streaming markdown (e.g., LLM output) |
| `config` | `DmMarkdownConfig?` | `null` | Rendering configuration |
| `selectable` | `bool` | `false` | Whether text is selectable |
| `shrinkWrap` | `bool` | `false` | Shrink-wrap the rendered content |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics |
| `padding` | `EdgeInsetsGeometry?` | `null` | Content padding |
| `themeData` | `MarkdownThemeData?` | `null` | Theme override |
| `onLinkTap` | `ValueChanged<String>?` | `null` | Link tap callback |
| `onImageTap` | `ValueChanged<String>?` | `null` | Image tap callback |

```dart
DmMarkdown(
  data: '# Hello\n\nWorld',
  selectable: true,
  config: DmMarkdownConfig(enableGfm: true, enableKatex: true),
  onLinkTap: (url) => launchUrl(Uri.parse(url)),
)
```

### DmMarkdownConfig

Configuration for markdown rendering features.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enableGfm` | `bool` | `true` | GitHub Flavored Markdown |
| `enableKatex` | `bool` | `true` | LaTeX math rendering |
| `enableMermaid` | `bool` | `true` | Mermaid diagram rendering |
| `enableCodeHighlight` | `bool` | `true` | Syntax highlighting in code blocks |
| `codeTheme` | `CodeTheme?` | `null` | Code block theme |
| `blockBuilders` | `Map?` | `null` | Custom block builders |
| `inlineBuilders` | `Map?` | `null` | Custom inline builders |

### DmMarkdownScrollController

Controller for scroll-to-anchor navigation within rendered markdown content.

### DmMarkdownInput

Markdown editor with write/preview tabs.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `controller` | `DmMarkdownInputController?` | `null` | Editor controller |
| `initialValue` | `String?` | `null` | Initial markdown content |
| `config` | `DmMarkdownConfig?` | `null` | Markdown config for preview |
| `initialTab` | `DmMarkdownTab` | `write` | Starting tab |
| `onChanged` | `ValueChanged<String>?` | `null` | Content change callback |
| `onTabChanged` | `ValueChanged<DmMarkdownTab>?` | `null` | Tab switch callback |
| `showLineNumbers` | `bool` | `false` | Show line numbers |
| `maxLines` | `int?` | `null` | Maximum lines |
| `minLines` | `int?` | `null` | Minimum lines |
| `readOnly` | `bool` | `false` | Read-only mode |
| `enabled` | `bool` | `true` | Whether interactive |
| `tabLabelWrite` | `String` | `'Write'` | Write tab label |
| `tabLabelPreview` | `String` | `'Preview'` | Preview tab label |
| `decoration` | `InputDecoration?` | `null` | Input decoration |

```dart
DmMarkdownInput(
  initialValue: '# Draft',
  initialTab: DmMarkdownTab.write,
  onChanged: (value) => print(value),
  showLineNumbers: true,
  minLines: 5,
)
```

### DmMarkdownInputController

Controller for `DmMarkdownInput` with helper methods such as `wrapSelection()` for formatting selected text (bold, italic, etc.).

### DmMarkdownTab

Enum for the active tab: `DmMarkdownTab.write`, `DmMarkdownTab.preview`.

## Code Editor

### DmCodeEditor

Code editor widget integrating `duskmoon_code_engine`. Supports 19 languages by name string.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `initialDoc` | `String` | `''` | Initial document content |
| `language` | `String?` | `null` | Language name (e.g., `'dart'`, `'python'`) |
| `theme` | `EditorTheme?` | `null` | Editor theme |
| `readOnly` | `bool` | `false` | Read-only mode |
| `lineNumbers` | `bool` | `true` | Show line numbers |
| `highlightActiveLine` | `bool` | `true` | Highlight current line |
| `onChanged` | `ValueChanged<String>?` | `null` | Document change callback |
| `onStateChanged` | `ValueChanged<EditorState>?` | `null` | State change callback |
| `controller` | `EditorViewController?` | `null` | Programmatic controller |
| `focusNode` | `FocusNode?` | `null` | Focus node |
| `autofocus` | `bool` | `false` | Auto-focus on mount |
| `minHeight` | `double?` | `null` | Minimum height |
| `maxHeight` | `double?` | `null` | Maximum height |
| `padding` | `EdgeInsetsGeometry?` | `null` | Content padding |
| `scrollPhysics` | `ScrollPhysics?` | `null` | Scroll physics |

Supported languages: Dart, JavaScript, TypeScript, Python, HTML, CSS, JSON, Markdown, Rust, Go, YAML, C, C++, Elixir, Java, Kotlin, PHP, Ruby, Erlang, Swift, Zig.

```dart
DmCodeEditor(
  initialDoc: 'void main() {\n  print("Hello");\n}',
  language: 'dart',
  theme: DmCodeEditorTheme.fromContext(context),
  lineNumbers: true,
  onChanged: (doc) => print(doc),
)
```

### DmCodeEditorTheme

`abstract final class` with a static factory for deriving an editor theme from the current build context.

```dart
final theme = DmCodeEditorTheme.fromContext(context); // returns EditorTheme
```

### Re-exports from duskmoon_code_engine

- `EditorViewController` -- controller for programmatic editor manipulation
- `EditorState` -- immutable editor state snapshot
- `EditorTheme` -- theme data for the code editor

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
      DmPlatformStyle.fluent => const Text('Fluent'),
    };
  }
}
```

The mixin provides `resolveStyle(context)` which handles the four-tier priority system automatically.
