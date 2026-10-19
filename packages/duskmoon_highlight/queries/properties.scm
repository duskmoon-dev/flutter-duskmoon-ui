; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(escape) @string.escape
(comment) @comment
"." @punctuation.delimiter
":" @punctuation.delimiter
"::" @operator
"=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"}" @punctuation.bracket

; Source: vendor/grammars/properties/queries/highlights.scm

(comment) @comment

(key) @property

(value) @string

(value (escape) @string.escape)

((index) @number
  (#match? @number "^[0-9]+$"))

((substitution (key) @constant)
  (#match? @constant "^[A-Z0-9_]+"))

(substitution
  (key) @function
  "::" @punctuation.special
  (secret) @embedded)

(property [ "=" ":" ] @operator)

[ "${" "}" ] @punctuation.special

(substitution ":" @punctuation.special)

[ "[" "]" ] @punctuation.bracket

[ "." "\\" ] @punctuation.delimiter
