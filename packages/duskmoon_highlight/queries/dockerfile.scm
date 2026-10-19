; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(double_quoted_string) @string
(heredoc_block) @string
(json_string) @string
(json_string_array) @string
(single_quoted_string) @string
(unquoted_string) @string
(comment) @comment
(escape_sequence) @string.escape
(heredoc_end) @string
(heredoc_line) @string
(heredoc_marker) @string
(variable) @variable
"," @punctuation.delimiter
":" @punctuation.delimiter
"=" @operator
"AS" @keyword
"FROM" @keyword
"[" @punctuation.bracket
"]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket
(arg_instruction name: (_) @type)

; Source: vendor/grammars/dockerfile/queries/highlights.scm

[
	"FROM"
	"AS"
	"RUN"
	"CMD"
	"LABEL"
	"EXPOSE"
	"ENV"
	"ADD"
	"COPY"
	"ENTRYPOINT"
	"VOLUME"
	"USER"
	"WORKDIR"
	"ARG"
	"ONBUILD"
	"STOPSIGNAL"
	"HEALTHCHECK"
	"SHELL"
	"MAINTAINER"
	"CROSS_BUILD"
	(heredoc_marker)
	(heredoc_end)
] @keyword

[
	":"
	"@"
] @operator

(comment) @comment

(image_spec
	(image_tag
		":" @punctuation.special)
	(image_digest
		"@" @punctuation.special))

[
	(double_quoted_string)
	(single_quoted_string)
	(json_string)
	(heredoc_line)
] @string

(expansion
  [
	"$"
	"{"
	"}"
  ] @punctuation.special
) @none

((variable) @constant
 (#match? @constant "^[A-Z][A-Z_0-9]*$"))
