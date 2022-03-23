require("scrollbar").setup({
  marks = {
    Search = { color = '#1d2021'},
  },
})

require("scrollbar.handlers.search").setup({
  calm_down = true,
  nearest_only = true,
  nearest_float_when = 'always',
  enable_incsearch = false,
})
