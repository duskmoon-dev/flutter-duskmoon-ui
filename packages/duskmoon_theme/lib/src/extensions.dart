import 'package:flutter/material.dart';

import 'generated/moonlight_tokens.g.dart';
import 'generated/sunshine_tokens.g.dart';

/// A [ThemeExtension] carrying 20 non-standard semantic color tokens.
///
/// Access via `Theme.of(context).extension<DmColorExtension>()`.
@immutable
class DmColorExtension extends ThemeExtension<DmColorExtension> {
  /// Creates a [DmColorExtension] with all required semantic color tokens.
  const DmColorExtension({
    required this.primaryFocus,
    required this.secondaryFocus,
    required this.tertiaryFocus,
    required this.accent,
    required this.accentFocus,
    required this.accentContent,
    required this.neutral,
    required this.neutralFocus,
    required this.neutralContent,
    required this.neutralVariant,
    required this.info,
    required this.infoContent,
    required this.success,
    required this.successContent,
    required this.warning,
    required this.warningContent,
    required this.base100,
    required this.base200,
    required this.base300,
    required this.baseContent,
  });

  /// Focused variant of the primary color.
  final Color primaryFocus;

  /// Focused variant of the secondary color.
  final Color secondaryFocus;

  /// Focused variant of the tertiary color.
  final Color tertiaryFocus;

  /// Accent color for highlights and emphasis.
  final Color accent;

  /// Focused variant of the accent color.
  final Color accentFocus;

  /// Content color for use on accent backgrounds.
  final Color accentContent;

  /// Neutral color for subdued UI elements.
  final Color neutral;

  /// Focused variant of the neutral color.
  final Color neutralFocus;

  /// Content color for use on neutral backgrounds.
  final Color neutralContent;

  /// Neutral variant for subtle differentiation.
  final Color neutralVariant;

  /// Semantic color for informational states.
  final Color info;

  /// Content color for use on info backgrounds.
  final Color infoContent;

  /// Semantic color for success states.
  final Color success;

  /// Content color for use on success backgrounds.
  final Color successContent;

  /// Semantic color for warning states.
  final Color warning;

  /// Content color for use on warning backgrounds.
  final Color warningContent;

  /// Base surface color at the first elevation level.
  final Color base100;

  /// Base surface color at the second elevation level.
  final Color base200;

  /// Base surface color at the third elevation level.
  final Color base300;

  /// Content color for use on base surfaces.
  final Color baseContent;

  /// Returns a [DmColorExtension] using the Sunshine (light) design tokens.
  static DmColorExtension sunshine() {
    return const DmColorExtension(
      primaryFocus: SunshineTokens.primaryFocus,
      secondaryFocus: SunshineTokens.secondaryFocus,
      tertiaryFocus: SunshineTokens.tertiaryFocus,
      accent: SunshineTokens.accent,
      accentFocus: SunshineTokens.accentFocus,
      accentContent: SunshineTokens.accentContent,
      neutral: SunshineTokens.neutral,
      neutralFocus: SunshineTokens.neutralFocus,
      neutralContent: SunshineTokens.neutralContent,
      neutralVariant: SunshineTokens.neutralVariant,
      info: SunshineTokens.info,
      infoContent: SunshineTokens.infoContent,
      success: SunshineTokens.success,
      successContent: SunshineTokens.successContent,
      warning: SunshineTokens.warning,
      warningContent: SunshineTokens.warningContent,
      base100: SunshineTokens.base100,
      base200: SunshineTokens.base200,
      base300: SunshineTokens.base300,
      baseContent: SunshineTokens.baseContent,
    );
  }

