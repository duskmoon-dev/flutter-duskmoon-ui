; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(block_comment) @comment
(comment_environment) @comment
(label_number) @number
(command_name) @function
(comment) @comment
(line_comment) @comment
"!" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"+" @operator
"," @punctuation.delimiter
"-" @operator
"/" @operator
":" @punctuation.delimiter
"<" @operator
"=" @operator
">" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"{" @punctuation.bracket
"|" @operator
"}" @punctuation.bracket
