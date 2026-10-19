; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(kwd_lit) @keyword
(str_lit) @string
(sym_lit) @variable
(char_lit) @character
(comment) @comment
(nil_lit) @constant.null
(num_lit) @number
"(" @punctuation.bracket
")" @punctuation.bracket
"/" @operator
":" @punctuation.delimiter
"::" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"{" @punctuation.bracket
"}" @punctuation.bracket
"~" @operator

; Source: vendor/grammars/clojure/queries/highlights.scm

(num_lit) @number

[
  (char_lit)
  (str_lit)
] @string

[
 (bool_lit)
 (nil_lit)
] @constant.builtin

(kwd_lit) @constant

;; Comments

(comment) @comment

;; Treat quasiquotation as operators for the purpose of highlighting.

[
 "'"
 "`"
 "~"
 "@"
 "~@"
] @operator
