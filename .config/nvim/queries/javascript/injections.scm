(variable_declarator
  name: (identifier) @_name (#match? @_name ".+(Html|Svg|Tpl)$")
  value: (template_string
    (string_fragment) @injection.content (#set! injection.language "html")
  )
)

(variable_declarator
  name: (identifier) @_name (#match? @_name ".+(Html|Svg|Tpl)$")
  value: (arrow_function
    body: (template_string
      (string_fragment) @injection.content (#set! injection.language "html")
    )
  )
)

(augmented_assignment_expression
  left: (identifier) @_name (#match? @_name ".+(Html|Svg|Tpl)$")
  right: (template_string
    (string_fragment) @injection.content (#set! injection.language "html")
  )
)

(object
  (pair
    (property_identifier) @_name (#match? @_name ".+(Shader)$")
    (template_string
      (string_fragment) @injection.content (#set! injection.language "glsl")
    )
  )
)

(lexical_declaration
  (variable_declarator
    (identifier) @_name (#match? @_name ".+(Shader)$")
    (template_string
      (string_fragment) @injection.content (#set! injection.language "glsl")
    )
  )
)
