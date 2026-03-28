import 'package:flutter/material.dart';
import 'package:duskmoon_settings/src/tiles/abstract_settings_tile.dart';
import 'package:duskmoon_settings/src/tiles/platforms/cupertino_settings_tile.dart';
import 'package:duskmoon_settings/src/tiles/platforms/fluent_settings_tile.dart';
import 'package:duskmoon_settings/src/tiles/platforms/material_settings_tile.dart';
import 'package:duskmoon_settings/src/utils/platform_utils.dart';
import 'package:duskmoon_settings/src/utils/settings_option.dart';
import 'package:duskmoon_settings/src/utils/settings_theme.dart';

/// Compositor widget that creates platform-specific settings tiles.
///
/// This widget does not extend [AbstractSettingsTile] because it uses
/// named constructors with late final assignments. Instead, it delegates
/// to design system implementations:
/// - [MaterialSettingsTile] for Android, Linux, Web, Fuchsia
/// - [CupertinoSettingsTile] for iOS, macOS
/// - [FluentSettingsTile] for Windows
class SettingsTile extends StatelessWidget {
  /// Creates a simple settings tile with a title and optional extras.
  SettingsTile({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    super.key,
  }) {
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.simpleTile;
    // New tile properties - null for simple tile
    inputValue = null;
    onInputChanged = null;
    inputHint = null;
    inputKeyboardType = null;
    inputMaxLength = null;
    sliderValue = null;
    onSliderChanged = null;
    sliderMin = 0;
    sliderMax = 1;
    sliderDivisions = null;
    selectOptions = null;
    selectValue = null;
    onSelectChanged = null;
    textareaValue = null;
    onTextareaChanged = null;
    textareaHint = null;
    textareaMaxLines = 3;
    textareaMaxLength = null;
    radioOptions = null;
    radioValue = null;
    onRadioChanged = null;
    checkboxOptions = null;
    checkboxValues = null;
    onCheckboxChanged = null;
  }

  /// Creates a navigation tile with a trailing chevron indicator.
  SettingsTile.navigation({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    super.key,
  }) {
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.navigationTile;
    // New tile properties
    inputValue = null;
    onInputChanged = null;
    inputHint = null;
    inputKeyboardType = null;
    inputMaxLength = null;
    sliderValue = null;
    onSliderChanged = null;
    sliderMin = 0;
    sliderMax = 1;
    sliderDivisions = null;
    selectOptions = null;
    selectValue = null;
    onSelectChanged = null;
    textareaValue = null;
    onTextareaChanged = null;
    textareaHint = null;
    textareaMaxLines = 3;
    textareaMaxLength = null;
    radioOptions = null;
    radioValue = null;
    onRadioChanged = null;
    checkboxOptions = null;
    checkboxValues = null;
    onCheckboxChanged = null;
  }

  /// Creates a tile with an integrated toggle switch.
  SettingsTile.switchTile({
    required this.initialValue,
    required this.onToggle,
    this.activeSwitchColor,
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    super.key,
  }) {
    value = null;
    checked = null;
    tileType = SettingsTileType.switchTile;
    // New tile properties
    inputValue = null;
    onInputChanged = null;
    inputHint = null;
    inputKeyboardType = null;
    inputMaxLength = null;
    sliderValue = null;
    onSliderChanged = null;
    sliderMin = 0;
    sliderMax = 1;
    sliderDivisions = null;
    selectOptions = null;
    selectValue = null;
    onSelectChanged = null;
    textareaValue = null;
    onTextareaChanged = null;
    textareaHint = null;
    textareaMaxLines = 3;
    textareaMaxLength = null;
    radioOptions = null;
    radioValue = null;
    onRadioChanged = null;
    checkboxOptions = null;
    checkboxValues = null;
    onCheckboxChanged = null;
  }

