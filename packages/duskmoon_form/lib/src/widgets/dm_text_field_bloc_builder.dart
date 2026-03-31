import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/field/field_bloc.dart';
import '../blocs/form/form_bloc.dart';
import '../theme/field_theme_resolver.dart';
import '../theme/form_bloc_theme.dart';
import '../theme/suffix_button_themes.dart';
import '../utils/utils.dart';
import 'fields/simple_field_bloc_builder.dart';
import 'flutter_typeahead.dart';
import 'suffix_buttons/clear_suffix_button.dart';
import 'suffix_buttons/obscure_suffix_button.dart';

export 'package:flutter/services.dart'
    show TextInputType, TextInputAction, TextCapitalization;
export 'package:flutter/widgets.dart' show EditableText;
export 'flutter_typeahead.dart' show SuggestionsBoxDecoration;

const double _kMenuItemHeight = 48.0;
const EdgeInsets _kMenuItemPadding = EdgeInsets.symmetric(horizontal: 16.0);

enum SuffixButton { obscureText, clearText, asyncValidating }

/// A material design text field that can show suggestions.
class DmTextFieldBlocBuilder extends StatefulWidget {
  /// Creates a Material Design text field
  ///
  ///
  ///
  ///
  ///
  /// If [decoration] is non-null (which is the default), the text field requires
  /// one of its ancestors to be a [Material] widget.
  ///
  /// To remove the decoration entirely (including the extra padding introduced
  /// by the decoration to save space for the labels), set the [decoration] to
  /// null.
  ///
  /// The [maxLines] property can be set to null to remove the restriction on
  /// the number of lines. By default, it is one, meaning this is a single-line
  /// text field. [maxLines] must not be zero.
  ///
  /// The [maxLength] property is set to null by default, which means the
  /// number of characters allowed in the text field is not restricted. If
  /// [maxLength] is set a character counter will be displayed below the
  /// field showing how many characters have been entered. If the value is
  /// set to a positive integer it will also display the maximum allowed
  /// number of characters to be entered.  If the value is set to
  /// [DmTextFieldBlocBuilder.noMaxLength] then only the current length is displayed.
  ///
  /// After [maxLength] characters have been input, additional input
  /// is ignored, unless [maxLengthEnforced] is set to false. The text field
  /// enforces the length with a [LengthLimitingTextInputFormatter], which is
  /// evaluated after the supplied [inputFormatters], if any. The [maxLength]
  /// value must be either null or greater than zero.
  ///
  /// If [maxLengthEnforced] is set to false, then more than [maxLength]
  /// characters may be entered, and the error counter and divider will
  /// switch to the [decoration.errorStyle] when the limit is exceeded.
  ///
  /// The text cursor is not shown if [showCursor] is false or if [showCursor]
  /// is null (the default) and [readOnly] is true.
  ///
  /// The [textAlign], [autofocus], [obscureText], [readOnly], [autocorrect],
  /// [maxLengthEnforced], [scrollPadding], [maxLines], and [maxLength]
  /// arguments must not be null.
  ///
  /// See also:
  ///
  ///  * [maxLength], which discusses the precise meaning of "number of
  ///    characters" and how it may differ from the intuitive meaning.
  const DmTextFieldBlocBuilder({
    super.key,
    required this.textFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.suffixButton,
    this.padding,
    this.removeSuggestionOnLongPress = false,
    this.focusNode,
    this.decoration = const InputDecoration(),
    TextInputType? keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    @Deprecated('Use textStyle') TextStyle? style,
    TextStyle? textStyle,
    this.textColor,
    this.strutStyle,
    this.obscureText,
    this.textAlign,
    this.textAlignVertical,
    this.textDirection,
    this.showCursor,
    this.autofocus = false,
    this.autocorrect = true,
    this.maxLines = 1,
    this.minLines,
    this.expands = false,
    this.maxLength,
    this.maxLengthEnforced = MaxLengthEnforcement.enforced,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.cursorWidth = 2.0,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.dragStartBehavior = DragStartBehavior.start,
    this.enableInteractiveSelection = true,
    this.onTap,
    this.buildCounter,
    this.scrollController,
    this.scrollPhysics,
    this.suggestionsBoxDecoration,
    this.suggestionTextStyle,
    this.debounceSuggestionDuration = const Duration(milliseconds: 300),
    this.getImmediateSuggestions = true,
    this.suggestionsAnimationDuration = const Duration(milliseconds: 700),
    this.nextFocusNode,
    this.hideOnLoadingSuggestions = false,
    this.hideOnEmptySuggestions = false,
    this.hideOnSuggestionsError = false,
    this.loadingSuggestionsBuilder,
    this.suggestionsNotFoundBuilder,
    this.suggestionsErrorBuilder,
    this.keepSuggestionsOnLoading = false,
    this.showSuggestionsWhenIsEmpty = true,
    this.readOnly = false,
    this.toolbarOptions,
    this.enableSuggestions = true,
    this.animateWhenCanShow = true,
    this.focusOnValidationFailed = true,
    this.obscureTextTrueIcon,
    this.obscureTextFalseIcon,
    this.clearTextIcon,
    this.autofillHints,
    this.asyncValidatingIcon = const SizedBox(
      height: 24,
      width: 24,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(strokeWidth: 2.0),
      ),
    ),
  }) : assert(maxLines == null || maxLines > 0),
       assert(minLines == null || minLines > 0),
       assert(
         (maxLines == null) || (minLines == null) || (maxLines >= minLines),
         "minLines can't be greater than maxLines",
       ),
       assert(
         !expands || (minLines == null),
         'minLines and maxLines must be null when expands is true.',
       ),
       assert(
         maxLength == null ||
             maxLength == DmTextFieldBlocBuilder.noMaxLength ||
             maxLength > 0,
       ),
       keyboardType =
           keyboardType ??
           (maxLines == 1 ? TextInputType.text : TextInputType.multiline),
       textStyle = textStyle ?? style;

  /// {@template flutter_form_bloc.FieldBlocBuilder.fieldBloc}
  /// The `fieldBloc` for rebuild the widget
  /// when its state changes.
  /// {@endtemplate}
  final TextFieldBloc<dynamic> textFieldBloc;

  /// {@template flutter_form_bloc.FieldBlocBuilder.errorBuilder}
  /// This function take the `context` and the [FieldBlocState.error]
  /// and must return a String error to display in the widget when
  /// has an error or null if you don't want to display the error.
  /// By default is [FieldBlocBuilder.defaultErrorBuilder].
  /// {@endtemplate}
  final FieldBlocErrorBuilder? errorBuilder;

  /// {@template flutter_form_bloc.FieldBlocBuilder.enableOnlyWhenFormBlocCanSubmit}
  /// If `true`, this widget will be enabled only
  /// when the `state` of the [FormBloc] that contains this
  /// `FieldBloc` has [FormBlocState.canSubmit] in `true`.
  /// {@endtemplate}
  final bool enableOnlyWhenFormBlocCanSubmit;

  /// {@template flutter_form_bloc.FieldBlocBuilder.isEnabled}
  ///  If false the text field is "disabled": it ignores taps
  /// and its [decoration] is rendered in grey.
  /// {@endtemplate}
  final bool isEnabled;

  /// {@template flutter_form_bloc.FieldBlocBuilder.padding}
  /// The amount of space by which to inset the child.
  /// {@endtemplate}
  final EdgeInsetsGeometry? padding;

  /// {@template flutter_form_bloc.FieldBlocBuilder.nextFocusNode}
  /// When change the value of the `FieldBloc`, this will call
  /// `nextFocusNode.requestFocus()`.
  /// {@endtemplate}
  final FocusNode? nextFocusNode;

  /// The suffix button with a default behavior:
  ///
  /// [SuffixButton.obscureText] : Show an eye icon and obscure the text,
  /// and when is pressed make a toggle, so Show an eye with a line icon and not
  /// obscure the text.
  ///
  /// [SuffixButton.clearText] : Show an "X" icon,
  /// and when is pressed, clear the text.
  final SuffixButton? suffixButton;

  /// if `true` when do a long press in a suggestion, it will be removed
  /// and will be added to [TextFieldBloc.selectedSuggestion] stream.
  final bool removeSuggestionOnLongPress;

  /// The decoration of the material sheet that contains the suggestions.
  ///
  /// If `null`, default decoration with an elevation of 4.0 is used
  final SuggestionsBoxDecoration? suggestionsBoxDecoration;

  /// The time for show and hide the suggestions box.
  /// By default is 700 milliseconds.
  final Duration suggestionsAnimationDuration;

  /// If set to true, suggestions will be fetched immediately when the field is
  /// added to the view.
  ///
  /// But the suggestions box will only be shown when the field receives focus.
  /// To make the field receive focus immediately, you can set the `autofocus`
  /// property in the [textFieldConfiguration] to true
  ///
  /// Defaults to true
  final bool getImmediateSuggestions;

  /// The style to use for the suggestion text.
  ///
  /// If `null`, defaults to the `subhead` text style from the current [Theme].
  final TextStyle? suggestionTextStyle;

  /// The duration to wait after the user stops typing before calling
  /// [TextFieldBlocState.suggestions].
  ///
  /// This is useful, because, if not set, a request for suggestions will be
  /// sent for every character that the user types.
  ///
  /// This duration is set by default to 300 milliseconds.
  final Duration debounceSuggestionDuration;

  /// If set to true, no loading box will be shown while suggestions are
  /// being fetched. [loadingSuggestionsBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnLoadingSuggestions;

  /// If set to true, nothing will be shown if there are no results.
  /// [suggestionsNotFoundBuilder] will also be ignored.
  ///
  /// Defaults to false
  final bool hideOnEmptySuggestions;

  /// If set to true, nothing will be shown if there is an error.
  /// [suggestionsErrorBuilder] will also be ignored.
  ///
  /// Defaults to false.
  final bool hideOnSuggestionsError;

  /// Called when waiting for [TextFieldBlocState.suggestions] to return.
  ///
  /// It is expected to return a widget to display while waiting.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('Loading...');
  /// }
  /// ```
  ///
  /// If not specified, a [CircularProgressIndicator](https://docs.flutter.io/flutter/material/CircularProgressIndicator-class.html) is shown
  final WidgetBuilder? loadingSuggestionsBuilder;

  /// Called when [TextFieldBlocState.suggestions] returns an empty array.
  ///
  /// It is expected to return a widget to display when no suggestions are
  /// available.
  /// For example:
  /// ```dart
  /// (BuildContext context) {
  ///   return Text('No Items Found!');
  /// }
  /// ```
  ///
  /// If not specified, a simple text is shown
  final WidgetBuilder? suggestionsNotFoundBuilder;

  /// Called when [TextFieldBlocState.suggestions] throws an exception.
  ///
  /// It is called with the error object, and expected to return a widget to
  /// display when an exception is thrown
  /// For example:
  /// ```dart
  /// (BuildContext context, error) {
  ///   return Text('$error');
  /// }
  /// ```
  ///
  /// If not specified, the error is shown in [ThemeData.errorColor](https://docs.flutter.io/flutter/material/ThemeData/errorColor.html)
  final ErrorBuilder? suggestionsErrorBuilder;

  /// If set to false, the suggestions box will show a circular
  /// progress indicator when retrieving suggestions.
  ///
  /// Defaults to true.
  final bool keepSuggestionsOnLoading;

  /// If set to false, the suggestion no will be showed
  /// when the text is empty
  /// and [TextFieldBlocState.suggestions] not will be called
  ///
  /// Defaults to true.
  final bool showSuggestionsWhenIsEmpty;

  /// --------------------------------------------------------------------------
  ///                          [TextField] properties
  /// --------------------------------------------------------------------------

  /// Defines the keyboard focus for this widget.
  final FocusNode? focusNode;

  /// The decoration to show around the text field.
  final InputDecoration decoration;

  /// {@macro flutter.widgets.editableText.obscureText}
  final bool? obscureText;

  /// {@macro flutter.widgets.editableText.keyboardType}
  final TextInputType keyboardType;

  /// The type of action button to use for the keyboard.
  final TextInputAction? textInputAction;

  /// {@macro flutter.widgets.editableText.textCapitalization}
  final TextCapitalization textCapitalization;

  /// {@template flutter_form_bloc.FieldBlocBuilder.textStyle}
  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `subtitle` text style from the current [Theme].
  /// {@endtemplate}
  final TextStyle? textStyle;

  /// {@template flutter_form_bloc.FieldBlocBuilder.textColor}
  /// It is the color of the text
  ///
  /// You can receive this state: [WidgetState.disabled]
  /// {@endtemplate}
  final WidgetStateProperty<Color?>? textColor;

  /// {@macro flutter.widgets.editableText.strutStyle}
  final StrutStyle? strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  /// Defaults [TextAlign.start]
  final TextAlign? textAlign;

  /// {@macro flutter.material.inputDecorator.textAlignVertical}
  final TextAlignVertical? textAlignVertical;

  /// {@macro flutter.widgets.editableText.textDirection}
  final TextDirection? textDirection;

  /// {@macro flutter.widgets.editableText.autofocus}
  final bool autofocus;

  /// {@macro flutter.widgets.editableText.autocorrect}
  final bool autocorrect;

  /// {@macro flutter.widgets.editableText.maxLines}
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.minLines}
  final int? minLines;

  /// {@macro flutter.widgets.editableText.expands}
  final bool expands;

  /// {@macro flutter.widgets.editableText.showCursor}
  final bool? showCursor;

  /// If [maxLength] is set to this value, only the "current input length"
  /// part of the character counter is shown.
  static const int noMaxLength = -1;

  /// The maximum number of characters (Unicode scalar values) to allow in the
  /// text field.
  final int? maxLength;

  /// {@template flutter.services.textFormatter.maxLengthEnforcement}
  final MaxLengthEnforcement maxLengthEnforced;

  /// {@macro flutter.widgets.editableText.onChanged}
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onEditingComplete}
  final VoidCallback? onEditingComplete;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  /// {@macro flutter.widgets.editableText.inputFormatters}
  final List<TextInputFormatter>? inputFormatters;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  final double cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  final Radius? cursorRadius;

  /// The color to use when painting the cursor.
  final Color? cursorColor;

  /// The appearance of the keyboard.
  final Brightness? keyboardAppearance;

  /// {@macro flutter.widgets.editableText.scrollPadding}
  final EdgeInsets scrollPadding;

  /// {@macro flutter.widgets.editableText.enableInteractiveSelection}
  final bool enableInteractiveSelection;

  /// {@macro flutter.widgets.editableText.readOnly}
  final bool readOnly;

  /// Configuration of toolbar options.
  @Deprecated(
    'Use `contextMenuBuilder` instead. '
    'This feature was deprecated after v3.3.0-0.5.pre.',
  )
  final ToolbarOptions? toolbarOptions;

  /// {@macro flutter.services.textInput.enableSuggestions}
  final bool enableSuggestions;

  /// {@macro flutter.widgets.scrollable.dragStartBehavior}
  final DragStartBehavior dragStartBehavior;

  /// Called when the user taps on this text field.
  final GestureTapCallback? onTap;

  /// Callback that generates a custom [InputDecorator.counter] widget.
  final InputCounterWidgetBuilder? buildCounter;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  final ScrollPhysics? scrollPhysics;

  /// {@macro flutter.widgets.editableText.scrollController}
  final ScrollController? scrollController;

  /// {@template flutter_form_bloc.FieldBlocBuilder.animateWhenCanShow}
  /// Set to `true` if you want animate size/fade, when the
  /// field bloc is added and removed from form bloc.
  /// {@endtemplate}
  final bool animateWhenCanShow;

  /// {@template flutter_form_bloc.FieldBlocBuilder.focusOnValidationFailed}
  /// Set to `true` if you want to focus field when has error on submitting
  /// {@endtemplate}
  final bool focusOnValidationFailed;

  /// When [suffixButton] is [SuffixButton.obscureText],
  /// this icon will be displayed when obscure text is `true`.
  ///
  /// Default: `Icon(Icons.visibility)`
  final Widget? obscureTextTrueIcon;

  /// When [suffixButton] is [SuffixButton.obscureText],
  /// this icon will be displayed when obscure text is `false`.
  ///
  /// Default: `const Icon(Icons.visibility_off)`
  final Widget? obscureTextFalseIcon;

  /// When [suffixButton] is [SuffixButton.clearText],
  /// this icon will be displayed.
  ///
  /// Default: `const Icon(Icons.clear)`
  final Widget? clearTextIcon;

  /// When [suffixButton] is [SuffixButton.asyncValidating],
  /// this icon will be displayed.
  ///
  /// Default
  /// ```dart
  /// const SizedBox(
  ///  height: 24,
  ///  width: 24,
  ///  child: Padding(
  ///    padding: const EdgeInsets.all(8.0),
  ///    child: const CircularProgressIndicator(
  ///      strokeWidth: 2.0,
  ///    ),
  ///  ),
  /// )
  /// ```
  final Widget asyncValidatingIcon;
  final Iterable<String>? autofillHints;

  TextFieldTheme themeStyleOf(BuildContext context) {
    final theme = Theme.of(context);
    final formTheme = DmFormTheme.of(context);
    final fieldTheme = formTheme.textTheme;
    final resolver = FieldThemeResolver(theme, formTheme, fieldTheme);
    final cleanTheme = fieldTheme.clearSuffixButtonTheme;
    final obscureTheme = fieldTheme.obscureSuffixButtonTheme;

    return TextFieldTheme(
      decorationTheme: resolver.decorationTheme,
      textStyle: textStyle ?? resolver.textStyle,
      textColor: textColor ?? resolver.textColor,
      textAlign: textAlign ?? fieldTheme.textAlign ?? TextAlign.start,
      clearSuffixButtonTheme: ClearSuffixButtonTheme(
        visibleWithoutValue:
            cleanTheme.visibleWithoutValue ??
            formTheme.clearSuffixButtonTheme.visibleWithoutValue ??
            true,
        appearDuration: cleanTheme.appearDuration,
        // ignore: deprecated_member_use_from_same_package
        icon: clearTextIcon ?? cleanTheme.icon ?? fieldTheme.clearIcon,
      ),
      obscureSuffixButtonTheme: ObscureSuffixButtonTheme(
        trueIcon:
            obscureTextTrueIcon ??
            obscureTheme.trueIcon ??
            // ignore: deprecated_member_use_from_same_package
            fieldTheme.obscureTrueIcon,
        falseIcon:
            obscureTextFalseIcon ??
            obscureTheme.falseIcon ??
            // ignore: deprecated_member_use_from_same_package
            fieldTheme.obscureFalseIcon,
      ),
      suggestionsTextStyle:
          fieldTheme.suggestionsTextStyle ??
          theme.textTheme.titleMedium!.copyWith(
            color:
                ThemeData.estimateBrightnessForColor(theme.canvasColor) ==
                    Brightness.dark
                ? Colors.white
                : Colors.grey[800],
          ),
    );
  }

  @override
  State<DmTextFieldBlocBuilder> createState() => _DmTextFieldBlocBuilderState();
}

