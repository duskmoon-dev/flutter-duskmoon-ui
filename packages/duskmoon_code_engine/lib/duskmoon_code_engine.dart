/// Pure Dart code editor engine with incremental parsing.
///
/// A ground-up port of the CodeMirror 6 architecture for Flutter,
/// providing: document model, state management, incremental parser,
/// virtual-viewport rendering, and syntax highlighting.
library;

// Document model
export 'src/document/change.dart' show ChangeSpec, ChangeSet;
export 'src/document/document.dart' show Document;
export 'src/document/position.dart' show Pos, Range;
export 'src/document/rope.dart' show RopeNode, RopeLeaf, RopeBranch, Rope;
export 'src/document/text.dart' show Line;

// State system
export 'src/state/selection.dart' show SelectionRange, EditorSelection;
export 'src/state/annotation.dart'
    show AnnotationType, Annotation, Annotations;
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
export 'src/lezer/common/tree.dart' show Tree, TreeBuffer, SyntaxNode, TreeCursor;
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
export 'src/language/syntax.dart' show syntaxTree, syntaxTreeAvailable;

// Grammars
export 'src/grammars/_registry.dart' show LanguageRegistry;
export 'src/grammars/json.dart' show jsonLanguageSupport, jsonHighlightMapping;

// Theme
export 'src/theme/editor_theme.dart' show EditorTheme;
export 'src/theme/default_highlight.dart' show defaultLightHighlight, defaultDarkHighlight;

// View
export 'src/view/editor_view_controller.dart' show EditorViewController;
export 'src/view/viewport.dart' show EditorViewport;
export 'src/view/highlight_builder.dart' show InlineSpan, HighlightBuilder;
export 'src/view/editor_view.dart' show EditorView;
export 'src/view/line_painter.dart' show LinePainter;
export 'src/view/gutter_painter.dart' show GutterPainter;
export 'src/view/selection_painter.dart' show SelectionPainter;

// Commands
export 'src/commands/keymap.dart' show Command, KeyBinding, Keymap;
export 'src/commands/commands.dart' show EditorCommands;
export 'src/commands/history.dart' show HistoryState, HistoryEntry, historyExtension;
