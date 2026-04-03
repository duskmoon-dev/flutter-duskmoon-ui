import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmColors', () {
    test('sunshine() has colorScheme matching DmColorScheme.sunshine()', () {
      final colors = DmColors.sunshine();
      expect(colors.colorScheme.brightness, Brightness.light);
      expect(colors.colorScheme.primary, const Color(0xFF6750A4));
    });

    test('moonlight() has colorScheme matching DmColorScheme.moonlight()', () {
      final colors = DmColors.moonlight();
      expect(colors.colorScheme.brightness, Brightness.dark);
      expect(colors.colorScheme.primary, const Color(0xFFD0BCFF));
    });

    test('sunshine() extension matches DmColorExtension.sunshine()', () {
      final colors = DmColors.sunshine();
      expect(colors.extension.accent, const Color(0xFF8B5CF6));
      expect(colors.extension.info, const Color(0xFF2196F3));
    });

    test('moonlight() extension matches DmColorExtension.moonlight()', () {
      final colors = DmColors.moonlight();
      expect(colors.extension.accent, const Color(0xFFA78BFA));
    });
  });

  group('DmTheme', () {
    test('sunshine has name == "sunshine"', () {
      expect(DmTheme.sunshine.name, 'sunshine');
    });

    test('moonlight has name == "moonlight"', () {
      expect(DmTheme.moonlight.name, 'moonlight');
    });

    test('all has length 2', () {
      expect(DmTheme.all.length, 2);
    });

    test('all contains sunshine and moonlight', () {
      expect(DmTheme.all, contains(DmTheme.sunshine));
      expect(DmTheme.all, contains(DmTheme.moonlight));
    });

    test('sunshine.colors.colorScheme.primary matches DmColorScheme.sunshine()', () {
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
      expect(ext!.accent, const Color(0xFF8B5CF6));
    });
  });
}
