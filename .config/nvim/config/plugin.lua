-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'scrollbar')
if not ok then
  return
end

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

-- nvim-dap config
local venv = os.getenv("VIRTUAL_ENV")
command = string.format("%s/bin/python",venv)
require('dap-python').setup(command)
require("dapui").setup()
require("nvim-dap-virtual-text").setup()
