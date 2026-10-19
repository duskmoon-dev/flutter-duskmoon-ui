; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(char_lit) @character
(complex_num_lit) @number
(defun_keyword) @keyword
(kwd_lit) @keyword
(kwd_symbol) @keyword
(num_lit) @number
(str_lit) @string
(sym_lit) @variable
(block_comment) @comment
(comment) @comment
(nil_lit) @constant.null
"%" @operator
"&" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"," @punctuation.delimiter
"." @punctuation.delimiter
"/" @operator
":" @punctuation.delimiter
"::" @operator
";" @punctuation.delimiter
"=" @operator
"^" @operator
"and" @keyword
"as" @keyword
"do" @keyword
"else" @keyword
"finally" @keyword
"for" @keyword
"from" @keyword
"if" @keyword
"in" @keyword
"return" @keyword
"then" @keyword
"using" @keyword
"when" @keyword
"while" @keyword
"with" @keyword
"{" @punctuation.bracket
"|" @operator
"}" @punctuation.bracket
"~" @operator
(defun_header function_name: (_) @function)