  /// Returns a [DmColorExtension] using the Moonlight (dark) design tokens.
  static DmColorExtension moonlight() {
    return const DmColorExtension(
      primaryFocus: MoonlightTokens.primaryFocus,
      secondaryFocus: MoonlightTokens.secondaryFocus,
      tertiaryFocus: MoonlightTokens.tertiaryFocus,
      accent: MoonlightTokens.accent,
      accentFocus: MoonlightTokens.accentFocus,
      accentContent: MoonlightTokens.accentContent,
      neutral: MoonlightTokens.neutral,
      neutralFocus: MoonlightTokens.neutralFocus,
      neutralContent: MoonlightTokens.neutralContent,
      neutralVariant: MoonlightTokens.neutralVariant,
      info: MoonlightTokens.info,
      infoContent: MoonlightTokens.infoContent,
      success: MoonlightTokens.success,
      successContent: MoonlightTokens.successContent,
      warning: MoonlightTokens.warning,
      warningContent: MoonlightTokens.warningContent,
      base100: MoonlightTokens.base100,
      base200: MoonlightTokens.base200,
      base300: MoonlightTokens.base300,
      baseContent: MoonlightTokens.baseContent,
    );
  }

  @override
  DmColorExtension copyWith({
    Color? primaryFocus,
    Color? secondaryFocus,
    Color? tertiaryFocus,
    Color? accent,
    Color? accentFocus,
    Color? accentContent,
    Color? neutral,
    Color? neutralFocus,
    Color? neutralContent,
    Color? neutralVariant,
    Color? info,
    Color? infoContent,
    Color? success,
    Color? successContent,
    Color? warning,
    Color? warningContent,
    Color? base100,
    Color? base200,
    Color? base300,
    Color? baseContent,
  }) {
    return DmColorExtension(
      primaryFocus: primaryFocus ?? this.primaryFocus,
      secondaryFocus: secondaryFocus ?? this.secondaryFocus,
      tertiaryFocus: tertiaryFocus ?? this.tertiaryFocus,
      accent: accent ?? this.accent,
      accentFocus: accentFocus ?? this.accentFocus,
      accentContent: accentContent ?? this.accentContent,
      neutral: neutral ?? this.neutral,
      neutralFocus: neutralFocus ?? this.neutralFocus,
      neutralContent: neutralContent ?? this.neutralContent,
      neutralVariant: neutralVariant ?? this.neutralVariant,
      info: info ?? this.info,
      infoContent: infoContent ?? this.infoContent,
      success: success ?? this.success,
      successContent: successContent ?? this.successContent,
      warning: warning ?? this.warning,
      warningContent: warningContent ?? this.warningContent,
      base100: base100 ?? this.base100,
      base200: base200 ?? this.base200,
      base300: base300 ?? this.base300,
      baseContent: baseContent ?? this.baseContent,
    );
  }

  @override
  DmColorExtension lerp(covariant DmColorExtension? other, double t) {
    if (other is! DmColorExtension) return this;
    return DmColorExtension(
      primaryFocus: Color.lerp(primaryFocus, other.primaryFocus, t)!,
      secondaryFocus: Color.lerp(secondaryFocus, other.secondaryFocus, t)!,
      tertiaryFocus: Color.lerp(tertiaryFocus, other.tertiaryFocus, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      accentFocus: Color.lerp(accentFocus, other.accentFocus, t)!,
      accentContent: Color.lerp(accentContent, other.accentContent, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      neutralFocus: Color.lerp(neutralFocus, other.neutralFocus, t)!,
      neutralContent: Color.lerp(neutralContent, other.neutralContent, t)!,
      neutralVariant: Color.lerp(neutralVariant, other.neutralVariant, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContent: Color.lerp(infoContent, other.infoContent, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContent: Color.lerp(successContent, other.successContent, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContent: Color.lerp(warningContent, other.warningContent, t)!,
      base100: Color.lerp(base100, other.base100, t)!,
      base200: Color.lerp(base200, other.base200, t)!,
      base300: Color.lerp(base300, other.base300, t)!,
      baseContent: Color.lerp(baseContent, other.baseContent, t)!,
    );
  }
}
