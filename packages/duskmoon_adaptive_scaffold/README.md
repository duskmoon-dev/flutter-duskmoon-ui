# duskmoon_adaptive_scaffold

Adaptive scaffold widgets for the DuskMoon Design System, forked from `flutter_adaptive_scaffold`.

## Features

- `AdaptiveScaffold` — adaptive layout that adjusts to screen size using Material 3 navigation patterns
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

AdaptiveScaffold(
  destinations: const [
    NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
    NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
  ],
  body: (_) => const Center(child: Text('Body')),
)
```

## Additional information

Part of the [DuskMoon UI](https://github.com/duskmoon-dev/flutter_duskmoon_ui) design system.
