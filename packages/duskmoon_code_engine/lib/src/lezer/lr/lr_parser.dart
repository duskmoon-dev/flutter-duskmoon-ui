import 'dart:typed_data';

import '../common/node_type.dart';
import '../common/parser.dart';
import '../common/tree.dart';
import 'grammar_data.dart';
import 'parse_state.dart';

/// A simplified LR parser that performs character-class-based tokenization
/// and wraps results in a [Tree].
///
/// This is a token-level parser, not a full table-driven LR parser. The full
/// table-driven engine will follow once real grammar codegen is available.
class LRParser extends Parser {
  LRParser(this.grammar);

  /// Deserialize a grammar from raw data arrays into an [LRParser].
  factory LRParser.deserialize({
    required List<String> nodeNames,
    required List<int> states,
    required List<int> stateData,
    required List<int> gotoTable,
    required List<int> tokenData,
    required int topRuleIndex,
    Map<int, Map<NodeProp<dynamic>, dynamic>>? nodeProps,
    List<int> skippedNodes = const [],
  }) {
    final types = List<NodeType>.generate(nodeNames.length, (i) {
      final props = nodeProps?[i];
      return NodeType(nodeNames[i], i, props: props);
    });

    final grammar = GrammarData(
      nodeSet: NodeSet(types),
      states: Uint16List.fromList(states),
      stateData: Uint16List.fromList(stateData),
      gotoTable: Uint16List.fromList(gotoTable),
      nodeNames: nodeNames,
      tokenData: Uint16List.fromList(tokenData),
      topRuleIndex: topRuleIndex,
      skippedNodes: skippedNodes,
    );

    return LRParser(grammar);
  }

  final GrammarData grammar;

  NodeType _typeByName(String name) {
    final idx = grammar.nodeNames.indexOf(name);
    if (idx < 0) return NodeType.none;
    return grammar.nodeSet.types[idx];
  }

  /// Parse [input] into a [Tree].
  ///
  /// Tokenizes the input using character-class matching suitable for JSON.
  /// Whitespace is skipped; unknown characters produce error nodes.
  @override
  Tree parse(
    String input, {
    Tree? previousTree,
    List<ChangedRange>? changedRanges,
    int? stopAt,
  }) {
    final builder = TreeBuilder();
    var pos = 0;
    final end = stopAt != null ? stopAt.clamp(0, input.length) : input.length;

    while (pos < end) {
      final ch = input[pos];

      // Skip whitespace
      if (ch == ' ' || ch == '\t' || ch == '\n' || ch == '\r') {
        pos++;
        continue;
      }

      // String literal
      if (ch == '"') {
        final start = pos;
        pos++; // consume opening quote
        while (pos < end) {
          final c = input[pos];
          if (c == '\\') {
            pos += 2; // skip escape sequence
          } else if (c == '"') {
            pos++;
            break;
          } else {
            pos++;
          }
        }
        final type = _typeByName('String');
        if (type.id > 0) {
          builder.addChild(
            Tree(type, const [], const [], pos - start),
            start,
          );
        }
        continue;
      }

      // Number literal: -?[0-9]+(\.[0-9]+)?([eE][+-]?[0-9]+)?
      if (ch == '-' || (ch.codeUnitAt(0) >= 0x30 && ch.codeUnitAt(0) <= 0x39)) {
        final start = pos;
        if (ch == '-') pos++;
        while (pos < end &&
            input.codeUnitAt(pos) >= 0x30 &&
            input.codeUnitAt(pos) <= 0x39) {
          pos++;
        }
        if (pos < end && input[pos] == '.') {
          pos++;
          while (pos < end &&
              input.codeUnitAt(pos) >= 0x30 &&
              input.codeUnitAt(pos) <= 0x39) {
            pos++;
          }
        }
        if (pos < end && (input[pos] == 'e' || input[pos] == 'E')) {
          pos++;
          if (pos < end && (input[pos] == '+' || input[pos] == '-')) pos++;
          while (pos < end &&
              input.codeUnitAt(pos) >= 0x30 &&
              input.codeUnitAt(pos) <= 0x39) {
            pos++;
          }
        }
        final type = _typeByName('Number');
        if (type.id > 0) {
          builder.addChild(
            Tree(type, const [], const [], pos - start),
            start,
          );
        }
        continue;
      }

      // Keywords: true, false, null
      if (_matchKeyword(input, pos, end, 'true')) {
        final type = _typeByName('Boolean');
        if (type.id > 0) {
          builder.addChild(Tree(type, const [], const [], 4), pos);
        }
        pos += 4;
        continue;
      }
      if (_matchKeyword(input, pos, end, 'false')) {
        final type = _typeByName('Boolean');
        if (type.id > 0) {
          builder.addChild(Tree(type, const [], const [], 5), pos);
        }
        pos += 5;
        continue;
      }
      if (_matchKeyword(input, pos, end, 'null')) {
        final type = _typeByName('Null');
        if (type.id > 0) {
          builder.addChild(Tree(type, const [], const [], 4), pos);
        }
        pos += 4;
        continue;
      }

      // Punctuation: look up by the literal character name
      final punctType = _typeByName(ch);
      if (punctType.id > 0) {
        builder.addChild(Tree(punctType, const [], const [], 1), pos);
        pos++;
        continue;
      }

      // Error recovery: consume unknown char as error node
      final errType = _typeByName('⚠');
      final errNode = errType.id > 0 ? errType : NodeType('⚠', 0);
      builder.addChild(Tree(errNode, const [], const [], 1), pos);
      pos++;
    }

    final topType = grammar.nodeSet.types.length > grammar.topRuleIndex
        ? grammar.nodeSet.types[grammar.topRuleIndex]
        : NodeType.none;

    return builder.build(topType, input.length);
  }

  bool _matchKeyword(String input, int pos, int end, String keyword) {
    if (pos + keyword.length > end) return false;
    for (var i = 0; i < keyword.length; i++) {
      if (input[pos + i] != keyword[i]) return false;
    }
    // Ensure it's a full word (not followed by alnum/_)
    final after = pos + keyword.length;
    if (after < end) {
      final c = input.codeUnitAt(after);
      if ((c >= 0x61 && c <= 0x7a) || // a-z
          (c >= 0x41 && c <= 0x5a) || // A-Z
          (c >= 0x30 && c <= 0x39) || // 0-9
          c == 0x5f) {
        // _
        return false;
      }
    }
    return true;
  }
}
