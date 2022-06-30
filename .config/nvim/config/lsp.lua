-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'null-ls')
if not ok then
  return
end

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    -- Python
    null_ls.builtins.diagnostics.flake8.with({
      -- more strict mode
      -- extra_args = {'--max-line-length=199', '--ignore=W504,E128'},
      extra_args = {'--max-line-length=199', '--ignore=W606,W605,W504,E128,F841,E731'},
    }),
    null_ls.builtins.formatting.autopep8.with({
      extra_args = {'-aa', '--max-line-length=199', '--ignore=E128,E722'},
    }),

    -- Html
    -- null_ls.builtins.formatting.djlint, -- python 3
  },
})

-- Keyboard Shortcut
vim.keymap.set('n', '<leader>af', vim.lsp.buf.format)
