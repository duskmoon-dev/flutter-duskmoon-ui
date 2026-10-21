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
48-pixel-wide hit area and slide to highlight a turn; release to jump once.
Holding near either edge reveals more markers in long histories. Lifting a
finger commits the candidate; a cancelled touch does not jump. Mouse wheel
scrolling and keyboard activation remain supported. Set
`showMessageNavigation: false` to hide it.

Set `showInput: false` to omit the built-in composer when the application
provides its own input or displays the conversation on a companion screen.
Messages, navigation and scrolling remain available; `showInput` defaults to
`true` and can change at runtime.

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
