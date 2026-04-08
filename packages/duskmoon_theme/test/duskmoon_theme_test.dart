import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DmColorScheme', () {
    test('sunshine() returns light ColorScheme with correct token values', () {
      final cs = DmColorScheme.sunshine();
      expect(cs.brightness, Brightness.light);
      expect(cs.primary, SunshineTokens.primary);
      expect(cs.onPrimary, SunshineTokens.primaryContent);
      expect(cs.primaryContainer, SunshineTokens.primaryContainer);
      expect(cs.onPrimaryContainer, SunshineTokens.onPrimaryContainer);
      expect(cs.secondary, SunshineTokens.secondary);
      expect(cs.onSecondary, SunshineTokens.secondaryContent);
      expect(cs.tertiary, SunshineTokens.tertiary);
      expect(cs.onTertiary, SunshineTokens.tertiaryContent);
      expect(cs.error, SunshineTokens.error);
      expect(cs.onError, SunshineTokens.errorContent);
      expect(cs.surface, SunshineTokens.surface);
      expect(cs.onSurface, SunshineTokens.onSurface);
      expect(cs.outline, SunshineTokens.outline);
      expect(cs.outlineVariant, SunshineTokens.outlineVariant);
      expect(cs.inverseSurface, SunshineTokens.inverseSurface);
      expect(cs.onInverseSurface, SunshineTokens.inverseOnSurface);
      expect(cs.inversePrimary, SunshineTokens.inversePrimary);
      expect(cs.shadow, SunshineTokens.shadow);
      expect(cs.scrim, SunshineTokens.scrim);
    });

    test('moonlight() returns dark ColorScheme with correct token values', () {
      final cs = DmColorScheme.moonlight();
      expect(cs.brightness, Brightness.dark);
      expect(cs.primary, MoonlightTokens.primary);
      expect(cs.onPrimary, MoonlightTokens.primaryContent);
      expect(cs.primaryContainer, MoonlightTokens.primaryContainer);
      expect(cs.secondary, MoonlightTokens.secondary);
      expect(cs.tertiary, MoonlightTokens.tertiary);
      expect(cs.error, MoonlightTokens.error);
      expect(cs.surface, MoonlightTokens.surface);
      expect(cs.onSurface, MoonlightTokens.onSurface);
    });

    test('forest() returns light ColorScheme', () {
      final cs = DmColorScheme.forest();
      expect(cs.brightness, Brightness.light);
      expect(cs.primary, ForestTokens.primary);
      expect(cs.surface, ForestTokens.surface);
    });

    test('ocean() returns dark ColorScheme', () {
      final cs = DmColorScheme.ocean();
      expect(cs.brightness, Brightness.dark);
      expect(cs.primary, OceanTokens.primary);
      expect(cs.surface, OceanTokens.surface);
    });

    test('all themes have surface container variants', () {
      final light = DmColorScheme.sunshine();
      expect(light.surfaceContainerLowest, SunshineTokens.surfaceContainerLowest);
      expect(light.surfaceContainerLow, SunshineTokens.surfaceContainerLow);
      expect(light.surfaceContainer, SunshineTokens.surfaceContainer);
      expect(light.surfaceContainerHigh, SunshineTokens.surfaceContainerHigh);
      expect(light.surfaceContainerHighest, SunshineTokens.surfaceContainerHighest);

      final dark = DmColorScheme.moonlight();
      expect(dark.surfaceContainerLowest, MoonlightTokens.surfaceContainerLowest);
      expect(dark.surfaceContainerLow, MoonlightTokens.surfaceContainerLow);
      expect(dark.surfaceContainer, MoonlightTokens.surfaceContainer);
      expect(dark.surfaceContainerHigh, MoonlightTokens.surfaceContainerHigh);
      expect(dark.surfaceContainerHighest, MoonlightTokens.surfaceContainerHighest);
    });
  });

  group('DmThemeData', () {
    test('sunshine() produces valid ThemeData', () {
      final theme = DmThemeData.sunshine();
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, SunshineTokens.primary);
    });

    test('moonlight() produces valid ThemeData', () {
      final theme = DmThemeData.moonlight();
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, MoonlightTokens.primary);
    });

    test('forest() produces valid ThemeData', () {
      final theme = DmThemeData.forest();
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.light);
      expect(theme.colorScheme.primary, ForestTokens.primary);
    });

    test('ocean() produces valid ThemeData', () {
      final theme = DmThemeData.ocean();
      expect(theme.useMaterial3, isTrue);
      expect(theme.colorScheme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, OceanTokens.primary);
    });

    test('sunshine() includes DmColorExtension', () {
      final theme = DmThemeData.sunshine();
      final ext = theme.extension<DmColorExtension>();
      expect(ext, isNotNull);
      expect(ext!.accent, SunshineTokens.accent);
      expect(ext.info, SunshineTokens.info);
      expect(ext.success, SunshineTokens.success);
      expect(ext.warning, SunshineTokens.warning);
    });

    test('moonlight() includes DmColorExtension', () {
      final theme = DmThemeData.moonlight();
      final ext = theme.extension<DmColorExtension>();
      expect(ext, isNotNull);
      expect(ext!.accent, MoonlightTokens.accent);
      expect(ext.info, MoonlightTokens.info);
      expect(ext.success, MoonlightTokens.success);
      expect(ext.warning, MoonlightTokens.warning);
    });

    test('sunshine() has AppBar styling from tokens', () {
      final theme = DmThemeData.sunshine();
      expect(theme.appBarTheme.backgroundColor, SunshineTokens.surface);
      expect(theme.appBarTheme.foregroundColor, SunshineTokens.onSurface);
      expect(theme.appBarTheme.elevation, 0);
    });

    test('sunshine() has NavigationRail styling from tokens', () {
      final theme = DmThemeData.sunshine();
      final rail = theme.navigationRailTheme;
      expect(rail.backgroundColor, SunshineTokens.surfaceContainerLow);
      expect(rail.indicatorColor, SunshineTokens.secondaryContainer);
    });

    test('sunshine() has NavigationBar styling from tokens', () {
      final theme = DmThemeData.sunshine();
      final nav = theme.navigationBarTheme;
      expect(nav.backgroundColor, SunshineTokens.surfaceContainer);
      expect(nav.indicatorColor, SunshineTokens.secondaryContainer);
    });

    test('themes returns list with duskmoon and ecotone entries', () {
      final themes = DmThemeData.themes;
      expect(themes.length, 2);
      expect(themes[0].name, 'duskmoon');
      expect(themes[0].light.colorScheme.brightness, Brightness.light);
      expect(themes[0].dark.colorScheme.brightness, Brightness.dark);
      expect(themes[1].name, 'ecotone');
      expect(themes[1].light.colorScheme.brightness, Brightness.light);
      expect(themes[1].dark.colorScheme.brightness, Brightness.dark);
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
    test('sunshine() has all extended color tokens', () {
      final ext = DmColorExtension.sunshine();
      expect(ext.accent, SunshineTokens.accent);
      expect(ext.accentContent, SunshineTokens.accentContent);
      expect(ext.neutral, SunshineTokens.neutral);
      expect(ext.neutralContent, SunshineTokens.neutralContent);
      expect(ext.neutralVariant, SunshineTokens.neutralVariant);
      expect(ext.surfaceVariant, SunshineTokens.surfaceVariant);
      expect(ext.info, SunshineTokens.info);
      expect(ext.infoContent, SunshineTokens.infoContent);
      expect(ext.infoContainer, SunshineTokens.infoContainer);
      expect(ext.onInfoContainer, SunshineTokens.onInfoContainer);
      expect(ext.success, SunshineTokens.success);
      expect(ext.successContent, SunshineTokens.successContent);
      expect(ext.successContainer, SunshineTokens.successContainer);
      expect(ext.onSuccessContainer, SunshineTokens.onSuccessContainer);
      expect(ext.warning, SunshineTokens.warning);
      expect(ext.warningContent, SunshineTokens.warningContent);
      expect(ext.warningContainer, SunshineTokens.warningContainer);
      expect(ext.onWarningContainer, SunshineTokens.onWarningContainer);
      expect(ext.base100, SunshineTokens.base100);
      expect(ext.base200, SunshineTokens.base200);
      expect(ext.base300, SunshineTokens.base300);
      expect(ext.base400, SunshineTokens.base400);
      expect(ext.base500, SunshineTokens.base500);
      expect(ext.base600, SunshineTokens.base600);
      expect(ext.base700, SunshineTokens.base700);
      expect(ext.base800, SunshineTokens.base800);
      expect(ext.base900, SunshineTokens.base900);
      expect(ext.baseContent, SunshineTokens.baseContent);
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
      expect(theme.colorScheme.primary, SunshineTokens.primary);

      final ext = theme.extension<DmColorExtension>();
      expect(ext, isNotNull);
      expect(ext!.accent, SunshineTokens.accent);
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
      expect(theme.colorScheme.primary, MoonlightTokens.primary);
    });

    testWidgets('MaterialApp renders with forest theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DmThemeData.forest(),
          home: const Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      final context = tester.element(find.text('Test'));
      final theme = Theme.of(context);
      expect(theme.colorScheme.primary, ForestTokens.primary);
    });

    testWidgets('MaterialApp renders with ocean theme', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: DmThemeData.ocean(),
          home: const Scaffold(
            body: Text('Test'),
          ),
        ),
      );

      final context = tester.element(find.text('Test'));
      final theme = Theme.of(context);
      expect(theme.colorScheme.primary, OceanTokens.primary);
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
