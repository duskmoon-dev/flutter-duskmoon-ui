import 'package:duskmoon_highlight/tree_sitter.dart';
import 'package:flutter/foundation.dart';

import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/state_effect.dart';
import 'language.dart';

final syntaxLanguage = Facet<Language, Language?>(
  combine: (values) => values.isEmpty ? null : values.last,
);
// Effect markers must retain unique identity even when callers use these types.
// ignore: prefer_const_constructors
final setSyntaxLanguage = StateEffectType<Language?>();
// ignore: prefer_const_constructors
final refreshSyntax = StateEffectType<void>();

// All editor states use this field identity. No global accessor is replaced
// when another editor or language is created.
final syntaxStateField = StateField<SyntaxState>(
  create: (state) {
    final editor = state as EditorState;
    return SyntaxState.create(
        editor.facet(syntaxLanguage), editor.doc.toString());
  },
  update: (transaction, value) {
    final tr = transaction as Transaction;
    var next = value;
    var refresh = false;
    for (final effect in tr.effects) {
      if (effect.type == setSyntaxLanguage) {
        next._session?.dispose();
        next = SyntaxState.create(
          effect.value as Language? ?? tr.startState.facet(syntaxLanguage),
          tr.startState.doc.toString(),
        );
      }
      if (effect.type == refreshSyntax) refresh = true;
    }
    if (!tr.docChanged && !refresh) return next;
    final source = tr.docChanged
        ? tr.startState.doc.replace(tr.changes!).toString()
        : tr.startState.doc.toString();
    return next.parse(source);
  },
);

class SyntaxState {
  const SyntaxState._(this.language, this._session, this.snapshot);
  final Language? language;
  final _Session? _session;
  final SyntaxSnapshot? snapshot;

  factory SyntaxState.create(Language? language, String source) {
    if (language == null) return const SyntaxState._(null, null, null);
    return SyntaxState._(language, _Session(language.name), null).parse(source);
  }

  SyntaxState parse(String source) {
    final holder = _session;
    if (holder == null) return this;
    if (kIsWeb && !TreeSitterRuntime.isInitialized(holder.language)) {
      return this;
    }
    return SyntaxState._(language, holder, holder.parse(source));
  }
}

class _Session {
  _Session(this.language);
  final String language;
  TreeSitterSession? _parser;
  SyntaxSnapshot parse(String source) =>
      (_parser ??= TreeSitterSession(language: language)).parse(source);
  void dispose() {
    _parser?.dispose();
    _parser = null;
  }
}

SyntaxState? syntaxState(EditorState state) {
  try {
    return state.field(syntaxStateField);
  } on StateError {
    return null;
  }
}

/// Immutable syntax snapshot belonging to this exact document state.
SyntaxSnapshot? syntaxTree(EditorState state) => syntaxState(state)?.snapshot;
bool syntaxTreeAvailable(EditorState state) => syntaxTree(state) != null;

/// Initialize web syntax and return a new state without changing text/history.
/// Raw-state consumers must retain the returned state. Native parsing is sync.
Future<EditorState> ensureSyntaxTree(EditorState state) async {
  final language = syntaxState(state)?.language;
  if (language == null) return state;
  await TreeSitterRuntime.ensureInitialized(languages: {language.name});
  return state.update(TransactionSpec(effects: [refreshSyntax.of(null)])).state;
}

/// Release native parser/tree resources when a raw editor state is no longer used.
void disposeSyntax(EditorState state) =>
    syntaxState(state)?._session?.dispose();
