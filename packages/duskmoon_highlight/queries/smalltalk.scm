; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(comment) @comment
(false) @boolean
(identifier) @variable
(keyword) @keyword
(nil) @constant.null
(number) @number
(string) @string
(symbol) @variable
(true) @boolean
"(" @punctuation.bracket
")" @punctuation.bracket
"." @punctuation.delimiter
";" @punctuation.delimiter
"<" @operator
">" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"{" @punctuation.bracket
"|" @operator
"}" @punctuation.bracket

; Source: vendor/grammars/smalltalk/queries/highlights.scm

[(self) (true) (false) (thisContext) (super) (nil)] @keyword

(pragma) @annotation

(number) @number

(string) @string

(symbol) @string

(character) @string

(comment) @comment

(block "|" @punctuation)

(identifier) @variable

(block_argument) @variable

";" @punctuation

"." @punctuation

(unary_message (_) (unary_identifier) @variable.part)

(binary_operator) @variable.part

(keyword) @variable.part

["^" "[" "]" "{" "}"] @important

["(" ")"] @punctuation

(keyword_selector (keyword) @major_declaration.part) @structure.part

(binary_selector (binary_operator) @major_declaration.part) @structure.part

(unary_selector (unary_identifier) @major_declaration.part) @structure.part

[(pragma_keyword_selector) (pragma_unary_selector)] @structure.part

(temporaries) @punctuation.part

(temporaries (identifier) @punctuation)
