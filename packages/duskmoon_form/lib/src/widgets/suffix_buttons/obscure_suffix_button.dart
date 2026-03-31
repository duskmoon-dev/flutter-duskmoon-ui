import 'package:flutter/material.dart';

import '../../blocs/field/field_bloc.dart';
import '../../theme/form_bloc_theme.dart';
import '../../theme/suffix_button_themes.dart';
import 'suffix_button_bloc_builder.dart';

class ObscureSuffixButton extends StatelessWidget {
  final SingleFieldBloc singleFieldBloc;
  final bool isEnabled;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? falseIcon;
  final Widget? trueIcon;

  const ObscureSuffixButton({
    super.key,
    required this.singleFieldBloc,
    required this.isEnabled,
    required this.value,
    required this.onChanged,
    this.falseIcon,
    this.trueIcon,
  });

  ObscureSuffixButtonTheme themeOf(BuildContext context) {
    final buttonTheme = DmFormTheme.of(context).obscureSuffixButtonTheme;

    return ObscureSuffixButtonTheme(
      trueIcon:
          trueIcon ?? buttonTheme.trueIcon ?? const Icon(Icons.visibility),
      falseIcon: falseIcon ??
          buttonTheme.falseIcon ??
          const Icon(Icons.visibility_off),
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonTheme = themeOf(context);

    return SuffixButtonBuilderBase(
      singleFieldBloc: singleFieldBloc,
      isEnabled: isEnabled,
      onTap: () => onChanged(!value),
      icon: value ? buttonTheme.trueIcon! : buttonTheme.falseIcon!,
    );
  }
}
