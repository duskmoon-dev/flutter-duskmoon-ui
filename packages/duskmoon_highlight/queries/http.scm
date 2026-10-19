; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(comment) @comment
(variable) @variable
(identifier) @variable
":" @punctuation.delimiter
"<" @operator
"=" @operator
">" @operator

; Source: vendor/grammars/http/queries/highlights.scm

(method) @function.method

; Headers

(header
  name: (_) @constant)

; Variables

(variable_declaration
  name: (identifier) @variable)

; Operators

(comment
  "=" @operator)

(variable_declaration
  "=" @operator)

; keywords

(comment
  "@" @keyword
  name: (_) @keyword)

; Literals

(request
  url: (_) @string.special.url)

(http_version) @constant

; Response

(status_code) @number

(status_text) @string

; Punctuation

[
  "{{"
  "}}"
] @punctuation.bracket

(header
  ":" @punctuation.delimiter)

; external JSON body

(external_body
  path: (_) @string.special.path)

; Comments

[
  (comment)
  (request_separator)
] @comment @spell
