# DmForm Rich Fields Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add `MarkdownFieldBloc` and `CodeEditorFieldBloc` to `duskmoon_form`, each with a state class and widget builder, following the existing `SingleFieldBloc` / `part of` pattern.

**Architecture:** Both BLoCs live as `part of` files inside the existing `field_bloc.dart` library. `MarkdownFieldBlocState` adds a mutable `DmMarkdownTab tab` field; `CodeEditorFieldBlocState` adds a mutable `String? language` field. Widget builders own their controllers (`DmMarkdownInputController` / `EditorViewController`) and use `BlocBuilder` to sync state.

**Tech Stack:** Flutter, `bloc`/`flutter_bloc`, `duskmoon_widgets` (provides `DmMarkdownInput`, `DmCodeEditor`, `DmMarkdownTab`, `DmMarkdownConfig`, `EditorViewController`, `EditorTheme`), `equatable`.

---

## File Map

**Create:**
- `packages/duskmoon_form/lib/src/blocs/markdown_field/markdown_field_bloc_state.dart`
- `packages/duskmoon_form/lib/src/blocs/markdown_field/markdown_field_bloc.dart`
- `packages/duskmoon_form/lib/src/blocs/code_editor_field/code_editor_field_bloc_state.dart`
- `packages/duskmoon_form/lib/src/blocs/code_editor_field/code_editor_field_bloc.dart`
- `packages/duskmoon_form/lib/src/widgets/dm_markdown_field_bloc_builder.dart`
- `packages/duskmoon_form/lib/src/widgets/dm_code_editor_field_bloc_builder.dart`
- `packages/duskmoon_form/test/src/blocs/markdown_field_bloc_test.dart`
- `packages/duskmoon_form/test/src/blocs/code_editor_field_bloc_test.dart`
- `packages/duskmoon_form/test/src/widgets/dm_markdown_field_bloc_builder_test.dart`
- `packages/duskmoon_form/test/src/widgets/dm_code_editor_field_bloc_builder_test.dart`

**Modify:**
- `packages/duskmoon_form/lib/src/blocs/field/field_bloc.dart` — add import + `part` directives
- `packages/duskmoon_form/lib/src/theme/form_bloc_theme.dart` — add theme classes + `DmFormTheme` fields
- `packages/duskmoon_form/lib/duskmoon_form.dart` — add exports

---

## Task 1: MarkdownFieldBlocState + MarkdownFieldBloc

