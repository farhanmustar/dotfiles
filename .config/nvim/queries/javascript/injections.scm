(variable_declarator
  name: (identifier) @_name (#match? @_name ".+(Html|Svg|Tpl)$")
  value: (_) @html
)

(object
  (pair
    (property_identifier) @_name (#match? @_name ".+(Shader)$")
    (template_string
      (string_fragment) @glsl
    )
  )
)
