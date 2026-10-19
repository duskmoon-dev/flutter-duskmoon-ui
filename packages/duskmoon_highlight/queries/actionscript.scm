; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(regex) @string.regexp
(string) @string
(block_comment) @comment
(false) @boolean
(identifier) @variable
(line_comment) @comment
(null) @constant.null
(number) @number
(regex_pattern) @string.regexp
(true) @boolean
"!" @operator
"!=" @operator
"!==" @operator
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
">" @operator
">=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"as" @keyword
"break" @keyword
"case" @keyword
"catch" @keyword
"class" @keyword
"const" @keyword
"continue" @keyword
"default" @keyword
"do" @keyword
"else" @keyword
"extends" @keyword
"final" @keyword
"finally" @keyword
"for" @keyword
"function" @keyword
"if" @keyword
"import" @keyword
"in" @keyword
"interface" @keyword
"is" @keyword
"namespace" @keyword
"new" @keyword
"package" @keyword
"private" @keyword
"protected" @keyword
"public" @keyword
"return" @keyword
"static" @keyword
"switch" @keyword
"throw" @keyword
"try" @keyword
"var" @keyword
"void" @keyword
"while" @keyword
"with" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
"~" @operator
(anonymous_function name: (_) @function)
(call_expression function: (_) @function)
(class_declaration name: (_) @type)
(function_declaration name: (_) @function)
(interface_declaration name: (_) @type)
(method_declaration name: (_) @function)
