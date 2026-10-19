import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';

void main() {
  late SharedPreferencesAsyncPlatform? previousPlatform;

  setUp(() {
    previousPlatform = SharedPreferencesAsyncPlatform.instance;
    SharedPreferencesAsyncPlatform.instance =
        InMemorySharedPreferencesAsync.empty();
  });

  tearDown(() {
    SharedPreferencesAsyncPlatform.instance = previousPlatform;
  });

  test('async preferences hydrate before the bloc is returned', () async {
    final prefs = SharedPreferencesAsync();
    await prefs.setString('dm_theme_name', 'sunshine');
    await prefs.setString('dm_theme_mode', 'dark');

    final bloc = await DmThemeBloc.fromAsync(prefs: prefs);
    expect(bloc.state.themeName, 'sunshine');
    expect(bloc.state.themeMode, ThemeMode.dark);
    await bloc.close();
  });

  test('async preferences retain defaults for absent keys', () async {
    final bloc = await DmThemeBloc.fromAsync(prefs: SharedPreferencesAsync());
    expect(bloc.state.themeName, DmThemeData.themes.first.name);
    expect(bloc.state.themeMode, ThemeMode.system);
    await bloc.close();
  });

  test('cache preferences hydrate and persist both theme keys', () async {
    final backend = SharedPreferencesAsync();
    await backend.setString('dm_theme_name', 'sunshine');
    await backend.setString('dm_theme_mode', 'dark');
    final prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        allowList: {'dm_theme_name', 'dm_theme_mode'},
      ),
    );
    final bloc = DmThemeBloc.withCache(prefs: prefs);
    expect(bloc.state.themeName, 'sunshine');
    expect(bloc.state.themeMode, ThemeMode.dark);

    bloc
      ..add(const DmSetTheme('duskmoon'))
      ..add(const DmSetThemeMode(ThemeMode.light));
    await bloc.close();

    expect(prefs.getString('dm_theme_name'), 'duskmoon');
    expect(prefs.getString('dm_theme_mode'), 'light');
    expect(await backend.getString('dm_theme_name'), 'duskmoon');
    expect(await backend.getString('dm_theme_mode'), 'light');
  });

  test('rapid changes render immediately and persist in event order', () async {
    final prefs = _DelayedPreferences();
    final bloc = await DmThemeBloc.fromAsync(prefs: prefs);
    final states = bloc.stream.take(3).toList();
    bloc
      ..add(const DmSetThemeMode(ThemeMode.dark))
      ..add(const DmSetTheme('sunshine'))
      ..add(const DmSetThemeMode(ThemeMode.light));
    await prefs.writeStarted.future;
    final emitted = await states;

    expect(emitted.last.themeName, 'sunshine');
    expect(emitted.last.themeMode, ThemeMode.light);
    expect(prefs.writes, ['dm_theme_mode=dark']);

    prefs.releaseWrite.complete();
    await bloc.close();

    expect(prefs.writes, [
      'dm_theme_mode=dark',
      'dm_theme_name=sunshine',
      'dm_theme_mode=light',
    ]);
    expect(await prefs.getString('dm_theme_mode'), 'light');
    expect(await prefs.getString('dm_theme_name'), 'sunshine');
  });

  test('closing waits for queued preference writes to finish', () async {
    final prefs = _DelayedPreferences();
    final bloc = await DmThemeBloc.fromAsync(prefs: prefs);
    bloc
      ..add(const DmSetTheme('sunshine'))
      ..add(const DmSetThemeMode(ThemeMode.dark));
    await prefs.writeStarted.future;

    var closed = false;
    final closing = bloc.close().then((_) => closed = true);
    await Future<void>.delayed(Duration.zero);
    expect(closed, isFalse);

    prefs.releaseWrite.complete();
    await closing;
    expect(await prefs.getString('dm_theme_name'), 'sunshine');
    expect(await prefs.getString('dm_theme_mode'), 'dark');
  });

  late _FailingPreferences failingPrefs;
  late DmThemeBloc failingBloc;
  blocTest<DmThemeBloc, DmThemeState>(
    'a failed write reports its error and does not stop later persistence',
    setUp: () async {
      failingPrefs = _FailingPreferences();
      failingBloc = await DmThemeBloc.fromAsync(prefs: failingPrefs);
    },
    build: () => failingBloc,
    act: (bloc) => bloc
      ..add(const DmSetTheme('first'))
      ..add(const DmSetTheme('last')),
    expect: () => [
      isA<DmThemeState>().having((state) => state.themeName, 'name', 'first'),
      isA<DmThemeState>().having((state) => state.themeName, 'name', 'last'),
    ],
    errors: () => [isA<StateError>()],
    verify: (_) async {
      expect(failingPrefs.writes, hasLength(2));
      expect(await failingPrefs.getString('dm_theme_name'), 'last');
    },
  );
}

class _DelayedPreferences extends SharedPreferencesAsync {
  final writeStarted = Completer<void>();
  final releaseWrite = Completer<void>();
  final writes = <String>[];

  @override
  Future<void> setString(String key, String value) async {
    writes.add('$key=$value');
    if (writes.length == 1) {
      writeStarted.complete();
      await releaseWrite.future;
    }
    await super.setString(key, value);
  }
}

class _FailingPreferences extends SharedPreferencesAsync {
  final writes = <String>[];

  @override
  Future<void> setString(String key, String value) async {
    writes.add('$key=$value');
    if (writes.length == 1) throw StateError('storage unavailable');
    await super.setString(key, value);
  }
}
