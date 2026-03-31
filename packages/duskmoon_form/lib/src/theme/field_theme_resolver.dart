import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../utils/to_string.dart';
import 'form_bloc_theme.dart';
import 'material_states.dart';

/// Resolves looking for the appropriate value to use in the widget
class FieldThemeResolver {
  final ThemeData theme;
  final DmFormTheme formTheme;
  final FieldTheme? fieldTheme;

  const FieldThemeResolver(this.theme, this.formTheme, [this.fieldTheme]);

  InputDecorationThemeData get decorationTheme {
    final InputDecorationThemeData? fieldDecorationTheme =
        fieldTheme?.decorationTheme;
    final InputDecorationThemeData? formDecorationTheme =
        formTheme.decorationTheme;
    return fieldDecorationTheme ??
        formDecorationTheme ??
        theme.inputDecorationTheme;
  }

  TextStyle get textStyle {
    return fieldTheme?.textStyle ??
        formTheme.textStyle ??
        theme.textTheme.titleMedium!;
  }

  WidgetStateProperty<Color?> get textColor {
    return fieldTheme?.textColor ??
        formTheme.textColor ??
        SimpleMaterialStateProperty(
          normal: theme.textTheme.titleMedium!.color,
          disabled: theme.disabledColor,
        );
  }
}

/// Represents the basic theme for a field
abstract class FieldTheme extends Equatable {
  /// Represents the style of the text within the field
  /// If null, defaults to the `subtitle` text style from the current [Theme].
  final TextStyle? textStyle;

  /// Resolves the color of the [textStyle].
  /// You will receive [WidgetState.disabled]
  final WidgetStateProperty<Color?>? textColor;

  /// The theme for InputDecoration of this field
  final InputDecorationThemeData? decorationTheme;

  const FieldTheme({this.textStyle, this.textColor, this.decorationTheme});

  @override
  List<Object?> get props => [textStyle, textColor, decorationTheme];

  @override
  String toString([ToString? toString]) {
    return (toString
          ?..add('textStyle', textStyle)
          ..add('textColor', textColor)
          ..add('decorationTheme', decorationTheme))
        .toString();
  }
}
