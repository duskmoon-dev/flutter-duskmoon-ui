import '../grammars/_registry.dart';
import '../lezer/common/node_type.dart';
import '../lezer/common/parser.dart';
import '../lezer/common/tree.dart';
import 'language.dart';
import 'language_data.dart';

/// A rule that maps a regex pattern to a node name.
class TokenRule {
  const TokenRule(this.pattern, this.nodeName);
  final RegExp pattern;
  final String nodeName;
}

/// A simple regex-based tokenizer implementing [Parser].
///
/// Each language defines a list of [TokenRule]s. Rules are tried in order;
/// the first match wins. Whitespace is skipped without creating nodes.
/// Unrecognized characters are silently skipped.
class StreamLanguage {
  StreamLanguage({
    required this.name,
    required this.rules,
    this.data = const LanguageData(),
  }) : _parser = _StreamParser(_buildNodeTypes(name, rules), rules);

  final String name;
  final List<TokenRule> rules;
  final LanguageData data;
  final _StreamParser _parser;

  /// Returns the [Parser] for this language.
  Parser get parser => _parser;

  /// Creates a [LanguageSupport] and registers it in [LanguageRegistry].
  LanguageSupport languageSupport({
    List<String> extensions = const [],
    List<String> mimeTypes = const [],
  }) {
    final language = Language(name: name, parser: _parser, data: data);
    final support = LanguageSupport(language: language);
    LanguageRegistry.register(support,
        extensions: extensions, mimeTypes: mimeTypes);
    return support;
  }

  static _NodeTypes _buildNodeTypes(String langName, List<TokenRule> rules) {
    // Collect unique node names from rules (preserve insertion order)
    final seen = <String>{};
    final names = <String>[];
    for (final rule in rules) {
      if (seen.add(rule.nodeName)) {
        names.add(rule.nodeName);
      }
    }

    // ID 0 is reserved for the top-level node; leaf nodes start at 1
    final topType = NodeType(langName, 0, props: {NodeProp.top: true});

    var nextId = 1;
    final byName = <String, NodeType>{};
    for (final n in names) {
      byName[n] = NodeType(n, nextId++);
    }

    return _NodeTypes(topType, byName);
  }
}

/// Internal container for pre-built node types.
class _NodeTypes {
  const _NodeTypes(this.top, this.byName);
  final NodeType top;
  final Map<String, NodeType> byName;
}

/// Internal parser implementation for [StreamLanguage].
class _StreamParser extends Parser {
  const _StreamParser(this._nodeTypes, this._rules);

  final _NodeTypes _nodeTypes;
  final List<TokenRule> _rules;

  @override
  Tree parse(
    String input, {
    Tree? previousTree,
    List<ChangedRange>? changedRanges,
    int? stopAt,
  }) {
    final children = <Tree>[];
    final positions = <int>[];

    var pos = 0;
    final length = input.length;

    while (pos < length) {
      final ch = input[pos];

      // Skip whitespace
      if (ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r') {
        pos++;
        continue;
      }

      // Try each rule in order
      Tree? matched;
      int? matchEnd;
      for (final rule in _rules) {
        final m = rule.pattern.matchAsPrefix(input, pos);
        if (m != null && m.end > pos) {
          final nodeType =
              _nodeTypes.byName[rule.nodeName] ?? NodeType(rule.nodeName, 0);
          final tokenLength = m.end - pos;
          matched = Tree(nodeType, const [], const [], tokenLength);
          matchEnd = m.end;
          break;
        }
      }

      if (matched != null && matchEnd != null) {
        children.add(matched);
        positions.add(pos);
        pos = matchEnd;
      } else {
        // No rule matched — skip one character silently
        pos++;
      }
    }

    return Tree(_nodeTypes.top, children, positions, length);
  }
}
