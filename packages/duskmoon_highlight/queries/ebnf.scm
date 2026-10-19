; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(comment) @comment
(identifier) @variable
(integer) @number
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"," @punctuation.delimiter
"-" @operator
";" @punctuation.delimiter
"=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"{" @punctuation.bracket
"|" @operator
"}" @punctuation.bracket

; Source: vendor/grammars/ebnf/crates/tree-sitter-ebnf/queries/highlights.scm

(terminal) @string.grammar

(special_sequence) @string.special.grammar

(integer) @number

(comment) @comment.block

;;;; Identifiers ;;;;
; Allow different highlighting for specific casings

((identifier) @symbol.grammar.upper
 (#match? @symbol.grammar.upper "^[A-Z][A-Z0-9_]+$"))

((identifier) @symbol.grammar.lower
 (#match? @symbol.grammar.lower "^[a-z][a-z0-9_]+$"))

((identifier) @symbol.grammar.pascal
 (#match? @symbol.grammar.pascal "^[A-Z]"))

((identifier) @symbol.grammar.camel
 (#match? @symbol.grammar.camel "^[a-z]"))

(identifier) @symbol.grammar

;;; Punctuation ;;;;

[
 ";"
 ","
] @punctuation.delimiter

[
 "|"
 "*"
 "-"
] @operator

"=" @keyword.operator

[
 "("
 ")"
 "["
 "]"
 "{"
 "}"
] @punctuation.bracket
