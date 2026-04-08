import 'package:bloc_test/bloc_test.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('DmThemeState', () {
    test('props are themeName and themeMode', () {
      const state = DmThemeState(themeName: 'duskmoon');
      expect(state.props, ['duskmoon', ThemeMode.system]);
    });

    test('default themeMode is system', () {
      const state = DmThemeState(themeName: 'duskmoon');
      expect(state.themeMode, ThemeMode.system);
    });

    test('entry returns matching theme', () {
      const state = DmThemeState(themeName: 'duskmoon');
      expect(state.entry.name, 'duskmoon');
    });

    test('entry falls back to first theme for unknown name', () {
      const state = DmThemeState(themeName: 'nonexistent');
      expect(state.entry.name, DmThemeData.themes.first.name);
    });

    test('resolveTheme returns light for ThemeMode.light', () {
      const state = DmThemeState(
        themeName: 'sunshine',
        themeMode: ThemeMode.light,
      );
      final theme = state.resolveTheme(Brightness.dark);
      expect(theme.brightness, Brightness.light);
    });

    test('resolveTheme returns dark for ThemeMode.dark', () {
      const state = DmThemeState(
        themeName: 'sunshine',
        themeMode: ThemeMode.dark,
      );
      final theme = state.resolveTheme(Brightness.light);
      expect(theme.brightness, Brightness.dark);
    });

    test('resolveTheme follows platform brightness for ThemeMode.system', () {
      const state = DmThemeState(themeName: 'duskmoon');
      expect(
        state.resolveTheme(Brightness.light).brightness,
        Brightness.light,
      );
      expect(
        state.resolveTheme(Brightness.dark).brightness,
        Brightness.dark,
      );
    });

    test('copyWith creates new state with overrides', () {
      const state = DmThemeState(themeName: 'duskmoon');
      final updated = state.copyWith(themeMode: ThemeMode.dark);
      expect(updated.themeName, 'duskmoon');
      expect(updated.themeMode, ThemeMode.dark);
    });

    test('equality', () {
      const a = DmThemeState(themeName: 'sunshine');
      const b = DmThemeState(themeName: 'sunshine');
      const c = DmThemeState(themeName: 'sunshine', themeMode: ThemeMode.dark);
      expect(a, b);
      expect(a, isNot(c));
    });
  });

  group('DmThemeEvent', () {
    test('DmSetTheme props contain name', () {
      const event = DmSetTheme('sunshine');
      expect(event.props, ['sunshine']);
    });

    test('DmSetThemeMode props contain mode', () {
      const event = DmSetThemeMode(ThemeMode.dark);
      expect(event.props, [ThemeMode.dark]);
    });

    test('DmSetTheme equality', () {
      expect(const DmSetTheme('a'), const DmSetTheme('a'));
      expect(const DmSetTheme('a'), isNot(const DmSetTheme('b')));
    });

    test('DmSetThemeMode equality', () {
      expect(
        const DmSetThemeMode(ThemeMode.dark),
        const DmSetThemeMode(ThemeMode.dark),
      );
      expect(
        const DmSetThemeMode(ThemeMode.dark),
        isNot(const DmSetThemeMode(ThemeMode.light)),
      );
    });
  });

  group('DmThemeBloc', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
    });

    test('initial state uses first theme and system mode', () {
      final bloc = DmThemeBloc(prefs: prefs);
      expect(bloc.state.themeName, DmThemeData.themes.first.name);
      expect(bloc.state.themeMode, ThemeMode.system);
      bloc.close();
    });

    test('initial state hydrates from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'dm_theme_name': 'sunshine',
        'dm_theme_mode': 'dark',
      });
      prefs = await SharedPreferences.getInstance();

      final bloc = DmThemeBloc(prefs: prefs);
      expect(bloc.state.themeName, 'sunshine');
      expect(bloc.state.themeMode, ThemeMode.dark);
      bloc.close();
    });

    blocTest<DmThemeBloc, DmThemeState>(
      'DmSetTheme updates themeName and persists',
      build: () => DmThemeBloc(prefs: prefs),
      act: (bloc) => bloc.add(const DmSetTheme('duskmoon')),
      expect: () => [
        const DmThemeState(themeName: 'duskmoon'),
      ],
      verify: (_) {
        expect(prefs.getString('dm_theme_name'), 'duskmoon');
      },
    );

    blocTest<DmThemeBloc, DmThemeState>(
      'DmSetThemeMode updates themeMode and persists',
      build: () => DmThemeBloc(prefs: prefs),
      act: (bloc) => bloc.add(const DmSetThemeMode(ThemeMode.dark)),
      expect: () => [
        DmThemeState(
          themeName: DmThemeData.themes.first.name,
          themeMode: ThemeMode.dark,
        ),
      ],
      verify: (_) {
        expect(prefs.getString('dm_theme_mode'), 'dark');
      },
    );

    blocTest<DmThemeBloc, DmThemeState>(
      'multiple events produce correct sequence',
      build: () => DmThemeBloc(prefs: prefs),
      act: (bloc) {
        bloc
          ..add(const DmSetThemeMode(ThemeMode.light))
          ..add(const DmSetThemeMode(ThemeMode.dark));
      },
      expect: () => [
        DmThemeState(
          themeName: DmThemeData.themes.first.name,
          themeMode: ThemeMode.light,
        ),
        DmThemeState(
          themeName: DmThemeData.themes.first.name,
          themeMode: ThemeMode.dark,
        ),
      ],
    );
  });
}
