import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

class FormPage extends StatelessWidget {
  const FormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeader(context),
        const SizedBox(height: 16),
        _buildContactFormSection(context),
        const SizedBox(height: 16),
        _buildShowcaseSection(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Form', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        Text(
          'BLoC-based form management with validation, async submission, '
          'and adaptive field widgets.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildContactFormSection(BuildContext context) {
    return BlocProvider(
      create: (_) => _ContactFormBloc(),
      child: Builder(
        builder: (ctx) {
          return DmFormBlocListener<_ContactFormBloc, String, String>(
            onSuccess: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.successResponse ?? 'Submitted!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            onFailure: (context, state) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.failureResponse ?? 'Submission failed.'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            },
            child: DmCard(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Form',
                      style: Theme.of(ctx).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Demonstrates required validation, email validation, '
                      'dropdown selection, and async submission.',
                      style: Theme.of(ctx).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 12),
                    DmTextFieldBlocBuilder(
                      textFieldBloc: ctx.read<_ContactFormBloc>().name,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      suffixButton: SuffixButton.clearText,
                    ),
                    DmTextFieldBlocBuilder(
                      textFieldBloc: ctx.read<_ContactFormBloc>().email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      suffixButton: SuffixButton.clearText,
                    ),
                    DmDropdownFieldBlocBuilder<String>(
                      selectFieldBloc: ctx.read<_ContactFormBloc>().role,
                      decoration: const InputDecoration(
                        labelText: 'Role',
                        prefixIcon: Icon(Icons.work_outline),
                      ),
                      itemBuilder: (context, value) => FieldItem(
                        child: Text(value),
                      ),
                    ),
                    DmSwitchFieldBlocBuilder(
                      booleanFieldBloc: ctx.read<_ContactFormBloc>().notify,
                      body: const Text('Receive notifications'),
                    ),
                    const SizedBox(height: 8),
                    BlocBuilder<_ContactFormBloc,
                        FormBlocState<String, String>>(
                      builder: (context, state) {
                        final isSubmitting = state is FormBlocSubmitting;
                        return SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: isSubmitting
                                ? null
                                : () =>
                                    context.read<_ContactFormBloc>().submit(),
                            child: isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text('Submit'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShowcaseSection(BuildContext context) {
    return BlocProvider(
      create: (_) => _ShowcaseFormBloc(),
      child: Builder(
        builder: (ctx) {
          return DmCard(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Field Widget Showcase',
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Demonstrates slider and checkbox field widgets.',
                    style: Theme.of(ctx).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  DmSliderFieldBlocBuilder(
                    inputFieldBloc: ctx.read<_ShowcaseFormBloc>().slider,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    decoration: const InputDecoration(
                      labelText: 'Priority score',
                    ),
                  ),
                  DmCheckboxFieldBlocBuilder(
                    booleanFieldBloc: ctx.read<_ShowcaseFormBloc>().agree,
                    body: const Text('I agree to the terms'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Form BLoCs
// ---------------------------------------------------------------------------

class _ContactFormBloc extends FormBloc<String, String> {
  final name = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  final email = TextFieldBloc(
    validators: [FieldBlocValidators.email],
  );

  final role = SelectFieldBloc<String, dynamic>(
    items: const ['Developer', 'Designer', 'Manager', 'Other'],
  );

  final notify = BooleanFieldBloc();

  _ContactFormBloc() {
    addFieldBlocs(fieldBlocs: [name, email, role, notify]);
  }

  @override
  void onSubmitting() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    emitSuccess(successResponse: 'Sent!');
  }
}

class _ShowcaseFormBloc extends FormBloc<String, String> {
  final slider = InputFieldBloc<double, dynamic>(initialValue: 50.0);

  final agree = BooleanFieldBloc();

  _ShowcaseFormBloc() {
    addFieldBlocs(fieldBlocs: [slider, agree]);
  }

  @override
  void onSubmitting() {
    emitSuccess();
  }
}
