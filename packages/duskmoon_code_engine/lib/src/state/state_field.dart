part of 'extension.dart';

/// Persistent state attached to EditorState, updated per transaction.
class StateField<T> extends Extension {
  const StateField({
    required this.create,
    required this.update,
  });

  /// Create the initial value from the starting state.
  final T Function(dynamic state) create;

  /// Update the value for a transaction.
  final T Function(dynamic transaction, T value) update;

  /// Internal: call [update] with a dynamic value, preserving generic types.
  dynamic updateDynamic(dynamic transaction, dynamic value) =>
      update(transaction, value as T);
}
