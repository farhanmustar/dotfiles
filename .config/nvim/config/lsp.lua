-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'null-ls')
if not ok then
  return
end

local null_ls = require('null-ls')
local helpers = require('null-ls.helpers')
local cmd_resolver = require("null-ls.helpers.command_resolver")
local plenary_path = require('plenary.path')
null_ls.setup({
  -- debug = true,
  sources = {
    null_ls.builtins.code_actions.gitsigns,
  },
  should_attach = function(bufnr)
    if vim.g.disable_lsp then
      return false
    end

    -- perf issue with large file.
    if vim.api.nvim_buf_line_count(bufnr) > 10000 then
      return false
    end
    return true
  end,
})

-- Keyboard Shortcut
vim.keymap.set('n', '<leader>af', bind(vim.lsp.buf.format, {timeout_ms = 3000}))
vim.keymap.set('n', '<leader>ee', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>ej', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>ek', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>e;', vim.lsp.buf.code_action)
vim.keymap.set('n', '<leader>ed', vim.lsp.buf.definition)
vim.keymap.set('n', '<leader>et', vim.lsp.buf.type_definition)
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover)
local on_attach = function(client, bufnr)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, {buffer = true})
end
local function create_code_action(title, action_fn)
  return {
    method = null_ls.methods.CODE_ACTION,
    filetypes = { "_all" },
    generator = {
      fn = function()
        return {
          {
            title = title,
            action = action_fn
          }
        }
      end
    }
  }
end
null_ls.register(create_code_action("Rename Symbol", vim.lsp.buf.rename))
null_ls.register(create_code_action("List Implementations", vim.lsp.buf.implementation))
null_ls.register(create_code_action("List References", vim.lsp.buf.references))
null_ls.register(create_code_action("List Incoming Calls", vim.lsp.buf.incoming_calls))
null_ls.register(create_code_action("View Signature", vim.lsp.buf.signature_help))
null_ls.register(create_code_action("List Hierarchy", vim.lsp.buf.typehierarchy))

