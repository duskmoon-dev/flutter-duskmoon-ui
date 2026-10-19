import 'package:flutter/foundation.dart';

import '../commands/commands.dart';
import '../document/change.dart';
import '../document/document.dart';
import '../language/language.dart';
import '../language/syntax.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import '../state/selection.dart';
import '../theme/editor_theme.dart';
import 'editor_view.dart';

/// Consumer-facing controller that wraps [EditorView] with convenience methods.
class EditorViewController {
  EditorViewController({
    String? text,
    LanguageSupport? language,
    EditorTheme? theme,
    List<Extension> extensions = const [],
  }) {
    final allExtensions = <Extension>[
      ...extensions,
      if (language != null) language.extension else syntaxStateField,
    ];
    _view = EditorView(
      state: EditorState.create(
        docString: text ?? '',
        extensions: allExtensions,
      ),
    );
    _extensions = extensions;
    _theme = theme;
    _initializeLanguage();
  }

  late EditorView _view;
  EditorTheme? _theme;
  late final List<Extension> _extensions;
  bool _disposed = false;
  int _languageGeneration = 0;
  Future<void> _ready = Future.value();

  /// Completes when the current language is available (automatic on web).
  Future<void> get ready => _ready;

  void _initializeLanguage() {
    final generation = ++_languageGeneration;
    final language = syntaxState(state)?.language;
    if (!kIsWeb || language == null) {
      _ready = Future.value();
      return;
    }
    _ready = LanguageSupport(language: language).ensureInitialized().then((_) {
      if (_disposed || generation != _languageGeneration) return;
      _view.dispatch(TransactionSpec(effects: [refreshSyntax.of(null)]));
    });
    // The public ready future retains errors for callers that await it, while
    // automatic widget initialization also reports them through Flutter.
    _ready.then<void>((_) {}, onError: (Object error, StackTrace stack) {
      if (!_disposed && generation == _languageGeneration) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'duskmoon_code_engine',
          context: ErrorDescription('initializing a Tree-sitter language'),
        ));
      }
    });
  }

  /// The underlying [EditorView].
  EditorView get view => _view;

  /// The current [EditorState].
  EditorState get state => _view.state;

  /// The current [Document].
  Document get document => _view.document;

  /// The full text of the current document.
  String get text => document.toString();

  /// Replace the entire document with [value] and move the cursor to the end.
  set text(String value) {
    dispatch(
      TransactionSpec(
        changes: ChangeSet.of(
          document.length,
          [ChangeSpec(from: 0, to: document.length, insert: value)],
        ),
        selection: EditorSelection.cursor(value.length),
      ),
    );
  }

  /// The current [EditorTheme], if any.
  EditorTheme? get theme => _theme;

  /// Set a new theme and notify listeners.
  set theme(EditorTheme? t) {
    _theme = t;
    _view.invalidate();
  }

  /// Switch syntax without replacing the view, document, selection or history.
  set language(LanguageSupport? lang) {
    if (_disposed) return;
    _view.dispatch(
      TransactionSpec(effects: [setSyntaxLanguage.of(lang?.language)]),
      extensions: [
        ..._extensions,
        if (lang != null) lang.extension else syntaxStateField,
      ],
    );
    _initializeLanguage();
  }

  /// Dispatch a [TransactionSpec] to the underlying [EditorView].
  void dispatch(TransactionSpec spec) => _view.dispatch(spec);

  /// Move the cursor / selection to [selection].
  void setSelection(EditorSelection selection) {
    dispatch(TransactionSpec(selection: selection));
  }

  /// Insert [t] at the current cursor position, replacing any active selection.
  void insertText(String t) {
    dispatch(EditorCommands.insertText(state, t));
  }

  /// Replace the text in [[from], [to]) with [replacement].
  void replaceRange(int from, int to, String replacement) {
    dispatch(
      TransactionSpec(
        changes: ChangeSet.of(
          document.length,
          [ChangeSpec(from: from, to: to, insert: replacement)],
        ),
      ),
    );
  }

  /// Dispose the underlying [EditorView].
  void dispose() {
    if (_disposed) return;
    _disposed = true;
    _languageGeneration++;
    _view.dispose();
  }
}