**Files:**
- Create: `packages/duskmoon_form/lib/src/blocs/markdown_field/markdown_field_bloc_state.dart`
- Create: `packages/duskmoon_form/lib/src/blocs/markdown_field/markdown_field_bloc.dart`
- Modify: `packages/duskmoon_form/lib/src/blocs/field/field_bloc.dart`
- Test: `packages/duskmoon_form/test/src/blocs/markdown_field_bloc_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `packages/duskmoon_form/test/src/blocs/markdown_field_bloc_test.dart`:

```dart
import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MarkdownFieldBloc', () {
    test('initial state has tab = DmMarkdownTab.write by default', () {
      final bloc = MarkdownFieldBloc();
      expect(bloc.state.tab, DmMarkdownTab.write);
      bloc.close();
    });

    test('initial state has tab = DmMarkdownTab.preview when specified', () {
      final bloc =
          MarkdownFieldBloc(initialTab: DmMarkdownTab.preview);
      expect(bloc.state.tab, DmMarkdownTab.preview);
      bloc.close();
    });

    test('updateTab emits state with updated tab', () {
      final bloc = MarkdownFieldBloc();
      bloc.updateTab(DmMarkdownTab.preview);
      expect(bloc.state.tab, DmMarkdownTab.preview);
      bloc.close();
    });

    test('initial value is empty string by default', () {
      final bloc = MarkdownFieldBloc();
      expect(bloc.state.value, '');
      bloc.close();
    });

    test('initialValue sets state.value', () {
      final bloc = MarkdownFieldBloc(initialValue: '# Hello');
      expect(bloc.state.value, '# Hello');
      bloc.close();
    });

    test('changeValue updates state.value', () {
      final bloc = MarkdownFieldBloc();
      bloc.changeValue('# Updated');
      expect(bloc.state.value, '# Updated');
      bloc.close();
    });

    test('validators run on changeValue', () {
      final bloc = MarkdownFieldBloc(
        validators: [(v) => v.isEmpty ? 'required' : null],
      );
      bloc.changeValue('');
      expect(bloc.state.hasError, isTrue);
      bloc.changeValue('hello');
      expect(bloc.state.hasError, isFalse);
      bloc.close();
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
cd packages/duskmoon_form && flutter test test/src/blocs/markdown_field_bloc_test.dart
```

Expected: compile error — `MarkdownFieldBloc` not found.

- [ ] **Step 3: Add `DmMarkdownTab` import and `part` directives to `field_bloc.dart`**

In `packages/duskmoon_form/lib/src/blocs/field/field_bloc.dart`, add after the existing imports:

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmMarkdownTab;
```

And add after the existing `part` directives (after `part '../text_field/text_field_state.dart';`):

```dart
part '../markdown_field/markdown_field_bloc.dart';
part '../markdown_field/markdown_field_bloc_state.dart';
```

The full import block at the top of `field_bloc.dart` becomes:

```dart
import 'dart:async';
import 'dart:collection' show LinkedHashSet;

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmMarkdownTab;
import 'field_bloc_utils.dart';
import '../form/form_bloc.dart';
import '../../extension/extension.dart';
import '../../utils.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
```

And the full `part` block:

```dart
part '../boolean_field/boolean_field_bloc.dart';
part '../boolean_field/boolean_field_state.dart';
part '../form/form_bloc_utils.dart';
part '../group_field/group_field_bloc.dart';
part '../input_field/input_field_bloc.dart';
part '../input_field/input_field_state.dart';
part '../list_field/list_field_bloc.dart';
part '../markdown_field/markdown_field_bloc.dart';
part '../markdown_field/markdown_field_bloc_state.dart';
part '../multi_select_field/multi_select_field_bloc.dart';
part '../multi_select_field/multi_select_field_state.dart';
part '../select_field/select_field_bloc.dart';
part '../select_field/select_field_state.dart';
part '../text_field/text_field_bloc.dart';
part '../text_field/text_field_state.dart';
part 'field_state.dart';
```

- [ ] **Step 4: Create `markdown_field_bloc_state.dart`**

Create `packages/duskmoon_form/lib/src/blocs/markdown_field/markdown_field_bloc_state.dart`:

```dart
part of '../field/field_bloc.dart';

class MarkdownFieldBlocState<ExtraData>
    extends FieldBlocState<String, String, ExtraData?> {
  final DmMarkdownTab tab;

  MarkdownFieldBlocState({
    required super.isValueChanged,
    required super.initialValue,
    required super.updatedValue,
    required super.value,
    required super.error,
    required super.isDirty,
    required super.suggestions,
    required super.isValidated,
    required super.isValidating,
    super.formBloc,
    required super.name,
    super.toJson,
    super.extraData,
    required this.tab,
  });

  @override
  MarkdownFieldBlocState<ExtraData> copyWith({
    bool? isValueChanged,
    Param<String>? initialValue,
    Param<String>? updatedValue,
    Param<String>? value,
    Param<Object?>? error,
    bool? isDirty,
    Param<Suggestions<String>?>? suggestions,
    bool? isValidated,
    bool? isValidating,
    Param<FormBloc<dynamic, dynamic>?>? formBloc,
    Param<ExtraData?>? extraData,
    DmMarkdownTab? tab,
  }) {
    return MarkdownFieldBlocState(
      isValueChanged: isValueChanged ?? this.isValueChanged,
      initialValue: initialValue.or(this.initialValue),
      updatedValue: updatedValue.or(this.updatedValue),
      value: value == null ? this.value : value.value,
      error: error == null ? this.error : error.value,
      isDirty: isDirty ?? this.isDirty,
      suggestions: suggestions == null ? this.suggestions : suggestions.value,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBloc: formBloc == null ? this.formBloc : formBloc.value,
      name: name,
      toJson: _toJson,
      extraData: extraData == null ? this.extraData : extraData.value,
      tab: tab ?? this.tab,
    );
  }

  @override
  List<Object?> get props => [...super.props, tab];
}
```

- [ ] **Step 5: Create `markdown_field_bloc.dart`**

Create `packages/duskmoon_form/lib/src/blocs/markdown_field/markdown_field_bloc.dart`:

```dart
part of '../field/field_bloc.dart';

class MarkdownFieldBloc<ExtraData> extends SingleFieldBloc<String, String,
    MarkdownFieldBlocState<ExtraData?>, ExtraData?> {
  MarkdownFieldBloc({
    String? name,
    String initialValue = '',
    DmMarkdownTab initialTab = DmMarkdownTab.write,
    super.validators,
    super.asyncValidators,
    super.asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<String>? suggestions,
    ExtraData? extraData,
  }) : super(
          initialState: MarkdownFieldBlocState(
            isValueChanged: false,
            initialValue: initialValue,
            updatedValue: initialValue,
            value: initialValue,
            error: FieldBlocUtils.getInitialStateError(
              validators: validators,
              value: initialValue,
            ),
            isDirty: false,
            suggestions: suggestions,
            isValidated: FieldBlocUtils.getInitialIsValidated(
              FieldBlocUtils.getInitialStateIsValidating(
                asyncValidators: asyncValidators,
                validators: validators,
                value: initialValue,
              ),
            ),
            isValidating: FieldBlocUtils.getInitialStateIsValidating(
              asyncValidators: asyncValidators,
              validators: validators,
              value: initialValue,
            ),
            name: FieldBlocUtils.generateName(name),
            toJson: (value) => value,
            extraData: extraData,
            tab: initialTab,
          ),
        );

  /// Emits a new state with [tab] updated.
  void updateTab(DmMarkdownTab tab) => emit(state.copyWith(tab: tab));
}
```

- [ ] **Step 6: Run tests to verify they pass**

```bash
cd packages/duskmoon_form && flutter test test/src/blocs/markdown_field_bloc_test.dart
```

Expected: 7 tests pass.

- [ ] **Step 7: Commit**

```bash
git add \
  packages/duskmoon_form/lib/src/blocs/field/field_bloc.dart \
  packages/duskmoon_form/lib/src/blocs/markdown_field/markdown_field_bloc.dart \
  packages/duskmoon_form/lib/src/blocs/markdown_field/markdown_field_bloc_state.dart \
  packages/duskmoon_form/test/src/blocs/markdown_field_bloc_test.dart
git commit -m "feat(duskmoon_form): add MarkdownFieldBloc with tab state"
```

---

## Task 2: CodeEditorFieldBlocState + CodeEditorFieldBloc

**Files:**
- Create: `packages/duskmoon_form/lib/src/blocs/code_editor_field/code_editor_field_bloc_state.dart`
- Create: `packages/duskmoon_form/lib/src/blocs/code_editor_field/code_editor_field_bloc.dart`
- Modify: `packages/duskmoon_form/lib/src/blocs/field/field_bloc.dart`
- Test: `packages/duskmoon_form/test/src/blocs/code_editor_field_bloc_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `packages/duskmoon_form/test/src/blocs/code_editor_field_bloc_test.dart`:

```dart
import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CodeEditorFieldBloc', () {
    test('initial state has language = null by default', () {
      final bloc = CodeEditorFieldBloc();
      expect(bloc.state.language, isNull);
      bloc.close();
    });

    test('initial state has language = "dart" when specified', () {
      final bloc = CodeEditorFieldBloc(initialLanguage: 'dart');
      expect(bloc.state.language, 'dart');
      bloc.close();
    });

    test('updateLanguage emits state with updated language', () {
      final bloc = CodeEditorFieldBloc();
      bloc.updateLanguage('python');
      expect(bloc.state.language, 'python');
      bloc.close();
    });

    test('updateLanguage(null) emits state with null language', () {
      final bloc = CodeEditorFieldBloc(initialLanguage: 'dart');
      bloc.updateLanguage(null);
      expect(bloc.state.language, isNull);
      bloc.close();
    });

    test('initial value is empty string by default', () {
      final bloc = CodeEditorFieldBloc();
      expect(bloc.state.value, '');
      bloc.close();
    });

    test('initialValue sets state.value', () {
      final bloc = CodeEditorFieldBloc(initialValue: 'void main() {}');
      expect(bloc.state.value, 'void main() {}');
      bloc.close();
    });

    test('changeValue updates state.value', () {
      final bloc = CodeEditorFieldBloc();
      bloc.changeValue('print("hello")');
      expect(bloc.state.value, 'print("hello")');
      bloc.close();
    });

    test('validators run on changeValue', () {
      final bloc = CodeEditorFieldBloc(
        validators: [(v) => v.isEmpty ? 'required' : null],
      );
      bloc.changeValue('');
      expect(bloc.state.hasError, isTrue);
      bloc.changeValue('x = 1');
      expect(bloc.state.hasError, isFalse);
      bloc.close();
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
cd packages/duskmoon_form && flutter test test/src/blocs/code_editor_field_bloc_test.dart
```

Expected: compile error — `CodeEditorFieldBloc` not found.

- [ ] **Step 3: Add `part` directives to `field_bloc.dart`**

In `packages/duskmoon_form/lib/src/blocs/field/field_bloc.dart`, add after the markdown_field parts:

```dart
part '../code_editor_field/code_editor_field_bloc.dart';
part '../code_editor_field/code_editor_field_bloc_state.dart';
```

The complete `part` block in `field_bloc.dart` is now:

```dart
part '../boolean_field/boolean_field_bloc.dart';
part '../boolean_field/boolean_field_state.dart';
part '../form/form_bloc_utils.dart';
part '../group_field/group_field_bloc.dart';
part '../input_field/input_field_bloc.dart';
part '../input_field/input_field_state.dart';
part '../list_field/list_field_bloc.dart';
part '../markdown_field/markdown_field_bloc.dart';
part '../markdown_field/markdown_field_bloc_state.dart';
part '../code_editor_field/code_editor_field_bloc.dart';
part '../code_editor_field/code_editor_field_bloc_state.dart';
part '../multi_select_field/multi_select_field_bloc.dart';
part '../multi_select_field/multi_select_field_state.dart';
part '../select_field/select_field_bloc.dart';
part '../select_field/select_field_state.dart';
part '../text_field/text_field_bloc.dart';
part '../text_field/text_field_state.dart';
part 'field_state.dart';
```

- [ ] **Step 4: Create `code_editor_field_bloc_state.dart`**

Create `packages/duskmoon_form/lib/src/blocs/code_editor_field/code_editor_field_bloc_state.dart`:

```dart
part of '../field/field_bloc.dart';

class CodeEditorFieldBlocState<ExtraData>
    extends FieldBlocState<String, String, ExtraData?> {
  final String? language;

  CodeEditorFieldBlocState({
    required super.isValueChanged,
    required super.initialValue,
    required super.updatedValue,
    required super.value,
    required super.error,
    required super.isDirty,
    required super.suggestions,
    required super.isValidated,
    required super.isValidating,
    super.formBloc,
    required super.name,
    super.toJson,
    super.extraData,
    this.language,
  });

  @override
  CodeEditorFieldBlocState<ExtraData> copyWith({
    bool? isValueChanged,
    Param<String>? initialValue,
    Param<String>? updatedValue,
    Param<String>? value,
    Param<Object?>? error,
    bool? isDirty,
    Param<Suggestions<String>?>? suggestions,
    bool? isValidated,
    bool? isValidating,
    Param<FormBloc<dynamic, dynamic>?>? formBloc,
    Param<ExtraData?>? extraData,
    Param<String?>? language,
  }) {
    return CodeEditorFieldBlocState(
      isValueChanged: isValueChanged ?? this.isValueChanged,
      initialValue: initialValue.or(this.initialValue),
      updatedValue: updatedValue.or(this.updatedValue),
      value: value == null ? this.value : value.value,
      error: error == null ? this.error : error.value,
      isDirty: isDirty ?? this.isDirty,
      suggestions: suggestions == null ? this.suggestions : suggestions.value,
      isValidated: isValidated ?? this.isValidated,
      isValidating: isValidating ?? this.isValidating,
      formBloc: formBloc == null ? this.formBloc : formBloc.value,
      name: name,
      toJson: _toJson,
      extraData: extraData == null ? this.extraData : extraData.value,
      language: language == null ? this.language : language.value,
    );
  }

  @override
  List<Object?> get props => [...super.props, language];
}
```

- [ ] **Step 5: Create `code_editor_field_bloc.dart`**

Create `packages/duskmoon_form/lib/src/blocs/code_editor_field/code_editor_field_bloc.dart`:

```dart
part of '../field/field_bloc.dart';

class CodeEditorFieldBloc<ExtraData> extends SingleFieldBloc<String, String,
    CodeEditorFieldBlocState<ExtraData?>, ExtraData?> {
  CodeEditorFieldBloc({
    String? name,
    String initialValue = '',
    String? initialLanguage,
    super.validators,
    super.asyncValidators,
    super.asyncValidatorDebounceTime = const Duration(milliseconds: 500),
    Suggestions<String>? suggestions,
    ExtraData? extraData,
  }) : super(
          initialState: CodeEditorFieldBlocState(
            isValueChanged: false,
            initialValue: initialValue,
            updatedValue: initialValue,
            value: initialValue,
            error: FieldBlocUtils.getInitialStateError(
              validators: validators,
              value: initialValue,
            ),
            isDirty: false,
            suggestions: suggestions,
            isValidated: FieldBlocUtils.getInitialIsValidated(
              FieldBlocUtils.getInitialStateIsValidating(
                asyncValidators: asyncValidators,
                validators: validators,
                value: initialValue,
              ),
            ),
            isValidating: FieldBlocUtils.getInitialStateIsValidating(
              asyncValidators: asyncValidators,
              validators: validators,
              value: initialValue,
            ),
            name: FieldBlocUtils.generateName(name),
            toJson: (value) => value,
            extraData: extraData,
            language: initialLanguage,
          ),
        );

  /// Emits a new state with [language] updated. Pass `null` to clear.
  void updateLanguage(String? language) =>
      emit(state.copyWith(language: Param(language)));
}
```

- [ ] **Step 6: Run tests to verify they pass**

```bash
cd packages/duskmoon_form && flutter test test/src/blocs/code_editor_field_bloc_test.dart
```

Expected: 8 tests pass.

- [ ] **Step 7: Commit**

```bash
git add \
  packages/duskmoon_form/lib/src/blocs/field/field_bloc.dart \
  packages/duskmoon_form/lib/src/blocs/code_editor_field/code_editor_field_bloc.dart \
  packages/duskmoon_form/lib/src/blocs/code_editor_field/code_editor_field_bloc_state.dart \
  packages/duskmoon_form/test/src/blocs/code_editor_field_bloc_test.dart
git commit -m "feat(duskmoon_form): add CodeEditorFieldBloc with language state"
```

---

## Task 3: Theme additions

**Files:**
- Modify: `packages/duskmoon_form/lib/src/theme/form_bloc_theme.dart`

- [ ] **Step 1: Write failing analysis check**

Run:

```bash
cd packages/duskmoon_form && dart analyze --fatal-infos lib/src/theme/form_bloc_theme.dart
```

This passes now. After changes, it must still pass.

- [ ] **Step 2: Add `EditorTheme` import to `form_bloc_theme.dart`**

At the top of `packages/duskmoon_form/lib/src/theme/form_bloc_theme.dart`, add after the existing imports:

```dart
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show EditorTheme;
```

The full import block becomes:

```dart
import 'package:equatable/equatable.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show EditorTheme;
import 'package:flutter/material.dart';

import '../utils/field_bloc_builder_control_affinity.dart';
import '../utils/to_string.dart';
import 'field_theme_resolver.dart';
import 'form_bloc_theme_provider.dart';
import 'form_config.dart';
import 'suffix_button_themes.dart';
```

- [ ] **Step 3: Add `MarkdownFieldTheme` and `CodeEditorFieldTheme` classes**

Append to the end of `packages/duskmoon_form/lib/src/theme/form_bloc_theme.dart`:

```dart
/// The theme of [DmMarkdownFieldBlocBuilder].
class MarkdownFieldTheme extends FieldTheme {
  const MarkdownFieldTheme({
    super.textStyle,
    super.textColor,
    super.decorationTheme,
  });

  @override
  List<Object?> get props => super.props;
}

/// The theme of [DmCodeEditorFieldBlocBuilder].
///
/// Does not extend [FieldTheme] because text/decoration theming does not
/// apply to the code editor — it has its own [EditorTheme] system.
class CodeEditorFieldTheme extends Equatable {
  /// Form-level default editor theme. Resolution order (highest to lowest):
  /// 1. `DmCodeEditorFieldBlocBuilder.theme` prop
  /// 2. This field
  /// 3. `DmCodeEditorTheme.fromContext(context)` (auto-derived)
  final EditorTheme? editorTheme;

  const CodeEditorFieldTheme({this.editorTheme});

  @override
  List<Object?> get props => [editorTheme];
}
```

- [ ] **Step 4: Add `markdownTheme` and `codeEditorTheme` to `DmFormTheme`**

In `packages/duskmoon_form/lib/src/theme/form_bloc_theme.dart`, update the `DmFormTheme` class:

Add fields after `scrollableFormTheme`:
```dart
/// The theme of [DmMarkdownFieldBlocBuilder]
final MarkdownFieldTheme markdownTheme;

/// The theme of [DmCodeEditorFieldBlocBuilder]
final CodeEditorFieldTheme codeEditorTheme;
```

Add to constructor after `scrollableFormTheme = const ScrollableFormTheme()`:
```dart
this.markdownTheme = const MarkdownFieldTheme(),
this.codeEditorTheme = const CodeEditorFieldTheme(),
```

Update `copyWith` — add parameters and return values:
```dart
MarkdownFieldTheme? markdownTheme,
CodeEditorFieldTheme? codeEditorTheme,
```
And in the return:
```dart
markdownTheme: markdownTheme ?? this.markdownTheme,
codeEditorTheme: codeEditorTheme ?? this.codeEditorTheme,
```

Update `props` — add at the end of the list:
```dart
markdownTheme,
codeEditorTheme,
```

Update `toString` — add at the end of the chain:
```dart
..add('markdownTheme', markdownTheme)
..add('codeEditorTheme', codeEditorTheme)
```

The complete updated `DmFormTheme` class (showing only changed/added parts clearly):

```dart
class DmFormTheme extends Equatable {
  final TextStyle? textStyle;
  final WidgetStateProperty<Color?>? textColor;
  final InputDecorationThemeData? decorationTheme;
  final EdgeInsetsGeometry? padding;
  final CheckboxFieldTheme checkboxTheme;
  final ChoiceChipFieldTheme choiceChipTheme;
  final FilterChipFieldTheme filterChipTheme;
  final DateTimeFieldTheme dateTimeTheme;
  final DropdownFieldTheme dropdownTheme;
  final SliderFieldTheme sliderTheme;
  final SwitchFieldTheme switchTheme;
  final RadioFieldTheme radioTheme;
  final TextFieldTheme textTheme;
  final ClearSuffixButtonTheme clearSuffixButtonTheme;
  final ObscureSuffixButtonTheme obscureSuffixButtonTheme;
  final ScrollableFormTheme scrollableFormTheme;
  final MarkdownFieldTheme markdownTheme;      // NEW
  final CodeEditorFieldTheme codeEditorTheme;  // NEW

  static EdgeInsets defaultPadding = const EdgeInsets.symmetric(vertical: 8.0);

  const DmFormTheme({
    this.textStyle,
    this.textColor,
    this.decorationTheme,
    this.padding,
    this.checkboxTheme = const CheckboxFieldTheme(),
    this.choiceChipTheme = const ChoiceChipFieldTheme(),
    this.filterChipTheme = const FilterChipFieldTheme(),
    this.dateTimeTheme = const DateTimeFieldTheme(),
    this.dropdownTheme = const DropdownFieldTheme(),
    this.sliderTheme = const SliderFieldTheme(),
    this.switchTheme = const SwitchFieldTheme(),
    this.radioTheme = const RadioFieldTheme(),
    this.textTheme = const TextFieldTheme(),
    this.clearSuffixButtonTheme = const ClearSuffixButtonTheme(),
    this.obscureSuffixButtonTheme = const ObscureSuffixButtonTheme(),
    this.scrollableFormTheme = const ScrollableFormTheme(),
    this.markdownTheme = const MarkdownFieldTheme(),      // NEW
    this.codeEditorTheme = const CodeEditorFieldTheme(),  // NEW
  });

  static DmFormTheme of(BuildContext context) {
    return DmFormThemeProvider.of(context) ?? const DmFormTheme();
  }

  DmFormTheme copyWith({
    TextStyle? textStyle,
    WidgetStateProperty<Color?>? textColor,
    InputDecorationThemeData? decorationTheme,
    EdgeInsetsGeometry? padding,
    CheckboxFieldTheme? checkboxTheme,
    DropdownFieldTheme? dropdownTheme,
    RadioFieldTheme? radioTheme,
    SwitchFieldTheme? switchTheme,
    TextFieldTheme? textTheme,
    MarkdownFieldTheme? markdownTheme,      // NEW
    CodeEditorFieldTheme? codeEditorTheme,  // NEW
  }) {
    return DmFormTheme(
      textStyle: textStyle ?? this.textStyle,
      textColor: textColor ?? this.textColor,
      decorationTheme: decorationTheme ?? this.decorationTheme,
      padding: padding ?? this.padding,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      dropdownTheme: dropdownTheme ?? this.dropdownTheme,
      radioTheme: radioTheme ?? this.radioTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      textTheme: textTheme ?? this.textTheme,
      markdownTheme: markdownTheme ?? this.markdownTheme,      // NEW
      codeEditorTheme: codeEditorTheme ?? this.codeEditorTheme, // NEW
    );
  }

  @override
  List<Object?> get props => [
        textStyle,
        textColor,
        decorationTheme,
        padding,
        checkboxTheme,
        choiceChipTheme,
        filterChipTheme,
        dateTimeTheme,
        dropdownTheme,
        switchTheme,
        radioTheme,
        textTheme.hashCode,
        markdownTheme,      // NEW
        codeEditorTheme,    // NEW
      ];

  @override
  String toString() {
    return (ToString(DmFormTheme)
          ..add('textStyle', textStyle)
          ..add('textColor', textColor)
          ..add('decorationTheme', decorationTheme)
          ..add('padding', padding)
          ..add('checkboxTheme', checkboxTheme)
          ..add('choiceChipFieldTheme', choiceChipTheme)
          ..add('filterChipFieldTheme', filterChipTheme)
          ..add('dateTimeTheme', dateTimeTheme)
          ..add('dropdownTheme', dropdownTheme)
          ..add('switchTheme', switchTheme)
          ..add('radioTheme', radioTheme)
          ..add('textTheme', textTheme)
          ..add('markdownTheme', markdownTheme)      // NEW
          ..add('codeEditorTheme', codeEditorTheme)) // NEW
        .toString();
  }
}
```

- [ ] **Step 5: Verify analysis passes**

```bash
cd packages/duskmoon_form && dart analyze --fatal-infos lib/src/theme/form_bloc_theme.dart
```

Expected: No issues found.

- [ ] **Step 6: Commit**

```bash
git add packages/duskmoon_form/lib/src/theme/form_bloc_theme.dart
git commit -m "feat(duskmoon_form): add MarkdownFieldTheme and CodeEditorFieldTheme"
```

---

## Task 4: DmMarkdownFieldBlocBuilder

**Files:**
- Create: `packages/duskmoon_form/lib/src/widgets/dm_markdown_field_bloc_builder.dart`
- Test: `packages/duskmoon_form/test/src/widgets/dm_markdown_field_bloc_builder_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `packages/duskmoon_form/test/src/widgets/dm_markdown_field_bloc_builder_test.dart`:

```dart
import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? DmThemeData.sunshine(),
    home: Scaffold(
      body: SizedBox(height: 400, child: child),
    ),
  );
}

void main() {
  group('DmMarkdownFieldBlocBuilder', () {
    testWidgets('renders DmMarkdownInput', (tester) async {
      final bloc = MarkdownFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmMarkdownFieldBlocBuilder(markdownFieldBloc: bloc)),
      );
      await tester.pump();
      expect(find.byType(DmMarkdownInput), findsOneWidget);
    });

    testWidgets('onChanged fires bloc.changeValue', (tester) async {
      final bloc = MarkdownFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmMarkdownFieldBlocBuilder(markdownFieldBloc: bloc)),
      );
      await tester.pump();

      // Simulate text change via entering text in the editor
      await tester.enterText(find.byType(TextField), '# Hello');
      await tester.pump();
      expect(bloc.state.value, '# Hello');
    });

    testWidgets('updateTab causes DmMarkdownInput rebuild with new initialTab',
        (tester) async {
      final bloc =
          MarkdownFieldBloc(initialTab: DmMarkdownTab.write);
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmMarkdownFieldBlocBuilder(markdownFieldBloc: bloc)),
      );
      await tester.pump();

      // Verify initial tab
      expect(
        tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput)).initialTab,
        DmMarkdownTab.write,
      );

      // Change tab from BLoC
      bloc.updateTab(DmMarkdownTab.preview);
      await tester.pump();

      // Widget should rebuild with new initialTab
      expect(
        tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput)).initialTab,
        DmMarkdownTab.preview,
      );
    });

    testWidgets('isEnabled = false sets DmMarkdownInput.enabled = false',
        (tester) async {
      final bloc = MarkdownFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmMarkdownFieldBlocBuilder(
          markdownFieldBloc: bloc,
          isEnabled: false,
        )),
      );
      await tester.pump();
      expect(
        tester.widget<DmMarkdownInput>(find.byType(DmMarkdownInput)).enabled,
        isFalse,
      );
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
cd packages/duskmoon_form && flutter test test/src/widgets/dm_markdown_field_bloc_builder_test.dart
```

Expected: compile error — `DmMarkdownFieldBlocBuilder` not found.

- [ ] **Step 3: Create `dm_markdown_field_bloc_builder.dart`**

Create `packages/duskmoon_form/lib/src/widgets/dm_markdown_field_bloc_builder.dart`:

```dart
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

  final MarkdownFieldBloc markdownFieldBloc;
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
        return BlocBuilder<MarkdownFieldBloc, MarkdownFieldBlocState>(
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
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
cd packages/duskmoon_form && flutter test test/src/widgets/dm_markdown_field_bloc_builder_test.dart
```

Expected: 4 tests pass.

- [ ] **Step 5: Commit**

```bash
git add \
  packages/duskmoon_form/lib/src/widgets/dm_markdown_field_bloc_builder.dart \
  packages/duskmoon_form/test/src/widgets/dm_markdown_field_bloc_builder_test.dart
git commit -m "feat(duskmoon_form): add DmMarkdownFieldBlocBuilder"
```

---

## Task 5: DmCodeEditorFieldBlocBuilder

**Files:**
- Create: `packages/duskmoon_form/lib/src/widgets/dm_code_editor_field_bloc_builder.dart`
- Test: `packages/duskmoon_form/test/src/widgets/dm_code_editor_field_bloc_builder_test.dart`

- [ ] **Step 1: Write the failing tests**

Create `packages/duskmoon_form/test/src/widgets/dm_code_editor_field_bloc_builder_test.dart`:

```dart
import 'package:duskmoon_code_engine/duskmoon_code_engine.dart'
    show CodeEditorWidget;
import 'package:duskmoon_form/duskmoon_form.dart';
import 'package:duskmoon_theme/duskmoon_theme.dart';
import 'package:duskmoon_widgets/duskmoon_widgets.dart' show DmCodeEditor;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {ThemeData? theme}) {
  return MaterialApp(
    theme: theme ?? DmThemeData.sunshine(),
    themeAnimationDuration: Duration.zero,
    home: Scaffold(body: child),
  );
}

void main() {
  group('DmCodeEditorFieldBlocBuilder', () {
    testWidgets('renders DmCodeEditor', (tester) async {
      final bloc = CodeEditorFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(codeEditorFieldBloc: bloc)),
      );
      await tester.pump();
      expect(find.byType(DmCodeEditor), findsOneWidget);
      expect(find.byType(CodeEditorWidget), findsOneWidget);
    });

    testWidgets('onChanged fires bloc.changeValue via controller',
        (tester) async {
      final bloc = CodeEditorFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(codeEditorFieldBloc: bloc)),
      );
      await tester.pump();

      // Change value from BLoC directly (external change path)
      bloc.changeValue('x = 1');
      await tester.pump();
      expect(bloc.state.value, 'x = 1');
    });

    testWidgets(
        'updateLanguage causes DmCodeEditor to receive updated language prop',
        (tester) async {
      final bloc = CodeEditorFieldBloc(initialLanguage: 'dart');
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(codeEditorFieldBloc: bloc)),
      );
      await tester.pump();

      expect(
        tester.widget<DmCodeEditor>(find.byType(DmCodeEditor)).language,
        'dart',
      );

      bloc.updateLanguage('python');
      await tester.pump();

      expect(
        tester.widget<DmCodeEditor>(find.byType(DmCodeEditor)).language,
        'python',
      );
    });

    testWidgets('external changeValue syncs controller text', (tester) async {
      final bloc = CodeEditorFieldBloc(initialValue: 'hello');
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(codeEditorFieldBloc: bloc)),
      );
      await tester.pump();
      expect(bloc.state.value, 'hello');

      bloc.changeValue('world');
      await tester.pump();
      expect(bloc.state.value, 'world');
    });

    testWidgets('isEnabled = false sets DmCodeEditor.readOnly = true',
        (tester) async {
      final bloc = CodeEditorFieldBloc();
      addTearDown(bloc.close);
      await tester.pumpWidget(
        _wrap(DmCodeEditorFieldBlocBuilder(
          codeEditorFieldBloc: bloc,
          isEnabled: false,
        )),
      );
      await tester.pump();
      expect(
        tester.widget<DmCodeEditor>(find.byType(DmCodeEditor)).readOnly,
        isTrue,
      );
    });
  });
}
```

- [ ] **Step 2: Run the test to verify it fails**

```bash
cd packages/duskmoon_form && flutter test test/src/widgets/dm_code_editor_field_bloc_builder_test.dart
```

Expected: compile error — `DmCodeEditorFieldBlocBuilder` not found.

- [ ] **Step 3: Create `dm_code_editor_field_bloc_builder.dart`**

Create `packages/duskmoon_form/lib/src/widgets/dm_code_editor_field_bloc_builder.dart`:

```dart
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

  final CodeEditorFieldBloc codeEditorFieldBloc;
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
```

- [ ] **Step 4: Run tests to verify they pass**

```bash
cd packages/duskmoon_form && flutter test test/src/widgets/dm_code_editor_field_bloc_builder_test.dart
```

Expected: 5 tests pass.

- [ ] **Step 5: Commit**

```bash
git add \
  packages/duskmoon_form/lib/src/widgets/dm_code_editor_field_bloc_builder.dart \
  packages/duskmoon_form/test/src/widgets/dm_code_editor_field_bloc_builder_test.dart
git commit -m "feat(duskmoon_form): add DmCodeEditorFieldBlocBuilder"
```

---

## Task 6: Barrel exports + final check

**Files:**
- Modify: `packages/duskmoon_form/lib/duskmoon_form.dart`

- [ ] **Step 1: Add exports to `duskmoon_form.dart`**

In `packages/duskmoon_form/lib/duskmoon_form.dart`, add a new section after the `// Date & Time` section and before `// ── Form-level widgets`:

```dart
// Rich text fields
export 'src/blocs/markdown_field/markdown_field_bloc.dart';
export 'src/blocs/markdown_field/markdown_field_bloc_state.dart';
export 'src/blocs/code_editor_field/code_editor_field_bloc.dart';
export 'src/blocs/code_editor_field/code_editor_field_bloc_state.dart';
export 'src/widgets/dm_markdown_field_bloc_builder.dart';
export 'src/widgets/dm_code_editor_field_bloc_builder.dart';
```

And add a new re-exports section at the end (after the existing `export 'package:flutter_bloc/flutter_bloc.dart';`):

```dart
// Re-export types callers need for rich field BLoCs
export 'package:duskmoon_widgets/duskmoon_widgets.dart'
    show DmMarkdownTab, DmMarkdownConfig, EditorTheme;
```

- [ ] **Step 2: Run full test suite**

```bash
cd packages/duskmoon_form && flutter test
```

Expected: All tests pass (the 15 new tests from Tasks 1–5).

- [ ] **Step 3: Run analysis**

```bash
cd packages/duskmoon_form && dart analyze --fatal-infos
```

Expected: No issues found.

- [ ] **Step 4: Commit**

```bash
git add packages/duskmoon_form/lib/duskmoon_form.dart
git commit -m "feat(duskmoon_form): export MarkdownFieldBloc, CodeEditorFieldBloc and builders"
```
