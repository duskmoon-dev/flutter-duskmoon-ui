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
