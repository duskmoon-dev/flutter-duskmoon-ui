; DuskMoon Tree-sitter highlights. See grammar manifest for upstream provenance.

(concatenated_string) @string

(null) @constant.null

(number_literal) @number

(primitive_type) @type

(raw_string_literal) @string

(string_literal) @string

(comment) @comment

(escape_sequence) @string.escape

(false) @boolean

(field_identifier) @property

(identifier) @variable

(namespace_identifier) @namespace

(raw_string_content) @string

(raw_string_delimiter) @string

(string_content) @string

(system_lib_string) @string

(true) @boolean

(type_identifier) @type

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

">" @operator

">=" @operator

"[" @punctuation.bracket

"]" @punctuation.bracket

"^" @operator

"and" @keyword

"break" @keyword

"case" @keyword

"catch" @keyword

"class" @keyword

"const" @keyword

"continue" @keyword

"default" @keyword

"do" @keyword

"else" @keyword

"enum" @keyword

"extern" @keyword

"final" @keyword

"for" @keyword

"if" @keyword

"namespace" @keyword

"new" @keyword

"not" @keyword

"or" @keyword

"private" @keyword

"protected" @keyword

"public" @keyword

"return" @keyword

"static" @keyword

"struct" @keyword

"switch" @keyword

"throw" @keyword

"try" @keyword

"typedef" @keyword

"union" @keyword

"using" @keyword

"virtual" @keyword

"while" @keyword

"{" @punctuation.bracket

"|" @operator

"||" @operator

"}" @punctuation.bracket

"~" @operator

(abstract_function_declarator declarator: (_) @function)

(call_expression function: (_) @function)

(class_specifier name: (_) @type)

(enum_specifier name: (_) @type)

(enumerator name: (_) @type)

(function_declarator declarator: (_) @function)

(function_definition declarator: (_) @function)

(preproc_function_def name: (_) @function)

(struct_specifier name: (_) @type)

(template_function name: (_) @function)

(template_method name: (_) @function)

; Source: vendor/grammars/c/queries/highlights.scm

(identifier) @variable

((identifier) @constant
 (#match? @constant "^[A-Z][A-Z\\d_]*$"))

"break" @keyword

"case" @keyword

"const" @keyword

"continue" @keyword

"default" @keyword

"do" @keyword

"else" @keyword

"enum" @keyword

"extern" @keyword

"for" @keyword

"if" @keyword

"inline" @keyword

"return" @keyword

"sizeof" @keyword

"static" @keyword

"struct" @keyword

"switch" @keyword

"typedef" @keyword

"union" @keyword

"volatile" @keyword

"while" @keyword

"#define" @keyword

"#elif" @keyword

"#else" @keyword

"#endif" @keyword

"#if" @keyword

"#ifdef" @keyword

"#ifndef" @keyword

"#include" @keyword

(preproc_directive) @keyword

"--" @operator

"-" @operator

"-=" @operator

"->" @operator

"=" @operator

"!=" @operator

"*" @operator

"&" @operator

"&&" @operator

"+" @operator

"++" @operator

"+=" @operator

"<" @operator

"==" @operator

">" @operator

"||" @operator

"." @delimiter

";" @delimiter

(string_literal) @string

(system_lib_string) @string

(null) @constant

(number_literal) @number

(char_literal) @number

(field_identifier) @property

(statement_identifier) @label

(type_identifier) @type

(primitive_type) @type

(sized_type_specifier) @type

(call_expression
  function: (identifier) @function)

(call_expression
  function: (field_expression
    field: (field_identifier) @function))

(function_declarator
  declarator: (identifier) @function)

(preproc_function_def
  name: (identifier) @function.special)

(comment) @comment

; Source: vendor/grammars/cpp/queries/highlights.scm

(call_expression
  function: (qualified_identifier
    name: (identifier) @function))

(template_function
  name: (identifier) @function)

(template_method
  name: (field_identifier) @function)

(template_function
  name: (identifier) @function)

(function_declarator
  declarator: (qualified_identifier
    name: (identifier) @function))

(function_declarator
  declarator: (field_identifier) @function)

; Types

((namespace_identifier) @type
 (#match? @type "^[A-Z]"))

(auto) @type

; Constants

(this) @variable.builtin

(null "nullptr" @constant)

; Modules

(raw_string_literal) @string

; Source: vendor/grammars/arduino/queries/highlights.scm

((identifier) @function.builtin
  (#any-of? @function.builtin
    ; Digital I/O
    "digitalRead" "digitalWrite" "pinMode"
    ; Analog I/O
    "analogRead" "analogReference" "analogWrite"
    ; Zero, Due & MKR Family
    "analogReadResolution" "analogWriteResolution"
    ; Advanced I/O
    "noTone" "pulseIn" "pulseInLong" "shiftIn" "shiftOut" "tone"
    ; Time
    "delay" "delayMicroseconds" "micros" "millis"
    ; Math
    "abs" "constrain" "map" "max" "min" "pow" "sq" "sqrt"
    ; Trigonometry
    "cos" "sin" "tan"
    ; Characters
    "isAlpha" "isAlphaNumeric" "isAscii" "isControl" "isDigit" "isGraph" "isHexadecimalDigit"
    "isLowerCase" "isPrintable" "isPunct" "isSpace" "isUpperCase" "isWhitespace"
    ; Random Numbers
    "random" "randomSeed"
    ; Bits and Bytes
    "bit" "bitClear" "bitRead" "bitSet" "bitWrite" "highByte" "lowByte"
    ; External Interrupts
    "attachInterrupt" "detachInterrupt"
    ; Interrupts
    "interrupts" "noInterrupts"))

((identifier) @type.builtin
  (#any-of? @type.builtin "Serial" "SPI" "Stream" "Wire" "Keyboard" "Mouse" "String"))

((identifier) @constant.builtin
  (#any-of? @constant.builtin "HIGH" "LOW" "INPUT" "OUTPUT" "INPUT_PULLUP" "LED_BUILTIN"))

(function_definition
  (function_declarator
    declarator: (identifier) @function.builtin)
  (#any-of? @function.builtin "loop" "setup"))

(call_expression
  function: (identifier) @constructor.builtin
  (#any-of? @constructor.builtin "SPISettings" "String"))

(declaration
  (type_identifier) @type.builtin
  (function_declarator
    declarator: (identifier) @constructor.builtin)
  (#eq? @type.builtin "SPISettings"))

; Inherited keyword alternatives restricted to terminals in this grammar.
[
  "catch"
  "class"
  "co_await"
  "co_return"
  "co_yield"
  "constexpr"
  "constinit"
  "consteval"
  "delete"
  "explicit"
  "final"
  "friend"
  "mutable"
  "namespace"
  "noexcept"
  "new"
  "override"
  "private"
  "protected"
  "public"
  "template"
  "throw"
  "try"
  "typename"
  "using"
  "concept"
  "requires"
  "virtual"
] @keyword
