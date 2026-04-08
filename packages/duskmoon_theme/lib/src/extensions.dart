import 'package:flutter/material.dart';

import 'generated/forest_tokens.g.dart';
import 'generated/moonlight_tokens.g.dart';
import 'generated/ocean_tokens.g.dart';
import 'generated/sunshine_tokens.g.dart';

/// A [ThemeExtension] carrying non-standard semantic color tokens.
///
/// Access via `Theme.of(context).extension<DmColorExtension>()`.
@immutable
class DmColorExtension extends ThemeExtension<DmColorExtension> {
  /// Creates a [DmColorExtension] with all required semantic color tokens.
  const DmColorExtension({
    required this.accent,
    required this.accentContent,
    required this.neutral,
    required this.neutralContent,
    required this.neutralVariant,
    required this.surfaceVariant,
    required this.info,
    required this.infoContent,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.success,
    required this.successContent,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContent,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.base100,
    required this.base200,
    required this.base300,
    required this.base400,
    required this.base500,
    required this.base600,
    required this.base700,
    required this.base800,
    required this.base900,
    required this.baseContent,
  });

  /// Accent color for highlights and emphasis.
  final Color accent;

  /// Content color for use on accent backgrounds.
  final Color accentContent;

  /// Neutral color for subdued UI elements.
  final Color neutral;

  /// Content color for use on neutral backgrounds.
  final Color neutralContent;

  /// Neutral variant for subtle differentiation.
  final Color neutralVariant;

  /// Surface variant color.
  final Color surfaceVariant;

  /// Semantic color for informational states.
  final Color info;

  /// Content color for use on info backgrounds.
  final Color infoContent;

  /// Container color for informational states.
  final Color infoContainer;

  /// Content color for use on info containers.
  final Color onInfoContainer;

  /// Semantic color for success states.
  final Color success;

  /// Content color for use on success backgrounds.
  final Color successContent;

  /// Container color for success states.
  final Color successContainer;

  /// Content color for use on success containers.
  final Color onSuccessContainer;

  /// Semantic color for warning states.
  final Color warning;

  /// Content color for use on warning backgrounds.
  final Color warningContent;

  /// Container color for warning states.
  final Color warningContainer;

  /// Content color for use on warning containers.
  final Color onWarningContainer;

  /// Base surface color at the first elevation level.
  final Color base100;

  /// Base surface color at the second elevation level.
  final Color base200;

  /// Base surface color at the third elevation level.
  final Color base300;

  /// Base surface color at the fourth elevation level.
  final Color base400;

  /// Base surface color at the fifth elevation level.
  final Color base500;

  /// Base surface color at the sixth elevation level.
  final Color base600;

  /// Base surface color at the seventh elevation level.
  final Color base700;

  /// Base surface color at the eighth elevation level.
  final Color base800;

  /// Base surface color at the ninth elevation level.
  final Color base900;

  /// Content color for use on base surfaces.
  final Color baseContent;

  /// Returns a [DmColorExtension] using the Sunshine (light) design tokens.
  static DmColorExtension sunshine() {
    return const DmColorExtension(
      accent: SunshineTokens.accent,
      accentContent: SunshineTokens.accentContent,
      neutral: SunshineTokens.neutral,
      neutralContent: SunshineTokens.neutralContent,
      neutralVariant: SunshineTokens.neutralVariant,
      surfaceVariant: SunshineTokens.surfaceVariant,
      info: SunshineTokens.info,
      infoContent: SunshineTokens.infoContent,
      infoContainer: SunshineTokens.infoContainer,
      onInfoContainer: SunshineTokens.onInfoContainer,
      success: SunshineTokens.success,
      successContent: SunshineTokens.successContent,
      successContainer: SunshineTokens.successContainer,
      onSuccessContainer: SunshineTokens.onSuccessContainer,
      warning: SunshineTokens.warning,
      warningContent: SunshineTokens.warningContent,
      warningContainer: SunshineTokens.warningContainer,
      onWarningContainer: SunshineTokens.onWarningContainer,
      base100: SunshineTokens.base100,
      base200: SunshineTokens.base200,
      base300: SunshineTokens.base300,
      base400: SunshineTokens.base400,
      base500: SunshineTokens.base500,
      base600: SunshineTokens.base600,
      base700: SunshineTokens.base700,
      base800: SunshineTokens.base800,
      base900: SunshineTokens.base900,
      baseContent: SunshineTokens.baseContent,
    );
  }

