import '../commands/commands.dart';
import '../document/change.dart';
import '../document/document.dart';
import '../language/language.dart';
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
      if (language != null) language.extension,
    ];
    _view = EditorView(
      state: EditorState.create(
        docString: text ?? '',
        extensions: allExtensions,
      ),
    );
    _theme = theme;
    _extensions = extensions;
  }

  late EditorView _view;
  EditorTheme? _theme;
  late List<Extension> _extensions;

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

  /// Switch to a different [LanguageSupport], rebuilding state to apply the
  /// new language extension while preserving the current text and selection.
  set language(LanguageSupport? lang) {
    final allExts = <Extension>[
      ..._extensions,
      if (lang != null) lang.extension,
    ];
    _view = EditorView(
      state: EditorState.create(
        docString: text,
        selection: state.selection,
        extensions: allExts,
      ),
    );
    _view.invalidate();
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
  void dispose() => _view.dispose();
}
