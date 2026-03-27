import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmColorScheme', () {
    test('sunshine() returns light ColorScheme with correct token values', () {
      final cs = DmColorScheme.sunshine();
      expect(cs.brightness, Brightness.light);
      expect(cs.primary, const Color(0xFF6750A4));
      expect(cs.onPrimary, const Color(0xFFFFFFFF));
      expect(cs.primaryContainer, const Color(0xFFEADDFF));
      expect(cs.onPrimaryContainer, const Color(0xFF21005D));
      expect(cs.secondary, const Color(0xFF625B71));
      expect(cs.onSecondary, const Color(0xFFFFFFFF));
      expect(cs.tertiary, const Color(0xFF7D5260));
      expect(cs.onTertiary, const Color(0xFFFFFFFF));
      expect(cs.error, const Color(0xFFB3261E));
      expect(cs.onError, const Color(0xFFFFFFFF));
      expect(cs.surface, const Color(0xFFFEF7FF));
      expect(cs.onSurface, const Color(0xFF1D1B20));
      expect(cs.outline, const Color(0xFF79747E));
      expect(cs.outlineVariant, const Color(0xFFCAC4D0));
      expect(cs.inverseSurface, const Color(0xFF322F35));
      expect(cs.onInverseSurface, const Color(0xFFF5EFF7));
      expect(cs.inversePrimary, const Color(0xFFD0BCFF));
      expect(cs.shadow, const Color(0xFF000000));
      expect(cs.scrim, const Color(0xFF000000));
    });

    test('moonlight() returns dark ColorScheme with correct token values', () {
      final cs = DmColorScheme.moonlight();
      expect(cs.brightness, Brightness.dark);
      expect(cs.primary, const Color(0xFFD0BCFF));
      expect(cs.onPrimary, const Color(0xFF381E72));
      expect(cs.primaryContainer, const Color(0xFF4F378B));
      expect(cs.secondary, const Color(0xFFCCC2DC));
      expect(cs.tertiary, const Color(0xFFEFB8C8));
      expect(cs.error, const Color(0xFFF2B8B5));
      expect(cs.surface, const Color(0xFF141218));
      expect(cs.onSurface, const Color(0xFFE6E0E9));
    });

    test('sunshine() and moonlight() have all surface container variants', () {
      final light = DmColorScheme.sunshine();
      expect(light.surfaceContainerLowest, const Color(0xFFFFFFFF));
      expect(light.surfaceContainerLow, const Color(0xFFF7F2FA));
      expect(light.surfaceContainer, const Color(0xFFF3EDF7));
      expect(light.surfaceContainerHigh, const Color(0xFFECE6F0));
      expect(light.surfaceContainerHighest, const Color(0xFFE6E0E9));

      final dark = DmColorScheme.moonlight();
      expect(dark.surfaceContainerLowest, const Color(0xFF0F0D13));
      expect(dark.surfaceContainerLow, const Color(0xFF1D1B20));
      expect(dark.surfaceContainer, const Color(0xFF211F26));
      expect(dark.surfaceContainerHigh, const Color(0xFF2B2930));
      expect(dark.surfaceContainerHighest, const Color(0xFF36343B));
    });
  });

  group('DmThemeData', () {
    test('sunshine() produces valid ThemeData', () {
      final theme = DmThemeData.sunshine();
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, const Color(0xFF6750A4));
    });

    test('moonlight() produces valid ThemeData', () {
      final theme = DmThemeData.moonlight();
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, const Color(0xFFD0BCFF));
    });

    test('sunshine() includes DmColorExtension', () {
      final theme = DmThemeData.sunshine();
      final ext = theme.extension<DmColorExtension>();
      expect(ext, isNotNull);
      expect(ext!.accent, const Color(0xFF8B5CF6));
      expect(ext.info, const Color(0xFF2196F3));
      expect(ext.success, const Color(0xFF4CAF50));
      expect(ext.warning, const Color(0xFFFF9800));
    });

    test('moonlight() includes DmColorExtension', () {
      final theme = DmThemeData.moonlight();
      final ext = theme.extension<DmColorExtension>();
      expect(ext, isNotNull);
      expect(ext!.accent, const Color(0xFFA78BFA));
      expect(ext.info, const Color(0xFF64B5F6));
      expect(ext.success, const Color(0xFF81C784));
      expect(ext.warning, const Color(0xFFFFB74D));
    });

    test('sunshine() has AppBar styling from tokens', () {
      final theme = DmThemeData.sunshine();
      expect(theme.appBarTheme.backgroundColor, const Color(0xFFFEF7FF));
      expect(theme.appBarTheme.foregroundColor, const Color(0xFF1D1B20));
      expect(theme.appBarTheme.elevation, 0);
    });

    test('sunshine() has NavigationRail styling from tokens', () {
      final theme = DmThemeData.sunshine();
      final rail = theme.navigationRailTheme;
      expect(rail.backgroundColor, const Color(0xFFF7F2FA));
      expect(rail.indicatorColor, const Color(0xFFE8DEF8));
    });

    test('sunshine() has NavigationBar styling from tokens', () {
      final theme = DmThemeData.sunshine();
      final nav = theme.navigationBarTheme;
      expect(nav.backgroundColor, const Color(0xFFF3EDF7));
      expect(nav.indicatorColor, const Color(0xFFE8DEF8));
    });

    test('themes returns list with sunshine entry', () {
      final themes = DmThemeData.themes;
      expect(themes, isNotEmpty);
      expect(themes.first.name, 'sunshine');
      expect(themes.first.light.colorScheme.brightness, Brightness.light);
      expect(themes.first.dark.colorScheme.brightness, Brightness.dark);
    });

    test('moonlight() has card elevation 0 for dark theme', () {
      final theme = DmThemeData.moonlight();
      expect(theme.cardTheme.elevation, 0);
    });

    test('sunshine() has card elevation 1 for light theme', () {
      final theme = DmThemeData.sunshine();
      expect(theme.cardTheme.elevation, 1);
    });
  });

  group('DmColorExtension', () {
    test('sunshine() has all 20 extended color tokens', () {
      final ext = DmColorExtension.sunshine();
      expect(ext.primaryFocus, const Color(0xFF7965AF));
      expect(ext.secondaryFocus, const Color(0xFF756D84));
      expect(ext.tertiaryFocus, const Color(0xFF926574));
      expect(ext.accent, const Color(0xFF8B5CF6));
      expect(ext.accentFocus, const Color(0xFF9F75F8));
      expect(ext.accentContent, const Color(0xFFFFFFFF));
      expect(ext.neutral, const Color(0xFF79747E));
      expect(ext.neutralFocus, const Color(0xFF8E8A93));
      expect(ext.neutralContent, const Color(0xFFFFFFFF));
      expect(ext.neutralVariant, const Color(0xFF49454F));
      expect(ext.info, const Color(0xFF2196F3));
      expect(ext.infoContent, const Color(0xFFFFFFFF));
      expect(ext.success, const Color(0xFF4CAF50));
      expect(ext.successContent, const Color(0xFFFFFFFF));
      expect(ext.warning, const Color(0xFFFF9800));
      expect(ext.warningContent, const Color(0xFFFFFFFF));
      expect(ext.base100, const Color(0xFFF5F5F5));
      expect(ext.base200, const Color(0xFFEEEEEE));
      expect(ext.base300, const Color(0xFFE0E0E0));
      expect(ext.baseContent, const Color(0xFF1D1B20));
    });

    test('copyWith returns new instance with overridden values', () {
      final ext = DmColorExtension.sunshine();
      final modified = ext.copyWith(accent: const Color(0xFF000000));
      expect(modified.accent, const Color(0xFF000000));
      expect(modified.info, ext.info);
    });

    test('lerp interpolates between sunshine and moonlight', () {
      final a = DmColorExtension.sunshine();
      final b = DmColorExtension.moonlight();
      final mid = a.lerp(b, 0.5);
      expect(mid.accent, isNot(a.accent));
      expect(mid.accent, isNot(b.accent));
    });

    test('lerp at 0.0 returns start values', () {
      final a = DmColorExtension.sunshine();
      final b = DmColorExtension.moonlight();
      final result = a.lerp(b, 0.0);
      expect(result.accent, a.accent);
    });

    test('lerp at 1.0 returns end values', () {
      final a = DmColorExtension.sunshine();
      final b = DmColorExtension.moonlight();
      final result = a.lerp(b, 1.0);
      expect(result.accent, b.accent);
    });
  });

  group('DmTextTheme', () {
    test('textTheme() has all 15 Material 3 text styles', () {
      final tt = DmTextTheme.textTheme();
      expect(tt.displayLarge, isNotNull);
      expect(tt.displayMedium, isNotNull);
      expect(tt.displaySmall, isNotNull);
      expect(tt.headlineLarge, isNotNull);
      expect(tt.headlineMedium, isNotNull);
      expect(tt.headlineSmall, isNotNull);
      expect(tt.titleLarge, isNotNull);
      expect(tt.titleMedium, isNotNull);
      expect(tt.titleSmall, isNotNull);
      expect(tt.bodyLarge, isNotNull);
      expect(tt.bodyMedium, isNotNull);
      expect(tt.bodySmall, isNotNull);
      expect(tt.labelLarge, isNotNull);
      expect(tt.labelMedium, isNotNull);
      expect(tt.labelSmall, isNotNull);
    });

    test('displayLarge has correct M3 spec values', () {
      final dl = DmTextTheme.textTheme().displayLarge!;
      expect(dl.fontSize, 57);
      expect(dl.fontWeight, FontWeight.w400);
      expect(dl.letterSpacing, -0.25);
    });
  });

  group('ThemeModeExtension', () {
    test('fromString parses light', () {
      expect(ThemeModeExtension.fromString('light'), ThemeMode.light);
    });

    test('fromString parses dark', () {
      expect(ThemeModeExtension.fromString('dark'), ThemeMode.dark);
    });

    test('fromString defaults to system for null', () {
      expect(ThemeModeExtension.fromString(null), ThemeMode.system);
    });

    test('fromString defaults to system for unknown', () {
      expect(ThemeModeExtension.fromString('unknown'), ThemeMode.system);
    });

    test('title returns correct strings', () {
      expect(ThemeMode.system.title, 'System');
      expect(ThemeMode.light.title, 'Light');
      expect(ThemeMode.dark.title, 'Dark');
    });
  });

  group('Integration', () {
    testWidgets('MaterialApp renders with sunshine theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DmThemeData.sunshine(),
          home: const Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      final context = tester.element(find.text('Test'));
      final theme = Theme.of(context);
      expect(theme.colorScheme.primary, const Color(0xFF6750A4));

      final ext = theme.extension<DmColorExtension>();
      expect(ext, isNotNull);
      expect(ext!.accent, const Color(0xFF8B5CF6));
    });

    testWidgets('MaterialApp renders with moonlight theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DmThemeData.moonlight(),
          home: const Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      final context = tester.element(find.text('Test'));
      final theme = Theme.of(context);
      expect(theme.colorScheme.primary, const Color(0xFFD0BCFF));
    });

    testWidgets('theme switching works with ThemeMode.system', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DmThemeData.sunshine(),
          darkTheme: DmThemeData.moonlight(),
          themeMode: ThemeMode.system,
          home: const Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
    });
  });
}
