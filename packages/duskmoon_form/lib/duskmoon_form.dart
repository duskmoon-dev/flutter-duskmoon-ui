/// Form state management and adaptive form widgets for DuskMoon Design System.
///
/// Merges BLoC-based form state management with platform-adaptive
/// form field widgets. Import this single library to access all
/// DuskMoon Form components.
library;

// ── BLoC layer ──────────────────────────────────────────────────────────────

// Form BLoC
export 'src/blocs/form/form_bloc.dart';

// Field BLoCs
export 'src/blocs/field/field_bloc.dart';

// Observer
export 'src/blocs/form_bloc_observer.dart';

// Validators
export 'src/validators/field_bloc_validators.dart';

// ── Theme ───────────────────────────────────────────────────────────────────

export 'src/theme/form_bloc_theme.dart';
export 'src/theme/form_bloc_theme_provider.dart';
export 'src/theme/field_theme_resolver.dart';
export 'src/theme/form_config.dart';
export 'src/theme/material_states.dart';
export 'src/theme/suffix_button_themes.dart';

// ── Widget infrastructure ───────────────────────────────────────────────────

export 'src/widgets/field_bloc_builder.dart';
export 'src/widgets/fields/simple_field_bloc_builder.dart';
export 'src/widgets/features/appear/can_show_field_bloc_builder.dart';
export 'src/widgets/features/scroll/scrollable_field_bloc_target.dart';
export 'src/widgets/features/scroll/scrollable_form_bloc_manager.dart';

// Suffix buttons
export 'src/widgets/suffix_buttons/suffix_button_bloc_builder.dart';
export 'src/widgets/suffix_buttons/clear_suffix_button.dart';
export 'src/widgets/suffix_buttons/obscure_suffix_button.dart';

// ── Field widget builders ───────────────────────────────────────────────────

// Text
export 'src/widgets/dm_text_field_bloc_builder.dart';

// Markdown
export 'src/widgets/dm_markdown_field_bloc_builder.dart';

// Code editor
export 'src/widgets/dm_code_editor_field_bloc_builder.dart';

// Boolean
export 'src/widgets/dm_checkbox_field_bloc_builder.dart';
export 'src/widgets/dm_switch_field_bloc_builder.dart';

// Selection
export 'src/widgets/dm_dropdown_field_bloc_builder.dart';
export 'src/widgets/chip/dm_choice_chip_field_bloc_builder.dart';
export 'src/widgets/chip/dm_filter_chip_field_bloc_builder.dart';
export 'src/widgets/chip/chip_field_item_builder.dart';

// Groups
export 'src/widgets/groups/fields/dm_checkbox_group_field_bloc_builder.dart';
export 'src/widgets/groups/fields/dm_radio_button_group_field_bloc.dart';
export 'src/widgets/groups/widgets/group_view.dart';

// Slider
export 'src/widgets/slider/dm_slider_field_bloc_builder.dart';

// Date & Time
export 'src/widgets/date_time/dm_date_time_field_bloc_builder.dart';
export 'src/widgets/date_time/dm_time_field_bloc_builder.dart';

// ── Form-level widgets ──────────────────────────────────────────────────────

export 'src/widgets/dm_form_bloc_listener.dart';
export 'src/widgets/stepper/dm_stepper_form_bloc_builder.dart';

// ── Utilities ───────────────────────────────────────────────────────────────

export 'src/utils/field_bloc_builder_control_affinity.dart';
export 'src/utils/field_item.dart';
export 'src/utils/typedefs.dart';
export 'src/utils/style.dart';

// ── Re-exports ──────────────────────────────────────────────────────────────

export 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmMarkdownTab;
export 'package:flutter_bloc/flutter_bloc.dart';
