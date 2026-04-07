# Form State Management

BLoC-based form state management with adaptive form widgets for the DuskMoon Design System.

## Table of Contents

- [Installation](#installation)
- [Overview](#overview)
- [Field BLoCs](#field-blocs)
- [FormBloc](#formbloc)
- [Validators](#validators)
- [Widget Builders](#widget-builders)
- [Form Listener](#form-listener)
- [Multi-step Forms](#multi-step-forms)
- [Theming](#theming)
- [Scrollable Forms](#scrollable-forms)
- [Re-exports](#re-exports)
- [Complete Example](#complete-example)

## Installation

```yaml
dependencies:
  duskmoon_form: ^1.2.3
```

Or use the umbrella package:

```yaml
dependencies:
  duskmoon_ui: ^1.2.3
```

```dart
import 'package:duskmoon_form/duskmoon_form.dart';
// or
import 'package:duskmoon_ui/duskmoon_ui.dart';
```

> **Requirements:** Dart >= 3.5.0, Flutter >= 3.24.0

## Overview

`duskmoon_form` provides a complete form solution built on the BLoC pattern:

- **Field BLoCs** manage individual input state, validation, and errors
- **FormBloc** orchestrates fields, handles submission, and manages multi-step workflows
- **Widget builders** (`Dm*` prefix) connect BLoCs to Material UI widgets
- **Validators** provide sync/async validation with debouncing
- **DmFormTheme** customizes all field widget appearances

The package re-exports `flutter_bloc` — no separate import needed.

## Field BLoCs

Nine field types cover all common form inputs:

### TextFieldBloc

For text input. Value type: `String`.

```dart
final email = TextFieldBloc(
  name: 'email',
  initialValue: '',
  validators: [FieldBlocValidators.required, FieldBlocValidators.email],
  asyncValidators: [checkEmailAvailability],
  asyncValidatorDebounceTime: const Duration(milliseconds: 500),
);
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | `String?` | auto-generated | Field identifier |
| `initialValue` | `String` | `''` | Starting value |
| `validators` | `List<Validator<String>>?` | `null` | Synchronous validators |
| `asyncValidators` | `List<AsyncValidator<String>>?` | `null` | Async validators |
| `asyncValidatorDebounceTime` | `Duration` | 500ms | Debounce for async validators |
| `suggestions` | `Suggestions<String>?` | `null` | Type-ahead suggestion function |
| `extraData` | `ExtraData?` | `null` | Custom metadata |

Extra properties: `valueToInt`, `valueToDouble`.

### BooleanFieldBloc

For toggles and checkboxes. Value type: `bool`.

```dart
final acceptTerms = BooleanFieldBloc(
  validators: [FieldBlocValidators.required], // requires true
);
```

### SelectFieldBloc

For single-selection from a list. Value type: `Value?` (generic).

```dart
final country = SelectFieldBloc<String, dynamic>(
  items: ['US', 'UK', 'DE', 'JP'],
  validators: [FieldBlocValidators.required],
);
```

| Method | Description |
|--------|-------------|
| `updateItems(List<Value>)` | Replace available items |
| `addItem(Value)` | Add one item |
| `removeItem(Value)` | Remove one item |

### MultiSelectFieldBloc

For multiple-selection. Value type: `List<Value>`.

```dart
final tags = MultiSelectFieldBloc<String, dynamic>(
  items: ['flutter', 'dart', 'bloc'],
);
```

| Method | Description |
|--------|-------------|
| `select(Value)` | Add to selection |
| `deselect(Value)` | Remove from selection |
| `updateItems(List<Value>)` | Replace available items |

### InputFieldBloc

Generic field for any value type (dates, numbers, custom objects).

```dart
final rating = InputFieldBloc<double, dynamic>(initialValue: 0.5);
final birthday = InputFieldBloc<DateTime?, dynamic>(initialValue: null);
```

### GroupFieldBloc

Groups related fields together for composite validation.

```dart
final address = GroupFieldBloc(name: 'address', fieldBlocs: [street, city, zip]);
```

### ListFieldBloc

Dynamic list of fields that can be added/removed at runtime.

```dart
final phones = ListFieldBloc<TextFieldBloc, dynamic>(
  fieldBlocs: [TextFieldBloc(name: 'phone_0')],
);
phones.addFieldBloc(TextFieldBloc(name: 'phone_1'));
phones.removeFieldBlocAt(0);
```

| Method | Description |
|--------|-------------|
| `addFieldBloc(T)` | Append field |
| `removeFieldBlocAt(int)` | Remove by index |
| `removeFieldBloc(FieldBloc)` | Remove specific field |
| `insertFieldBloc(T, int)` | Insert at index |
| `updateFieldBlocs(List<T>)` | Replace all fields |
| `clearFieldBlocs()` | Remove all fields |

### MarkdownFieldBloc

Extends `InputFieldBloc` for markdown text with write/preview tab state.

```dart
final notes = MarkdownFieldBloc<dynamic>(
  initialValue: '# Hello',
);
```

| Property | Type | Description |
|----------|------|-------------|
| `initialTab` | `DmMarkdownTab` | Default active tab (write or preview) |

### CodeEditorFieldBloc

Extends `InputFieldBloc` for source code with language/syntax highlighting state.

```dart
final code = CodeEditorFieldBloc<dynamic>(
  initialValue: 'void main() {}',
);
```

| Method | Description |
|--------|-------------|
| `updateLanguage(String?)` | Change syntax highlighting language at runtime |

### Common Field API

All single-value field BLoCs share these methods:

| Method | Description |
|--------|-------------|
| `changeValue(Value)` | Set value (marks as changed) |
| `updateValue(Value)` | Set value (marks as not changed) |
| `updateInitialValue(Value)` | Update initial value |
| `clear()` | Reset to initial value |
| `validate()` | Run validators, returns `Future<bool>` |
| `addValidators(List<Validator>)` | Add validators |
| `updateValidators(List<Validator>)` | Replace validators |
| `addFieldError(Object, {bool isPermanent})` | Set manual error |
| `updateExtraData(ExtraData)` | Update metadata |
| `selectSuggestion(Suggestion)` | Trigger suggestion selection |

## FormBloc

Subclass `FormBloc<SuccessResponse, FailureResponse>` to create your form:

```dart
class LoginFormBloc extends FormBloc<String, String> {
  final email = TextFieldBloc(
    validators: [FieldBlocValidators.required, FieldBlocValidators.email],
  );
  final password = TextFieldBloc(
    validators: [FieldBlocValidators.required, FieldBlocValidators.passwordMin6Chars],
  );

  LoginFormBloc() {
    addFieldBlocs(fieldBlocs: [email, password]);
  }

  @override
  void onSubmitting() async {
    try {
      await authService.login(email.value, password.value);
      emitSuccess(successResponse: 'Logged in!');
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}
```

### Constructor

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `isLoading` | `bool` | `false` | Start in loading state (calls `onLoading()`) |
| `autoValidate` | `bool` | `true` | Validate fields on every value change |
| `isEditing` | `bool` | `false` | Flag for edit mode |

### Overridable methods

| Method | When called |
|--------|-------------|
| `onSubmitting()` | **Required.** Form passed validation and is submitting |
| `onLoading()` | Form enters loading state |
| `onDeleting()` | `delete()` was called |
| `onCancelingSubmission()` | `cancelSubmission()` was called during submission |

### State emission methods

Call these inside `onSubmitting()` (or other overrides) to transition the form state:

| Method | Resulting state |
|--------|----------------|
| `emitLoading({double progress})` | `FormBlocLoading` |
| `emitLoaded()` | `FormBlocLoaded` |
| `emitLoadFailed({F?})` | `FormBlocLoadFailed` |
| `emitSubmitting({double? progress})` | `FormBlocSubmitting` |
| `emitSuccess({S?, bool? canSubmitAgain, bool? isEditing})` | `FormBlocSuccess` |
| `emitFailure({F?})` | `FormBlocFailure` |
| `emitSubmissionCancelled()` | `FormBlocSubmissionCancelled` |
| `emitDeleteFailed({F?})` | `FormBlocDeleteFailed` |
| `emitDeleteSuccessful({S?})` | `FormBlocDeleteSuccessful` |
| `emitUpdatingFields({double? progress})` | `FormBlocUpdatingFields` |

### Field management

| Method | Description |
|--------|-------------|
| `addFieldBloc({int step = 0, required FieldBloc})` | Add field to step |
| `addFieldBlocs({int step = 0, required List<FieldBloc>})` | Add multiple fields |
| `removeFieldBloc({int? step, required FieldBloc})` | Remove field |
| `submit()` | Validate and submit |
| `clear()` | Reset all fields |
| `reload()` | Call `onLoading()` again |
| `delete()` | Call `onDeleting()` |
| `cancelSubmission()` | Cancel active submission |

### State properties

| Property | Type | Description |
|----------|------|-------------|
| `isValid([int? step])` | `bool` | All fields valid |
| `currentStep` | `int` | Current step index |
| `numberOfSteps` | `int` | Total steps |
| `isLastStep` / `isFirstStep` | `bool` | Step position |
| `canSubmit` | `bool` | Can the form submit |
| `isEditing` | `bool` | Edit mode flag |
| `toJson([int? step])` | `Map<String, dynamic>` | Serialize field values |

## Validators

### Built-in validators

| Validator | Checks |
|-----------|--------|
| `FieldBlocValidators.required` | Non-null, non-empty string, non-false bool |
| `FieldBlocValidators.email` | Valid email format |
| `FieldBlocValidators.passwordMin6Chars` | Minimum 6 characters |
| `FieldBlocValidators.confirmPassword(passwordBloc)` | Matches another field's value |

### Custom validators

Synchronous — return `null` for valid, error object for invalid:

```dart
Validator<String> minLength(int min) {
  return (value) => value.length < min ? 'Must be at least $min characters' : null;
}
```

Asynchronous — return a `Future`:

```dart
AsyncValidator<String> checkAvailability = (value) async {
  final taken = await api.isUsernameTaken(value);
  return taken ? 'Username already taken' : null;
};
```

### Custom error display

```dart
DmTextFieldBlocBuilder(
  textFieldBloc: username,
  errorBuilder: (context, error) {
    if (error == 'Username already taken') return 'Try a different username';
    return error.toString();
  },
)
```

## Widget Builders

All widget builders share these common parameters:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `enableOnlyWhenFormBlocCanSubmit` | `bool` | `false` | Disable when form can't submit |
| `isEnabled` | `bool` | `true` | Enable/disable field |
| `errorBuilder` | `FieldBlocErrorBuilder?` | `null` | Custom error text |
| `padding` | `EdgeInsetsGeometry?` | `null` | Field padding |
| `nextFocusNode` | `FocusNode?` | `null` | Focus node for next field |
| `animateWhenCanShow` | `bool` | `true` | Animate show/hide |

### DmTextFieldBlocBuilder

Text input with optional type-ahead suggestions.

```dart
DmTextFieldBlocBuilder(
  textFieldBloc: formBloc.email,
  decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email)),
  keyboardType: TextInputType.emailAddress,
  suffixButton: SuffixButton.clearText,
)
```

`SuffixButton` enum: `obscureText` (show/hide password), `clearText` (clear field), `asyncValidating` (show spinner).

### DmCheckboxFieldBlocBuilder

```dart
DmCheckboxFieldBlocBuilder(
  booleanFieldBloc: formBloc.acceptTerms,
  body: const Text('I accept the terms and conditions'),
  controlAffinity: FieldBlocBuilderControlAffinity.leading,
)
```

### DmSwitchFieldBlocBuilder

```dart
DmSwitchFieldBlocBuilder(
  booleanFieldBloc: formBloc.notifications,
  body: const Text('Enable notifications'),
)
```

### DmDropdownFieldBlocBuilder

```dart
DmDropdownFieldBlocBuilder<String>(
  selectFieldBloc: formBloc.country,
  decoration: const InputDecoration(labelText: 'Country'),
  itemBuilder: (context, value) => FieldItem(child: Text(value)),
  showEmptyItem: true,
)
```

### DmSliderFieldBlocBuilder

```dart
DmSliderFieldBlocBuilder(
  inputFieldBloc: formBloc.rating,
  decoration: const InputDecoration(labelText: 'Rating'),
  min: 0.0,
  max: 5.0,
  divisions: 10,
  labelBuilder: (context, value) => value.toStringAsFixed(1),
)
```

### DmDateTimeFieldBlocBuilder

```dart
DmDateTimeFieldBlocBuilder(
  dateTimeFieldBloc: formBloc.birthday,
  format: DateFormat('yyyy-MM-dd'),
  initialDate: DateTime.now(),
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
  canSelectTime: false,
  showClearIcon: true,
  decoration: const InputDecoration(labelText: 'Date of Birth'),
)
```

### DmTimeFieldBlocBuilder

```dart
DmTimeFieldBlocBuilder(
  dateTimeFieldBloc: formBloc.meetingTime,
  format: DateFormat.Hm(),
  initialTime: TimeOfDay.now(),
  decoration: const InputDecoration(labelText: 'Meeting Time'),
)
```

### DmChoiceChipFieldBlocBuilder

Single-select with chips.

```dart
DmChoiceChipFieldBlocBuilder<String>(
  selectFieldBloc: formBloc.size,
  itemBuilder: (context, value) => ChipFieldItem(label: Text(value)),
  canDeselect: true,
  direction: Axis.horizontal,
)
```

### DmFilterChipFieldBlocBuilder

Multi-select with chips.

```dart
DmFilterChipFieldBlocBuilder<String>(
  multiSelectFieldBloc: formBloc.colors,
  itemBuilder: (context, value) => ChipFieldItem(label: Text(value)),
)
```

### DmCheckboxGroupFieldBlocBuilder

Multi-select with checkboxes in a group layout.

```dart
DmCheckboxGroupFieldBlocBuilder<String>(
  multiSelectFieldBloc: formBloc.toppings,
  itemBuilder: (context, value) => FieldItem(child: Text(value)),
  groupStyle: const FlexGroupStyle(),
)
```

### DmRadioButtonGroupFieldBlocBuilder

Single-select with radio buttons in a group layout.

```dart
DmRadioButtonGroupFieldBlocBuilder<String>(
  selectFieldBloc: formBloc.priority,
  itemBuilder: (context, value) => FieldItem(child: Text(value)),
)
```

### DmMarkdownFieldBlocBuilder

Markdown editor with write/preview tabs.

```dart
DmMarkdownFieldBlocBuilder(
  markdownFieldBloc: formBloc.notes,
  config: const DmMarkdownConfig(),
  tabLabelWrite: 'Write',
  tabLabelPreview: 'Preview',
  showLineNumbers: false,
  maxLines: null,
  minLines: 10,
  onLinkTap: (url, title) {},
  decoration: const InputDecoration(labelText: 'Notes'),
)
```

### DmCodeEditorFieldBlocBuilder

Source code editor with syntax highlighting.

```dart
DmCodeEditorFieldBlocBuilder(
  codeEditorFieldBloc: formBloc.code,
  lineNumbers: true,
  highlightActiveLine: true,
  theme: null, // EditorTheme? — auto-derived from DmFormTheme or context
  minHeight: null,
  maxHeight: null,
  editorPadding: null,
  scrollPhysics: null,
)
```

### DmCanShowFieldBlocBuilder

Conditionally shows or hides a field based on the field BLoC's `canShow` state, with optional animation:

```dart
DmCanShowFieldBlocBuilder(
  fieldBloc: formBloc.addressField,
  animate: true,   // Animated show/hide (default: true)
  builder: (context, canShow) {
    return canShow
        ? DmTextFieldBlocBuilder(textFieldBloc: formBloc.addressField, ...)
        : const SizedBox.shrink();
  },
)
```

This is useful for conditionally rendering fields based on other field values — toggle the BLoC's `canShow` state to show or hide the widget.

## Form Listener

`DmFormBlocListener` reacts to form state changes without rebuilding UI:

```dart
DmFormBlocListener<LoginFormBloc, String, String>(
  onSubmitting: (context, state) {
    showDialog(context: context, builder: (_) => const Center(child: CircularProgressIndicator()));
  },
  onSuccess: (context, state) {
    Navigator.of(context).pop(); // dismiss loading
    Navigator.of(context).pushReplacementNamed('/home');
  },
  onFailure: (context, state) {
    Navigator.of(context).pop(); // dismiss loading
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.failureResponse ?? 'Error')),
    );
  },
  child: formContent,
)
```

Available callbacks: `onLoading`, `onLoaded`, `onLoadFailed`, `onSubmitting`, `onSuccess`, `onFailure`, `onSubmissionCancelled`, `onSubmissionFailed`, `onDeleting`, `onDeleteFailed`, `onDeleteSuccessful`.

## Multi-step Forms

### Define steps in FormBloc

```dart
class WizardFormBloc extends FormBloc<String, String> {
  final name = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(validators: [FieldBlocValidators.required, FieldBlocValidators.email]);
  final password = TextFieldBloc(validators: [FieldBlocValidators.required]);

  WizardFormBloc() {
    addFieldBloc(step: 0, fieldBloc: name);
    addFieldBloc(step: 1, fieldBloc: email);
    addFieldBloc(step: 2, fieldBloc: password);
  }

  @override
  void onSubmitting() async {
    emitSuccess(successResponse: 'Done!');
  }
}
```

### DmStepperFormBlocBuilder

```dart
DmStepperFormBlocBuilder<WizardFormBloc>(
  formBloc: wizardFormBloc,
  type: StepperType.horizontal,
  stepsBuilder: (formBloc) => [
    FormBlocStep(title: const Text('Name'), content: nameFields),
    FormBlocStep(title: const Text('Contact'), content: contactFields),
    FormBlocStep(title: const Text('Security'), content: securityFields),
  ],
)
```

## Theming

Wrap your form (or app) in `DmFormThemeProvider` to customize all field widgets:

```dart
DmFormThemeProvider(
  theme: DmFormTheme(
    padding: const EdgeInsets.symmetric(vertical: 12),
    textTheme: const TextFieldTheme(
      decorationTheme: InputDecorationThemeData(border: OutlineInputBorder()),
    ),
  ),
  child: yourForm,
)
```

Access the theme in any descendant: `DmFormTheme.of(context)`.

### Field theme classes

| Class | Controls |
|-------|----------|
| `TextFieldTheme` | Text input decoration and style |
| `CheckboxFieldTheme` | Checkbox colors and affinity |
| `SwitchFieldTheme` | Switch colors and style |
| `DropdownFieldTheme` | Dropdown decoration |
| `SliderFieldTheme` | Slider colors and divisions |
| `DateTimeFieldTheme` | Date/time picker style |
| `ChoiceChipFieldTheme` | Choice chip appearance |
| `FilterChipFieldTheme` | Filter chip appearance |
| `RadioFieldTheme` | Radio button colors |
| `ClearSuffixButtonTheme` | Clear button icon and color |
| `ObscureSuffixButtonTheme` | Show/hide password button |
| `ScrollableFormTheme` | Scroll animation duration, curve, alignment |
| `MarkdownFieldTheme` | Markdown editor appearance |
| `CodeEditorFieldTheme` | Code editor appearance |

## Scrollable Forms

Auto-scroll to the first invalid field when submission fails:

```dart
ScrollableFormBlocManager(
  formBloc: formBloc,
  child: ListView(
    children: [
      ScrollableFieldBlocTarget(
        fieldBloc: formBloc.email,
        child: DmTextFieldBlocBuilder(textFieldBloc: formBloc.email, ...),
      ),
      ScrollableFieldBlocTarget(
        fieldBloc: formBloc.password,
        child: DmTextFieldBlocBuilder(textFieldBloc: formBloc.password, ...),
      ),
    ],
  ),
)
```

## Re-exports

The barrel file re-exports key types from `duskmoon_widgets` for convenience:

```dart
export 'package:duskmoon_widgets/duskmoon_widgets.dart'
    show DmMarkdownTab, DmMarkdownConfig, EditorTheme;
```

These are needed when configuring `DmMarkdownFieldBlocBuilder` and `DmCodeEditorFieldBlocBuilder`.

## Complete Example

```dart
// 1. Define the form BLoC
class RegistrationFormBloc extends FormBloc<String, String> {
  final name = TextFieldBloc(validators: [FieldBlocValidators.required]);
  final email = TextFieldBloc(
    validators: [FieldBlocValidators.required, FieldBlocValidators.email],
  );
  final password = TextFieldBloc(
    validators: [FieldBlocValidators.required, FieldBlocValidators.passwordMin6Chars],
  );
  late final confirmPassword = TextFieldBloc(
    validators: [
      FieldBlocValidators.required,
      FieldBlocValidators.confirmPassword(password),
    ],
  );
  final acceptTerms = BooleanFieldBloc(
    validators: [FieldBlocValidators.required],
  );

  RegistrationFormBloc() {
    addFieldBlocs(fieldBlocs: [name, email, password, confirmPassword, acceptTerms]);
  }

  @override
  void onSubmitting() async {
    try {
      await api.register(
        name: name.value,
        email: email.value,
        password: password.value,
      );
      emitSuccess(successResponse: 'Registration complete!');
    } catch (e) {
      emitFailure(failureResponse: e.toString());
    }
  }
}

// 2. Build the form UI
class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegistrationFormBloc(),
      child: Builder(builder: (context) {
        final formBloc = context.read<RegistrationFormBloc>();
        return Scaffold(
          appBar: AppBar(title: const Text('Register')),
          body: DmFormBlocListener<RegistrationFormBloc, String, String>(
            onSuccess: (context, state) =>
                Navigator.of(context).pushReplacementNamed('/home'),
            onFailure: (context, state) => ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.failureResponse ?? 'Error'))),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DmTextFieldBlocBuilder(
                  textFieldBloc: formBloc.name,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                ),
                DmTextFieldBlocBuilder(
                  textFieldBloc: formBloc.email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                DmTextFieldBlocBuilder(
                  textFieldBloc: formBloc.password,
                  suffixButton: SuffixButton.obscureText,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                DmTextFieldBlocBuilder(
                  textFieldBloc: formBloc.confirmPassword,
                  suffixButton: SuffixButton.obscureText,
                  decoration: const InputDecoration(labelText: 'Confirm Password'),
                ),
                DmCheckboxFieldBlocBuilder(
                  booleanFieldBloc: formBloc.acceptTerms,
                  body: const Text('I accept the terms and conditions'),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: formBloc.submit,
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
```

## See Also

- [Theme System](theme.md) — DmThemeData and color tokens used by form widgets
- [Adaptive Widgets](widgets.md) — Base adaptive widget library
- [Architecture](architecture.md) — Package dependency graph
