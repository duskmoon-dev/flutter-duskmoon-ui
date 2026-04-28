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

MIT
