# Adaptive Widgets

The `duskmoon_widgets` package provides adaptive widgets plus Markdown, Chat, and Code Editor widgets. The adaptive widgets automatically render Material, Cupertino, or Fluent variants based on the current platform.

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
- [Chat](#chat)
- [Code Editor](#code-editor)
- [Custom Adaptive Widgets](#custom-adaptive-widgets)

## Installation

```yaml
dependencies:
  duskmoon_widgets: ^1.6.0
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

### DmDropdown

Adaptive dropdown that renders platform-appropriate selection UI. Generic over the value type `T`.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `items` | `List<DmDropdownItem<T>>` | required | Selectable items |
| `onChanged` | `ValueChanged<T?>?` | required | Selection callback |
| `value` | `T?` | `null` | Currently selected value |
| `placeholder` | `String?` | `null` | Placeholder text when no item is selected |
| `isExpanded` | `bool` | `true` | Whether the dropdown expands to fill its parent width |
| `platformOverride` | `DmPlatformStyle?` | `null` | Per-widget platform override |

`DmDropdownItem<T>` has `value` (required `T`) and `child` (required `Widget`).

```dart
DmDropdown<String>(
  items: [
    DmDropdownItem(value: 'a', child: Text('Option A')),
    DmDropdownItem(value: 'b', child: Text('Option B')),
  ],
  value: 'a',
  onChanged: (value) {},
  placeholder: 'Select an option',
)
```

Material: `DropdownButton`. Cupertino: button that opens a `CupertinoPicker` modal. Fluent: `ComboBox`.

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

Read-only markdown renderer with GFM, KaTeX, optional Mermaid, and syntax highlighting support. Three input modes: `data` (String), `nodes` (`List<md.Node>`), and `stream` (`Stream<String>` for LLM output).

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `data` | `String?` | `null` | Markdown source string |
| `nodes` | `List<md.Node>?` | `null` | Pre-parsed markdown nodes |
| `stream` | `Stream<String>?` | `null` | Streaming markdown (e.g., LLM output) |
| `config` | `DmMarkdownConfig` | `const DmMarkdownConfig()` | Rendering configuration |
| `controller` | `ScrollController?` | `null` | Internal list controller; use `DmMarkdownScrollController` for anchor navigation |
| `selectable` | `bool` | `true` | Whether text is selectable |
| `shrinkWrap` | `bool` | `false` | Shrink-wrap the rendered content |
| `physics` | `ScrollPhysics?` | `null` | Scroll physics |
| `padding` | `EdgeInsetsGeometry?` | `null` | Content padding |
| `themeData` | `ThemeData?` | `null` | Theme override |
| `onLinkTap` | `void Function(String url, String? title)?` | `null` | Link tap callback; defaults to `url_launcher` |
| `onImageTap` | `void Function(String src, String? alt)?` | `null` | Image tap callback |
| `imageErrorBuilder` | `Widget Function(String src, String? alt)?` | `null` | Custom image failure widget |

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
| `enableMermaid` | `bool` | `false` | Mermaid diagram rendering; when disabled, Mermaid blocks render as code |
| `enableCodeHighlight` | `bool` | `true` | Syntax highlighting in code blocks |
| `codeTheme` | `String?` | `null` | Highlight theme name; when `null`, selected from brightness |
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
| `minLines` | `int` | `10` | Minimum lines |
| `readOnly` | `bool` | `false` | Read-only mode |
| `enabled` | `bool` | `true` | Whether interactive |
| `tabLabelWrite` | `String` | `'Write'` | Write tab label |
| `tabLabelPreview` | `String` | `'Preview'` | Preview tab label |
| `showPreview` | `bool` | `true` | Whether to show the preview tab; when false, only the editor is shown |
| `onLinkTap` | `void Function(String url, String? title)?` | `null` | Link tap callback in preview mode |
| `decoration` | `InputDecoration?` | `null` | Custom input decoration for the editor field |
| `bottom` | `Widget?` | `null` | Fully custom bottom bar; overrides `bottomLeft` and `bottomRight` |
| `bottomLeft` | `Widget?` | `null` | Widget placed on the left side of the built-in bottom bar |
| `bottomRight` | `Widget?` | `null` | Widget placed on the right side of the built-in bottom bar |

```dart
DmMarkdownInput(
  initialValue: '# Draft',
  initialTab: DmMarkdownTab.write,
  onChanged: (value) => print(value),
  showLineNumbers: true,
  minLines: 10,
  bottomLeft: const Text('Markdown'),
  bottomRight: IconButton(
    icon: const Icon(Icons.send),
    onPressed: () {},
  ),
)
```

### DmMarkdownInputController

Controller for `DmMarkdownInput` with helpers for formatting and insertion:

| Method | Description |
|--------|-------------|
| `wrapSelection(String marker)` | Toggle wrapping the selection, such as `**bold**` |
| `insertAtCursor(String content)` | Replace the current selection with content |
| `toggleLinePrefix(String prefix)` | Toggle line prefixes such as `# `, `> `, or `- ` |
| `insertCodeFence({String language = ''})` | Insert a fenced code block |
| `insertLink({String url = 'url'})` | Insert a markdown link |
| `appendMarkdown(String markdown)` | Append markdown at the end |

### DmMarkdownTab

Enum for the active tab: `DmMarkdownTab.write`, `DmMarkdownTab.preview`.

## Chat

The chat module provides LLM-style message models, markdown-rendered bubbles, attachment chips, tool-call blocks, a markdown composer, and a composed `DmChatView`.

### DmChatView

`DmChatView` renders a reverse chat list with pinned-to-bottom auto-scroll, an optional jump-to-bottom button, and a `DmChatInput` composer.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `messages` | `List<DmChatMessage>` | required | Ordered conversation messages |
| `onSend` | `DmChatSendCallback?` | `null` | Called with markdown and ready attachments |
| `onStop` | `VoidCallback?` | `null` | Called by the stop button while streaming |
| `onAttach` | `ValueChanged<List<DmChatAttachment>>?` | `null` | Enables the file picker and receives picked attachments |
| `onRetry` | `DmChatRetryCallback?` | `null` | Message-level retry callback |
| `uploadAdapter` | `DmChatUploadAdapter?` | `null` | Consumer-provided upload adapter type |
| `isStreaming` | `bool` | `false` | Toggles send/stop state |
| `inputController` | `DmMarkdownInputController?` | `null` | Composer controller |
| `inputPlaceholder` | `String` | `'Message…'` | Composer placeholder |
| `inputLeading` / `inputTrailing` | `Widget?` | `null` | Bottom-bar slots around attach/send controls |
| `inputMinLines` / `inputMaxLines` | `int` | `1` / `8` | Composer line limits |
| `submitShortcut` | `DmChatSubmitShortcut` | `cmdEnter` | Keyboard submit mode |
| `markdownConfig` | `DmMarkdownConfig` | `const DmMarkdownConfig()` | Markdown config for messages |
| `emptyBuilder` | `WidgetBuilder?` | `null` | Empty-state builder |
| `avatarBuilder` / `headerBuilder` | callback | `null` | Per-message avatar/header slots |
| `showJumpToBottom` | `bool` | `true` | Show jump button when unpinned |
| `autoScroll` | `bool` | `true` | Auto-scroll when pinned |
| `reverse` | `bool` | `true` | Reverse list behavior |
| `padding` | `EdgeInsets?` | `null` | Message list padding |
| `theme` | `DmChatTheme?` | `null` | Chat theme override |
| `pendingAttachments` | `List<DmChatAttachment>` | `const []` | Composer attachment chips |
| `onRemoveAttachment` | `ValueChanged<DmChatAttachment>?` | `null` | Remove/cancel/retry callback for pending chips |

```dart
DmChatView(
  messages: messages,
  inputPlaceholder: 'Ask about this file...',
  onAttach: (attachments) => setState(() => pending = attachments),
  pendingAttachments: pending,
  inputLeading: DropdownButton<String>(
    value: model,
    items: const [
      DropdownMenuItem(value: 'fast', child: Text('Fast')),
      DropdownMenuItem(value: 'deep', child: Text('Deep')),
    ],
    onChanged: (value) => setState(() => model = value!),
  ),
  avatarBuilder: (context, message) => switch (message.role) {
    DmChatRole.user => const DmAvatar(child: Text('U')),
    DmChatRole.assistant => const DmAvatar(child: Icon(Icons.auto_awesome)),
    DmChatRole.system => null,
  },
  headerBuilder: (context, message) => Text(message.role.name),
  onSend: (markdown, attachments) {},
)
```

### Message Models

```dart
const DmChatMessage(
  id: 'u1',
  role: DmChatRole.user,
  blocks: [
    DmChatTextBlock(text: 'Summarize this **markdown**.'),
  ],
)
```

| Type | Constructor / Values |
|------|----------------------|
| `DmChatRole` | `user`, `assistant`, `system` |
| `DmChatMessageStatus` | `pending`, `streaming`, `complete`, `error` |
| `DmChatMessage` | `id`, `role`, `blocks`, optional `status`, `error`, `createdAt`; includes `copyWith()` |
| `DmChatBlock` | Sealed base for all content blocks |
| `DmChatTextBlock` | `text` or `stream`; exactly one is required |
| `DmChatThinkingBlock` | `text` or `stream`, optional `elapsed`; collapsible reasoning content |
| `DmChatToolCallBlock` | `id`, `name`, optional `input`, `output`, `status`, `errorMessage`; includes `copyWith()` |
| `DmChatToolCallStatus` | `pending`, `running`, `done`, `error` |
| `DmChatAttachmentBlock` | One or more `DmChatAttachment` values |
| `DmChatCustomBlock` | `kind` plus optional `data`; rendered through `DmChatTheme.customBuilders` |

### Attachments

```dart
DmChatAttachment(
  id: 'file-1',
  name: 'notes.md',
  sizeBytes: 2048,
  mimeType: 'text/markdown',
  status: DmChatAttachmentStatus.done,
)
```

| Type | Description |
|------|-------------|
| `DmChatAttachmentStatus` | `idle`, `uploading`, `done`, `error` |
| `DmChatAttachment` | `id`, `name`, optional `sizeBytes`, `mimeType`, `url`, `bytes`, `status`, `uploadProgress`, `errorMessage`; includes `copyWith()` |
| `DmChatUploadAdapter` | Consumer interface with `upload(DmChatAttachment local)` and `cancel(String attachmentId)` |

`DmChatInput`'s attach button returns picked files through `onAttach`; applications own upload state and pass current chips back through `pendingAttachments`.

### DmChatInput

Markdown composer built on `DmMarkdownInput`.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `onSend` | `DmChatSendCallback` | required | Sends current markdown plus `done` attachments |
| `onStop` | `VoidCallback?` | `null` | Stop callback while streaming |
| `onAttach` | `ValueChanged<List<DmChatAttachment>>?` | `null` | Shows file picker when non-null |
| `uploadAdapter` | `DmChatUploadAdapter?` | `null` | Upload adapter type available to consumers |
| `controller` | `DmMarkdownInputController?` | `null` | Composer controller |
| `isStreaming` | `bool` | `false` | Shows stop action and disables send |
| `pendingAttachments` | `List<DmChatAttachment>` | `const []` | Attachment chips above the editor |
| `onRemoveAttachment` | `ValueChanged<DmChatAttachment>?` | `null` | Remove/cancel/retry callback |
| `placeholder` | `String?` | `null` | Input hint |
| `leading` / `trailing` | `Widget?` | `null` | Bottom-bar slots |
| `minLines` / `maxLines` | `int` | `1` / `8` | Markdown input line limits |
| `submitShortcut` | `DmChatSubmitShortcut` | `cmdEnter` | Keyboard submit mode |

`DmChatSubmitShortcut.cmdEnter` uses Cmd+Enter on macOS/iOS and Ctrl+Enter elsewhere. `DmChatSubmitShortcut.enter` submits on Enter and leaves Shift+Enter for new lines.

### Block Views And Theme

Public block renderers are available when you need to compose custom bubbles:

- `DmChatThinkingBlockView(block, config)`
- `DmChatToolCallBlockView(block, config)`
- `DmChatAttachmentBlockView(block, onTap, onRetry, onCancel)`

`DmChatTheme` is a `ThemeExtension` covering bubble colors, thinking/tool-call surfaces, attachment chip styles, composer surface, custom block builders, and fallback avatars.

```dart
Theme(
  data: Theme.of(context).copyWith(
    extensions: [
      DmChatTheme.withContext(context).copyWith(
        userBubbleMaxWidthFraction: 0.72,
      ),
    ],
  ),
  child: DmChatView(messages: messages),
)
```

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
