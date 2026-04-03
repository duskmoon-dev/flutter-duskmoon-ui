/// A token produced by tokenization.
class Token {
  const Token(this.type, this.start, this.end);
  final int type;
  final int start;
  final int end;
  int get length => end - start;
}

/// Interface for external tokenizers.
abstract class ExternalTokenizer {
  const ExternalTokenizer();
  Token? token(String input, int pos);
}
