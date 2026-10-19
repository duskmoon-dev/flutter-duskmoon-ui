; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(boolean) @boolean
(string) @string
(string_content) @string
(comment) @comment
(escape_sequence) @string.escape
(identifier) @variable
(integer) @number
"!" @operator
"!=" @operator
"&&" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"+" @operator
"+=" @operator
"," @punctuation.delimiter
"-" @operator
"-=" @operator
"." @punctuation.delimiter
"<" @operator
"<=" @operator
"=" @operator
"==" @operator
">" @operator
">=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"else" @keyword
"false" @keyword
"foreach" @keyword
"if" @keyword
"import" @keyword
"true" @keyword
"{" @punctuation.bracket
"||" @operator
"}" @punctuation.bracket
(call_expression function: (_) @function)

; Source: vendor/grammars/gn/queries/highlights.scm

"import" @include

; Conditionals

[
  "if"
  "else"
] @conditional

; Repeats

"foreach" @repeat

; Operators

[
  "="
  "+="
  "-="
  "!"
  "+"
  "-"
  "<"
  "<="
  ">"
  ">="
  "=="
  "!="
  "&&"
  "||"
] @operator

; Variables

(identifier) @variable

; Functions

(call_expression function: (identifier) @function.call)

; Fields

(scope_access field: (identifier) @field)

; Literals

(string) @string

(escape_sequence) @string.escape

(expansion) @none

(integer) @number

(hex) @string.special

(boolean) @boolean

; Punctuation

[ "{" "}" "[" "]" "(" ")" ] @punctuation.bracket

[
  "."
  ","
] @punctuation.delimiter

(expansion ["$" "${" "}"] @punctuation.special)

; Comments

(comment) @comment
