import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:flutter/material.dart';
import 'package:duskmoon_settings/src/utils/platform_utils.dart';

class SettingsTheme extends InheritedWidget {
  final SettingsThemeData themeData;
  final DevicePlatform platform;

  const SettingsTheme({
    required this.themeData,
    required this.platform,
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(SettingsTheme oldWidget) => true;

  static SettingsTheme? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SettingsTheme>();
  }

  static SettingsTheme of(BuildContext context) {
    final SettingsTheme? result = maybeOf(context);
    assert(result != null, 'No SettingsTheme found in context');
    return result!;
  }
}

class SettingsThemeData {
  static SettingsThemeData withContext(
    BuildContext context,
    DevicePlatform? platform,
  ) {
    platform ??= DevicePlatform.fromContext(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final dmColors = theme.extension<DmColorExtension>();
    return withColorScheme(colorScheme, platform, dmColors: dmColors);
  }

  static SettingsThemeData withColorScheme(
    ColorScheme colorScheme,
    DevicePlatform? platform, {
    DmColorExtension? dmColors,
  }) {
    platform ??= DevicePlatform.android;
    switch (platform) {
      // Material Design (Android, Linux, Web, Fuchsia)
      case DevicePlatform.android:
      case DevicePlatform.fuchsia:
      case DevicePlatform.linux:
      case DevicePlatform.web:
      case DevicePlatform.custom:
        return _materialTheme(colorScheme, dmColors);
      // Cupertino (iOS, macOS)
      case DevicePlatform.iOS:
      case DevicePlatform.macOS:
        return _cupertinoTheme(colorScheme, dmColors);
      // Fluent Design (Windows)
      case DevicePlatform.windows:
        return _fluentTheme(colorScheme, dmColors);
    }
  }

  /// Material Design 3 theme for Android, Linux, Web, Fuchsia.
  static SettingsThemeData _materialTheme(
    ColorScheme colorScheme,
    DmColorExtension? dmColors,
  ) {
    return SettingsThemeData(
      settingsListBackground:
          dmColors?.base100 ?? colorScheme.surface,
      settingsSectionBackground:
          dmColors?.base100 ?? colorScheme.surface,
      titleTextColor: colorScheme.primary,
      settingsTileTextColor:
          dmColors?.baseContent ?? colorScheme.onSurface,
      tileDescriptionTextColor: colorScheme.onSurfaceVariant,
      tileHighlightColor: colorScheme.surfaceContainerHighest,
      leadingIconsColor: colorScheme.onSurfaceVariant,
      inactiveTitleColor: colorScheme.onSurface.withValues(alpha: 0.38),
      inactiveSubtitleColor: colorScheme.onSurfaceVariant.withValues(
        alpha: 0.38,
      ),
    );
  }

  /// Cupertino theme for iOS and macOS.
  static SettingsThemeData _cupertinoTheme(
    ColorScheme colorScheme,
    DmColorExtension? dmColors,
  ) {
    return SettingsThemeData(
      settingsListBackground:
          dmColors?.base200 ?? colorScheme.surfaceContainerHighest,
      settingsSectionBackground:
          dmColors?.base100 ?? colorScheme.surface,
      titleTextColor: colorScheme.onSurfaceVariant,
      settingsTileTextColor:
          dmColors?.baseContent ?? colorScheme.onSurface,
      tileDescriptionTextColor: colorScheme.onSurfaceVariant,
      dividerColor: colorScheme.outlineVariant,
      trailingTextColor: colorScheme.onSurfaceVariant,
      tileHighlightColor: colorScheme.surfaceTint.withValues(alpha: 0.12),
      leadingIconsColor: colorScheme.primary,
      inactiveTitleColor: colorScheme.onSurface.withValues(alpha: 0.38),
      inactiveSubtitleColor: colorScheme.onSurfaceVariant.withValues(
        alpha: 0.38,
      ),
    );
  }

  /// Fluent Design theme for Windows.
  static SettingsThemeData _fluentTheme(
    ColorScheme colorScheme,
    DmColorExtension? dmColors,
  ) {
    return SettingsThemeData(
      settingsListBackground:
          dmColors?.base100 ?? colorScheme.surfaceContainerLow,
      settingsSectionBackground:
          dmColors?.base200 ?? colorScheme.surfaceContainerHighest,
      titleTextColor:
          dmColors?.baseContent ?? colorScheme.onSurface,
      settingsTileTextColor:
          dmColors?.baseContent ?? colorScheme.onSurface,
      tileDescriptionTextColor: colorScheme.onSurfaceVariant,
      tileHighlightColor: colorScheme.surfaceContainerHigh,
      leadingIconsColor: colorScheme.primary,
      inactiveTitleColor: colorScheme.onSurface.withValues(alpha: 0.38),
      inactiveSubtitleColor: colorScheme.onSurfaceVariant.withValues(
        alpha: 0.38,
      ),
    );
  }

  const SettingsThemeData({
    this.trailingTextColor,
    this.settingsListBackground,
    this.settingsSectionBackground,
    this.dividerColor,
    this.tileHighlightColor,
    this.titleTextColor,
    this.leadingIconsColor,
    this.tileDescriptionTextColor,
    this.settingsTileTextColor,
    this.inactiveTitleColor,
    this.inactiveSubtitleColor,
  });

  final Color? settingsListBackground;
  final Color? trailingTextColor;
  final Color? leadingIconsColor;
  final Color? settingsSectionBackground;
  final Color? dividerColor;
  final Color? tileDescriptionTextColor;
  final Color? tileHighlightColor;
  final Color? titleTextColor;
  final Color? settingsTileTextColor;
  final Color? inactiveTitleColor;
  final Color? inactiveSubtitleColor;

  SettingsThemeData merge({SettingsThemeData? theme}) {
    if (theme == null) return this;

    return copyWith(
      leadingIconsColor: theme.leadingIconsColor,
      tileDescriptionTextColor: theme.tileDescriptionTextColor,
      dividerColor: theme.dividerColor,
      trailingTextColor: theme.trailingTextColor,
      settingsListBackground: theme.settingsListBackground,
      settingsSectionBackground: theme.settingsSectionBackground,
      settingsTileTextColor: theme.settingsTileTextColor,
      tileHighlightColor: theme.tileHighlightColor,
      titleTextColor: theme.titleTextColor,
      inactiveTitleColor: theme.inactiveTitleColor,
      inactiveSubtitleColor: theme.inactiveSubtitleColor,
    );
  }

  SettingsThemeData copyWith({
    Color? settingsListBackground,
    Color? trailingTextColor,
    Color? leadingIconsColor,
    Color? settingsSectionBackground,
    Color? dividerColor,
    Color? tileDescriptionTextColor,
    Color? tileHighlightColor,
    Color? titleTextColor,
    Color? settingsTileTextColor,
    Color? inactiveTitleColor,
    Color? inactiveSubtitleColor,
  }) {
    return SettingsThemeData(
      settingsListBackground:
          settingsListBackground ?? this.settingsListBackground,
      trailingTextColor: trailingTextColor ?? this.trailingTextColor,
      leadingIconsColor: leadingIconsColor ?? this.leadingIconsColor,
      settingsSectionBackground:
          settingsSectionBackground ?? this.settingsSectionBackground,
      dividerColor: dividerColor ?? this.dividerColor,
      tileDescriptionTextColor:
          tileDescriptionTextColor ?? this.tileDescriptionTextColor,
      tileHighlightColor: tileHighlightColor ?? this.tileHighlightColor,
      titleTextColor: titleTextColor ?? this.titleTextColor,
      inactiveTitleColor: inactiveTitleColor ?? this.inactiveTitleColor,
      inactiveSubtitleColor:
          inactiveSubtitleColor ?? this.inactiveSubtitleColor,
      settingsTileTextColor:
          settingsTileTextColor ?? this.settingsTileTextColor,
    );
  }
}
