import 'package:duskmoon_theme_bloc/duskmoon_theme_bloc.dart';
import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemePage extends StatelessWidget {
  const ThemePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DmThemeBloc, DmThemeState>(
      builder: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;
        final dmColors = Theme.of(context).extension<DmColorExtension>();
        final textTheme = Theme.of(context).textTheme;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildThemeModeSection(context, state),
            const SizedBox(height: 24),
            _buildThemeSelector(context, state),
            const SizedBox(height: 24),
            _buildColorSchemeSection(colorScheme),
            const SizedBox(height: 24),
            if (dmColors != null) ...[
              _buildDmColorExtensionSection(dmColors),
              const SizedBox(height: 24),
            ],
            _buildTextThemeSection(textTheme),
          ],
        );
      },
    );
  }

  Widget _buildThemeModeSection(BuildContext context, DmThemeState state) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme Mode', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            SegmentedButton<ThemeMode>(
              segments: [
                for (final mode in ThemeMode.values)
                  ButtonSegment(
                    value: mode,
                    label: Text(mode.title),
                    icon: mode.iconOutlined,
                  ),
              ],
              selected: {state.themeMode},
              onSelectionChanged: (modes) {
                context.read<DmThemeBloc>().add(DmSetThemeMode(modes.first));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSelector(BuildContext context, DmThemeState state) {
    final themes = DmThemeData.themes;
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Themes',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                for (final theme in themes)
                  ChoiceChip(
                    label: Text(theme.name),
                    selected: state.themeName == theme.name,
                    onSelected: (_) {
                      context.read<DmThemeBloc>().add(DmSetTheme(theme.name));
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSchemeSection(ColorScheme cs) {
    final colors = <String, Color>{
      'primary': cs.primary,
      'onPrimary': cs.onPrimary,
      'primaryContainer': cs.primaryContainer,
      'onPrimaryContainer': cs.onPrimaryContainer,
      'secondary': cs.secondary,
      'onSecondary': cs.onSecondary,
      'secondaryContainer': cs.secondaryContainer,
      'onSecondaryContainer': cs.onSecondaryContainer,
      'tertiary': cs.tertiary,
      'onTertiary': cs.onTertiary,
      'tertiaryContainer': cs.tertiaryContainer,
      'onTertiaryContainer': cs.onTertiaryContainer,
      'surface': cs.surface,
      'onSurface': cs.onSurface,
      'onSurfaceVariant': cs.onSurfaceVariant,
      'error': cs.error,
      'onError': cs.onError,
      'errorContainer': cs.errorContainer,
      'onErrorContainer': cs.onErrorContainer,
      'outline': cs.outline,
      'outlineVariant': cs.outlineVariant,
      'shadow': cs.shadow,
      'scrim': cs.scrim,
      'inverseSurface': cs.inverseSurface,
      'onInverseSurface': cs.onInverseSurface,
      'inversePrimary': cs.inversePrimary,
    };

    return _buildColorGrid('ColorScheme', colors);
  }

  Widget _buildDmColorExtensionSection(DmColorExtension dm) {
    final colors = <String, Color>{
      'primaryFocus': dm.primaryFocus,
      'secondaryFocus': dm.secondaryFocus,
      'tertiaryFocus': dm.tertiaryFocus,
      'accent': dm.accent,
      'accentFocus': dm.accentFocus,
      'accentContent': dm.accentContent,
      'neutral': dm.neutral,
      'neutralFocus': dm.neutralFocus,
      'neutralContent': dm.neutralContent,
      'neutralVariant': dm.neutralVariant,
      'info': dm.info,
      'infoContent': dm.infoContent,
      'success': dm.success,
      'successContent': dm.successContent,
      'warning': dm.warning,
      'warningContent': dm.warningContent,
      'base100': dm.base100,
      'base200': dm.base200,
      'base300': dm.base300,
      'baseContent': dm.baseContent,
    };

    return _buildColorGrid('DmColorExtension', colors);
  }

  Widget _buildColorGrid(String title, Map<String, Color> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) =>
              Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 140,
            childAspectRatio: 1.2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: colors.length,
          itemBuilder: (context, i) {
            final entry = colors.entries.elementAt(i);
            final luminance = entry.value.computeLuminance();
            return Container(
              decoration: BoxDecoration(
                color: entry.value,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant,
                ),
              ),
              padding: const EdgeInsets.all(6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: luminance > 0.5 ? Colors.black : Colors.white,
                    ),
                  ),
                  Text(
                    '#${entry.value.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}',
                    style: TextStyle(
                      fontSize: 9,
                      color: luminance > 0.5 ? Colors.black54 : Colors.white70,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextThemeSection(TextTheme tt) {
    final styles = <String, TextStyle?>{
      'displayLarge': tt.displayLarge,
      'displayMedium': tt.displayMedium,
      'displaySmall': tt.displaySmall,
      'headlineLarge': tt.headlineLarge,
      'headlineMedium': tt.headlineMedium,
      'headlineSmall': tt.headlineSmall,
      'titleLarge': tt.titleLarge,
      'titleMedium': tt.titleMedium,
      'titleSmall': tt.titleSmall,
      'bodyLarge': tt.bodyLarge,
      'bodyMedium': tt.bodyMedium,
      'bodySmall': tt.bodySmall,
      'labelLarge': tt.labelLarge,
      'labelMedium': tt.labelMedium,
      'labelSmall': tt.labelSmall,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(
          builder: (context) => Text('TextTheme / Type Scale',
              style: Theme.of(context).textTheme.titleLarge),
        ),
        const SizedBox(height: 12),
        for (final entry in styles.entries)
          if (entry.value != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                '${entry.key} (${entry.value!.fontSize?.toInt()}/${entry.value!.height})',
                style: entry.value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      ],
    );
  }
}
