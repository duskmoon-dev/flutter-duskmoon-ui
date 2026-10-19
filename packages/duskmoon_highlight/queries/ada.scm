; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(floating_point_definition) @number
(formal_floating_point_definition) @number
(formal_signed_integer_type_definition) @number
(number_declaration) @number
(signed_integer_type_definition) @number
(comment) @comment
(identifier) @variable
(numeric_literal) @number
(string_literal) @string
"&" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"+" @operator
"," @punctuation.delimiter
"-" @operator
"." @punctuation.delimiter
"/" @operator
"/=" @operator
":" @punctuation.delimiter
";" @punctuation.delimiter
"<" @operator
"<=" @operator
"=" @operator
"=>" @operator
">" @operator
">=" @operator
"Class" @keyword
"[" @punctuation.bracket
"]" @punctuation.bracket
"abstract" @keyword
"and" @keyword
"begin" @keyword
"case" @keyword
"do" @keyword
"else" @keyword
"elsif" @keyword
"end" @keyword
"finally" @keyword
"for" @keyword
"function" @keyword
"if" @keyword
"in" @keyword
"interface" @keyword
"is" @keyword
"new" @keyword
"not" @keyword
"of" @keyword
"or" @keyword
"package" @keyword
"private" @keyword
"protected" @keyword
"raise" @keyword
"return" @keyword
"select" @keyword
"then" @keyword
"type" @keyword
"use" @keyword
"when" @keyword
"while" @keyword
"with" @keyword
"|" @operator
(function_call name: (_) @function)
(function_specification name: (_) @function)
(iterator_procedure_call name: (_) @function)
(procedure_call_statement name: (_) @function)

; Source: vendor/grammars/ada/queries/highlights.scm

[
   "abort"
   "abs"
   "abstract"
   "accept"
   "access"
   "all"
   "array"
   "at"
   "begin"
   "declare"
   "delay"
   "delta"
   "digits"
   "do"
   "end"
   "entry"
   "exit"
   "finally"
   "generic"
   "interface"
   "is"
   "limited"
   "null"
   "of"
   "others"
   "out"
   "pragma"
   "private"
   "range"
   "synchronized"
   "tagged"
   "task"
   "terminate"
   "until"
   "when"
] @keyword

[
   "aliased"
   "constant"
   "renames"
] @storageclass

[
   "mod"
   "new"
   "protected"
   "record"
   "subtype"
   "type"
] @keyword.type

[
   "with"
   "use"
] @include

[
   "body"
   "function"
   "overriding"
   "procedure"
   "package"
   "separate"
] @keyword.function

[
   "and"
   "in"
   "not"
   "or"
   "xor"
] @keyword.operator

[
   "while"
   "loop"
   "for"
   "parallel"
   "reverse"
   "some"
] @repeat

[
   "return"
] @keyword.return

[
   "case"
   "if"
   "else"
   "then"
   "elsif"
   "select"
] @conditional

[
   "exception"
   "raise"
] @exception

(comment) @comment @spell

(string_literal) @string

(character_literal) @string

(numeric_literal) @number

;; Highlight the name of subprograms

(procedure_specification name: (_) @function)

(function_specification name: (_) @function)

(package_declaration name: (_) @function)

(package_body name: (_) @function)

(generic_instantiation name: (_) @function)

(entry_declaration . (identifier) @function)

;; Some keywords should take different categories depending on the context

(use_clause "use"  @include "type" @include)

(with_clause "private" @include)

(with_clause "limited" @include)

(use_clause (_) @namespace)

(with_clause (_) @namespace)

(loop_statement "end" @keyword.repeat)

(if_statement "end" @conditional)

(loop_parameter_specification "in" @keyword.repeat)

(loop_parameter_specification "in" @keyword.repeat)

(iterator_specification ["in" "of"] @keyword.repeat)

(range_attribute_designator "range" @keyword.repeat)

(raise_statement "with" @exception)

(gnatprep_declarative_if_statement)  @preproc

(gnatprep_if_statement)              @preproc

(gnatprep_identifier)                @preproc

(subprogram_declaration "is" @keyword.function "abstract"  @keyword.function)

(aspect_specification "with" @keyword.function)

(full_type_declaration "is" @keyword.type)

(subtype_declaration "is" @keyword.type)

(record_definition "end" @keyword.type)

(full_type_declaration (_ "access" @keyword.type))

(array_type_definition "array" @keyword.type "of" @keyword.type)

(access_to_object_definition "access" @keyword.type)

(access_to_object_definition "access" @keyword.type
   [
      (general_access_modifier "constant" @keyword.type)
      (general_access_modifier "all" @keyword.type)
   ]
)

(range_constraint "range" @keyword.type)

(signed_integer_type_definition "range" @keyword.type)

(index_subtype_definition "range" @keyword.type)

(record_type_definition "abstract" @keyword.type)

(record_type_definition "tagged" @keyword.type)

(record_type_definition "limited" @keyword.type)

(record_type_definition (record_definition "null" @keyword.type))

(private_type_declaration "is" @keyword.type "private" @keyword.type)

(private_type_declaration "tagged" @keyword.type)

(private_type_declaration "limited" @keyword.type)

(task_type_declaration "task" @keyword.type "is" @keyword.type)

;; Gray the body of expression functions

(expression_function_declaration
   (function_specification)
   "is"
   (_) @attribute
)

(subprogram_declaration (aspect_specification) @attribute)

;; Highlight full subprogram specifications
;(subprogram_body
;    [
;       (procedure_specification)
;       (function_specification)
;    ] @function.spec
;)

((comment) @comment.documentation
  . [
      (entry_declaration)
      (subprogram_declaration)
      (parameter_specification)
    ])

(compilation_unit 
  . (comment) @comment.documentation)

(component_list
  (component_declaration)
    . (comment) @comment.documentation)

(enumeration_type_definition 
  (identifier)
  . (comment) @comment.documentation)

;; Highlight errors in red. This is not very useful in practice, as text will
;; be highlighted as user types, and the error could be elsewhere in the code.
;; This also requires defining    :hi @error guifg=Red    for instance.

(ERROR) @error
