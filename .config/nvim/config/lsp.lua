-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'null-ls')
if not ok then
  return
end

local null_ls = require('null-ls')
local helpers = require('null-ls.helpers')
null_ls.setup({})

-- Python
local flake8 = null_ls.builtins.diagnostics.flake8.with({
  -- extra_args = {'--max-line-length=199', '--ignore=W504,E128'}, -- more strict mode
  extra_args = {'--max-line-length=199', '--ignore=W606,W605,W504,E128,F841,E731'},
})
local autopep8 = null_ls.builtins.formatting.autopep8.with({
  extra_args = {'-aa', '--max-line-length=199', '--ignore=E128,E722'},
})
local roslint_pep8 = {
  name = 'roslint_pep8',
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {'python',},
  generator = null_ls.generator({
    command = 'rosrun',
    args = {'roslint', 'pep8', '-'},
    to_stdin = true,
    format = 'line',
		check_exit_code = function(code, stderr)
			print(stderr)
			return code <= 1
		end,
    on_output = helpers.diagnostics.from_patterns({
      {
        pattern = [[[^:]:(%d+):(%d+): ([%w-/]+) (.*)]],
        groups = { "row", "col", "code", "message" },
      },
    }),
  }),
}
null_ls.register(flake8)
null_ls.register(autopep8)
if vim.fn.executable('rosrun') ~= 0 then
  null_ls.register(roslint_pep8)
end

-- Html
-- local djlint = null_ls.builtins.formatting.djlint, -- python 3

-- Keyboard Shortcut
vim.keymap.set('n', '<leader>af', vim.lsp.buf.format)
vim.keymap.set('n', '<leader>ee', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>ej', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>ek', vim.diagnostic.goto_prev)

-- Configs
vim.cmd([[
augroup luabehaviour
  autocmd!
  autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({open = false })
augroup END
]])
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	float = {
		border = "single",
		format = function(diagnostic)
      print(type(diagnostic))
      print_table(diagnostic)
			return string.format(
				"%s: %s (%s)",
				diagnostic.code or diagnostic.user_data.lsp.code,
				diagnostic.message,
				diagnostic.source
			)
		end,
	},
})
