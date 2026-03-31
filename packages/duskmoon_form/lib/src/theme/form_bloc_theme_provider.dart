import 'package:flutter/widgets.dart';

import 'form_bloc_theme.dart';

class DmFormThemeProvider extends InheritedWidget {
  final DmFormTheme theme;

  const DmFormThemeProvider({
    super.key,
    required this.theme,
    required super.child,
  });

  static DmFormTheme? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DmFormThemeProvider>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(DmFormThemeProvider oldWidget) {
    return theme != oldWidget.theme;
  }
}
