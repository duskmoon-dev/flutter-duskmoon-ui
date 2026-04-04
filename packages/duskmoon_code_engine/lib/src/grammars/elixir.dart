import '../language/language.dart';
import '../language/language_data.dart';
import '../language/stream_language.dart';
import '_registry.dart';

LanguageSupport? _cached;

void _ensureRegistered() {
  if (LanguageRegistry.byName('elixir') != null) return;
  _cached = _elixirStream.languageSupport(
    extensions: ['ex', 'exs'],
    mimeTypes: ['text/x-elixir', 'application/x-elixir'],
  );
}

LanguageSupport elixirLanguageSupport() {
  _ensureRegistered();
  return _cached!;
}

final _elixirStream = StreamLanguage(
  name: 'elixir',
  rules: [
    // Line comments
    TokenRule(RegExp(r'#.*'), 'Comment'),
    // Heredocs (triple-quoted strings)
    TokenRule(RegExp(r'"""[\s\S]*?"""'), 'String'),
    TokenRule(RegExp(r"'''[\s\S]*?'''"), 'String'),
    // Sigils ~r/.../ ~w[...] etc.
    TokenRule(RegExp(r'~[a-zA-Z]\{[\s\S]*?\}[a-zA-Z]*'), 'String'),
    TokenRule(RegExp(r'~[a-zA-Z]\[[\s\S]*?\][a-zA-Z]*'), 'String'),
    TokenRule(RegExp(r'~[a-zA-Z]\([\s\S]*?\)[a-zA-Z]*'), 'String'),
    TokenRule(RegExp(r'~[a-zA-Z]/[\s\S]*?/[a-zA-Z]*'), 'String'),
    TokenRule(RegExp(r'~[a-zA-Z]"[\s\S]*?"[a-zA-Z]*'), 'String'),
    TokenRule(RegExp(r"~[a-zA-Z]'[\s\S]*?'[a-zA-Z]*"), 'String'),
    // String literals
    TokenRule(RegExp(r'"(?:[^"\\]|\\.)*"'), 'String'),
    // Module attributes @name
    TokenRule(RegExp(r'@[a-zA-Z_]\w*'), 'Annotation'),
    // Atoms :name and :"name"
    TokenRule(RegExp(r':"(?:[^"\\]|\\.)*"'), 'Atom'),
    TokenRule(RegExp(r':[a-zA-Z_][a-zA-Z0-9_?!]*'), 'Atom'),
    // Numbers (hex, binary, octal, float, int)
    TokenRule(RegExp(r'0x[0-9a-fA-F_]+'), 'Number'),
    TokenRule(RegExp(r'0b[01_]+'), 'Number'),
    TokenRule(RegExp(r'0o[0-7_]+'), 'Number'),
    TokenRule(RegExp(r'\b\d[\d_]*\.?\d*([eE][+-]?\d+)?\b'), 'Number'),
    // Keywords
    TokenRule(
      RegExp(r'\b(def|defp|defmodule|defmacro|defmacrop|defstruct|defprotocol|'
          r'defimpl|defdelegate|defoverridable|do|end|if|else|unless|cond|case|'
          r'when|fn|with|for|raise|rescue|try|catch|after|in|not|and|or|true|'
          r'false|nil|import|require|alias|use|receive|send|spawn|exit|throw)\b'),
      'Keyword',
    ),
    // Module names (uppercase start)
    TokenRule(RegExp(r'\b[A-Z][a-zA-Z0-9_]*\b'), 'TypeName'),
    // Identifiers (may end with ? or !)
    TokenRule(RegExp(r'[a-zA-Z_][a-zA-Z0-9_]*[?!]?'), 'Identifier'),
    // Operators
    TokenRule(RegExp(r'[+\-*/%&|^~<>=!?:]+'), 'Operator'),
    // Punctuation
    TokenRule(RegExp(r'[{}()\[\];,.]'), 'Punctuation'),
  ],
  data: const LanguageData(
    commentTokens: CommentTokens(line: '#'),
  ),
);
