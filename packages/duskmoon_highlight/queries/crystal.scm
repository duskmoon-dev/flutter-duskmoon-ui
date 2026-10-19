; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(chained_string) @string
(char) @character
(float) @number
(heredoc_body) @string
(integer) @number
(nil) @constant.null
(op_assign) @keyword
(op_call) @keyword
(regex) @string.regexp
(string) @string
(symbol) @variable
(comment) @comment
(false) @boolean
(heredoc_content) @string
(heredoc_end) @string
(heredoc_start) @string
(identifier) @variable
(string_escape_sequence) @string
(true) @boolean
"!" @operator
"!=" @operator
"%" @operator
"&" @operator
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
"->" @operator
"." @punctuation.delimiter
"/" @operator
"/=" @operator
":" @punctuation.delimiter
"::" @operator
";" @punctuation.delimiter
"<" @operator
"<=" @operator
"=" @operator
"==" @operator
"===" @operator
"=>" @operator
">" @operator
">=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"abstract" @keyword
"alias" @keyword
"begin" @keyword
"break" @keyword
"case" @keyword
"class" @keyword
"def" @keyword
"do" @keyword
"else" @keyword
"elsif" @keyword
"end" @keyword
"enum" @keyword
"if" @keyword
"in" @keyword
"module" @keyword
"of" @keyword
"private" @keyword
"protected" @keyword
"return" @keyword
"struct" @keyword
"then" @keyword
"when" @keyword
"while" @keyword
"with" @keyword
"yield" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(abstract_method_def name: (_) @function)
(assign_call method: (_) @function)
(call method: (_) @function)
(class_def name: (_) @type)
(enum_def name: (_) @type)
(implicit_object_call method: (_) @function)
(method_def name: (_) @function)
(struct_def name: (_) @type)
