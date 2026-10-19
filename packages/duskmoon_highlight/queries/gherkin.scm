; DuskMoon Tree-sitter highlights. Upstream sources remain under vendor/.

; Structural fallback captures use grammar terminals and named syntax nodes.

(additional_step_keyword) @keyword
(doc_string) @string
(doc_string_content) @string
(doc_string_content_type) @string
(doc_string_delimiter) @string
(and_keyword) @keyword
(asterisk_keyword) @keyword
(background_keyword) @keyword
(but_keyword) @keyword
(comment) @comment
(feature_keyword) @keyword
(given_keyword) @keyword
(rule_keyword) @keyword
(scenario_keyword) @keyword
(then_keyword) @keyword
(when_keyword) @keyword
"|" @operator

; Source: vendor/grammars/gherkin/queries/highlights.scm

[
  (feature_keyword)
  (rule_keyword)
  (background_keyword)
  (scenario_keyword)
  (given_keyword)
  (when_keyword)
  (then_keyword)
  (and_keyword)
  (but_keyword)
  (asterisk_keyword)
] @keyword

(tag) @tag

(doc_string) @string

(data_table) @special

(comment) @comment
