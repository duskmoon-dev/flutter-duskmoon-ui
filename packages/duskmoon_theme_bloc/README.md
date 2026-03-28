# duskmoon_theme_bloc

BLoC for persisting DuskMoon theme selection (theme name + mode) via `SharedPreferences`. Opt-in package — not included in the `duskmoon_ui` umbrella.

## Installation

```bash
flutter pub add duskmoon_theme_bloc
```

## Usage

```dart
import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';

// Provide the bloc
BlocProvider(
  create: (_) => DmThemeBloc()..add(const DmSetTheme('sunshine')),
  child: BlocBuilder<DmThemeBloc, DmThemeState>(
    builder: (context, state) {
      return MaterialApp(
        themeMode: state.themeMode,
        // ... use state.themeName to resolve ThemeData
      );
    },
  ),
);

// Change theme mode
context.read<DmThemeBloc>().add(const DmSetThemeMode(ThemeMode.dark));
```

## License

MIT
