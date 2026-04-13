/// Pure Dart code editor engine with incremental parsing.
///
/// A ground-up port of the CodeMirror 6 architecture for Flutter,
/// providing document model, state management, syntax highlighting,
/// and an interactive editor widget.
///
/// ## Quick Start
///
/// ```dart
/// import 'package:duskmoon_code_engine/duskmoon_code_engine.dart';
///
/// CodeEditorWidget(
///   initialDoc: 'print("hello")',
///   language: dartLanguageSupport(),
///   theme: EditorTheme.dark(),
///   lineNumbers: true,
/// )
/// ```
///
/// ## Supported Languages
///
/// 19 languages: Dart, JavaScript/TypeScript, Python, HTML, CSS,
/// JSON, Markdown, Rust, Go, YAML, C/C++, Elixir, Java, Kotlin,
/// PHP, Ruby, Erlang, Swift, Zig.
///
/// ## Key Classes
///
/// - [CodeEditorWidget] — the main editor widget
/// - [EditorViewController] — programmatic editor control
/// - [EditorState] — immutable editor state snapshot
/// - [EditorTheme] — editor visual theme configuration
/// - [Language] / [LanguageSupport] — language definitions
/// - [EditorCommands] — standard editing commands
library;

// Document model
export 'src/document/change.dart' show ChangeSpec, ChangeSet;
export 'src/document/document.dart' show Document;
export 'src/document/position.dart' show Pos, Range;
export 'src/document/rope.dart' show RopeNode, RopeLeaf, RopeBranch, Rope;
export 'src/document/text.dart' show Line;

// State system
export 'src/state/selection.dart' show SelectionRange, EditorSelection;
export 'src/state/annotation.dart' show AnnotationType, Annotation, Annotations;
export 'src/state/extension.dart'
    show
        Extension,
        ExtensionGroup,
        PrecedenceExtension,
        Precedence,
        prec,
        Compartment,
        CompartmentExtension,
        StateField,
        Facet,
        FacetExtension,
        FacetStore;
export 'src/state/state_effect.dart' show StateEffectType, StateEffect;
export 'src/state/editor_state.dart'
    show EditorState, TransactionSpec, Transaction;

// Lezer common
export 'src/lezer/common/node_type.dart' show NodeProp, NodeType, NodeSet;
export 'src/lezer/common/tree.dart'
    show Tree, TreeBuffer, SyntaxNode, TreeCursor;
export 'src/lezer/common/parser.dart' show Parser, ChangedRange;
export 'src/lezer/common/token.dart' show Token, ExternalTokenizer;

// Lezer highlight
export 'src/lezer/highlight/tags.dart' show Tag;
export 'src/lezer/highlight/highlight.dart' show TagStyle, HighlightStyle;

// Lezer LR
export 'src/lezer/lr/grammar_data.dart' show GrammarData;
export 'src/lezer/lr/lr_parser.dart' show LRParser;

// Language system
export 'src/language/language.dart' show Language, LanguageSupport;
export 'src/language/language_data.dart' show LanguageData, CommentTokens;
export 'src/language/stream_language.dart' show TokenRule, StreamLanguage;
export 'src/language/syntax.dart' show syntaxTree, syntaxTreeAvailable;

// Grammars
export 'src/grammars/_registry.dart' show LanguageRegistry;
export 'src/grammars/json.dart' show jsonLanguageSupport, jsonHighlightMapping;
export 'src/grammars/dart.dart' show dartLanguageSupport;
export 'src/grammars/javascript.dart' show javascriptLanguageSupport;
export 'src/grammars/python.dart' show pythonLanguageSupport;
export 'src/grammars/html.dart' show htmlLanguageSupport;
export 'src/grammars/css.dart' show cssLanguageSupport;
export 'src/grammars/markdown.dart' show markdownLanguageSupport;
export 'src/grammars/rust.dart' show rustLanguageSupport;
export 'src/grammars/go.dart' show goLanguageSupport;
export 'src/grammars/yaml.dart' show yamlLanguageSupport;
export 'src/grammars/c.dart' show cLanguageSupport;
export 'src/grammars/elixir.dart' show elixirLanguageSupport;
export 'src/grammars/java.dart' show javaLanguageSupport;
export 'src/grammars/kotlin.dart' show kotlinLanguageSupport;
export 'src/grammars/php.dart' show phpLanguageSupport;
export 'src/grammars/ruby.dart' show rubyLanguageSupport;
export 'src/grammars/erlang.dart' show erlangLanguageSupport;
export 'src/grammars/swift.dart' show swiftLanguageSupport;
export 'src/grammars/zig.dart' show zigLanguageSupport;

// Theme
export 'src/theme/editor_theme.dart' show EditorTheme;
export 'src/theme/default_highlight.dart'
    show defaultLightHighlight, defaultDarkHighlight;

// View
export 'src/view/editor_view_controller.dart' show EditorViewController;
export 'src/view/viewport.dart' show EditorViewport;
export 'src/view/highlight_builder.dart' show InlineSpan, HighlightBuilder;
export 'src/view/editor_view.dart' show EditorView;
export 'src/view/line_painter.dart' show LinePainter;
export 'src/view/gutter_painter.dart' show GutterPainter;
export 'src/view/selection_painter.dart' show SelectionPainter;
export 'src/view/code_editor_widget.dart' show CodeEditorWidget;
export 'src/view/dm_editor_action.dart' show DmEditorAction;
export 'src/view/dm_code_editor_toolbar.dart' show DmCodeEditorToolbar;
export 'src/view/dm_code_editor_status_bar.dart' show DmCodeEditorStatusBar;
export 'src/view/search_panel.dart' show SearchPanel;

// Commands
export 'src/commands/keymap.dart' show Command, KeyBinding, Keymap;
export 'src/commands/commands.dart' show EditorCommands;
export 'src/commands/history.dart'
    show HistoryState, HistoryEntry, historyExtension;
export 'src/commands/default_keymap.dart' show defaultKeymap;
export 'src/commands/bracket_matching.dart' show BracketPair, BracketMatching;
export 'src/commands/comment.dart' show CommentCommands;
export 'src/commands/clipboard.dart' show ClipboardCommands;
export 'src/commands/search.dart' show SearchMatch, SearchState, SearchCommands;
export 'src/commands/folding.dart' show FoldRegion, FoldDetector;
export 'src/view/position_utils.dart' show LineColumn, PositionUtils;
export 'src/view/cursor_blink.dart' show CursorBlink;
export 'src/view/input_handler.dart' show InputHandler;
