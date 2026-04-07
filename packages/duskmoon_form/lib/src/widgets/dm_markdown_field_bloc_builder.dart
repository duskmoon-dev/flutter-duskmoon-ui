import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/field/field_bloc.dart';
import '../utils/utils.dart';
import 'fields/simple_field_bloc_builder.dart';

/// A form field widget backed by [MarkdownFieldBloc].
///
/// Creates and owns a [DmMarkdownInputController] internally. Wraps
/// [DmMarkdownInput] with standard form field enable/disable handling and
/// BLoC value synchronisation.
class DmMarkdownFieldBlocBuilder extends StatefulWidget {
  const DmMarkdownFieldBlocBuilder({
    super.key,
    required this.markdownFieldBloc,
    this.enableOnlyWhenFormBlocCanSubmit = false,
    this.isEnabled = true,
    this.errorBuilder,
    this.padding,
    this.animateWhenCanShow = true,
    this.config = const DmMarkdownConfig(),
    this.tabLabelWrite = 'Write',
    this.tabLabelPreview = 'Preview',
    this.showLineNumbers = false,
    this.maxLines,
    this.minLines = 10,
    this.onLinkTap,
    this.decoration,
  });

  final MarkdownFieldBloc<dynamic> markdownFieldBloc;
  final bool enableOnlyWhenFormBlocCanSubmit;
  final bool isEnabled;
  final FieldBlocErrorBuilder? errorBuilder;
  final EdgeInsetsGeometry? padding;
  final bool animateWhenCanShow;
  final DmMarkdownConfig config;
  final String tabLabelWrite;
  final String tabLabelPreview;
  final bool showLineNumbers;
  final int? maxLines;
  final int minLines;
  final void Function(String url, String? title)? onLinkTap;
  final InputDecoration? decoration;

  @override
  State<DmMarkdownFieldBlocBuilder> createState() =>
      _DmMarkdownFieldBlocBuilderState();
}

class _DmMarkdownFieldBlocBuilderState
    extends State<DmMarkdownFieldBlocBuilder> {
  late DmMarkdownInputController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DmMarkdownInputController(
      text: widget.markdownFieldBloc.state.value,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DmSimpleFieldBlocBuilder(
      singleFieldBloc: widget.markdownFieldBloc,
      animateWhenCanShow: widget.animateWhenCanShow,
      builder: (context, __) {
        return BlocBuilder<MarkdownFieldBloc<dynamic>,
            MarkdownFieldBlocState<dynamic>>(
          bloc: widget.markdownFieldBloc,
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
              child: DmMarkdownInput(
                // ValueKey forces a full rebuild when tab changes programmatically,
                // applying the new initialTab. The external _controller preserves
                // the text value through the rebuild.
                key: ValueKey(state.tab),
                controller: _controller,
                config: widget.config,
                initialTab: state.tab,
                onChanged: (text) =>
                    widget.markdownFieldBloc.changeValue(text),
                onTabChanged: (tab) =>
                    widget.markdownFieldBloc.updateTab(tab),
                showLineNumbers: widget.showLineNumbers,
                maxLines: widget.maxLines,
                minLines: widget.minLines,
                enabled: isEnabled,
                tabLabelWrite: widget.tabLabelWrite,
                tabLabelPreview: widget.tabLabelPreview,
                onLinkTap: widget.onLinkTap,
                decoration: widget.decoration,
              ),
            );
          },
        );
      },
    );
  }
}
