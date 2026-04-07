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
