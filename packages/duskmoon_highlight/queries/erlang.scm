; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(_string_like) @string
(macro_string) @string
(multi_string) @string
(string) @string
(type_name) @type
(char) @character
(comment) @comment
(float) @number
(integer) @number
"!" @operator
"&&" @operator
"(" @punctuation.bracket
")" @punctuation.bracket
"*" @operator
"+" @operator
"," @punctuation.delimiter
"-" @operator
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
"=>" @operator
">" @operator
">=" @operator
"[" @punctuation.bracket
"]" @punctuation.bracket
"and" @keyword
"begin" @keyword
"case" @keyword
"catch" @keyword
"elif" @keyword
"else" @keyword
"end" @keyword
"export" @keyword
"fun" @keyword
"if" @keyword
"import" @keyword
"include" @keyword
"module" @keyword
"not" @keyword
"of" @keyword
"or" @keyword
"try" @keyword
"type" @keyword
"when" @keyword
"where" @keyword
"{" @punctuation.bracket
"|" @operator
"||" @operator
"}" @punctuation.bracket
(function_clause name: (_) @function)
(macro_call_expr name: (_) @function)
(type_alias name: (_) @type)

; Source: vendor/grammars/erlang/queries/highlights.scm

(string) @string

(char) @constant

(integer) @number

(var) @variable

(atom) @string.special.symbol

;;; Comments

((var) @comment.discard
 (#match? @comment.discard "^_"))

(dotdotdot) @comment.discard

(comment) @comment

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions

(fa fun: (atom) @function)

(type_name name: (atom) @function)

(call expr: (atom) @function)

(function_clause name: (atom) @function)

(internal_fun fun: (atom) @function)

;; This is a fudge, we should check that the operator is '/'
;; But our grammar does not (currently) provide it

(binary_op_expr lhs: (atom) @function rhs: (integer))

;; Others

(remote_module module: (atom) @module)

(remote fun: (atom) @function)

(macro_call_expr name: (var) @constant)

(macro_call_expr name: (var) @keyword.directive args: (_) )

(macro_call_expr name: (atom) @keyword.directive)

(record_field_name name: (atom) @property)

(record_name name: (atom) @type)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Attributes

;; module attribute

(module_attribute
  name: (atom) @module)

;; behaviour

(behaviour_attribute name: (atom) @module)

;; export

;; Import attribute

(import_attribute
    module: (atom) @module)

;; export_type

;; optional_callbacks

;; compile

(compile_options_attribute
    options: (tuple
      expr: (atom)
      expr: (list
        exprs: (binary_op_expr
          lhs: (atom)
          rhs: (integer)))))

;; file attribute

;; record

(record_decl name: (atom) @type)

(record_decl name: (macro_call_expr name: (var) @constant))

(record_field name: (atom) @property)

;; type alias

;; opaque

;; Spec attribute

(spec fun: (atom) @function)

(spec
  module: (module name: (atom) @module)
  fun: (atom) @function)

;; callback

(callback fun: (atom) @function)

;; wild attribute

(wild_attribute name: (attr_name name: (atom) @keyword))

;; fun decl

;; include/include_lib

;; ifdef/ifndef

(pp_ifdef name: (_) @keyword.directive)

(pp_ifndef name: (_) @keyword.directive)

;; define

(pp_define
    lhs: (macro_lhs
      name: (var) @constant))

(pp_define
    lhs: (macro_lhs
      name: (_) @keyword.directive
      args: (var_args args: (var))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Reserved words

[ "after"
  "and"
  "band"
  "begin"
  "behavior"
  "behaviour"
  "bnot"
  "bor"
  "bsl"
  "bsr"
  "bxor"
  "callback"
  "case"
  "catch"
  "compile"
  "define"
  "div"
  "elif"
  "else"
  "end"
  "endif"
  "export"
  "export_type"
  "file"
  "fun"
  "if"
  "ifdef"
  "ifndef"
  "import"
  "include"
  "include_lib"
  "module"
  "of"
  "opaque"
  "optional_callbacks"
  "or"
  "receive"
  "record"
  "spec"
  "try"
  "type"
  "undef"
  "unit"
  "when"
  "xor"] @keyword

["andalso" "orelse"] @keyword.operator

;; Punctuation

["," "." ";"] @punctuation.delimiter

["(" ")" "{" "}" "[" "]" "<<" ">>"] @punctuation.bracket

;; Operators

["!"
 "->"
 "<-"
 "#"
 "::"
 ":>"
 "|"
 ":"
 "="
 "||"

 "+"
 "-"
 "bnot"
 "not"

 "/"
 "*"
 "div"
 "rem"
 "band"
 "and"

 "+"
 "-"
 "bor"
 "bxor"
 "bsl"
 "bsr"
 "or"
 "xor"

 "++"
 "--"

 "=="
 "/="
 "=<"
 "<"
 ">="
 ">"
 "=:="
 "=/="
 ] @operator
