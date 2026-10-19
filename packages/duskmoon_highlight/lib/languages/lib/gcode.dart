import 'package:duskmoon_highlight/duskmoon_highlight.dart';

/// Mirrors HighlightJS's LETTER_BOUNDARY_CALLBACK for adjacent G-code words.
ModeCallback callbackOnBegin =
    (EnhancedMatch match, ModeCallbackResponse response) {
  if (match.index == 0) {
    return;
  }
  final before = match.input.codeUnitAt(match.index - 1);
  if ((before >= 0x30 && before <= 0x39) || before == 0x5f) {
    return;
  }
  response.ignoreMatch();
};
