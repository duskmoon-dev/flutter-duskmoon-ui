; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(attribute_name) @property
(command_name) @function
(expandable_here_string_literal) @string
(expandable_string_literal) @string
(function_name) @function
(integer_literal) @number
(string_literal) @string
(type_name) @type
(variable) @variable
(comment) @comment
(decimal_integer_literal) @number
(hexadecimal_integer_literal) @number
(type_identifier) @type
(verbatim_here_string_characters) @string
(verbatim_string_characters) @string
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
"." @punctuation.delimiter
"/" @operator
"/=" @operator
":" @punctuation.delimiter
"::" @operator
";" @punctuation.delimiter
"<" @operator
"=" @operator
">" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"begin" @keyword
"break" @keyword
"catch" @keyword
"continue" @keyword
"do" @keyword
"else" @keyword
"end" @keyword
"finally" @keyword
"for" @keyword
"foreach" @keyword
"function" @keyword
"if" @keyword
"in" @keyword
"return" @keyword
"switch" @keyword
"throw" @keyword
"try" @keyword
"while" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket

; Source: vendor/grammars/powershell/queries/highlights.scm

"param" @keyword

"dynamicparam" @keyword

"begin" @keyword

"process" @keyword

"end" @keyword

"if" @keyword

"elseif" @keyword

"else" @keyword

"switch" @keyword

"foreach" @keyword

"for" @keyword

"while" @keyword

"do" @keyword

"until" @keyword

"function" @keyword

"filter" @keyword

"workflow" @keyword

"break" @keyword

"continue" @keyword

"throw" @keyword

"return" @keyword

"exit" @keyword

"trap" @keyword

"try" @keyword

"catch" @keyword

"finally" @keyword

"data" @keyword

"inlinescript" @keyword

"parallel" @keyword

"sequence" @keyword

"-as" @operator

"-ccontains" @operator

"-ceq" @operator

"-cge" @operator

"-cgt" @operator

"-cle" @operator

"-clike" @operator

"-clt" @operator

"-cmatch" @operator

"-cne" @operator

"-cnotcontains" @operator

"-cnotlike" @operator

"-cnotmatch" @operator

"-contains" @operator

"-creplace" @operator

"-csplit" @operator

"-eq" @operator

"-ge" @operator

"-gt" @operator

"-icontains" @operator

"-ieq" @operator

"-ige" @operator

"-igt" @operator

"-ile" @operator

"-ilike" @operator

"-ilt" @operator

"-imatch" @operator

"-in" @operator

"-ine" @operator

"-inotcontains" @operator

"-inotlike" @operator

"-inotmatch" @operator

"-ireplace" @operator

"-is" @operator

"-isnot" @operator

"-isplit" @operator

"-join" @operator

"-le" @operator

"-like" @operator

"-lt" @operator

"-match" @operator

"-ne" @operator

"-notcontains" @operator

"-notin" @operator

"-notlike" @operator

"-notmatch" @operator

"-replace" @operator

"-shl" @operator

"-shr" @operator

"-split" @operator

"-and" @operator

"-or" @operator

"-xor" @operator

"-band" @operator

"-bor" @operator

"-bxor" @operator

"+" @operator

"-" @operator

"/" @operator

"\\" @operator

"%" @operator

"*" @operator

".." @operator

"-not" @operator

";" @delimiter

(string_literal) @string

(integer_literal) @number

(real_literal) @number

(command
  command_name: (command_name) @function)

(function_statement
  (function_name) @function)

(invokation_expression
  (member_name) @function)

(member_access
  (member_name) @property)

(command_invokation_operator) @operator

(type_spec) @type

(variable) @variable

(comment) @comment

(array_expression) @array

(assignment_expression
  value: (pipeline) @assignvalue)
