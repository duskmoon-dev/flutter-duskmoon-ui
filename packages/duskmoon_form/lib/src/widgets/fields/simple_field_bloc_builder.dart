import 'package:flutter/material.dart';

import '../../blocs/field/field_bloc.dart';
import '../features/appear/can_show_field_bloc_builder.dart';
import '../features/scroll/scrollable_field_bloc_target.dart';

/// Use these widgets:
/// - [DmCanShowFieldBlocBuilder]
/// - [DmScrollableFieldBlocTarget]
class DmSimpleFieldBlocBuilder extends StatelessWidget {
  final SingleFieldBloc singleFieldBloc;
  final bool animateWhenCanShow;
  final bool focusOnValidationFailed;
  final Widget Function(BuildContext context, bool canShow) builder;

  const DmSimpleFieldBlocBuilder({
    super.key,
    required this.singleFieldBloc,
    this.animateWhenCanShow = true,
    this.focusOnValidationFailed = true,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return DmCanShowFieldBlocBuilder(
      fieldBloc: singleFieldBloc,
      animate: animateWhenCanShow,
      builder: (context, canShow) {
        final field = builder(context, canShow);

        if (!canShow) {
          return field;
        }

        return DmScrollableFieldBlocTarget(
          singleFieldBloc: singleFieldBloc,
          canScroll: focusOnValidationFailed,
          child: field,
        );
      },
    );
  }
}
