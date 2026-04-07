import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/field/field_bloc.dart';
import '../theme/form_bloc_theme.dart';
import '../utils/utils.dart';
import 'fields/simple_field_bloc_builder.dart';

/// A form field widget backed by [CodeEditorFieldBloc].
///
/// Creates and owns an [EditorViewController] internally. Wraps [DmCodeEditor]
/// with standard form field enable/disable handling and BLoC value
/// synchronisation. Language changes via [CodeEditorFieldBloc.updateLanguage]
/// propagate to [DmCodeEditor] via the `language` prop.
class DmCodeEditorFieldBlocBuilder extends StatefulWidget {
  const DmCodeEditorFieldBlocBuilder({
    super.key,
    required this.codeEditorFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.animateWhenCanShow = true,
    this.lineNumbers = true,
    this.highlightActiveLine = true,
    this.theme,
    this.minHeight,
    this.maxHeight,
    this.editorPadding,
    this.scrollPhysics,
  });

  final CodeEditorFieldBloc<dynamic> codeEditorFieldBloc;
  final bool enableOnlyWhenFormBlocCanSubmit;
  final bool isEnabled;
  final FieldBlocErrorBuilder? errorBuilder;
  final EdgeInsetsGeometry? padding;
  final bool animateWhenCanShow;
  final bool lineNumbers;
  final bool highlightActiveLine;

  /// Per-instance editor theme override. Resolution order:
  /// 1. This prop (highest priority)
  /// 2. `DmFormTheme.codeEditorTheme.editorTheme`
  /// 3. `DmCodeEditorTheme.fromContext(context)` (auto-derived, handled by [DmCodeEditor])
  final EditorTheme? theme;

  final double? minHeight;
  final double? maxHeight;
  final EdgeInsets? editorPadding;
  final ScrollPhysics? scrollPhysics;

  @override
  State<DmCodeEditorFieldBlocBuilder> createState() =>
      _DmCodeEditorFieldBlocBuilderState();
}

class _DmCodeEditorFieldBlocBuilderState
    extends State<DmCodeEditorFieldBlocBuilder> {
  late EditorViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = EditorViewController(
      text: widget.codeEditorFieldBloc.state.value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resolvedTheme =
        widget.theme ?? DmFormTheme.of(context).codeEditorTheme.editorTheme;

    return DmSimpleFieldBlocBuilder(
      singleFieldBloc: widget.codeEditorFieldBloc,
      animateWhenCanShow: widget.animateWhenCanShow,
      builder: (context, __) {
        return BlocBuilder<CodeEditorFieldBloc, CodeEditorFieldBlocState>(
          bloc: widget.codeEditorFieldBloc,
          builder: (context, state) {
            final isEnabled = fieldBlocIsEnabled(
              isEnabled: widget.isEnabled,
              enableOnlyWhenFormBlocCanSubmit:
                  widget.enableOnlyWhenFormBlocCanSubmit,
              fieldBlocState: state,
            );

            // Sync controller when value is changed externally.
            if (_controller.text != state.value) {
              _controller.text = state.value;
            }

            return DefaultFieldBlocBuilderPadding(
              padding: widget.padding,
              child: DmCodeEditor(
                controller: _controller,
                language: state.language,
                // When null, DmCodeEditor auto-derives theme from DmCodeEditorTheme.fromContext.
                theme: resolvedTheme,
                readOnly: !isEnabled,
                lineNumbers: widget.lineNumbers,
                highlightActiveLine: widget.highlightActiveLine,
                minHeight: widget.minHeight,
                maxHeight: widget.maxHeight,
                padding: widget.editorPadding,
                scrollPhysics: widget.scrollPhysics,
                onChanged: (text) =>
                    widget.codeEditorFieldBloc.changeValue(text),
              ),
            );
          },
        );
      },
    );
  }
}
