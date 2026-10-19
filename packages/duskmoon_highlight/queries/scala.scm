; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(boolean_literal) @boolean
(comment) @comment
(identifier) @variable
(interpolated_string) @string
(interpolated_string_expression) @string
(package_identifier) @namespace
(string) @string
(block_comment) @comment
(escape_sequence) @string.escape
(floating_point_literal) @number
(integer_literal) @number
(null_literal) @constant.null
(type_identifier) @type
(xml_comment) @comment
(xml_string) @string
"!" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"+" @operator
"," @punctuation.delimiter
"-" @operator
"->" @operator
"." @punctuation.delimiter
":" @punctuation.delimiter
";" @punctuation.delimiter
"<" @operator
"=" @operator
"=>" @operator
">" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"^" @operator
"abstract" @keyword
"as" @keyword
"case" @keyword
"catch" @keyword
"class" @keyword
"def" @keyword
"do" @keyword
"else" @keyword
"enum" @keyword
"except" @keyword
"export" @keyword
"extends" @keyword
"false" @keyword
"final" @keyword
"finally" @keyword
"for" @keyword
"if" @keyword
"import" @keyword
"match" @keyword
"new" @keyword
"package" @keyword
"private" @keyword
"protected" @keyword
"return" @keyword
"super" @keyword
"then" @keyword
"this" @keyword
"throw" @keyword
"trait" @keyword
"true" @keyword
"try" @keyword
"type" @keyword
"using" @keyword
"val" @keyword
"var" @keyword
"while" @keyword
"with" @keyword
"yield" @keyword
"{" @punctuation.bracket
"|" @operator
"}" @punctuation.bracket
"~" @operator
(call_expression function: (_) @function)
(class_definition name: (_) @type)
(class_parameter name: (_) @type)
(enum_definition name: (_) @type)
(full_enum_case name: (_) @type)
(function_declaration name: (_) @function)
(function_definition name: (_) @function)
(generic_function function: (_) @function)
(simple_enum_case name: (_) @type)

; Source: vendor/grammars/scala/queries/highlights.scm

(field_expression field: (identifier) @property)

(field_expression value: (identifier) @type
 (#match? @type "^[A-Z]"))

(type_identifier) @type

(class_definition
  name: (identifier) @type)

(enum_definition
  name: (identifier) @type)

(object_definition
  name: (identifier) @type)

(trait_definition
  name: (identifier) @type)

(full_enum_case
  name: (identifier) @type)

(simple_enum_case
  name: (identifier) @type)

;; variables

(class_parameter
  name: (identifier) @parameter)

(self_type (identifier) @parameter)

(interpolation (identifier) @none)

(interpolation (block) @none)

;; types

(type_definition
  name: (type_identifier) @type.definition)

;; val/var definitions/declarations

(val_definition
  pattern: (identifier) @variable)

(var_definition
  pattern: (identifier) @variable)

(val_declaration
  name: (identifier) @variable)

(var_declaration
  name: (identifier) @variable)

; imports/exports

(import_declaration
  path: (identifier) @namespace)

((stable_identifier (identifier) @namespace))

((import_declaration
  path: (identifier) @type) (#match? @type "^[A-Z]"))

((stable_identifier (identifier) @type) (#match? @type "^[A-Z]"))

(export_declaration
  path: (identifier) @namespace)

((stable_identifier (identifier) @namespace))

((export_declaration
  path: (identifier) @type) (#match? @type "^[A-Z]"))

((stable_identifier (identifier) @type) (#match? @type "^[A-Z]"))

((namespace_selectors (identifier) @type) (#match? @type "^[A-Z]"))

; method invocation

(call_expression
  function: (identifier) @function.call)

(call_expression
  function: (operator_identifier) @function.call)

(call_expression
  function: (field_expression
    field: (identifier) @method.call))

((call_expression
   function: (identifier) @constructor)
 (#match? @constructor "^[A-Z]"))

(generic_function
  function: (identifier) @function.call)

(interpolated_string_expression
  interpolator: (identifier) @function.call)

; function definitions

(function_definition
  name: (identifier) @function)

(parameter
  name: (identifier) @parameter)

(binding
  name: (identifier) @parameter)

; method definition

(function_declaration
      name: (identifier) @method)

(function_definition
      name: (identifier) @method)

; expressions

(infix_expression operator: (identifier) @operator)

(infix_expression operator: (operator_identifier) @operator)
; An operator taking a colon argument parses as a postfix expression call.

(call_expression
  function: (postfix_expression (identifier) @operator .)
  arguments: (colon_argument))

(infix_type operator: (operator_identifier) @operator)

(infix_type operator: (operator_identifier) @operator)

; literals

(boolean_literal) @boolean

(integer_literal) @number

(floating_point_literal) @float

[
  (string)
  (character_literal)
  (interpolated_string_expression)
] @string

(interpolation "$" @punctuation.special)

;; keywords

(opaque_modifier) @type.qualifier

(infix_modifier) @keyword

(transparent_modifier) @type.qualifier

(open_modifier) @type.qualifier

[
  "case"
  "class"
  "enum"
  "extends"
  "derives"
  "finally"
  "forSome"
;; `macro` not implemented yet
  "object"
  "override"
  "package"
  "trait"
  "type"
  "val"
  "var"
  "with"
  "given"
  "using"
  "implicit"
  "with"
] @keyword

; `end` is scanner-lexed, so the marker node is the only thing to match.

(end_marker) @keyword

; `extension` is a soft keyword. Highlight it only where it starts an
; extension definition, not when used as a plain identifier.

(extension_definition "extension" @keyword)

[
  "abstract"
  "final"
  "lazy"
  "sealed"
  "private"
  "protected"
] @type.qualifier

(inline_modifier) @storageclass

(null_literal) @constant.builtin

(wildcard) @parameter

(annotation) @attribute

;; special keywords

"new" @keyword.operator

[
  "else"
  "if"
  "match"
  "then"
] @conditional

[
 "("
 ")"
 "["
 "]"
 "{"
 "}"
]  @punctuation.bracket

[
 "."
 ","
] @punctuation.delimiter

[
  "do"
  "for"
  "while"
  "yield"
] @repeat

"def" @keyword.function

[
 "=>"
 "<-"
 "@"
] @operator

["import" "export"] @include

[
  "try"
  "catch"
  "throw"
] @exception

"return" @keyword.return

(comment) @spell @comment

(block_comment) @spell @comment

;; `case` is a conditional keyword in case_block

(case_block
  (case_clause ("case") @conditional))

(indented_cases
  (case_clause ("case") @conditional))

(operator_identifier) @operator

((identifier) @type (#match? @type "^[A-Z]"))

((identifier) @variable.builtin
 (#match? @variable.builtin "^this$"))

(
  (identifier) @function.builtin
  (#match? @function.builtin "^super$")
)

;; Scala CLI using directives

(using_directive_key) @parameter

(using_directive_value) @string

;; XML literals

(xml_name) @tag

(xml_attribute key: (xml_name) @tag.attribute)

(xml_string) @string

(xml_text) @spell

(xml_comment) @spell @comment

(xml_cdata) @string

(xml_processing_instruction) @keyword.directive
