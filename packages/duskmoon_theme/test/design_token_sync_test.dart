import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Reference: duskmoon-dev/design ddbd765, generated/sunshine.json.
  test('generated Sunshine tokens retain the upstream palette and alpha', () {
    expect(SunshineTokens.primary, const Color(0xFFF2BD4B));
    expect(SunshineTokens.primaryContent, const Color(0xFF35270D));
    expect(SunshineTokens.primaryContainer, const Color(0xFFFFF0C2));
    expect(SunshineTokens.secondary, const Color(0xFFB5A6D9));
    expect(SunshineTokens.secondaryContent, const Color(0xFF322747));
    expect(SunshineTokens.secondaryContainer, const Color(0xFFF0EBF8));
    expect(SunshineTokens.onSecondaryContainer, const Color(0xFF493764));
    expect(SunshineTokens.tertiary, const Color(0xFF86BED1));
    expect(SunshineTokens.tertiaryContent, const Color(0xFF18343F));
    expect(SunshineTokens.accent, const Color(0xFFF7DE87));
    expect(SunshineTokens.accentContent, const Color(0xFF493A13));
    expect(SunshineTokens.surface, const Color(0xFFFFFCF5));
    expect(SunshineTokens.onSurface, const Color(0xFF30291F));
    expect(SunshineTokens.success, const Color(0xFF327A4F));
    expect(SunshineTokens.successContent, const Color(0xFFFFFFFF));
    expect(SunshineTokens.error, const Color(0xFFB8423A));
    expect(SunshineTokens.errorContent, const Color(0xFFFFFFFF));
    expect(SunshineTokens.scrim, const Color(0x80000000));
  });

  test('public Sunshine theme exposes the upstream semantic colors', () {
    final theme = DmThemeData.sunshine();
    final scheme = theme.colorScheme;
    final extension = theme.extension<DmColorExtension>()!;

    expect(scheme.primary, const Color(0xFFF2BD4B));
    expect(scheme.onPrimary, const Color(0xFF35270D));
    expect(scheme.primaryContainer, const Color(0xFFFFF0C2));
    expect(scheme.secondary, const Color(0xFFB5A6D9));
    expect(scheme.onSecondary, const Color(0xFF322747));
    expect(scheme.secondaryContainer, const Color(0xFFF0EBF8));
    expect(scheme.onSecondaryContainer, const Color(0xFF493764));
    expect(scheme.tertiary, const Color(0xFF86BED1));
    expect(scheme.onTertiary, const Color(0xFF18343F));
    expect(scheme.surface, const Color(0xFFFFFCF5));
    expect(scheme.onSurface, const Color(0xFF30291F));
    expect(scheme.error, const Color(0xFFB8423A));
    expect(scheme.onError, const Color(0xFFFFFFFF));
    expect(scheme.scrim, const Color(0x80000000));
    expect(extension.accent, const Color(0xFFF7DE87));
    expect(extension.accentContent, const Color(0xFF493A13));
    expect(extension.success, const Color(0xFF327A4F));
    expect(extension.successContent, const Color(0xFFFFFFFF));
  });

  group('upstream surface variant and highest container mappings', () {
    final cases = [
      (
        name: 'sunshine',
        theme: DmThemeData.sunshine(),
        variant: const Color(0xFFE8DDC7),
        highest: const Color(0xFFE8DDC7),
      ),
      (
        name: 'moonlight',
        theme: DmThemeData.moonlight(),
        variant: const Color(0xFF282E38),
        highest: const Color(0xFF26292E),
      ),
      (
        name: 'forest',
        theme: DmThemeData.forest(),
        variant: const Color(0xFFEBE8DA),
        highest: const Color(0xFFE7E5DA),
      ),
      (
        name: 'ocean',
        theme: DmThemeData.ocean(),
        variant: const Color(0xFF0C1D23),
        highest: const Color(0xFF112227),
      ),
    ];

    for (final entry in cases) {
      test(entry.name, () {
        expect(entry.theme.extension<DmColorExtension>()!.surfaceVariant,
            entry.variant);
        expect(entry.theme.colorScheme.surfaceContainerHighest, entry.highest);
      });
    }
  });
}
