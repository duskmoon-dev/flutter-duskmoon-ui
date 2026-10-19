; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(comment) @comment
(number) @number
(quoted_atom) @string
(string) @string
(variable) @variable
"," @punctuation.delimiter
":" @punctuation.delimiter
"{" @punctuation.bracket
"}" @punctuation.bracket
(functional_notation name: (_) @function)
