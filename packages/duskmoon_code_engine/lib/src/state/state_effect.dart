/// Typed marker for describing side effects in transactions.
class StateEffectType<T> {
  const StateEffectType();

  /// Create an effect instance with a value.
  StateEffect<T> of(T value) => StateEffect<T>(this, value);
}

/// An effect instance carrying a typed value.
class StateEffect<T> {
  const StateEffect(this.type, this.value);
  final StateEffectType<T> type;
  final T value;

  /// Check if this effect matches a given type.
  bool is_(StateEffectType<T> type) => this.type == type;
}
