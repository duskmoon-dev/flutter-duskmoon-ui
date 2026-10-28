# duskmoon_widgets

Adaptive widget library for the DuskMoon Design System. Includes platform-aware widgets plus chat components for LLM-style conversations.

## Installation

```bash
flutter pub add duskmoon_widgets
```

## Usage

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart';

// Buttons
DmButton(
  variant: DmButtonVariant.filled,
  onPressed: () {},
  child: const Text('Submit'),
);

// Inputs
DmTextField(placeholder: 'Enter text');
DmSwitch(value: true, onChanged: (v) {});

// Navigation
DmAppBar(title: const Text('Home'));

// Chat
DmChatView(
  messages: const [],
  onSend: (text, attachments) {},
);
```

`DmChatView` includes a leading rail with one tick per user message. Click a
tick to jump to that turn, or hover/focus it to preview the prompt and reply.
The rail stays vertically centered with compact spacing that adapts to the
message count and available height. On touchscreens, press anywhere in its
48-pixel-wide hit area and slide to highlight a turn and preview its abbreviated
prompt and reply in a popover; release to jump once and dismiss the preview.
Holding near either edge reveals more markers in long histories. Lifting a
finger commits the candidate; a cancelled touch does not jump. Mouse wheel
scrolling and keyboard activation remain supported. Set
`showMessageNavigation: false` to hide it.

Distant turns appear directly once their position is resolved; nearby rendered
turns scroll into view. The current conversation remains visible during a
distant lookup.

Set `showInput: false` to omit the built-in composer when the application
provides its own input or displays the conversation on a companion screen.
Messages, navigation and scrolling remain available; `showInput` defaults to
`true` and can change at runtime.

`DmMarkdownInput` can be placed directly in a `SingleChildScrollView` or a
scrolling form. Its editor grows from `minLines` up to `maxLines`, and the preview
uses its content height. When the parent provides bounded height, the editor
fills that space and supports swiping between Write and Preview. Optional bottom
bars and line numbers work in either layout.

### Platform Resolution

Three-tier resolution order:

1. **Widget override** — `platformOverride` parameter on each widget
2. **DmPlatformOverride** — InheritedWidget for app-level override
3. **Theme.of(context).platform** — automatic platform detection

```dart
// Override globally
DmPlatformOverride(
  style: DmPlatformStyle.cupertino,
  child: MyApp(),
);

// Override per widget
DmButton(
  platformOverride: DmPlatformStyle.material,
  onPressed: () {},
  child: const Text('Always Material'),
);
```

### Available Widgets

| Category | Widgets |
|----------|---------|
| Scaffold | `DmScaffold`, `DmActionList` |
| Buttons | `DmButton`, `DmIconButton`, `DmFab` |
| Inputs | `DmTextField`, `DmCheckbox`, `DmSwitch`, `DmSlider` |
| Layout | `DmCard`, `DmDivider` |
| Navigation | `DmAppBar`, `DmBottomNav`, `DmTabBar`, `DmDrawer` |
| Data Display | `DmBadge`, `DmChip`, `DmAvatar` |
| Chat | `DmChatView`, `DmChatInput`, `DmChatBubble`, `DmChatTheme` |

## License

MIT for DuskMoon code. The private Markdown parser retains the Dart authors'
BSD-3-Clause license. The private native math renderer retains its Apache-2.0
license and KaTeX MIT notices, including bundled fonts. See
[THIRD_PARTY_LICENSES](THIRD_PARTY_LICENSES),
[Markdown provenance](lib/src/vendor/markdown/SOURCE.md) and
[math renderer provenance](lib/src/vendor/flutter_math/SOURCE.md).

## Gamepad controller views

Each model has its own implementation file under `lib/src/gamepad/`:
`dm_xbox_controller_view.dart`, `dm_ps5_controller_view.dart`, and
`dm_switch_pro_controller_view.dart`. Shared rendering and input handling live
in `dm_controller_view.dart`. Import the public `duskmoon_widgets.dart` library
(or `duskmoon_ui`) to use any model.

```dart
DmXboxControllerView(
  showTriggerIndicators: true,
  onLeftStickChanged: (position) {}, // Offset: +X right, +Y down
  onLeftTriggerChanged: (value) {}, // 0–1
  onPressedChanged: (button, pressed) {},
);
```

Use `DmControllerView(style: DmControllerStyle.dualSense)` for a configurable
view, or `DmXboxControllerView`, `DmPs5ControllerView`, and
`DmSwitchProControllerView`. These are also exported by `duskmoon_ui`.

Stick vectors are clamped to a unit circle. Drag in any direction; release or
cancel returns to center. Xbox/PS5 triggers increase while held and decrease
on release/cancel at one unit per second (one second for full travel). Pressing
again reverses from the current value. Switch Pro touch triggers are digital.
Left/right controls support simultaneous independent pointers. Existing digital
button contact callbacks remain separate from continuous values.

Pass `leftStick`, `rightStick`, `leftTrigger`, `rightTrigger`, and
`pressedButtons` to display hardware state; device mapping belongs in the app.
Local touch and trigger decay take visual precedence until finished, then the
external state is displayed. Controlled views should feed callback values back
into these properties. External values are clamped; non-finite values display
neutral. Wrap the view in `IgnorePointer` for read-only hardware monitoring.

Xbox/PS5 display vertical trigger meters with percentages at both sides.
Set `showTriggerIndicators: false` to hide them without changing the view's
size or input behavior. Switch Pro does not display analog trigger meters.
