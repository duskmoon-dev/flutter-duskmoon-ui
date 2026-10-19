; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(boolean) @boolean
(comment) @comment
(keyword) @keyword
(quoted_string_literal) @string
(variable) @variable
(numeric_literal) @number
(string_literal) @string
"*" @operator
"-" @operator
"." @punctuation.delimiter
"/" @operator
";" @punctuation.delimiter
"=" @operator
"if" @keyword
"select" @keyword
"{" @punctuation.bracket
"}" @punctuation.bracket
"~" @operator

; Source: vendor/grammars/nginx/queries/highlights.scm

(comment) @comment @spell

(value) @variable

(attribute (keyword) @attribute)

[
  (location_modifier)
  "="
] @operator

[
  (keyword)
  "location"
] @keyword

[
  "if"
  "map"
] @keyword.conditional

(directive (keyword) @constant)

(boolean) @boolean

[
  (auto)
  (constant)
  (level)
  (connection_method)
  (var)
  condition: (condition)
] @variable.builtin

[
  (string_literal)
  (quoted_string_literal)
  (file)
  (mask)
] @string

(directive (variable) @variable.parameter)

(directive (variable (keyword) @variable.parameter))

(location_route) @string.special

";" @punctuation.delimiter

[
  (numeric_literal)
  (time)
  (size)
  (cpumask)
] @number

[
  "{"
  "}"
] @punctuation.bracket