  /// Creates a tile with a checkmark indicator for selection state.
  SettingsTile.checkTile({
    this.leading,
    this.trailing,
    this.value,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    this.checked,
    super.key,
  }) {
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    tileType = SettingsTileType.checkTile;
    // New tile properties
    inputValue = null;
    onInputChanged = null;
    inputHint = null;
    inputKeyboardType = null;
    inputMaxLength = null;
    sliderValue = null;
    onSliderChanged = null;
    sliderMin = 0;
    sliderMax = 1;
    sliderDivisions = null;
    selectOptions = null;
    selectValue = null;
    onSelectChanged = null;
    textareaValue = null;
    onTextareaChanged = null;
    textareaHint = null;
    textareaMaxLines = 3;
    textareaMaxLength = null;
    radioOptions = null;
    radioValue = null;
    onRadioChanged = null;
    checkboxOptions = null;
    checkboxValues = null;
    onCheckboxChanged = null;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // New tile constructors
  // ───────────────────────────────────────────────────────────────────────────

  /// Creates a single-line text input tile.
  SettingsTile.input({
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    this.inputValue,
    required this.onInputChanged,
    this.inputHint,
    this.inputKeyboardType,
    this.inputMaxLength,
    super.key,
  }) {
    value = null;
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.inputTile;
    // Other new tile properties null
    sliderValue = null;
    onSliderChanged = null;
    sliderMin = 0;
    sliderMax = 1;
    sliderDivisions = null;
    selectOptions = null;
    selectValue = null;
    onSelectChanged = null;
    textareaValue = null;
    onTextareaChanged = null;
    textareaHint = null;
    textareaMaxLines = 3;
    textareaMaxLength = null;
    radioOptions = null;
    radioValue = null;
    onRadioChanged = null;
    checkboxOptions = null;
    checkboxValues = null;
    onCheckboxChanged = null;
  }

  /// Creates a slider tile for numeric value selection.
  SettingsTile.slider({
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    required this.sliderValue,
    required this.onSliderChanged,
    this.sliderMin = 0,
    this.sliderMax = 1,
    this.sliderDivisions,
    super.key,
  }) {
    value = null;
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.sliderTile;
    // Input properties null
    inputValue = null;
    onInputChanged = null;
    inputHint = null;
    inputKeyboardType = null;
    inputMaxLength = null;
    // Other new tile properties null
    selectOptions = null;
    selectValue = null;
    onSelectChanged = null;
    textareaValue = null;
    onTextareaChanged = null;
    textareaHint = null;
    textareaMaxLines = 3;
    textareaMaxLength = null;
    radioOptions = null;
    radioValue = null;
    onRadioChanged = null;
    checkboxOptions = null;
    checkboxValues = null;
    onCheckboxChanged = null;
  }

  /// Creates a dropdown/picker tile for option selection.
  SettingsTile.select({
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    required List<SettingsOption> options,
    this.selectValue,
    required this.onSelectChanged,
    super.key,
  }) {
    value = null;
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.selectTile;
    // Input properties null
    inputValue = null;
    onInputChanged = null;
    inputHint = null;
    inputKeyboardType = null;
    inputMaxLength = null;
    sliderValue = null;
    onSliderChanged = null;
    sliderMin = 0;
    sliderMax = 1;
    sliderDivisions = null;
    // Select properties
    selectOptions = options;
    // Other new tile properties null
    textareaValue = null;
    onTextareaChanged = null;
    textareaHint = null;
    textareaMaxLines = 3;
    textareaMaxLength = null;
    radioOptions = null;
    radioValue = null;
    onRadioChanged = null;
    checkboxOptions = null;
    checkboxValues = null;
    onCheckboxChanged = null;
  }

  /// Creates a multi-line text input tile.
  SettingsTile.textarea({
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    this.textareaValue,
    required this.onTextareaChanged,
    this.textareaHint,
    this.textareaMaxLines = 3,
    this.textareaMaxLength,
    super.key,
  }) {
    value = null;
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.textareaTile;
    // Input properties null
    inputValue = null;
    onInputChanged = null;
    inputHint = null;
    inputKeyboardType = null;
    inputMaxLength = null;
    sliderValue = null;
    onSliderChanged = null;
    sliderMin = 0;
    sliderMax = 1;
    sliderDivisions = null;
    selectOptions = null;
    selectValue = null;
    onSelectChanged = null;
    // Other new tile properties null
    radioOptions = null;
    radioValue = null;
    onRadioChanged = null;
    checkboxOptions = null;
    checkboxValues = null;
    onCheckboxChanged = null;
  }

  /// Creates a radio group tile with single selection.
  SettingsTile.radioGroup({
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    required List<SettingsOption> options,
    this.radioValue,
    required this.onRadioChanged,
    super.key,
  }) {
    value = null;
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.radioGroupTile;
    // Input properties null
    inputValue = null;
    onInputChanged = null;
    inputHint = null;
    inputKeyboardType = null;
    inputMaxLength = null;
    sliderValue = null;
    onSliderChanged = null;
    sliderMin = 0;
    sliderMax = 1;
    sliderDivisions = null;
    selectOptions = null;
    selectValue = null;
    onSelectChanged = null;
    textareaValue = null;
    onTextareaChanged = null;
    textareaHint = null;
    textareaMaxLines = 3;
    textareaMaxLength = null;
    // Radio properties
    radioOptions = options;
    // Other new tile properties null
    checkboxOptions = null;
    checkboxValues = null;
    onCheckboxChanged = null;
  }

  /// Creates a checkbox group tile with multiple selection.
  SettingsTile.checkboxGroup({
    this.leading,
    this.trailing,
    required this.title,
    this.description,
    this.onPressed,
    this.enabled = true,
    required List<SettingsOption> options,
    required this.checkboxValues,
    required this.onCheckboxChanged,
    super.key,
  }) {
    value = null;
    onToggle = null;
    initialValue = null;
    activeSwitchColor = null;
    checked = null;
    tileType = SettingsTileType.checkboxGroupTile;
    // Input properties null
    inputValue = null;
    onInputChanged = null;
    inputHint = null;
    inputKeyboardType = null;
    inputMaxLength = null;
    sliderValue = null;
    onSliderChanged = null;
    sliderMin = 0;
    sliderMax = 1;
    sliderDivisions = null;
    selectOptions = null;
    selectValue = null;
    onSelectChanged = null;
    textareaValue = null;
    onTextareaChanged = null;
    textareaHint = null;
    textareaMaxLines = 3;
    textareaMaxLength = null;
    radioOptions = null;
    radioValue = null;
    onRadioChanged = null;
    // Checkbox properties
    checkboxOptions = options;
  }

  /// The widget at the beginning of the tile
  final Widget? leading;

  /// The Widget at the end of the tile
  final Widget? trailing;

  /// The widget at the center of the tile
  final Widget title;

  /// The widget at the bottom of the [title]
  final Widget? description;

  /// A function that is called by tap on a tile
  final void Function(BuildContext context)? onPressed;

  /// Color for the active state of the switch toggle.
  late final Color? activeSwitchColor;

  /// Secondary value widget displayed below or beside the title.
  late final Widget? value;

  /// Callback when the switch is toggled.
  late final Function(bool value)? onToggle;

  /// The visual type of this tile.
  late final SettingsTileType tileType;

  /// Initial on/off value for switch tiles.
  late final bool? initialValue;

  /// Whether this tile is interactive.
  late final bool enabled;

  /// Whether this tile displays a checkmark.
  late final bool? checked;

  /// Current text for input tiles.
  late final String? inputValue;

  /// Callback when input text changes.
  late final void Function(String)? onInputChanged;

  /// Placeholder hint for input tiles.
  late final String? inputHint;

  /// Keyboard type for input tiles.
  late final TextInputType? inputKeyboardType;

  /// Maximum character length for input tiles.
  late final int? inputMaxLength;

  /// Current value for slider tiles.
  late final double? sliderValue;

  /// Callback when the slider value changes.
  late final void Function(double)? onSliderChanged;

  /// Minimum slider value.
  late final double sliderMin;

  /// Maximum slider value.
  late final double sliderMax;

  /// Number of discrete slider divisions.
  late final int? sliderDivisions;

  /// Available options for select tiles.
  late final List<SettingsOption>? selectOptions;

  /// Currently selected value for select tiles.
  late final String? selectValue;

  /// Callback when the selected option changes.
  late final void Function(String?)? onSelectChanged;

  /// Current text for textarea tiles.
  late final String? textareaValue;

  /// Callback when textarea text changes.
  late final void Function(String)? onTextareaChanged;

  /// Placeholder hint for textarea tiles.
  late final String? textareaHint;

  /// Number of visible text lines for textarea tiles.
  late final int textareaMaxLines;

  /// Maximum character length for textarea tiles.
  late final int? textareaMaxLength;

  /// Available options for radio group tiles.
  late final List<SettingsOption>? radioOptions;

  /// Currently selected radio value.
  late final String? radioValue;

  /// Callback when the radio selection changes.
  late final void Function(String?)? onRadioChanged;

  /// Available options for checkbox group tiles.
  late final List<SettingsOption>? checkboxOptions;

  /// Currently selected checkbox values.
  late final Set<String>? checkboxValues;

  /// Callback when checkbox selections change.
  late final void Function(Set<String>)? onCheckboxChanged;

  Widget? addCheckedTrailing(BuildContext context) {
    if (checked != null) {
      return checked!
          ? const Icon(Icons.check, color: Colors.lightGreen)
          : const Icon(Icons.check, color: Colors.transparent);
    }
    return trailing;
  }

  @override
  Widget build(BuildContext context) {
    final theme = SettingsTheme.of(context);

    switch (theme.platform) {
      case DevicePlatform.android:
      case DevicePlatform.fuchsia:
      case DevicePlatform.linux:
      case DevicePlatform.web:
      case DevicePlatform.custom:
        return MaterialSettingsTile(
          description: description,
          onPressed: onPressed,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          enabled: enabled,
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
          trailing: addCheckedTrailing(context),
          // New tile properties
          inputValue: inputValue,
          onInputChanged: onInputChanged,
          inputHint: inputHint,
          inputKeyboardType: inputKeyboardType,
          inputMaxLength: inputMaxLength,
          sliderValue: sliderValue,
          onSliderChanged: onSliderChanged,
          sliderMin: sliderMin,
          sliderMax: sliderMax,
          sliderDivisions: sliderDivisions,
          selectOptions: selectOptions,
          selectValue: selectValue,
          onSelectChanged: onSelectChanged,
          textareaValue: textareaValue,
          onTextareaChanged: onTextareaChanged,
          textareaHint: textareaHint,
          textareaMaxLines: textareaMaxLines,
          textareaMaxLength: textareaMaxLength,
          radioOptions: radioOptions,
          radioValue: radioValue,
          onRadioChanged: onRadioChanged,
          checkboxOptions: checkboxOptions,
          checkboxValues: checkboxValues,
          onCheckboxChanged: onCheckboxChanged,
        );
      case DevicePlatform.iOS:
      case DevicePlatform.macOS:
        return CupertinoSettingsTile(
          description: description,
          onPressed: onPressed,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          trailing: addCheckedTrailing(context),
          enabled: enabled,
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
          // New tile properties
          inputValue: inputValue,
          onInputChanged: onInputChanged,
          inputHint: inputHint,
          inputKeyboardType: inputKeyboardType,
          inputMaxLength: inputMaxLength,
          sliderValue: sliderValue,
          onSliderChanged: onSliderChanged,
          sliderMin: sliderMin,
          sliderMax: sliderMax,
          sliderDivisions: sliderDivisions,
          selectOptions: selectOptions,
          selectValue: selectValue,
          onSelectChanged: onSelectChanged,
          textareaValue: textareaValue,
          onTextareaChanged: onTextareaChanged,
          textareaHint: textareaHint,
          textareaMaxLines: textareaMaxLines,
          textareaMaxLength: textareaMaxLength,
          radioOptions: radioOptions,
          radioValue: radioValue,
          onRadioChanged: onRadioChanged,
          checkboxOptions: checkboxOptions,
          checkboxValues: checkboxValues,
          onCheckboxChanged: onCheckboxChanged,
        );
      case DevicePlatform.windows:
        return FluentSettingsTile(
          description: description,
          onPressed: onPressed,
          onToggle: onToggle,
          tileType: tileType,
          value: value,
          leading: leading,
          title: title,
          enabled: enabled,
          trailing: addCheckedTrailing(context),
          activeSwitchColor: activeSwitchColor,
          initialValue: initialValue ?? false,
          // New tile properties
          inputValue: inputValue,
          onInputChanged: onInputChanged,
          inputHint: inputHint,
          inputKeyboardType: inputKeyboardType,
          inputMaxLength: inputMaxLength,
          sliderValue: sliderValue,
          onSliderChanged: onSliderChanged,
          sliderMin: sliderMin,
          sliderMax: sliderMax,
          sliderDivisions: sliderDivisions,
          selectOptions: selectOptions,
          selectValue: selectValue,
          onSelectChanged: onSelectChanged,
          textareaValue: textareaValue,
          onTextareaChanged: onTextareaChanged,
          textareaHint: textareaHint,
          textareaMaxLines: textareaMaxLines,
          textareaMaxLength: textareaMaxLength,
          radioOptions: radioOptions,
          radioValue: radioValue,
          onRadioChanged: onRadioChanged,
          checkboxOptions: checkboxOptions,
          checkboxValues: checkboxValues,
          onCheckboxChanged: onCheckboxChanged,
        );
    }
  }
}
