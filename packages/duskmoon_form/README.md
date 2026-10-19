# duskmoon_form

Form state management and adaptive form widgets for the DuskMoon Design System.

Merges BLoC-based form state management with platform-adaptive form field widgets in a single package.

## Features

- **7 field BLoC types**: TextFieldBloc, InputFieldBloc, BooleanFieldBloc, SelectFieldBloc, MultiSelectFieldBloc, GroupFieldBloc, ListFieldBloc
- **11 form field widgets**: text, checkbox, switch, dropdown, slider, date/time, choice chip, filter chip, radio group, checkbox group
- **FormBloc**: submission, validation, multi-step wizard support
- **Sync/async validators** with debouncing and cross-field validation
- **DmFormTheme**: theming integrated with DuskMoon Design System

## Usage

```dart
import 'package:duskmoon_form/duskmoon_form.dart';
```

See the [documentation](https://github.com/duskmoon-dev/flutter_duskmoon_ui) for detailed usage guides.

## Source and licenses

Imported form BLoCs/widgets retain GiancarloCode's MIT notice, the embedded
autocomplete retains BSD-2-Clause, and the Material Stepper retains Flutter's
BSD-3-Clause terms. DuskMoon modifications retain their MIT terms.

See [SOURCE.md](SOURCE.md),
[LICENSE](LICENSE) and [THIRD_PARTY_LICENSES](THIRD_PARTY_LICENSES) for the
retained notices, import history and known provenance limits.
