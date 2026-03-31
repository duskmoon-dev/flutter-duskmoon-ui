import 'package:flutter/material.dart' hide Stepper, Step;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/form/form_bloc.dart';
import 'stepper.dart';

/// A material step used in [Stepper]. The step can have a title and subtitle,
/// an icon within its circle, some content and a state that governs its
/// styling.
@immutable
class FormBlocStep {
  const FormBlocStep({
    required this.title,
    this.subtitle,
    required this.content,
    this.state = StepState.indexed,
    this.isActive,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget content;
  final StepState state;
  final bool? isActive;
}

class DmStepperFormBlocBuilder<T extends FormBloc> extends StatelessWidget {
  const DmStepperFormBlocBuilder({
    super.key,
    this.formBloc,
    required this.stepsBuilder,
    this.physics,
    this.type = StepperType.vertical,
    this.onStepTapped,
    this.onStepContinue,
    this.onStepCancel,
    this.controlsBuilder,
  });

  final T? formBloc;

  final List<FormBlocStep> Function(T? formBloc) stepsBuilder;
  final ScrollPhysics? physics;
  final StepperType type;
  final void Function(FormBloc? formBloc, int step)? onStepTapped;
  final void Function(FormBloc? formBloc)? onStepContinue;
  final void Function(FormBloc? formBloc)? onStepCancel;
  final Widget Function(
    BuildContext context,
    VoidCallback? onStepContinue,
    VoidCallback? onStepCancel,
    int step,
    FormBloc formBloc,
  )? controlsBuilder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<T, FormBlocState>(
      bloc: formBloc,
      buildWhen: (p, c) =>
          p.numberOfSteps != c.numberOfSteps || p.currentStep != c.currentStep,
      builder: (context, state) {
        final formBloc = this.formBloc ?? context.read<T>();

        final formBlocSteps = stepsBuilder(formBloc);
        return Stepper(
          key: Key('__stepper_form_bloc_${formBlocSteps.length}__'),
          currentStep: state.currentStep,
          onStepCancel: onStepCancel == null
              ? (state.isFirstStep ? null : formBloc.previousStep)
              : () => onStepCancel?.call(formBloc),
          onStepContinue: onStepContinue == null
              ? formBloc.submit
              : () => onStepContinue?.call(formBloc),
          onStepTapped: onStepTapped == null
              ? null
              : (step) => onStepTapped?.call(formBloc, step),
          physics: physics,
          type: type,
          steps: [
            for (var i = 0; i < formBlocSteps.length; i++)
              Step(
                title: formBlocSteps[i].title,
                isActive: formBlocSteps[i].isActive ?? i == state.currentStep,
                content: formBlocSteps[i].content,
                state: formBlocSteps[i].state,
                subtitle: formBlocSteps[i].subtitle,
              ),
          ],
          controlsBuilder: controlsBuilder == null
              ? null
              : (context, controlsDetails) => controlsBuilder!(
                    context,
                    controlsDetails.onStepContinue,
                    controlsDetails.onStepCancel,
                    controlsDetails.stepIndex,
                    formBloc,
                  ),
        );
      },
    );
  }
}
