; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(comment) @comment
(number) @number
(regex) @string.regexp
(regex_pattern) @string.regexp
(string) @string
(string_concat) @string
(escape_sequence) @string.escape
(identifier) @variable
"!" @operator
"!=" @operator
"%" @operator
"&&" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"*=" @operator
"+" @operator
"+=" @operator
"," @punctuation.delimiter
"-" @operator
"-=" @operator
"/" @operator
"/=" @operator
":" @punctuation.delimiter
"::" @operator
";" @punctuation.delimiter
"<" @operator
"<=" @operator
"=" @operator
"==" @operator
">" @operator
">=" @operator
"BEGIN" @keyword
"END" @keyword
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"and" @keyword
"case" @keyword
"default" @keyword
"do" @keyword
"else" @keyword
"for" @keyword
"function" @keyword
"if" @keyword
"in" @keyword
"match" @keyword
"namespace" @keyword
"or" @keyword
"return" @keyword
"switch" @keyword
"while" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(func_call name: (_) @function)

; Source: vendor/grammars/awk/queries/highlights.scm

(ns_qualified_name (namespace) @namespace)

(ns_qualified_name "::" @operator)

(func_def name: (_ (identifier) @function) @function)

(func_call name: (_ (identifier) @function) @function)

[
  (identifier)
  (field_ref)
] @variable

(field_ref (_) @variable)

(string) @string

(number) @number

(regex) @regexp

(comment) @comment

[
  "function"
  "func"
  "print"
  "printf"
  "if"
  "else"
  "do"
  "while"
  "for"
  "in"
  "delete"
  "return"
  "exit"
  "switch"
  "case"
  "default"
  (break_statement)
  (continue_statement)
  (next_statement)
  (nextfile_statement)
  (getline_input)
  (getline_file)
] @keyword

[
  "@include"
  "@load"
  "@namespace"
  (pattern)
] @namespace

(binary_exp [
  "^"
  "**"
  "*"
  "/"
  "%"
  "+"
  "-"
  "<"
  ">"
  "<="
  ">="
  "=="
  "!="
  "~"
  "!~"
  "in"
  "&&"
  "||"
] @operator)

(unary_exp [
  "!"
  "+"
  "-"
] @operator)

(assignment_exp [
  "="
  "+="
  "-="
  "*="
  "/="
  "%="
  "^="
] @operator)

(ternary_exp [
  "?"
  ":"
] @operator)

(update_exp [
  "++"
  "--"
] @operator)

(redirected_io_statement [
  ">"
  ">>"
] @operator)

(piped_io_statement [
  "|"
  "|&"
] @operator)

[
  ";"
  ","
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @operator
