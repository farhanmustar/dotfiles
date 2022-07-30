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

-- LuaSnip config
require("luasnip.loaders.from_vscode").lazy_load()

-- nvim-dap config
local venv = os.getenv("VIRTUAL_ENV")
if vim.fn.has('win32') == 1 then
  command = string.format("%s/Scripts/pythonw",venv)
else
  command = string.format("%s/bin/python",venv)
end
require('dap-python').setup(command, {
  console = 'integratedTerminal',
})
require("dapui").setup()
require("nvim-dap-virtual-text").setup()

local dap = require('dap')

local codelldb_command = '/usr/bin/codelldb'
dap.adapters.codelldb = function(on_adapter)
  -- This asks the system for a free port
  local tcp = vim.loop.new_tcp()
  tcp:bind('127.0.0.1', 0)
  local port = tcp:getsockname().port
  tcp:shutdown()
  tcp:close()

  -- Start codelldb with the port
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local opts = {
    stdio = {nil, stdout, stderr},
    args = {'--port', tostring(port)},
  }
  local handle
  local pid_or_err
  handle, pid_or_err = vim.loop.spawn(codelldb_command, opts, function(code)
    stdout:close()
    stderr:close()
    handle:close()
    if code ~= 0 then
      print("codelldb exited with code", code)
    end
  end)
  if not handle then
    vim.notify("Error running codelldb: " .. tostring(pid_or_err), vim.log.levels.ERROR)
    stdout:close()
    stderr:close()
    return
  end
  vim.notify('codelldb started. pid=' .. pid_or_err)
  stderr:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
      vim.schedule(function()
        require("dap.repl").append(chunk)
      end)
    end
  end)
  local adapter = {
    type = 'server',
    host = '127.0.0.1',
    port = port
  }
  vim.defer_fn(function() on_adapter(adapter) end, 500)
end

dap.configurations.cpp = {
    {
      name = "Attach to process",
      type = 'codelldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      args = {},
    },
}

-- aerial config
require("aerial").setup({
  backends = { "treesitter" },
})
