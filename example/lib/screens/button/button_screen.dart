import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

import '../../destination.dart';

class ButtonScreen extends StatelessWidget {
  static const name = 'Buttons';
  static const path = '/buttons';

  const ButtonScreen({super.key});

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
        title: const Text('Buttons & Inputs'),
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => const _ButtonBody(),
    );
  }
}

class _ButtonBody extends StatefulWidget {
  const _ButtonBody();

  @override
  State<_ButtonBody> createState() => _ButtonBodyState();
}

class _ButtonBodyState extends State<_ButtonBody> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildButtonVariants(),
        const SizedBox(height: 24),
        _buildIconButtons(),
        const SizedBox(height: 24),
        _buildFabs(),
        const SizedBox(height: 24),
        _buildInputWidgets(),
        const SizedBox(height: 24),
        _buildDataDisplayWidgets(),
      ],
    );
  }

  Widget _buildButtonVariants() {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DmButton Variants',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final variant in DmButtonVariant.values)
                  DmButton(
                    variant: variant,
                    onPressed: () => _showMessage('${variant.name} pressed'),
                    child: Text(variant.name),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Disabled', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final variant in DmButtonVariant.values)
                  DmButton(
                    variant: variant,
                    onPressed: null,
                    child: Text(variant.name),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButtons() {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DmIconButton',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                DmIconButton(
                  icon: const Icon(Icons.favorite),
                  tooltip: 'Favorite',
                  onPressed: () => _showMessage('Favorite'),
                ),
                DmIconButton(
                  icon: const Icon(Icons.share),
                  tooltip: 'Share',
                  onPressed: () => _showMessage('Share'),
                ),
                DmIconButton(
                  icon: const Icon(Icons.more_vert),
                  tooltip: 'More',
                  onPressed: () => _showMessage('More'),
                ),
                const DmIconButton(
                  icon: Icon(Icons.block),
                  tooltip: 'Disabled',
                  onPressed: null,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFabs() {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('DmFab', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                DmFab(
                  onPressed: () => _showMessage('FAB icon'),
                  icon: const Icon(Icons.add),
                ),
                DmFab(
                  onPressed: () => _showMessage('FAB extended'),
                  icon: const Icon(Icons.edit),
                  label: const Text('Compose'),
                ),
                DmFab(
                  onPressed: () => _showMessage('FAB child'),
                  child: const Icon(Icons.navigation),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputWidgets() {
    return _InputWidgetsSection(onMessage: _showMessage);
  }

  Widget _buildDataDisplayWidgets() {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Data Display',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('DmAvatar', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            const Wrap(
              spacing: 8,
              children: [
                DmAvatar(child: Text('A')),
                DmAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.person),
                ),
                DmAvatar(radius: 30, child: Text('XL')),
              ],
            ),
            const SizedBox(height: 16),
            Text('DmBadge', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 16,
              children: [
                const DmBadge(
                  label: '3',
                  child: Icon(Icons.mail, size: 28),
                ),
                DmBadge(
                  label: '99+',
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  child: const Icon(Icons.notifications, size: 28),
                ),
                const DmBadge(child: Icon(Icons.chat, size: 28)),
              ],
            ),
            const SizedBox(height: 16),
            Text('DmChip', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                const DmChip(label: Text('Basic Chip')),
                DmChip(
                  label: const Text('Deletable'),
                  onDeleted: () => _showMessage('Chip deleted'),
                ),
                DmChip(
                  label: const Text('Filter'),
                  selected: true,
                  onSelected: (v) => _showMessage('Filter: $v'),
                ),
                DmChip(
                  label: const Text('With Avatar'),
                  avatar: const Icon(Icons.tag, size: 18),
                  onSelected: (v) {},
                ),
              ],
            ),
          ],
        ),
      ),
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

class _InputWidgetsSection extends StatefulWidget {
  const _InputWidgetsSection({required this.onMessage});

  final void Function(String) onMessage;

  @override
  State<_InputWidgetsSection> createState() => _InputWidgetsSectionState();
}

class _InputWidgetsSectionState extends State<_InputWidgetsSection> {
  bool _checkboxValue = false;
  bool _switchValue = true;
  double _sliderValue = 0.5;

  @override
  Widget build(BuildContext context) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Input Widgets',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Text('DmTextField',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            DmTextField(
              placeholder: 'Enter text...',
              onChanged: (v) {},
            ),
            const SizedBox(height: 8),
            const DmTextField(
              placeholder: 'Disabled',
              enabled: false,
            ),
            const SizedBox(height: 16),
            Text('DmCheckbox',
                style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                DmCheckbox(
                  value: _checkboxValue,
                  onChanged: (v) =>
                      setState(() => _checkboxValue = v ?? false),
                ),
                const SizedBox(width: 8),
                Text(_checkboxValue ? 'Checked' : 'Unchecked'),
              ],
            ),
            const SizedBox(height: 16),
            Text('DmSwitch', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                DmSwitch(
                  value: _switchValue,
                  onChanged: (v) => setState(() => _switchValue = v),
                ),
                const SizedBox(width: 8),
                Text(_switchValue ? 'On' : 'Off'),
              ],
            ),
            const SizedBox(height: 16),
            Text('DmSlider', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DmSlider(
                    value: _sliderValue,
                    divisions: 10,
                    onChanged: (v) => setState(() => _sliderValue = v),
                  ),
                ),
                const SizedBox(width: 8),
                Text(_sliderValue.toStringAsFixed(1)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
