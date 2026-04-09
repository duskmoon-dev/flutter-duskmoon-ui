import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

import 'router.dart';

/// Font families used as fallbacks for characters not covered by the
/// default Material font (e.g. math symbols, special Unicode).
const _fontFallbacks = ['NotoSansMath', 'NotoSansSymbols2'];

/// Applies [_fontFallbacks] to every [TextStyle] in [theme]'s [TextTheme].
ThemeData _withFontFallbacks(ThemeData theme) {
  TextTheme applyFallback(TextTheme tt) {
    return tt.copyWith(
      displayLarge: tt.displayLarge?.copyWith(fontFamilyFallback: _fontFallbacks),
      displayMedium: tt.displayMedium?.copyWith(fontFamilyFallback: _fontFallbacks),
      displaySmall: tt.displaySmall?.copyWith(fontFamilyFallback: _fontFallbacks),
      headlineLarge: tt.headlineLarge?.copyWith(fontFamilyFallback: _fontFallbacks),
      headlineMedium: tt.headlineMedium?.copyWith(fontFamilyFallback: _fontFallbacks),
      headlineSmall: tt.headlineSmall?.copyWith(fontFamilyFallback: _fontFallbacks),
      titleLarge: tt.titleLarge?.copyWith(fontFamilyFallback: _fontFallbacks),
      titleMedium: tt.titleMedium?.copyWith(fontFamilyFallback: _fontFallbacks),
      titleSmall: tt.titleSmall?.copyWith(fontFamilyFallback: _fontFallbacks),
      bodyLarge: tt.bodyLarge?.copyWith(fontFamilyFallback: _fontFallbacks),
      bodyMedium: tt.bodyMedium?.copyWith(fontFamilyFallback: _fontFallbacks),
      bodySmall: tt.bodySmall?.copyWith(fontFamilyFallback: _fontFallbacks),
      labelLarge: tt.labelLarge?.copyWith(fontFamilyFallback: _fontFallbacks),
      labelMedium: tt.labelMedium?.copyWith(fontFamilyFallback: _fontFallbacks),
      labelSmall: tt.labelSmall?.copyWith(fontFamilyFallback: _fontFallbacks),
    );
  }

  return theme.copyWith(textTheme: applyFallback(theme.textTheme));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DmThemeBloc, DmThemeState>(
      builder: (context, state) {
        final entry = state.entry;
        return MaterialApp.router(
          title: 'DuskMoon UI Showcase',
          debugShowCheckedModeBanner: false,
          routerConfig: AppRouter.router,
          theme: _withFontFallbacks(entry.light),
          darkTheme: _withFontFallbacks(entry.dark),
          themeMode: state.themeMode,
          scaffoldMessengerKey: dmScaffoldMessengerKey,
          localizationsDelegates: dmFluentLocalizationsDelegates,
        );
      },
    );
  }
}
