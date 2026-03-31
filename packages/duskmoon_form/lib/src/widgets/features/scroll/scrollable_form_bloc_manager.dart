import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/form/form_bloc.dart';
import '../../../theme/form_bloc_theme.dart';
import 'scrollable_field_bloc_target.dart';

/// Allows you to make the first wrong child visible
///
/// Place it on every page
class DmScrollableFormBlocManager extends StatelessWidget {
  /// The form bloc instance
  final FormBloc formBloc;

  /// See [ScrollPosition.ensureVisible]
  final Duration? duration;

  /// See [ScrollPosition.ensureVisible]
  final double? alignment;

  /// See [ScrollPosition.ensureVisible]
  final Curve? curve;

  /// See [ScrollPosition.ensureVisible]
  final ScrollPositionAlignmentPolicy? alignmentPolicy;

  /// The tree
  final Widget child;

  const DmScrollableFormBlocManager({
    super.key,
    required this.formBloc,
    this.duration,
    this.alignment,
    this.curve,
    this.alignmentPolicy,
    required this.child,
  });

  /// Search from the context for the first wrong field and make it visible by scrolling
  void ensureFieldVisible(BuildContext context) {
    final target = DmScrollableFieldBlocTarget.findFirstWrong(context);

    if (target == null) return;

    final formTheme = DmFormTheme.of(context);
    final scrollableConfig = formTheme.scrollableFormTheme;

    Scrollable.ensureVisible(
      target.context,
      duration: duration ?? scrollableConfig.duration,
      alignment: alignment ?? scrollableConfig.alignment,
      curve: curve ?? scrollableConfig.curve,
      alignmentPolicy: alignmentPolicy ?? scrollableConfig.alignmentPolicy,
    );
  }

  void _onFormBlocState(BuildContext context, FormBlocState state) {
    if (state is FormBlocSubmissionFailed) {
      ensureFieldVisible(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FormBloc, FormBlocState>(
      bloc: formBloc,
      listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
      listener: _onFormBlocState,
      child: child,
    );
  }
}