class _DmTextFieldBlocBuilderState extends State<DmTextFieldBlocBuilder> {
  late TextEditingController _controller;

  late bool _obscureText;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(text: widget.textFieldBloc.state.value);

    _controller.addListener(_textControllerListener);

    _obscureText = widget.suffixButton == SuffixButton.obscureText;
  }

  @override
  void didUpdateWidget(covariant DmTextFieldBlocBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // You can manage the value of _obscureText from the outside
    if (widget.obscureText != null) {
      _obscureText = widget.obscureText!;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_textControllerListener);
    _controller.dispose();
    super.dispose();
  }

  /// Disable editing when the state of the FormBloc is [FormBlocSubmitting].
  void _textControllerListener() {
    if (widget.textFieldBloc.state.formBloc?.state is FormBlocSubmitting) {
      if (_controller.text != (widget.textFieldBloc.value)) {
        _fixControllerTextValue(widget.textFieldBloc.value);
      }
    }
  }

  void _onSubmitted(String value) {
    if (widget.nextFocusNode != null) {
      widget.nextFocusNode!.requestFocus();
    }
    if (widget.onSubmitted != null) {
      widget.onSubmitted!(value);
    }
  }

  void _fixControllerTextValue(String value) async {
    _controller
      ..text = value
      ..selection = TextSelection.collapsed(offset: _controller.text.length);

    // TODO: Find out why the cursor returns to the beginning.
    await Future.delayed(const Duration(milliseconds: 0));
    _controller.selection = TextSelection.collapsed(
      offset: _controller.text.length,
    );
  }

  void obscureText(bool value) {
    setState(() => _obscureText = value);
  }

  @override
  Widget build(BuildContext context) {
    final fieldTheme = widget.themeStyleOf(context);

    return DmSimpleFieldBlocBuilder(
      singleFieldBloc: widget.textFieldBloc,
      animateWhenCanShow: widget.animateWhenCanShow,
      focusOnValidationFailed: widget.focusOnValidationFailed,
      builder: (_, _) {
        return BlocBuilder<TextFieldBloc, TextFieldBlocState>(
          bloc: widget.textFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: widget.isEnabled,
              enableOnlyWhenFormBlocCanSubmit:
                  widget.enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );

            if (_controller.text != state.value) {
              _fixControllerTextValue(state.value);
            }
            return DefaultFieldBlocBuilderPadding(
              padding: widget.padding,
              child: _buildTextField(
                state: state,
                isEnabled: isEnabled,
                fieldTheme: fieldTheme,
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _buildDecoration(
    TextFieldTheme fieldTheme,
    TextFieldBlocState state,
  ) {
    InputDecoration decoration = widget.decoration;
    if (widget.suffixButton != null) {
      switch (widget.suffixButton!) {
        case SuffixButton.obscureText:
          if (widget.obscureText == null) {
            decoration = decoration.copyWith(
              suffixIcon: _buildObscureSuffixButton(
                buttonTheme: fieldTheme.obscureSuffixButtonTheme,
              ),
            );
          }
          break;
        case SuffixButton.clearText:
          decoration = decoration.copyWith(
            suffixIcon: _buildClearSuffixButton(
              buttonTheme: fieldTheme.clearSuffixButtonTheme,
            ),
          );
          break;
        case SuffixButton.asyncValidating:
          decoration = decoration.copyWith(
            suffixIcon: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: state.canShowIsValidating ? 1.0 : 0.0,
              child: widget.asyncValidatingIcon,
            ),
          );
      }
    }

    decoration = decoration.copyWith(
      errorText: Style.getErrorText(
        context: context,
        errorBuilder: widget.errorBuilder,
        fieldBlocState: state,
        fieldBloc: widget.textFieldBloc,
      ),
    );

    return decoration.applyDefaults(fieldTheme.decorationTheme!);
  }

  Widget _buildObscureSuffixButton({
    required ObscureSuffixButtonTheme buttonTheme,
  }) {
    return ObscureSuffixButton(
      singleFieldBloc: widget.textFieldBloc,
      isEnabled: widget.isEnabled,
      value: _obscureText,
      onChanged: obscureText,
      trueIcon: buttonTheme.trueIcon,
      falseIcon: buttonTheme.falseIcon,
    );
  }

  Widget _buildClearSuffixButton({
    required ClearSuffixButtonTheme buttonTheme,
  }) {
    return ClearSuffixButton(
      singleFieldBloc: widget.textFieldBloc,
      isEnabled: widget.isEnabled,
      appearDuration: buttonTheme.appearDuration,
      visibleWithoutValue: buttonTheme.visibleWithoutValue,
      icon: buttonTheme.icon,
    );
  }

  Widget _buildTextField({
    required TextFieldTheme fieldTheme,
    required TextFieldBlocState state,
    required bool isEnabled,
  }) {
    return TypeAheadField<String>(
      textFieldConfiguration: TextFieldConfiguration<String>(
        controller: _controller,
        autofillHints: widget.autofillHints,
        decoration: _buildDecoration(fieldTheme, state),
        keyboardType: widget.keyboardType,
        textInputAction:
            widget.textInputAction ??
            (widget.nextFocusNode != null ? TextInputAction.next : null),
        textCapitalization: widget.textCapitalization,
        style: Style.resolveTextStyle(
          isEnabled: isEnabled,
          style: fieldTheme.textStyle!,
          color: fieldTheme.textColor!,
        ),
        textAlign: fieldTheme.textAlign!,
        textDirection: widget.textDirection,
        autofocus: widget.autofocus,
        obscureText: _obscureText,
        autocorrect: widget.autocorrect,
        minLines: widget.minLines,
        maxLines: widget.maxLines,
        maxLength: widget.maxLength,
        maxLengthEnforcement: widget.maxLengthEnforced,
        onChanged: (value) {
          widget.textFieldBloc.changeValue(value);
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: _onSubmitted,
        inputFormatters: widget.inputFormatters,
        enabled: isEnabled,
        cursorWidth: widget.cursorWidth,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        keyboardAppearance: widget.keyboardAppearance,
        scrollPadding: widget.scrollPadding,
        focusNode: widget.focusNode,
        buildCounter: widget.buildCounter,
        dragStartBehavior: widget.dragStartBehavior,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        enableSuggestions: widget.enableSuggestions,
        expands: widget.expands,
        readOnly: widget.readOnly,
        scrollController: widget.scrollController,
        scrollPhysics: widget.scrollPhysics,
        showCursor: widget.showCursor,
        strutStyle: widget.strutStyle,
        textAlignVertical: widget.textAlignVertical,
        // ignore: deprecated_member_use_from_same_package
        toolbarOptions: widget.toolbarOptions,
      ),
      onTap: widget.onTap,
      hideOnLoading: widget.hideOnLoadingSuggestions,
      hideOnEmpty: widget.hideOnEmptySuggestions,
      hideOnError: widget.hideOnSuggestionsError,
      errorBuilder: widget.suggestionsErrorBuilder,
      loadingBuilder:
          widget.loadingSuggestionsBuilder ??
          (context) {
            return Container(
              height: _kMenuItemHeight,
              alignment: AlignmentDirectional.center,
              child: Container(
                height: 36,
                width: 36,
                padding: const EdgeInsets.all(4.0),
                child: const CircularProgressIndicator(strokeWidth: 3),
              ),
            );
          },
      noItemsFoundBuilder:
          widget.suggestionsNotFoundBuilder ??
          (context) {
            return Container(
              height: _kMenuItemHeight,
              alignment: AlignmentDirectional.center,
              padding: _kMenuItemPadding,
              child: Text(
                'No Items Found!',
                style: fieldTheme.suggestionsTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            );
          },
      keepSuggestionsOnLoading: widget.keepSuggestionsOnLoading,
      keepSuggestionsOnSuggestionSelected: false,
      hideSuggestionsOnKeyboardHide: true,
      showSuggestionsWhenIsEmpty: widget.showSuggestionsWhenIsEmpty,
      getImmediateSuggestions: widget.getImmediateSuggestions,
      debounceDuration: widget.debounceSuggestionDuration,
      suggestionsCallback: state.suggestions,
      itemBuilder: (context, suggestion) {
        return Container(
          height: _kMenuItemHeight,
          alignment: AlignmentDirectional.centerStart,
          padding: _kMenuItemPadding,
          child: Text(
            suggestion,
            style: fieldTheme.suggestionsTextStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      },
      onSuggestionSelected: (value) {
        widget.textFieldBloc.changeValue(value);
        _onSubmitted(value);
      },
      animationDuration: widget.suggestionsAnimationDuration,
      removeSuggestionOnLongPress: widget.removeSuggestionOnLongPress,
      suggestionsBoxDecoration:
          widget.suggestionsBoxDecoration ??
          SuggestionsBoxDecoration(
            constraints: const BoxConstraints(minHeight: _kMenuItemHeight),
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).canvasColor,
          ),
      onSuggestionRemoved: (suggestion) {
        if (widget.removeSuggestionOnLongPress) {
          widget.textFieldBloc.selectSuggestion(suggestion);
        }
      },
    );
  }
}
