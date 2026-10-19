; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(boolean) @boolean
(comment) @comment
(function_identifier) @function
(interpolated_string) @string
(name) @variable
(variable) @variable
(keyword) @keyword
(null) @constant.null
(number) @number
(string) @string
"!=" @operator
"%" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"+" @operator
"," @punctuation.delimiter
"-" @operator
"." @punctuation.delimiter
"/" @operator
":" @punctuation.delimiter
"<" @operator
"<=" @operator
"=" @operator
"==" @operator
"=>" @operator
">" @operator
">=" @operator
"?." @operator
"??" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"and" @keyword
"false" @keyword
"in" @keyword
"is" @keyword
"not" @keyword
"or" @keyword
"true" @keyword
"{" @punctuation.bracket
"|" @operator
"}" @punctuation.bracket
"~" @operator

; Source: vendor/grammars/twig/queries/highlights.scm

(comment) @comment @spell

(filter_identifier) @function.call

(function_identifier) @function.call

(test) @function.builtin

(variable) @variable

(string) @string

(interpolated_string) @string

(operator) @operator

(number) @number

(boolean) @boolean

(null) @constant.builtin

(keyword) @keyword

(attribute) @attribute

(tag) @tag

(conditional) @keyword.conditional

(repeat) @keyword.repeat

(method) @function.method

(parameter) @variable.parameter

[
  "{{"
  "}}"
  "{{-"
  "-}}"
  "{{~"
  "~}}"
  "{%"
  "%}"
  "{%-"
  "-%}"
  "{%~"
  "~%}"
] @tag.delimiter

[
  ","
  "."
] @punctuation.delimiter

[
  "?"
  ":"
  "="
  "|"
] @operator

(interpolated_string
  [
    "#{"
    "}"
  ] @punctuation.special)

[
  "("
  ")"
  "["
  "]"
] @punctuation.bracket

(hash
  [
    "{"
    "}"
  ] @punctuation.bracket)
