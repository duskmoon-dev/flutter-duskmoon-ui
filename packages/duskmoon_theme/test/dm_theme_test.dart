import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmColors', () {
    test('sunshine() has colorScheme matching DmColorScheme.sunshine()', () {
      final colors = DmColors.sunshine();
      expect(colors.colorScheme.brightness, Brightness.light);
      expect(colors.colorScheme.primary, SunshineTokens.primary);
    });

    test('moonlight() has colorScheme matching DmColorScheme.moonlight()', () {
      final colors = DmColors.moonlight();
      expect(colors.colorScheme.brightness, Brightness.dark);
      expect(colors.colorScheme.primary, MoonlightTokens.primary);
    });

    test('sunshine() extension matches DmColorExtension.sunshine()', () {
      final colors = DmColors.sunshine();
      expect(colors.extension.accent, SunshineTokens.accent);
      expect(colors.extension.info, SunshineTokens.info);
    });

    test('moonlight() extension matches DmColorExtension.moonlight()', () {
      final colors = DmColors.moonlight();
      expect(colors.extension.accent, MoonlightTokens.accent);
    });

    test('forest() has colorScheme matching DmColorScheme.forest()', () {
      final colors = DmColors.forest();
      expect(colors.colorScheme.brightness, Brightness.light);
      expect(colors.colorScheme.primary, ForestTokens.primary);
    });

    test('ocean() has colorScheme matching DmColorScheme.ocean()', () {
      final colors = DmColors.ocean();
      expect(colors.colorScheme.brightness, Brightness.dark);
      expect(colors.colorScheme.primary, OceanTokens.primary);
    });
  });

  group('DmTheme', () {
    test('sunshine has name == "sunshine"', () {
      expect(DmTheme.sunshine.name, 'sunshine');
    });

    test('moonlight has name == "moonlight"', () {
      expect(DmTheme.moonlight.name, 'moonlight');
    });

    test('all has length 4', () {
      expect(DmTheme.all.length, 4);
    });

    test('all contains all themes', () {
      expect(DmTheme.all, contains(DmTheme.sunshine));
      expect(DmTheme.all, contains(DmTheme.moonlight));
      expect(DmTheme.all, contains(DmTheme.forest));
      expect(DmTheme.all, contains(DmTheme.ocean));
    });

    test('sunshine.colors.colorScheme.primary matches DmColorScheme.sunshine()',
        () {
      expect(
        DmTheme.sunshine.colors.colorScheme.primary,
        DmColors.sunshine().colorScheme.primary,
      );
    });
  });

  group('DmThemeData.fromDmTheme', () {
    test('fromDmTheme(DmTheme.sunshine) has same primary as sunshine()', () {
      final fromDm = DmThemeData.fromDmTheme(DmTheme.sunshine);
      final direct = DmThemeData.sunshine();
      expect(fromDm.colorScheme.primary, direct.colorScheme.primary);
      expect(fromDm.colorScheme.brightness, direct.colorScheme.brightness);
    });

    test('fromDmTheme(DmTheme.moonlight) has same primary as moonlight()', () {
      final fromDm = DmThemeData.fromDmTheme(DmTheme.moonlight);
      final direct = DmThemeData.moonlight();
      expect(fromDm.colorScheme.primary, direct.colorScheme.primary);
      expect(fromDm.colorScheme.brightness, direct.colorScheme.brightness);
    });

    test('fromDmTheme includes DmColorExtension', () {
      final theme = DmThemeData.fromDmTheme(DmTheme.sunshine);
      final ext = theme.extension<DmColorExtension>();
      expect(ext, isNotNull);
      expect(ext!.accent, SunshineTokens.accent);
    });
  });
}
