# duskmoon_theme_bloc

BLoC for persisting DuskMoon theme selection (theme name + mode) via shared preferences. Opt-in package — not included in the `duskmoon_ui` umbrella.

## Installation

```bash
flutter pub add duskmoon_theme_bloc
```

## Usage

```dart
import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Await hydration before showing the app.
final themeBloc = await DmThemeBloc.fromAsync(
  prefs: SharedPreferencesAsync(),
);

// Provide the restored bloc. BlocProvider owns and closes it.
BlocProvider(
  create: (_) => themeBloc,
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

For a synchronous local cache, initialize it first and use `withCache`:

```dart
final prefs = await SharedPreferencesWithCache.create(
  cacheOptions: const SharedPreferencesWithCacheOptions(
    allowList: {'dm_theme_name', 'dm_theme_mode'},
  ),
);
final bloc = DmThemeBloc.withCache(prefs: prefs);
```

Existing applications can keep their legacy constructor and persisted values:

```dart
final prefs = await SharedPreferences.getInstance();
final bloc = DmThemeBloc(prefs: prefs);
```

All three entry points use `dm_theme_name` and `dm_theme_mode`. State changes
appear immediately, while writes are serialized so rapid changes persist in
order. Write failures are reported through the BLoC error handler; later writes
can still succeed.

### Migrating existing applications

Switching APIs does not migrate the platform store. Applications must choose
their platform backend and migrate existing values before constructing a modern
bloc. Follow the [shared_preferences migration guidance](https://pub.dev/packages/shared_preferences#migrating-from-sharedpreferences-to-sharedpreferencesasyncwithcache)
and test upgrades from an installed version, especially on Windows where
[legacy/async coexistence can lose keys](https://github.com/flutter/flutter/issues/192759).
The showcase keeps its legacy constructor until its application migration is
validated. New installations may use the async example directly.

## License

MIT
