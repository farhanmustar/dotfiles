-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'null-ls')
if not ok then
  return
end

local null_ls = require('null-ls')
local helpers = require('null-ls.helpers')
local plenary_path = require('plenary.path')
null_ls.setup({
  -- debug = true,
})

-- Keyboard Shortcut
vim.keymap.set('n', '<leader>af', bind(vim.lsp.buf.format, {timeout_ms = 3000}))
vim.keymap.set('n', '<leader>ee', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>ej', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>ek', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>e;', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>ed', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover)
local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = true})
end

-- Configs
vim.cmd([[
augroup lspbehaviour
  autocmd!
  autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({open = false})
  autocmd CursorMoved,CursorHold * lua if vim.fn.mode() == "n" then vim.diagnostic.open_float({focus = false}) end
augroup END
]])
vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	float = {
		border = "single",
		format = function(diagnostic)
			return string.format(
				"%s: %s (%s)",
				(diagnostic.code or diagnostic.user_data and diagnostic.user_data.lsp and diagnostic.user_data.lsp.code) or '#',
				diagnostic.message,
				diagnostic.source
			)
		end,
	},
})

-- Misc
local refactoring = null_ls.builtins.code_actions.refactoring
null_ls.register(refactoring)

-- Python
local flake8 = null_ls.builtins.diagnostics.flake8.with({
  -- extra_args = {'--max-line-length=199', '--ignore=W504,E128'}, -- more strict mode
  extra_args = {'--max-line-length=199', '--ignore=W606,W605,W504,E128,F841,E731'},
})
local autopep8 = null_ls.builtins.formatting.autopep8.with({
  extra_args = {'-aa', '--max-line-length=199', '--ignore=E128,E722'},
})
local compile_path = vim.fn.expand('<sfile>:p:h')..'/compile.py'
local python_compile = {
  name = 'python_compile',
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {'python',},
  generator = null_ls.generator({
    command = 'python',
    args = { compile_path, '-' },
    to_stdin = true,
    format = 'line',
		check_exit_code = function(code, stderr)
			return code <= 1
		end,
    on_output = helpers.diagnostics.from_patterns({
      {
        pattern = [[[^:]:(%d+):(%d+): (.*)]],
        groups = { "row", "col", "message" },
      },
    }),
  }),
}
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
null_ls.register(python_compile)
if vim.fn.executable('rosrun') ~= 0 then
  null_ls.register(roslint_pep8)
end

-- Javascript
local jshint = {
  name = 'jshint',
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {'javascript',},
  generator = null_ls.generator({
    dynamic_command = function(params)
      if vim.b.null_ls_js_jshintrc ~= nil then
        return {'jshint', '--config', vim.b.null_ls_js_jshintrc}
      end
      local mod = ':p:h'
      local path = vim.fn.fnamemodify(params.bufname, mod)
      local root = plenary_path.path.root(path)
      while path ~= root do
        local jshintrc = path..'/.jshintrc'
        if vim.fn.glob(jshintrc) ~= '' then
          vim.b.null_ls_js_jshintrc = jshintrc
          return {'jshint', '--config', jshintrc}
        end
        mod = mod..':h'
        path = vim.fn.fnamemodify(params.bufname, mod)
      end
      return 'jshint'
    end,
    args = {'$FILENAME'},
    to_stdin = false,
    to_temp_file = true,
    format = 'line',
		check_exit_code = function(code, stderr)
			return code > 0
		end,
    on_output = helpers.diagnostics.from_patterns({
      {
        pattern = [[[^:]: line (%d+), col (%d+), (.*)]],
        groups = { "row", "col", "message" },
      },
    }),
  }),
}
local js_beautify = {
  name = 'js-beautify',
  method = null_ls.methods.FORMATTING,
  filetypes = {'javascript',},
  generator = null_ls.formatter({
    command = 'js-beautify',
    args = {'--jslint-happy', '-s', '2', '-n', '-f', '-'},
    to_stdin = true,
  }),
}
null_ls.register(jshint)
null_ls.register(js_beautify)

-- Html
-- local djlint = null_ls.builtins.formatting.djlint, -- python 3

-- Golang
require('lspconfig').gopls.setup({
  on_attach = on_attach,
})

-- c/c++
local cpplint = {
  name = 'cpplint',
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {'c', 'cpp', 'h',},
  generator = null_ls.generator({
    command = 'cpplint',
    args = { '--filter=-legal/copyright,-readability/todo,-readability/casting,-whitespace/braces,-whitespace/newline,whitespace/comments,readability/multiline_comment', '-' },
    to_stdin = true,
    from_stderr = true,
    format = 'line',
		check_exit_code = function(code, stderr)
			return code <= 1
		end,
    on_output = helpers.diagnostics.from_patterns({
      {
        pattern = [[[^:]:(%d+):  (.*)]],
        groups = { "row", "message" },
      },
    }),
  }),
}
null_ls.register(cpplint)

local astyle = null_ls.builtins.formatting.astyle.with({
  extra_args = {'--mode=c', '--style=allman', '--indent=spaces=2', '--pad-oper', '--unpad-paren', '--pad-header', '--convert-tabs'}
})
null_ls.register(astyle)
