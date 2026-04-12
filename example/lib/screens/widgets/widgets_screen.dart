import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../destination.dart';
import '../button/button_screen.dart';
import '../code_editor/code_editor_screen.dart';
import '../feedback/feedback_screen.dart';
import '../markdown/markdown_screen.dart';
import '../scaffold/scaffold_screen.dart';

class WidgetsScreen extends StatelessWidget {
  static const name = 'Widgets';
  static const path = '/widgets';

  const WidgetsScreen({super.key});

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
        title: const Text('Widgets'),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => const _WidgetsBody(),
    );
  }
}

class _WidgetsBody extends StatelessWidget {
  const _WidgetsBody();

  static const _items = [
    _WidgetMenuItem(
      routeName: ButtonScreen.name,
      title: 'Buttons & Inputs',
      subtitle: 'DmButton, DmTextField, DmCheckbox, DmSlider, DmChip…',
      icon: Icons.smart_button,
    ),
    _WidgetMenuItem(
      routeName: FeedbackScreen.name,
      title: 'Feedback',
      subtitle: 'Dialogs, snackbars, toasts, bottom sheets',
      icon: Icons.feedback_outlined,
    ),
    _WidgetMenuItem(
      routeName: ScaffoldScreen.name,
      title: 'Scaffold & Layout',
      subtitle: 'DmAppBar, DmDrawer, DmTabBar, DmCard, DmDivider…',
      icon: Icons.dashboard_outlined,
    ),
    _WidgetMenuItem(
      routeName: MarkdownScreen.name,
      title: 'Markdown',
      subtitle: 'DmMarkdown viewer and DmMarkdownInput editor',
      icon: Icons.edit_document,
    ),
    _WidgetMenuItem(
      routeName: CodeEditorScreen.name,
      title: 'Code Editor',
      subtitle: '19-language editor with syntax highlighting',
      icon: Icons.code,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 320,
        mainAxisExtent: 140,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: _items.length,
      itemBuilder: (context, i) => _items[i].build(context),
    );
  }
}

class _WidgetMenuItem {
  final String routeName;
  final String title;
  final String subtitle;
  final IconData icon;

  const _WidgetMenuItem({
    required this.routeName,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DmCard(
      child: InkWell(
        onTap: () => context.goNamed(routeName),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
