; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(number) @number
(boolean) @boolean
(comment) @comment
(float) @number
(identifier) @variable
(string) @string
"!" @operator
"!=" @operator
"%" @operator
"&&" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"+" @operator
"," @punctuation.delimiter
"-" @operator
"." @punctuation.delimiter
"/" @operator
":" @punctuation.delimiter
";" @punctuation.delimiter
"<" @operator
"<=" @operator
"=" @operator
"==" @operator
">" @operator
">=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"else" @keyword
"false" @keyword
"for" @keyword
"function" @keyword
"if" @keyword
"include" @keyword
"let" @keyword
"module" @keyword
"true" @keyword
"use" @keyword
"{" @punctuation.bracket
"||" @operator
"}" @punctuation.bracket
(function_call function: (_) @function)
(function_declaration name: (_) @function)
(module_call name: (_) @function)

; Source: vendor/grammars/openscad/queries/highlights.scm

"include" @keyword.import

(include_path) @string

; Functions

(function_call function: (identifier) @function (#set! "priority" 105))

(module_call name: (identifier) @function (#set! "priority" 105))

; Variables

(identifier) @variable

(special_variable) @variable.builtin

; TODO: Types/Properties/

; Keywords

[
 "module"
 "function"
 "let"
 "assign"
 "use"
 "each"
 ] @keyword

; Operators

[
 "||"
 "&&"
 "=="
 "!="
 "<"
 ">"
 "<="
 ">="
 "+"
 "-"
 "*"
 "/"
 "%"
 "^"
 "!"
 ":"
 ] @operator

; Builtins

((identifier) @function.builtin
			  (#any-of? @function.builtin
			   "union"
			   "difference"
			   "intersection"
			   "circle"
			   "square"
			   "polygon"
			   "text"
			   "import"
			   "projection"
			   "sphere"
			   "cube"
			   "cylinder"
			   "polyhedron"
			   "linear_extrude"
			   "rotate_extrude"
			   "surface"
			   "translate"
			   "rotate"
			   "scale"
			   "resize"
			   "mirror"
			   "multmatrix"
			   "color"
			   "offset"
			   "hull"
			   "minkowski"
			   ))

((identifier) @identifier
			  (#eq? @identifier "PI")) @constant.builtin

; Conditionals

[
 "if"
 "else"
 ] @keyword.conditional

(ternary_expression
  ["?" ":"] @keyword.conditional.ternary)

; Repeats

[
 "for"
 "intersection_for"
 ] @keyword.repeat

; Literals

(decimal) @number

(float) @number.float

(string) @string

(boolean) @boolean

; Misc

[
 "#"
 ] @punctuation.special

["{" "}"] @punctuation.bracket

["(" ")"] @punctuation.bracket

["[" "]"] @punctuation.bracket

[
 ";"
 ","
 "."
 ] @punctuation.delimiter

; Comments

(comment) @comment @spell
