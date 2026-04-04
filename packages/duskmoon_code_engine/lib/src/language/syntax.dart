import '../lezer/common/tree.dart';

Tree? Function(dynamic state)? _syntaxTreeAccessor;
bool Function(dynamic state)? _syntaxTreeAvailableAccessor;

/// Get the current syntax tree from an EditorState.
Tree? syntaxTree(dynamic state) => _syntaxTreeAccessor?.call(state);

/// Check if a complete syntax tree is available.
bool syntaxTreeAvailable(dynamic state) =>
    _syntaxTreeAvailableAccessor?.call(state) ?? false;

/// Register the syntax tree accessor (called by LanguageSupport internally).
// ignore: avoid_setters_without_getters
void registerSyntaxTreeAccessor(Tree? Function(dynamic state) fn) {
  _syntaxTreeAccessor = fn;
}

/// Register the syntax tree available accessor (called by LanguageSupport internally).
// ignore: avoid_setters_without_getters
void registerSyntaxTreeAvailableAccessor(bool Function(dynamic state) fn) {
  _syntaxTreeAvailableAccessor = fn;
}
