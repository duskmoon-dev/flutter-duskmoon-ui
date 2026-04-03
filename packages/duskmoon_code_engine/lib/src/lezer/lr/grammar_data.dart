import 'dart:typed_data';
import '../common/node_type.dart';

/// Serialized grammar data for an LR parser.
class GrammarData {
  const GrammarData({
    required this.nodeSet,
    required this.states,
    required this.stateData,
    required this.gotoTable,
    required this.nodeNames,
    required this.tokenData,
    required this.topRuleIndex,
    this.tokenPrec = 0,
    this.skippedNodes = const [],
  });

  final NodeSet nodeSet;
  final Uint16List states;
  final Uint16List stateData;
  final Uint16List gotoTable;
  final List<String> nodeNames;
  final Uint16List tokenData;
  final int topRuleIndex;
  final int tokenPrec;
  final List<int> skippedNodes;
}
