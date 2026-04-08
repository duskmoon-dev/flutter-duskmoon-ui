import 'package:duskmoon_widgets/duskmoon_widgets.dart'
    show DmPlatformStyle, DmSwitch, resolvePlatformStyle;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/field/field_bloc.dart';
import '../theme/field_theme_resolver.dart';
import '../theme/form_bloc_theme.dart';
import '../utils/utils.dart';
import 'fields/simple_field_bloc_builder.dart';

/// A material design switch
class DmSwitchFieldBlocBuilder extends StatelessWidget {
  const DmSwitchFieldBlocBuilder({
    super.key,
    required this.booleanFieldBloc,
    required this.body,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.alignment = AlignmentDirectional.centerStart,
    this.nextFocusNode,
    this.controlAffinity,
    this.dragStartBehavior = DragStartBehavior.start,
    this.focusNode,
    this.autofocus = false,
    this.animateWhenCanShow = true,
    this.textStyle,
    this.textColor,
    this.activeThumbImage,
    this.inactiveThumbImage,
    this.thumbColor,
    this.trackColor,
    this.materialTapTargetSize,
    this.mouseCursor,
    this.overlayColor,
    this.splashRadius,
  });

  /// {@macro flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  final BooleanFieldBloc booleanFieldBloc;

  /// {@macro flutter_form_bloc.FieldBlocBuilderControlAffinity}
  final FieldBlocBuilderControlAffinity? controlAffinity;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.isEnabled}
  final bool isEnabled;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.padding}
  final EdgeInsetsGeometry? padding;

  final AlignmentGeometry alignment;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  final FocusNode? nextFocusNode;

  /// {@macro flutter_form_bloc.FieldBlocBuilder.checkboxBody}
  final Widget body;

  /// {@macro flutter.cupertino.switch.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// {@macro  flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  final bool animateWhenCanShow;

  final TextStyle? textStyle;
  final WidgetStateProperty<Color?>? textColor;

  // ========== [Switch] ==========

  /// An image to use on the thumb of this switch when the switch is on.
  final ImageProvider? activeThumbImage;

  /// An image to use on the thumb of this switch when the switch is off.
  final ImageProvider? inactiveThumbImage;

  /// [Switch.thumbColor]
  final WidgetStateProperty<Color?>? thumbColor;

  /// [Switch.trackColor]
  final WidgetStateProperty<Color?>? trackColor;

  /// [Switch.materialTapTargetSize]
  final MaterialTapTargetSize? materialTapTargetSize;

  /// [Switch.mouseCursor]
  final WidgetStateProperty<MouseCursor?>? mouseCursor;

  /// [Switch.overlayColor]
  final WidgetStateProperty<Color?>? overlayColor;

  /// [Switch.splashRadius]
  final double? splashRadius;

  SwitchFieldTheme themeStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = DmFormTheme.of(context);
    final fieldTheme = formTheme.switchTheme;
    final resolver = FieldThemeResolver(theme, formTheme, fieldTheme);
    final switchTheme = fieldTheme.switchTheme ?? theme.switchTheme;

    return SwitchFieldTheme(
      decorationTheme: resolver.decorationTheme,
      textStyle: textStyle ?? resolver.textStyle,
      textColor: textColor ?? resolver.textColor,
      switchTheme: switchTheme.copyWith(
        thumbColor: thumbColor,
        trackColor: trackColor,
        materialTapTargetSize: materialTapTargetSize,
        mouseCursor: mouseCursor,
        overlayColor: overlayColor,
        splashRadius: splashRadius,
      ),
      controlAffinity: controlAffinity ??
          fieldTheme.controlAffinity ??
          FieldBlocBuilderControlAffinity.leading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = themeStyleOf(context);

    return DmSimpleFieldBlocBuilder(
      singleFieldBloc: booleanFieldBloc,
      animateWhenCanShow: animateWhenCanShow,
      builder: (context0, __) {
        return BlocBuilder<BooleanFieldBloc, BooleanFieldBlocState>(
          bloc: booleanFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: this.isEnabled,
              enableOnlyWhenFormBlocCanSubmit:
                  enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );

            final isMaterial = resolvePlatformStyle(context) ==
                DmPlatformStyle.material;
            final switchWidget = _buildSwitch(context, state);
            final errorText = Style.getErrorText(
              context: context,
              errorBuilder: errorBuilder,
              fieldBlocState: state,
              fieldBloc: booleanFieldBloc,
            );
            final bodyWidget = DefaultTextStyle(
              style: Style.resolveTextStyle(
                isEnabled: isEnabled,
                style: fieldTheme.textStyle!,
                color: fieldTheme.textColor!,
              ),
              child: Container(
                constraints: const BoxConstraints(
                  minHeight: kMinInteractiveDimension,
                ),
                alignment: alignment,
                child: body,
              ),
            );

            if (isMaterial) {
              return DefaultFieldBlocBuilderPadding(
                padding: padding,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(switchTheme: fieldTheme.switchTheme!),
                  child: InputDecorator(
                    decoration:
                        Style.inputDecorationWithoutBorder.copyWith(
                      prefixIcon: fieldTheme.controlAffinity ==
                              FieldBlocBuilderControlAffinity.leading
                          ? switchWidget
                          : null,
                      suffixIcon: fieldTheme.controlAffinity ==
                              FieldBlocBuilderControlAffinity.trailing
                          ? switchWidget
                          : null,
                      errorText: errorText,
                    ),
                    child: bodyWidget,
                  ),
                ),
              );
            }

            final isLeading = fieldTheme.controlAffinity ==
                FieldBlocBuilderControlAffinity.leading;
            return DefaultFieldBlocBuilderPadding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      if (isLeading)
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          child: switchWidget,
                        ),
                      Expanded(child: bodyWidget),
                      if (!isLeading)
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          child: switchWidget,
                        ),
                    ],
                  ),
                  if (errorText != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        errorText,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSwitch(BuildContext context, BooleanFieldBlocState state) {
    return DmSwitch(
      value: state.value,
      onChanged: fieldBlocBuilderOnChange<bool>(
        isEnabled: isEnabled,
        nextFocusNode: nextFocusNode,
        onChanged: booleanFieldBloc.changeValue,
      ),
    );
  }
}
