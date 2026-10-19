; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(string) @string
(comment) @comment
(escape_sequence) @string.escape
(false) @boolean
(null) @constant.null
(number) @number
(string_content) @string
(true) @boolean
"," @punctuation.delimiter
":" @punctuation.delimiter
"[" @punctuation.bracket
"]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket

; Source: vendor/grammars/json/queries/highlights.scm

(pair
  key: (_) @string.special.key)

(string) @string

(number) @number

[
  (null)
  (true)
  (false)
] @constant.builtin

(escape_sequence) @escape

(comment) @comment
