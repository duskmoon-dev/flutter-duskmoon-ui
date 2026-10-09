import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

import 'duo_display_controller.dart';

void main() => runApp(const DuoScreenApp());

@pragma('vm:entry-point')
void secondaryDisplayMain() => runApp(const DuoScreenApp(secondary: true));

class DuoScreenApp extends StatelessWidget {
  const DuoScreenApp({super.key, this.secondary = false, this.controller});

  final bool secondary;
  final DuoDisplayController? controller;

  @override
  Widget build(BuildContext context) {
    final page =
        SharedDuoScaffold(secondary: secondary, controller: controller);
    return DuskmoonApp(
      platformStyle: DmPlatformStyle.material,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DuskMoon Duo',
        theme: DmThemeData.sunshine(),
        darkTheme: DmThemeData.moonlight(),
        themeMode: ThemeMode.system,
        home: page,
        // The Android companion engine sets this initial route.
        // Declare it explicitly instead of relying on unknown-route fallback.
        routes: {secondaryRoute: (_) => page},
      ),
    );
  }
}

class SharedDuoScaffold extends StatefulWidget {
  const SharedDuoScaffold({
    super.key,
    this.secondary = false,
    this.controller,
  });

  final bool secondary;
  final DuoDisplayController? controller;

  @override
  State<SharedDuoScaffold> createState() => _SharedDuoScaffoldState();
}

