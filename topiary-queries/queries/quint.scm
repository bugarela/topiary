; Sometimes we want to indicate that certain parts of our source text should
; not be formatted, but taken as is. We use the leaf capture name to inform the
; tool of this.
[
 (string)
 (comment)
] @leaf

[
 ":"
 "pure"
 "var"
 "const"
 "type"
 "module"
 "all"
 "any"
 "match"
 "if"
 "else"
 (operator_definition)
] @append_space

(module_definition
  (qualified_identifier)
  .
  "{" @append_hardline
  _
  "}" @prepend_hardline
  .
)

[
 (qualified_identifier)
 "="
 "+"
 "-"
 "*"
 "/"
 "%"
 ">"
 "<"
 ">="
 "<="
 "=="
 "!="
 "->"
 "=>"
 "|"
 "and"
 "or"
 "iff"
 "implies"
] @prepend_space @append_space

[
  (comment)
  (constant_declaration)
  (assumption)
  (variable_definition)
  (operator_definition)
  (type_alias)
  (import)
  (export)
  (match_case)
] @prepend_input_softline @append_input_softline @allow_blank_line_before

(module_definition) @allow_blank_line_before @prepend_hardline

; Consecutive definitions must be separated by line breaks
(
  (operator_definition) @append_hardline
  .
  (operator_definition)
)

(
  "{" @append_spaced_softline @append_indent_start
  _
  "}" @prepend_spaced_softline @prepend_indent_end
)

(
  "(" @append_empty_softline @append_indent_start
  _
  ")" @prepend_empty_softline @prepend_indent_end
)

(operator_definition
  (qualified_identifier)
  _
  "=" @append_spaced_softline @append_indent_start
  [ "{" ]* @do_nothing
  (expr) @append_indent_end
)

(operator_application
  (qualified_identifier) @append_antispace
  "("
  (_) @prepend_antispace @append_antispace
  ")"
)

;; TODO: fix me, this is not working and we should probably not ident "else if"s
(if_else_condition
 "if"
 "("
 (expr) @prepend_antispace @append_antispace
 ")" @append_spaced_softline @append_indent_start
 (expr)
 "else" @prepend_indent_end @append_indent_start @append_spaced_softline @prepend_spaced_softline
 (if_else_condition)* @do_nothing
 (expr) @append_indent_end
)

(
  "," @append_spaced_softline
)

; Never put a space before a comma
(
  "," @prepend_antispace
)

; Never put spaces around dots
(
  "." @prepend_antispace @append_antispace
)

; Assignments should always look like x' = 1
(
  "'" @prepend_antispace @append_space
)