  /// Returns a [DmColorExtension] using the Moonlight (dark) design tokens.
  static DmColorExtension moonlight() {
    return const DmColorExtension(
      accent: MoonlightTokens.accent,
      accentContent: MoonlightTokens.accentContent,
      neutral: MoonlightTokens.neutral,
      neutralContent: MoonlightTokens.neutralContent,
      neutralVariant: MoonlightTokens.neutralVariant,
      surfaceVariant: MoonlightTokens.surfaceVariant,
      info: MoonlightTokens.info,
      infoContent: MoonlightTokens.infoContent,
      infoContainer: MoonlightTokens.infoContainer,
      onInfoContainer: MoonlightTokens.onInfoContainer,
      success: MoonlightTokens.success,
      successContent: MoonlightTokens.successContent,
      successContainer: MoonlightTokens.successContainer,
      onSuccessContainer: MoonlightTokens.onSuccessContainer,
      warning: MoonlightTokens.warning,
      warningContent: MoonlightTokens.warningContent,
      warningContainer: MoonlightTokens.warningContainer,
      onWarningContainer: MoonlightTokens.onWarningContainer,
      base100: MoonlightTokens.base100,
      base200: MoonlightTokens.base200,
      base300: MoonlightTokens.base300,
      base400: MoonlightTokens.base400,
      base500: MoonlightTokens.base500,
      base600: MoonlightTokens.base600,
      base700: MoonlightTokens.base700,
      base800: MoonlightTokens.base800,
      base900: MoonlightTokens.base900,
      baseContent: MoonlightTokens.baseContent,
    );
  }

  /// Returns a [DmColorExtension] using the Forest (light) design tokens.
  static DmColorExtension forest() {
    return const DmColorExtension(
      accent: ForestTokens.accent,
      accentContent: ForestTokens.accentContent,
      neutral: ForestTokens.neutral,
      neutralContent: ForestTokens.neutralContent,
      neutralVariant: ForestTokens.neutralVariant,
      surfaceVariant: ForestTokens.surfaceVariant,
      info: ForestTokens.info,
      infoContent: ForestTokens.infoContent,
      infoContainer: ForestTokens.infoContainer,
      onInfoContainer: ForestTokens.onInfoContainer,
      success: ForestTokens.success,
      successContent: ForestTokens.successContent,
      successContainer: ForestTokens.successContainer,
      onSuccessContainer: ForestTokens.onSuccessContainer,
      warning: ForestTokens.warning,
      warningContent: ForestTokens.warningContent,
      warningContainer: ForestTokens.warningContainer,
      onWarningContainer: ForestTokens.onWarningContainer,
      base100: ForestTokens.base100,
      base200: ForestTokens.base200,
      base300: ForestTokens.base300,
      base400: ForestTokens.base400,
      base500: ForestTokens.base500,
      base600: ForestTokens.base600,
      base700: ForestTokens.base700,
      base800: ForestTokens.base800,
      base900: ForestTokens.base900,
      baseContent: ForestTokens.baseContent,
    );
  }