class _SharedDuoScaffoldState extends State<SharedDuoScaffold> {
  late final DuoDisplayController _controller;
  final _message = TextEditingController();
  final _project = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ??
        DuoDisplayController(
          secondary: widget.secondary,
          platform: defaultDisplayPlatform(),
          bridge: defaultBridge(secondary: widget.secondary),
        );
    _controller.addListener(_changed);
    if (!widget.secondary) _controller.onToast = _showToast;
    _syncText();
    _controller.start();
  }

  void _showToast() {
    if (!mounted) return;
    showDmSuccessToast(
      context: context,
      message: 'Action completed!',
      title: 'Viewer Input',
    );
  }

  void _syncText() {
    if (_message.text != _controller.state.message) {
      _message.value = TextEditingValue(
        text: _controller.state.message,
        selection: TextSelection.collapsed(
          offset: _controller.state.message.length,
        ),
      );
    }
    if (_project.text != _controller.state.projectName) {
      _project.value = TextEditingValue(
        text: _controller.state.projectName,
        selection: TextSelection.collapsed(
          offset: _controller.state.projectName.length,
        ),
      );
    }
  }

  void _changed() {
    if (!mounted) return;
    setState(_syncText);
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    if (!widget.secondary) _controller.onToast = null;
    if (widget.controller == null) _controller.dispose();
    _message.dispose();
    _project.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = _controller.state;
    final role = widget.secondary
        ? DuoScreenRole.secondary
        : _controller.connected
            ? DuoScreenRole.primary
            : DuoScreenRole.single;
    return DmAdaptiveScaffold(
      duoScreenRole: role,
      duoScreenPolicy: DuoScreenPolicy.navigationOnSecondary,
      useDrawer: false,
      appBarBreakpoint: Breakpoints.standard,
      appBar: DmAppBar(
        title: Text(widget.secondary
            ? 'Controller Panel'
            : _controller.connected
                ? 'DuskMoon Viewer'
                : 'DuskMoon Duo'),
        automaticallyImplyLeading: false,
      ),
      body: (_) => _buildViewer(context),
      secondaryBody: widget.secondary || DuoScreen.hingeOf(context) != null
          ? (_) => _buildControls(context)
          : null,
      destinations: [
        for (var index = 0; index < navigationLabels.length; index++)
          NavigationDestination(
            icon: Icon(const [
              Icons.palette,
              Icons.edit_note,
              Icons.insights,
              Icons.code,
            ][index]),
            label: navigationLabels[index],
          ),
      ],
      selectedIndex: state.selectedIndex,
      onSelectedIndexChange: (index) => _controller.intent('select', index),
    );
  }

  Widget _buildViewer(BuildContext context) {
    final state = _controller.state;
    Widget content;
    if (state.isViewerOnly) {
      content = Column(children: [
        Icon(Icons.dashboard_customize,
            size: 80, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 24),
        Text('System Dashboard',
            style: Theme.of(context).textTheme.headlineMedium),
        Text('Navigation: ${navigationLabels[state.selectedIndex]}'),
        const SizedBox(height: 24),
        Text(state.message),
      ]);
    } else {
      content = switch (state.selectedIndex) {
        0 => Column(children: [
            Text(state.message,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Wrap(spacing: 16, runSpacing: 16, children: [
              const DmBadge(label: 'Duo', child: Icon(Icons.devices, size: 40)),
              DmButton(onPressed: _showToast, child: const Text('Fire Toast')),
              DmButton(
                  variant: DmButtonVariant.tonal,
                  onPressed: () {},
                  child: const Text('Tonal')),
              DmButton(
                  variant: DmButtonVariant.outlined,
                  onPressed: () {},
                  child: const Text('Outline')),
            ]),
            const SizedBox(height: 24),
            _messageControls(),
          ]),
        1 => Column(children: [
            Text('DuskMoon Form',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            Text(
              'Preview: ${state.liveFormPreview ? state.projectName : state.savedProjectName}',
              key: const ValueKey('form-preview'),
            ),
            const SizedBox(height: 16),
            _formControls(),
          ]),
        2 => Column(children: [
            Text('Visualization',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: DmVizLineChart(
                data: state.chartData
                    .asMap()
                    .entries
                    .map((e) => DmVizPoint(x: e.key, y: e.value))
                    .toList(),
                xAxisLabel: 'Time',
                yAxisLabel: 'Value',
              ),
            ),
            _chartControls(),
          ]),
        _ => Column(children: [
            Text('Distributed Editor',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            _languageControls(),
            const SizedBox(height: 16),
            SizedBox(
              height: 400,
              child: DmCodeEditor(
                // Each language has its own sample document, so replacing the
                // language intentionally resets this read-only sample editor.
                key: ValueKey(state.editorLanguage),
                language: state.editorLanguage.toLowerCase(),
                initialDoc: editorSamples[state.editorLanguage],
                readOnly: true,
              ),
            ),
          ]),
      };
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(children: [
        if (_controller.status != null) ...[
          Text(_controller.status!),
          const SizedBox(height: 16),
        ],
        content,
      ]),
    );
  }

  Widget _buildControls(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Category: ${navigationLabels[_controller.state.selectedIndex]}',
                style: Theme.of(context).textTheme.headlineSmall),
            if (widget.secondary && !_controller.connected) ...[
              const SizedBox(height: 16),
              const Text('Waiting for viewer connection…'),
            ],
            const SizedBox(height: 16),
            Row(children: [
              const Expanded(child: Text('Dashboard view')),
              DmSwitch(
                value: _controller.state.isViewerOnly,
                onChanged: (value) => _controller.intent('viewerOnly', value),
              ),
            ]),
            const DmDivider(),
            IgnorePointer(
              ignoring: widget.secondary && !_controller.connected,
              child: switch (_controller.state.selectedIndex) {
                0 => _messageControls(includeToast: true),
                1 => _formControls(),
                2 => _chartControls(),
                _ => _languageControls(),
              },
            ),
          ],
        ),
      );

  Widget _messageControls({bool includeToast = false}) => Column(children: [
        DmTextField(
          controller: _message,
          placeholder: 'Viewer message',
          onChanged: (value) => _controller.intent('message', value),
        ),
        if (includeToast) ...[
          const SizedBox(height: 16),
          DmButton(
            onPressed: () => _controller.intent('toast'),
            child: const Text('Fire Toast'),
          ),
        ],
      ]);

  Widget _formControls() => DmCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            DmTextField(
              controller: _project,
              placeholder: 'Project Name',
              onChanged: (value) => _controller.intent('projectName', value),
            ),
            const SizedBox(height: 16),
            Row(children: [
              const Expanded(child: Text('Live form preview')),
              DmSwitch(
                value: _controller.state.liveFormPreview,
                onChanged: (value) =>
                    _controller.intent('liveFormPreview', value),
              ),
            ]),
            const SizedBox(height: 16),
            Text('Saved project: ${_controller.state.savedProjectName}'),
            DmButton(
              onPressed: () => _controller.intent('saveProject'),
              child: const Text('Save Configuration'),
            ),
          ]),
        ),
      );

  Widget _chartControls() => DmButton(
        onPressed: () => _controller.intent('randomize'),
        child: const Text('Randomize Data'),
      );

  Widget _languageControls() => Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final language in editorLanguages)
            DmChip(
              label: Text(language),
              selected: _controller.state.editorLanguage == language,
              onSelected: (_) => _controller.intent('language', language),
            ),
        ],
      );
}

const editorSamples = {
  'Dart': 'void main() {\n  print("Hello from DuskMoon Duo!");\n}',
  'Python': 'def main():\n    print("Hello from DuskMoon Duo!")\n\nmain()',
  'JavaScript':
      'function main() {\n  console.log("Hello from DuskMoon Duo!");\n}\nmain();',
};
