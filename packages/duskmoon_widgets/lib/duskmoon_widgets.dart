/// Adaptive widget library for the DuskMoon Design System.
///
/// Provides platform-aware widgets that render Material or Cupertino
/// variants based on the current platform or an explicit override.
library;

// Adaptive infrastructure
export 'src/adaptive/adaptive_widget.dart';
export 'src/adaptive/dm_platform_style.dart';
export 'src/adaptive/duskmoon_app.dart';
export 'src/adaptive/fluent_theme_bridge.dart'
    show dmFluentLocalizationsDelegates;
export 'src/adaptive/platform_override.dart';
export 'src/adaptive/platform_resolver.dart';

// Scaffold
export 'src/scaffold/dm_action_list.dart';
export 'src/scaffold/dm_scaffold.dart';

// Buttons
export 'src/buttons/dm_button.dart';
export 'src/buttons/dm_fab.dart';
export 'src/buttons/dm_icon_button.dart';

// Inputs
export 'src/inputs/dm_checkbox.dart';
export 'src/inputs/dm_dropdown.dart';
export 'src/inputs/dm_slider.dart';
export 'src/inputs/dm_switch.dart';
export 'src/inputs/dm_text_field.dart';

// Layout
export 'src/layout/dm_card.dart';
export 'src/layout/dm_divider.dart';

// Navigation
export 'src/navigation/dm_app_bar.dart';
export 'src/navigation/dm_bottom_nav.dart';
export 'src/navigation/dm_drawer.dart';
export 'src/navigation/dm_tab_bar.dart';

// Data Display
export 'src/data_display/dm_avatar.dart';
export 'src/data_display/dm_badge.dart';
export 'src/data_display/dm_chip.dart';

// Markdown
export 'src/markdown/dm_markdown.dart';
export 'src/markdown/dm_markdown_config.dart';
export 'src/markdown/dm_markdown_scroll_controller.dart';

// Markdown Input
export 'src/markdown_input/dm_markdown_input.dart';
export 'src/markdown_input/dm_markdown_input_controller.dart';
export 'src/markdown_input/dm_markdown_tab.dart';

// Code Editor
export 'src/code_editor/dm_code_editor.dart';
export 'src/code_editor/dm_code_editor_theme.dart';
export 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show EditorViewController, EditorState, EditorTheme;
