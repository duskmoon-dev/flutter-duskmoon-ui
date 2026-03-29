import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Switch tile state
  bool _switchValue = true;

  // Check tile state
  bool _checkValue = false;

  // Input tile state
  String _inputValue = '';

  // Slider tile state
  double _sliderValue = 0.3;

  // Select tile state
  String? _selectValue = 'option1';

  // Textarea tile state
  String _textareaValue = '';

  // Radio group state
  String? _radioValue = 'small';

  // Checkbox group state
  Set<String> _checkboxGroupValues = {'email'};

  // Platform override
  DevicePlatform? _platformOverride;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<DevicePlatform?>(
            segments: const [
              ButtonSegment(value: null, label: Text('Auto')),
              ButtonSegment(
                  value: DevicePlatform.android, label: Text('Material')),
              ButtonSegment(value: DevicePlatform.iOS, label: Text('Cupertino')),
              ButtonSegment(
                  value: DevicePlatform.windows, label: Text('Fluent')),
            ],
            selected: {_platformOverride},
            onSelectionChanged: (v) =>
                setState(() => _platformOverride = v.first),
          ),
        ),
        Expanded(
          child: SettingsList(
            platform: _platformOverride,
            sections: [
              SettingsSection(
                title: const Text('Basic Tiles'),
                tiles: [
                  // 1. Simple tile
                  SettingsTile(
                    leading: const Icon(Icons.info),
                    title: const Text('Simple Tile'),
                    value: const Text('Displays information'),
                    onPressed: (ctx) => _showMessage('Simple tile tapped'),
                  ),

                  // 2. Navigation tile
                  SettingsTile.navigation(
                    leading: const Icon(Icons.language),
                    title: const Text('Navigation Tile'),
                    value: const Text('English'),
                    onPressed: (ctx) => _showMessage('Navigate to language'),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Toggle Tiles'),
                tiles: [
                  // 3. Switch tile
                  SettingsTile.switchTile(
                    leading: const Icon(Icons.dark_mode),
                    title: const Text('Switch Tile'),
                    description: const Text('Toggle a boolean setting'),
                    initialValue: _switchValue,
                    onToggle: (v) => setState(() => _switchValue = v),
                  ),

                  // 4. Check tile
                  SettingsTile.checkTile(
                    leading: const Icon(Icons.check_circle),
                    title: const Text('Check Tile'),
                    description: const Text('Checkmark indicator'),
                    checked: _checkValue,
                    onPressed: (_) =>
                        setState(() => _checkValue = !_checkValue),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Input Tiles'),
                tiles: [
                  // 5. Input tile
                  SettingsTile.input(
                    leading: const Icon(Icons.edit),
                    title: const Text('Input Tile'),
                    description: const Text('Single-line text input'),
                    inputValue: _inputValue,
                    onInputChanged: (v) => setState(() => _inputValue = v),
                    inputHint: 'Enter a value...',
                  ),

                  // 6. Textarea tile
                  SettingsTile.textarea(
                    leading: const Icon(Icons.notes),
                    title: const Text('Textarea Tile'),
                    description: const Text('Multi-line text input'),
                    textareaValue: _textareaValue,
                    onTextareaChanged: (v) =>
                        setState(() => _textareaValue = v),
                    textareaHint: 'Enter notes...',
                    textareaMaxLines: 4,
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Selection Tiles'),
                tiles: [
                  // 7. Slider tile
                  SettingsTile.slider(
                    leading: const Icon(Icons.volume_up),
                    title: const Text('Slider Tile'),
                    description:
                        Text('Value: ${_sliderValue.toStringAsFixed(2)}'),
                    sliderValue: _sliderValue,
                    onSliderChanged: (v) => setState(() => _sliderValue = v),
                    sliderDivisions: 10,
                  ),

                  // 8. Select tile
                  SettingsTile.select(
                    leading: const Icon(Icons.list),
                    title: const Text('Select Tile'),
                    description: const Text('Dropdown selection'),
                    options: const [
                      SettingsOption(value: 'option1', label: 'Option 1'),
                      SettingsOption(value: 'option2', label: 'Option 2'),
                      SettingsOption(value: 'option3', label: 'Option 3'),
                    ],
                    selectValue: _selectValue,
                    onSelectChanged: (v) => setState(() => _selectValue = v),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Group Tiles'),
                tiles: [
                  // 9. Radio group tile
                  SettingsTile.radioGroup(
                    leading: const Icon(Icons.radio_button_checked),
                    title: const Text('Radio Group'),
                    description: const Text('Single-choice selection'),
                    options: const [
                      SettingsOption(value: 'small', label: 'Small'),
                      SettingsOption(value: 'medium', label: 'Medium'),
                      SettingsOption(value: 'large', label: 'Large'),
                    ],
                    radioValue: _radioValue,
                    onRadioChanged: (v) => setState(() => _radioValue = v),
                  ),

                  // 10. Checkbox group tile
                  SettingsTile.checkboxGroup(
                    leading: const Icon(Icons.checklist),
                    title: const Text('Checkbox Group'),
                    description: const Text('Multi-choice selection'),
                    options: const [
                      SettingsOption(value: 'email', label: 'Email'),
                      SettingsOption(value: 'sms', label: 'SMS'),
                      SettingsOption(value: 'push', label: 'Push'),
                    ],
                    checkboxValues: _checkboxGroupValues,
                    onCheckboxChanged: (v) =>
                        setState(() => _checkboxGroupValues = v),
                  ),
                ],
              ),
              SettingsSection(
                title: const Text('Custom Tile'),
                tiles: [
                  CustomSettingsTile(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          const Icon(Icons.palette),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'This is a CustomSettingsTile with arbitrary content',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showMessage(String msg) {
    showDmSnackbar(
      context: context,
      message: Text(msg),
      duration: const Duration(seconds: 2),
    );
  }
}
