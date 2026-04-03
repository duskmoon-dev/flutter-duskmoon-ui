import '../lezer/common/parser.dart';
import '../lezer/common/tree.dart';
import '../state/editor_state.dart';
import '../state/extension.dart';
import 'language_data.dart';
import 'syntax.dart';

class Language {
  Language({
    required this.name,
    required this.parser,
    this.data = const LanguageData(),
  });
  final String name;
  final Parser parser;
  final LanguageData data;
}

class LanguageSupport {
  LanguageSupport({required this.language, this.support = const []});
  final Language language;
  final List<Extension> support;

  Extension get extension {
    final languageField = StateField<_LanguageState>(
      create: (state) {
        final editorState = state as EditorState;
        final doc = editorState.doc.toString();
        final tree = language.parser.parse(doc);
        return _LanguageState(tree, true);
      },
      update: (transaction, value) {
        final tr = transaction as Transaction;
        if (!tr.docChanged) return value;
        final changes = tr.changes!;
        final newDoc = tr.startState.doc.replace(changes);
        final tree = language.parser.parse(newDoc.toString());
        return _LanguageState(tree, true);
      },
    );

    // Register accessors for syntaxTree/syntaxTreeAvailable
    registerSyntaxTreeAccessor((state) {
      try {
        return (state as EditorState).field(languageField).tree;
      } catch (_) {
        return null;
      }
    });
    registerSyntaxTreeAvailableAccessor((state) {
      try {
        return (state as EditorState).field(languageField).available;
      } catch (_) {
        return false;
      }
    });

    if (support.isEmpty) return languageField;
    return ExtensionGroup([languageField, ...support]);
  }
}

class _LanguageState {
  const _LanguageState(this.tree, this.available);
  final Tree tree;
  final bool available;
}
