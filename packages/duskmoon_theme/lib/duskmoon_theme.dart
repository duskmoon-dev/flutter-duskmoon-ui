/// DuskMoon Design System theme package.
///
/// Provides codegen-driven color schemes, text themes, and theme data
/// factories for Material 3 applications.
library;

// Theme factories
export 'src/theme_data.dart' show DmThemeData, DmThemeEntry;
export 'src/color_scheme.dart' show DmColorScheme;
export 'src/text_theme.dart' show DmTextTheme;

// Theme containers
export 'src/dm_theme.dart' show DmTheme;
export 'src/dm_colors.dart' show DmColors;

// Extensions
export 'src/extensions.dart' show DmColorExtension;
export 'src/theme_mode_extension.dart' show ThemeModeExtension;

// Platform resolution
export 'src/adaptive/adaptive_widget.dart';
export 'src/adaptive/dm_platform_style.dart';
export 'src/adaptive/duskmoon_app.dart';
export 'src/adaptive/platform_override.dart';
export 'src/adaptive/platform_resolver.dart';

// Generated tokens (direct access)
export 'src/generated/sunshine_tokens.g.dart' show SunshineTokens;
export 'src/generated/moonlight_tokens.g.dart' show MoonlightTokens;
export 'src/generated/forest_tokens.g.dart' show ForestTokens;
export 'src/generated/ocean_tokens.g.dart' show OceanTokens;
