import 'package:duskmoon_ui/duskmoon_ui.dart';
import 'package:flutter/material.dart';

import '../../destination.dart';

class FormScreen extends StatelessWidget {
  static const name = 'Form';
  static const path = '/form';

  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DmAdaptiveScaffold(
      selectedIndex: Destinations.indexOf(const Key(name)),
      onSelectedIndexChange: (idx) => Destinations.changeHandler(idx, context),
      destinations: Destinations.navs,
      useDrawer: true,
      transitionDuration: Duration.zero,
      appBar: DmAppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        title: const Text('Form'),
        actions: const [PlatformSwitchAction()],
      ),
      appBarBreakpoint: Breakpoints.standard,
      body: (_) => const _FormBody(),
    );
  }
}

class _FormBody extends StatelessWidget {
  const _FormBody();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _AllFieldsFormBloc(),
      child: Builder(
        builder: (ctx) {
          final bloc = ctx.read<_AllFieldsFormBloc>();
          return DmFormBlocListener<_AllFieldsFormBloc, String, String>(
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(ctx),
                const SizedBox(height: 16),
                _buildTextFieldsSection(ctx, bloc),
                const SizedBox(height: 16),
                _buildSelectionSection(ctx, bloc),
                const SizedBox(height: 16),
                _buildChipSection(ctx, bloc),
                const SizedBox(height: 16),
                _buildToggleSection(ctx, bloc),
                const SizedBox(height: 16),
                _buildDateTimeSection(ctx, bloc),
                const SizedBox(height: 16),
                _buildSliderSection(ctx, bloc),
                const SizedBox(height: 16),
                _buildRichEditorSection(ctx, bloc),
                const SizedBox(height: 16),
                _buildSubmitButton(ctx, bloc),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Form Field Types',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Showcases every Dm form field widget builder: text, dropdown, '
          'radio, checkbox group, choice chips, filter chips, switch, '
          'checkbox, slider, date/time pickers, code editor, and markdown.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  // -- Text Fields --

  Widget _buildTextFieldsSection(BuildContext ctx, _AllFieldsFormBloc bloc) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Text Fields', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'DmTextFieldBlocBuilder with validation and clear button.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            DmTextFieldBlocBuilder(
              textFieldBloc: bloc.fullName,
              decoration: const InputDecoration(
                labelText: 'Full name *',
                prefixIcon: Icon(Icons.person_outline),
              ),
              suffixButton: SuffixButton.clearText,
            ),
            DmTextFieldBlocBuilder(
              textFieldBloc: bloc.email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email address *',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              suffixButton: SuffixButton.clearText,
            ),
            DmTextFieldBlocBuilder(
              textFieldBloc: bloc.password,
              suffixButton: SuffixButton.obscureText,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            DmTextFieldBlocBuilder(
              textFieldBloc: bloc.bio,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Short bio',
                prefixIcon: Icon(Icons.notes),
                alignLabelWithHint: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Selection: Dropdown & Radio --

  Widget _buildSelectionSection(BuildContext ctx, _AllFieldsFormBloc bloc) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selection Fields',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'DmDropdownFieldBlocBuilder and DmRadioButtonGroupFieldBlocBuilder.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            DmDropdownFieldBlocBuilder<String>(
              selectFieldBloc: bloc.role,
              decoration: const InputDecoration(
                labelText: 'Role',
                hintText: 'Select a role',
                prefixIcon: Icon(Icons.work_outline),
              ),
              itemBuilder: (context, value) => FieldItem(child: Text(value)),
            ),
            const SizedBox(height: 8),
            Text(
              'Experience level',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            DmRadioButtonGroupFieldBlocBuilder<String>(
              selectFieldBloc: bloc.experience,
              groupStyle: const WrapGroupStyle(),
              itemBuilder: (context, value) => FieldItem(child: Text(value)),
            ),
          ],
        ),
      ),
    );
  }

  // -- Chips: Choice & Filter --

  Widget _buildChipSection(BuildContext ctx, _AllFieldsFormBloc bloc) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chip Fields', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'DmChoiceChipFieldBlocBuilder (single) and '
              'DmFilterChipFieldBlocBuilder (multi-select).',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Priority',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            DmChoiceChipFieldBlocBuilder<String>(
              selectFieldBloc: bloc.priority,
              itemBuilder: (context, value) => ChipFieldItem(label: Text(value)),
            ),
            const SizedBox(height: 12),
            Text(
              'Skills',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            DmFilterChipFieldBlocBuilder<String>(
              multiSelectFieldBloc: bloc.skills,
              itemBuilder: (context, value) => ChipFieldItem(label: Text(value)),
            ),
          ],
        ),
      ),
    );
  }

  // -- Toggles: Switch, Checkbox, Checkbox Group --

  Widget _buildToggleSection(BuildContext ctx, _AllFieldsFormBloc bloc) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Toggle Fields', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'DmSwitchFieldBlocBuilder, DmCheckboxFieldBlocBuilder, '
              'and DmCheckboxGroupFieldBlocBuilder.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            DmSwitchFieldBlocBuilder(
              booleanFieldBloc: bloc.darkMode,
              body: const Text('Enable dark mode'),
            ),
            DmCheckboxFieldBlocBuilder(
              booleanFieldBloc: bloc.agreeTerms,
              body: const Text('I agree to the terms and conditions'),
            ),
            const SizedBox(height: 8),
            Text(
              'Notification channels',
              style: Theme.of(ctx).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            DmCheckboxGroupFieldBlocBuilder<String>(
              multiSelectFieldBloc: bloc.notifications,
              groupStyle: const WrapGroupStyle(),
              itemBuilder: (context, value) => FieldItem(child: Text(value)),
            ),
          ],
        ),
      ),
    );
  }

  // -- Date & Time --

  Widget _buildDateTimeSection(BuildContext ctx, _AllFieldsFormBloc bloc) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date & Time Fields',
              style: Theme.of(ctx).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'DmDateTimeFieldBlocBuilder (date only and date+time) '
              'and DmTimeFieldBlocBuilder.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            DmDateTimeFieldBlocBuilder(
              dateTimeFieldBloc: bloc.birthDate,
              format: DateFormat.yMMMd(),
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              decoration: const InputDecoration(
                labelText: 'Birth date',
                prefixIcon: Icon(Icons.calendar_today),
              ),
            ),
            DmDateTimeFieldBlocBuilder(
              dateTimeFieldBloc: bloc.appointmentDateTime,
              format: DateFormat.yMMMd().add_jm(),
              canSelectTime: true,
              initialDate: DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              decoration: const InputDecoration(
                labelText: 'Appointment date & time',
                prefixIcon: Icon(Icons.event),
              ),
            ),
            DmTimeFieldBlocBuilder(
              timeFieldBloc: bloc.reminderTime,
              format: DateFormat.jm(),
              initialTime: const TimeOfDay(hour: 9, minute: 0),
              decoration: const InputDecoration(
                labelText: 'Daily reminder time',
                prefixIcon: Icon(Icons.access_time),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Slider --

  Widget _buildSliderSection(BuildContext ctx, _AllFieldsFormBloc bloc) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Slider Field', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'DmSliderFieldBlocBuilder with divisions.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            DmSliderFieldBlocBuilder(
              inputFieldBloc: bloc.satisfaction,
              min: 0,
              max: 10,
              divisions: 10,
              decoration: const InputDecoration(
                labelText: 'Satisfaction (0-10)',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Rich Editors: Code & Markdown --

  Widget _buildRichEditorSection(BuildContext ctx, _AllFieldsFormBloc bloc) {
    return DmCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Rich Editors', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              'DmCodeEditorFieldBlocBuilder and DmMarkdownFieldBlocBuilder.',
              style: Theme.of(ctx).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: DmCodeEditorFieldBlocBuilder(
                codeEditorFieldBloc: bloc.codeSnippet,
                minHeight: 200,
                maxHeight: 200,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 400,
              child: DmMarkdownFieldBlocBuilder(
                markdownFieldBloc: bloc.notes,
                minLines: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -- Submit --

  Widget _buildSubmitButton(BuildContext ctx, _AllFieldsFormBloc bloc) {
    return BlocBuilder<_AllFieldsFormBloc, FormBlocState<String, String>>(
      builder: (context, state) {
        final isSubmitting = state is FormBlocSubmitting;
        return SizedBox(
          width: double.infinity,
          child: DmButton(
            onPressed: isSubmitting ? null : () => bloc.submit(),
            child: isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator.adaptive(strokeWidth: 2),
                  )
                : const Text('Submit All Fields'),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// FormBloc with every field type
// ---------------------------------------------------------------------------

class _AllFieldsFormBloc extends FormBloc<String, String> {
  // Text fields
  final fullName = TextFieldBloc(
    validators: [FieldBlocValidators.required],
  );
  final email = TextFieldBloc(
    validators: [FieldBlocValidators.required, FieldBlocValidators.email],
  );
  final password = TextFieldBloc();
  final bio = TextFieldBloc();

  // Dropdown (single select)
  final role = SelectFieldBloc<String, dynamic>(
    items: const ['Developer', 'Designer', 'Manager', 'QA', 'Other'],
  );

  // Radio button group (single select)
  final experience = SelectFieldBloc<String, dynamic>(
    items: const ['Junior', 'Mid-level', 'Senior', 'Lead'],
  );

  // Choice chips (single select)
  final priority = SelectFieldBloc<String, dynamic>(
    items: const ['Low', 'Medium', 'High', 'Critical'],
  );

  // Filter chips (multi-select)
  final skills = MultiSelectFieldBloc<String, dynamic>(
    items: const ['Flutter', 'Dart', 'Swift', 'Kotlin', 'React', 'Go'],
  );

  // Switch
  final darkMode = BooleanFieldBloc();

  // Checkbox
  final agreeTerms = BooleanFieldBloc();

  // Checkbox group (multi-select)
  final notifications = MultiSelectFieldBloc<String, dynamic>(
    items: const ['Email', 'Push', 'SMS', 'In-app'],
  );

  // Date picker
  final birthDate = InputFieldBloc<DateTime?, dynamic>(initialValue: null);

  // Date + time picker
  final appointmentDateTime = InputFieldBloc<DateTime?, dynamic>(
    initialValue: null,
  );

  // Time picker
  final reminderTime = InputFieldBloc<TimeOfDay?, dynamic>(
    initialValue: null,
  );

  // Slider
  final satisfaction = InputFieldBloc<double, dynamic>(initialValue: 5.0);

  // Code editor
  final codeSnippet = CodeEditorFieldBloc(
    initialValue: 'void main() {\n  print("Hello, DuskMoon!");\n}\n',
    initialLanguage: 'dart',
  );

  // Markdown editor
  final notes = MarkdownFieldBloc(
    initialValue: '## Notes\n\nWrite your **markdown** here.',
  );

  _AllFieldsFormBloc() {
    addFieldBlocs(fieldBlocs: [
      fullName,
      email,
      password,
      bio,
      role,
      experience,
      priority,
      skills,
      darkMode,
      agreeTerms,
      notifications,
      birthDate,
      appointmentDateTime,
      reminderTime,
      satisfaction,
      codeSnippet,
      notes,
    ]);
  }

  @override
  void onSubmitting() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    emitSuccess(
      successResponse:
          'All 17 fields submitted successfully!',
    );
  }
}