  /// Returns a [DmColorExtension] using the Ocean (dark) design tokens.
  static DmColorExtension ocean() {
    return const DmColorExtension(
      accent: OceanTokens.accent,
      accentContent: OceanTokens.accentContent,
      neutral: OceanTokens.neutral,
      neutralContent: OceanTokens.neutralContent,
      neutralVariant: OceanTokens.neutralVariant,
      surfaceVariant: OceanTokens.surfaceVariant,
      info: OceanTokens.info,
      infoContent: OceanTokens.infoContent,
      infoContainer: OceanTokens.infoContainer,
      onInfoContainer: OceanTokens.onInfoContainer,
      success: OceanTokens.success,
      successContent: OceanTokens.successContent,
      successContainer: OceanTokens.successContainer,
      onSuccessContainer: OceanTokens.onSuccessContainer,
      warning: OceanTokens.warning,
      warningContent: OceanTokens.warningContent,
      warningContainer: OceanTokens.warningContainer,
      onWarningContainer: OceanTokens.onWarningContainer,
      base100: OceanTokens.base100,
      base200: OceanTokens.base200,
      base300: OceanTokens.base300,
      base400: OceanTokens.base400,
      base500: OceanTokens.base500,
      base600: OceanTokens.base600,
      base700: OceanTokens.base700,
      base800: OceanTokens.base800,
      base900: OceanTokens.base900,
      baseContent: OceanTokens.baseContent,
    );
  }

  @override
  DmColorExtension copyWith({
    Color? accent,
    Color? accentContent,
    Color? neutral,
    Color? neutralContent,
    Color? neutralVariant,
    Color? surfaceVariant,
    Color? info,
    Color? infoContent,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? success,
    Color? successContent,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContent,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? base100,
    Color? base200,
    Color? base300,
    Color? base400,
    Color? base500,
    Color? base600,
    Color? base700,
    Color? base800,
    Color? base900,
    Color? baseContent,
  }) {
    return DmColorExtension(
      accent: accent ?? this.accent,
      accentContent: accentContent ?? this.accentContent,
      neutral: neutral ?? this.neutral,
      neutralContent: neutralContent ?? this.neutralContent,
      neutralVariant: neutralVariant ?? this.neutralVariant,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      info: info ?? this.info,
      infoContent: infoContent ?? this.infoContent,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      success: success ?? this.success,
      successContent: successContent ?? this.successContent,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContent: warningContent ?? this.warningContent,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      base100: base100 ?? this.base100,
      base200: base200 ?? this.base200,
      base300: base300 ?? this.base300,
      base400: base400 ?? this.base400,
      base500: base500 ?? this.base500,
      base600: base600 ?? this.base600,
      base700: base700 ?? this.base700,
      base800: base800 ?? this.base800,
      base900: base900 ?? this.base900,
      baseContent: baseContent ?? this.baseContent,
    );
  }

  @override
  DmColorExtension lerp(covariant DmColorExtension? other, double t) {
    if (other is! DmColorExtension) return this;
    return DmColorExtension(
      accent: Color.lerp(accent, other.accent, t)!,
      accentContent: Color.lerp(accentContent, other.accentContent, t)!,
      neutral: Color.lerp(neutral, other.neutral, t)!,
      neutralContent: Color.lerp(neutralContent, other.neutralContent, t)!,
      neutralVariant: Color.lerp(neutralVariant, other.neutralVariant, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContent: Color.lerp(infoContent, other.infoContent, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      success: Color.lerp(success, other.success, t)!,
      successContent: Color.lerp(successContent, other.successContent, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContent: Color.lerp(warningContent, other.warningContent, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      base100: Color.lerp(base100, other.base100, t)!,
      base200: Color.lerp(base200, other.base200, t)!,
      base300: Color.lerp(base300, other.base300, t)!,
      base400: Color.lerp(base400, other.base400, t)!,
      base500: Color.lerp(base500, other.base500, t)!,
      base600: Color.lerp(base600, other.base600, t)!,
      base700: Color.lerp(base700, other.base700, t)!,
      base800: Color.lerp(base800, other.base800, t)!,
      base900: Color.lerp(base900, other.base900, t)!,
      baseContent: Color.lerp(baseContent, other.baseContent, t)!,
    );
  }
}
