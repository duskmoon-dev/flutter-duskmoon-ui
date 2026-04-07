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
