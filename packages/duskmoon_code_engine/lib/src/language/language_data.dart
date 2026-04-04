/// Metadata about a language.
class LanguageData {
  const LanguageData({this.commentTokens, this.indentOnInput});
  final CommentTokens? commentTokens;
  final String? indentOnInput;
}

class CommentTokens {
  const CommentTokens({this.line, this.block});
  final String? line;
  final ({String open, String close})? block;
}
