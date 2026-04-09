import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

import '../../destination.dart';

class SettingsScreen extends StatelessWidget {
  static const name = 'Settings';
  static const path = '/settings';

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(name)),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Settings'),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => const _SettingsBody(),
    );
  }
}

class _SettingsBody extends StatefulWidget {
  const _SettingsBody();

  @override
  State<_SettingsBody> createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<_SettingsBody> {
  bool _switchValue = true;
  bool _checkValue = false;
  String _inputValue = '';
  double _sliderValue = 0.3;
  String? _selectValue = 'option1';
  String _textareaValue = '';
  String? _radioValue = 'small';
  Set<String> _checkboxGroupValues = {'email'};

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      sections: [
        SettingsSection(
          title: const Text('Basic Tiles'),
          tiles: [
            SettingsTile(
              leading: const Icon(Icons.info),
              title: const Text('Simple Tile'),
              value: const Text('Displays information'),
              onPressed: (ctx) => _showMessage('Simple tile tapped'),
            ),
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
            SettingsTile.switchTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('Switch Tile'),
              description: const Text('Toggle a boolean setting'),
              initialValue: _switchValue,
              onToggle: (v) => setState(() => _switchValue = v),
            ),
            SettingsTile.checkTile(
              leading: const Icon(Icons.check_circle),
              title: const Text('Check Tile'),
              description: const Text('Checkmark indicator'),
              checked: _checkValue,
              onPressed: (_) => setState(() => _checkValue = !_checkValue),
            ),
          ],
        ),
        SettingsSection(
          title: const Text('Input Tiles'),
          tiles: [
            SettingsTile.input(
              leading: const Icon(Icons.edit),
              title: const Text('Input Tile'),
              description: const Text('Single-line text input'),
              inputValue: _inputValue,
              onInputChanged: (v) => setState(() => _inputValue = v),
              inputHint: 'Enter a value...',
            ),
            SettingsTile.textarea(
              leading: const Icon(Icons.notes),
              title: const Text('Textarea Tile'),
              description: const Text('Multi-line text input'),
              textareaValue: _textareaValue,
              onTextareaChanged: (v) => setState(() => _textareaValue = v),
              textareaHint: 'Enter notes...',
              textareaMaxLines: 4,
            ),
          ],
        ),
        SettingsSection(
          title: const Text('Selection Tiles'),
          tiles: [
            SettingsTile.slider(
              leading: const Icon(Icons.volume_up),
              title: const Text('Slider Tile'),
              description:
                  Text('Value: ${_sliderValue.toStringAsFixed(2)}'),
              sliderValue: _sliderValue,
              onSliderChanged: (v) => setState(() => _sliderValue = v),
              sliderDivisions: 10,
            ),
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
