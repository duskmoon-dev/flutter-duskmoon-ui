/// DuskMoon Design System theme package.
///
/// Provides codegen-driven color schemes, text themes, and theme data
/// factories for Material 3 applications.
library;

// Theme factories
export 'src/theme_data.dart' show DmThemeData, DmThemeEntry;
export 'src/color_scheme.dart' show DmColorScheme;
export 'src/text_theme.dart' show DmTextTheme;

// Extensions
export 'src/extensions.dart' show DmColorExtension;
export 'src/theme_mode_extension.dart' show ThemeModeExtension;

// Generated tokens (direct access)
export 'src/generated/sunshine_tokens.g.dart' show SunshineTokens;
export 'src/generated/moonlight_tokens.g.dart' show MoonlightTokens;