-- Configs
vim.cmd([[
function! s:EnableDiagnosticPopup() abort
  augroup diagnosticpopbehaviour
    autocmd!
    autocmd CursorMoved,CursorHold * lua if vim.fn.mode() == "n" then vim.diagnostic.open_float({focus = false}) end
  augroup END
endfunction

function! s:DisableDiagnosticPopup() abort
  augroup diagnosticpopbehaviour
    autocmd!
  augroup END
endfunction

call s:EnableDiagnosticPopup()
command! -nargs=0 DisableDiagnosticPopup silent call <SID>DisableDiagnosticPopup()
command! -nargs=0 EnableDiagnosticPopup silent call <SID>EnableDiagnosticPopup()
command! -nargs=0 DisableDiagnostic silent lua vim.diagnostic.disable(0, nil); vim.diagnostic.reset(nil, 0)
command! -nargs=0 EnableDiagnostic silent lua vim.diagnostic.enable(0, nil)
command! -nargs=0 DisableAllDiagnostic silent lua vim.diagnostic.disable(); vim.diagnostic.reset()
command! -nargs=0 EnableAllDiagnostic silent lua vim.diagnostic.enable()

augroup diagnosticbehaviour
  autocmd!
  autocmd DiagnosticChanged * lua vim.diagnostic.setloclist({open = false})
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

vim.api.nvim_create_user_command("NullLsReset", function()
  for _, source in ipairs(null_ls.get_sources()) do
    source.generator._failed = false
  end
end, {})

-- TODO: auto trigger DisableLsp when user run cdo command.
vim.api.nvim_create_user_command("DisableLsp", function()
  vim.g.disable_lsp = true
  vim.lsp.stop_client(vim.lsp.get_active_clients())
end, {})

vim.api.nvim_create_user_command("EnableLsp", function()
  -- TODO: notify to trigger edit manually to start lsp
  vim.g.disable_lsp = false
  vim.api.nvim_cmd({cmd='NullLsReset'}, {})
end, {})

-- Misc
local refactoring = null_ls.builtins.code_actions.refactoring
null_ls.register(refactoring)

-- Html

local tidy_diagnostic = null_ls.builtins.diagnostics.tidy.with({
  extra_args = {
    '--mute-id', 'yes',
    '--mute', 'TRIM_EMPTY_ELEMENT',
  },
})
local tidy_formatter = null_ls.builtins.formatting.tidy.with({
  extra_args = {
    '--drop-empty-elements', 'no',
    '--drop-empty-paras', 'no',
    '--merge-divs', 'no',
    '--merge-spans', 'no',
    '--preserve-entities', 'yes',
  },
})
null_ls.register(tidy_diagnostic)
null_ls.register(tidy_formatter)

-- Lua
local luacheck = null_ls.builtins.diagnostics.luacheck
null_ls.register(luacheck)

-- Python

-- require('lspconfig').pyright.setup({
--   on_attach = on_attach,
-- })

local flake8 = null_ls.builtins.diagnostics.flake8.with({
  -- extra_args = {'--max-line-length=199', '--ignore=W504,E128'}, -- more strict mode
  extra_args = {'--max-line-length=199', '--ignore=W606,W605,W504,E128,F841,E731,E741'},
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
    command = vim.fn.executable('python') == 1 and 'python' or 'python3',
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
    args = {'roslint', 'pep8', '--max-line-length=199', '--ignore=E128', '-'},
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
  -- tmp disable for noetic
  local output = vim.fn.system('rosrun roslint pep8 /dev/null')
  if output == 0 then
    -- null_ls.register(roslint_pep8)
  end
end

-- Javascript
local jshint = {
  name = 'jshint',
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {'javascript',},
  generator = null_ls.generator({
    dynamic_command = function(params)
      if params.bufname:startswith('fugitive') then
        return nil
      end
      if vim.b.null_ls_js_jshint ~= nil then
        return vim.b.null_ls_js_jshint
      end
      local mod = ':p:h'
      local path = vim.fn.fnamemodify(params.bufname, mod)
      local root = plenary_path.path.root(path)
      local max = 100
      while path ~= root and max > 0 do
        local jshintrc = path..'/.jshintrc'
        if vim.fn.glob(jshintrc) ~= '' then
          vim.b.null_ls_js_jshint = {'jshint', '--config', jshintrc}
          return vim.b.null_ls_js_jshint
        end
        mod = mod..':h'
        local old_path = path
        path = vim.fn.fnamemodify(params.bufname, mod)
        if old_path == path then
          break
        end
        max = max - 1
      end
      vim.b.null_ls_js_jshint = 'jshint'
      return vim.b.null_ls_js_jshint
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
    dynamic_command = cmd_resolver.from_node_modules(),
    command = 'js-beautify',
    args = {'--jslint-happy', '-s', '2', '-n', '-f', '-'},
    to_stdin = true,
  }),
}
local prettier = null_ls.builtins.formatting.prettier.with({
  filetypes = {
    "javascript",
    "typescript",
    "svelte",
  }
})
local eslint_action = null_ls.builtins.code_actions.eslint.with({
  filetypes = {
    "javascript",
    "typescript",
    "svelte",
  }
})
local eslint =  null_ls.builtins.diagnostics.eslint.with({
  filetypes = {
    "javascript",
    "typescript",
    "svelte",
  }
})
local prettylint = {
  name = 'prettylint',
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = {
    "javascript",
    "typescript",
    "svelte",
  },
  generator = null_ls.generator({
    dynamic_command = cmd_resolver.from_node_modules(),
    command = 'prettylint',
    args = {'$FILENAME'},
    ignore_stderr = true,
    format = 'line',
    to_temp_file = true,
		check_exit_code = function(code, stderr)
			return code > 0
		end,
    cwd = function(params)
      return vim.fn.fnamemodify(params.bufname, ":h")
    end,
    on_output = helpers.diagnostics.from_patterns({
      {
        pattern = [[[^%d]+(%d+):(%d+)(.*)]],
        groups = { "row", "col", "message" },
      },
    }),
  }),
}
-- null_ls.register(jshint)
-- null_ls.register(js_beautify)
null_ls.register(prettier)
null_ls.register(eslint_action)
null_ls.register(eslint)
null_ls.register(prettylint)

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
    args = { '--filter=-legal/copyright,-readability/todo,-readability/casting,-whitespace/braces,-whitespace/newline,-whitespace/comments,-readability/multiline_comment', '-' },
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
require('lspconfig').clangd.setup({
  on_attach = on_attach,
})

local astyle = null_ls.builtins.formatting.astyle.with({
  extra_args = {'--mode=c', '--style=allman', '--indent=spaces=2', '--pad-oper', '--unpad-paren', '--pad-header', '--convert-tabs'}
})
null_ls.register(astyle)

-- rust
require('lspconfig').rust_analyzer.setup({
  on_attach = on_attach,
  on_init = function(client, initialization_result)
    -- disable lsp highlight.
    if client.server_capabilities then

      client.server_capabilities.documentSymbolProvider = false
      client.server_capabilities.documentHighlightProvider = false
      -- client.server_capabilities.referencesProvider = false
      client.server_capabilities.renameProvider = false
      -- client.server_capabilities.hoverProvider = false
      -- client.server_capabilities.completionProvider = false

      client.server_capabilities.semanticTokensProvider = nil
      client.server_capabilities.codeActionProvider = nil
    end
  end,
  settings = {
    ['rust-analyzer'] = {
      cachePriming = {
        enable = false,
      },
      procMacro = {
        enable = false,
      },
      checkOnSave = false,
      diagnostics = {
        enable = false,
        experimental = {
          enable = false,
        }
      }
    }
  }
})

-- c_sharp
require('lspconfig').csharp_ls.setup({})

-- shell
null_ls.register(null_ls.builtins.diagnostics.shellcheck)
null_ls.register(null_ls.builtins.code_actions.shellcheck)
