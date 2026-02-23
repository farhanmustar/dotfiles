-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'dap')
if not ok then
  return
end

-- nvim-dap config
local dap = require('dap')
local dapui = require("dapui")
local widgets = require('dap.ui.widgets')

dapui.setup({
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
    {
      elements = {
        "console",
      },
      size = 0.5, -- 25% of total lines
      position = "right",
    },
    {
      elements = {
        "repl",
      },
      size = 0.5, -- 25% of total lines
      position = "right",
    },
  },
})
require("nvim-dap-virtual-text").setup()

-- python config
local venv = os.getenv("VIRTUAL_ENV")
if venv == nil then
  command = vim.fn.executable('python') == 1 and 'python' or 'python3'
elseif vim.fn.has('win32') == 1 then
  command = string.format("%s/Scripts/pythonw",venv)
else
  command = string.format("%s/bin/python",venv)
end
require('dap-python').setup(command, {
  console = 'integratedTerminal',
})

-- nvim-dap shortcuts
vim.keymap.set('n', '<leader>dp', dap.toggle_breakpoint, {silent = true})
vim.keymap.set('n', '<leader>d;', function()
  vim.ui.input({prompt = 'Breakpoint condition: '}, function(input)
    if not input then
      return
    end
    dap.set_breakpoint(input)
  end)
end, {silent=true})
vim.keymap.set('n', '<leader>dl', function()
  vim.ui.input({prompt = 'Log point message: '}, function(input)
    if not input then
      return
    end
    dap.set_breakpoint(nil, nil, input)
  end)
end, {silent = true})
vim.keymap.set('n', '<leader>dc', dap.clear_breakpoints, {silent = true})
vim.keymap.set('n', '<leader>dd', dap.continue, {silent = true})
vim.keymap.set('n', '<leader>dj', dap.step_over, {silent = true})
vim.keymap.set('n', '<leader>di', dap.step_into, {silent = true})
vim.keymap.set('n', '<leader>do', dap.step_out, {silent = true})
vim.keymap.set('n', '<leader>du', dap.run_to_cursor, {silent = true})
vim.keymap.set('n', '<leader>ds', dap.terminate, {silent = true})
local isOpen = false
vim.keymap.set('n', '<leader>dv', function()
  if not isOpen then
    dapui.open({reset = true, layout = 1})
    dapui.open({reset = true, layout = 2})
    isOpen = true
  else
    dapui.close({layout = 1})
    dapui.close({layout = 2})
    isOpen = false
  end
end, {silent = true})
vim.keymap.set('n', '<leader>db', function() dapui.toggle({reset = true, layout = 3}) end, {silent = true})
vim.keymap.set('n', '<leader>dr', function() dapui.toggle({reset = true, layout = 4}) end, {silent = true})
vim.keymap.set('n', '<leader>da', function()
  require('dap.ext.vscode').load_launchjs(nil, {
    chrome = {'javascript'},
  })
  print('launch.json loaded')
end, {silent = true})
vim.keymap.set('n', '<leader>dk', function() dapui.eval(nil, {enter = true}) end, {silent = true})

local dapMenuExtra = {
  { 'Watches', function() dapui.float_element('watches', {enter=true}) end },
  { 'Breakpoints', function() dapui.float_element('breakpoints', {enter=true}) end },
  { 'Threads', function() widgets.cursor_float(widgets.threads) end },
  { 'Frames', function() widgets.cursor_float(widgets.frames) end },
}

function showExtraMenu()
  vim.ui.select(dapMenuExtra, {
    prompt = 'Select Debugger Window:',
    format_item = function(item)
      return item[1]
    end,
  }, function(choice)
    if not choice then
      return
    end
    choice[2]()
  end)
end

local dapMenu = {
  { 'Console', function() dapui.float_element('console', {enter=true}) end },
  { 'Scopes', function() dapui.float_element('scopes', {enter=true}) end },
  { 'Console Fullscreen', function() dapui.float_element('console', {enter=true, width=vim.opt.columns:get(), height=vim.opt.lines:get()}) end },
  { 'Repl', function() dapui.float_element('repl', {enter=true}) end },
  { 'Stacks', function() dapui.float_element('stacks', {enter=true}) end },
  { 'Alt Hover', widgets.hover},
  { 'More', showExtraMenu },
}

vim.keymap.set('n', '<leader>dh', function()
  vim.ui.select(dapMenu, {
    prompt = 'Select Debugger Window:',
    format_item = function(item)
      return item[1]
    end,
  }, function(choice)
    if not choice then
      return
    end
    choice[2]()
  end)
end, {silent = true})

-- dap sub mode
local submode = require("submode")

submode.create("DAPMode", {
  mode = "n",
  enter = "<leader>dm",
  leave = { "q", "<ESC>" },
  enter_cb = function()
    vim.api.nvim_echo({ { "-- DAP --", "ModeMsg" } }, false, {})
    vim.notify('DAP Mode Enabled', vim.log.levels.INFO)
  end,
  leave_cb = function()
    vim.api.nvim_echo({ {""} }, false, {})
    vim.notify('DAP Mode Disabled', vim.log.levels.INFO)
  end,
}, {
  lhs = "j",
  rhs = dap.step_over,
}, {
  lhs = "i",
  rhs = dap.step_into,
}, {
  lhs = "o",
  rhs = dap.step_out,
}, {
  lhs = "s",
  rhs = dap.terminate,
}, {
  lhs = "d",
  rhs = dap.continue,
}, {
  lhs = "<space>",
  rhs = dap.continue,
})

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

-- TODO: remove old config if this working for all
dap.adapters.codelldbexe = {
  type = "executable",
  command = 'codelldb',
}

local pick_cur_dir_file = function()
  local label_fn = function(p)
    return string.format("%s", vim.fn.fnamemodify(p, ':~:.'))
  end
  local co = coroutine.running()
  if co then
    return coroutine.create(function()
      local files = require('plenary.scandir').scan_dir(vim.fn.expand('%:p:h'), {hidden=false, depth=1})
      require('dap.ui').pick_one(files, "Select file", label_fn, function(result)
        coroutine.resume(co, result)
      end)
    end)
  else
    local files = require('plenary.scandir').scan_dir(vim.fn.expand('%:p:h'), {hidden=false, depth=1})
    local result = require('dap.ui').pick_one_sync(files, "Select file", label_fn)
    return result or nil
  end
end

dap.configurations.cpp = {
    {
      name = "Attach to process",
      type = 'codelldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      args = {},
    },
    {
      name = "Run python test",
      type = 'codelldb',
      request = 'launch',
      program = 'python',
      args = {'./runtests.py'},
      cwd = '${workspaceFolder}',
    },
    {
      name = "Run file in folder",
      type = 'codelldb',
      request = 'launch',
      program = pick_cur_dir_file,
      cwd = '${workspaceFolder}',
    },
    {
      name = "Run a.out",
      type = 'codelldb',
      request = 'launch',
      program = '${workspaceFolder}/a.out',
      cwd = '${workspaceFolder}',
    },
}

dap.configurations.c = dap.configurations.cpp

table.insert(dap.configurations.python, {
  name = "Python debug runtests",
  type = 'python',
  request = 'launch',
  program = '${workspaceFolder}/runtests.py',
  cwd = '${workspaceFolder}',
})

table.insert(dap.configurations.python, {
  name = "Python debug runtests (with args)",
  type = 'python',
  request = 'launch',
  program = '${workspaceFolder}/runtests.py',
  cwd = '${workspaceFolder}',
  -- justMyCode = false,
  args = function()
    local args_string = vim.fn.input('Arguments: ')
    if args_string == nil or args_string == '' then
      print('dap cancelled.')
      return
    end
    table.insert(dap.configurations.python, {
      name = "Python debug runtests ("..args_string..")",
      type = 'python',
      request = 'launch',
      program = '${workspaceFolder}/runtests.py',
      cwd = '${workspaceFolder}',
      -- justMyCode = false,
      args = vim.split(args_string, " +")
    })
    return vim.split(args_string, " +")
  end;
})

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/.bin/vscode-node-debug2/out/src/nodeDebug.js'},
}
dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = {os.getenv("HOME") .. "/.bin/vscode-chrome-debug/out/src/chromeDebug.js"},
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require('dap.utils').pick_process,
  },
	{
		-- For this to work you need to start chrome with `--remote-debugging-port=9222` flag.
    name = 'Attach to chrome',
		type = "chrome",
		request = "attach",
		program = "${file}",
		cwd = vim.fn.getcwd(),
		sourceMaps = true,
		protocol = "inspector",
		port = 9222,
		webRoot = "${workspaceFolder}"
	}
}

local function find_cargo_root()
  local result = vim.fn.system('cargo locate-project --workspace --message-format=plain 2>/dev/null')
  if vim.v.shell_error == 0 then
    return vim.fn.fnamemodify(result:gsub('\n', ''), ':h')
  end
  return vim.fn.getcwd()
end

local function cargo_program()
  -- TODO: cargo build migh fail silently. make it not silent.
  vim.fn.system('cargo build')

  -- Get package name from cargo metadata (no jq needed)
  local metadata = vim.fn.system('cargo metadata --no-deps --format-version 1')
  local decoded = vim.fn.json_decode(metadata)
  local package_name = decoded.packages[1].name

  return find_cargo_root() .. '/target/debug/' .. package_name
end

local function rust_debug()
  -- Get package name from cargo metadata (no jq needed)
  local metadata = vim.fn.system('cargo metadata --no-deps --format-version 1')
  local decoded = vim.fn.json_decode(metadata)
  local package_name = decoded.packages[1].name

  return find_cargo_root() .. '/target/debug/' .. package_name
end

function rustlldbCommands()
  -- source: https://github.com/rust-lang/rust/blob/main/src/etc/rust-lldb
  -- hint: run rust-lldb and see the top 2 line it exec

  -- Get the rustc sysroot
  local rustc_sysroot = vim.fn.system('rustc --print sysroot'):gsub('%s+$', '')
  if vim.v.shell_error ~= 0 then
    vim.notify('Failed to get rustc sysroot', vim.log.levels.ERROR)
    return {}
  end

  -- Build the paths dynamically
  local script_import = string.format('command script import "%s/lib/rustlib/etc/lldb_lookup.py"', rustc_sysroot)
  local commands_file = string.format('command source -s 0 "%s/lib/rustlib/etc/lldb_commands"', rustc_sysroot)

  return {
    script_import,
    commands_file,
  }
end

dap.configurations.rust = {
  {
    name = "Rust debug",
    type = "codelldbexe",
    request = "launch",
    program = rust_debug,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    initCommands = rustlldbCommands,
  },
  {
    name = "Rust debug (with args)",
    type = "codelldbexe",
    request = "launch",
    program = rust_debug,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    initCommands = rustlldbCommands,
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      if args_string == nil or args_string == '' then
        print('dap cancelled.')
        return
      end
      table.insert(dap.configurations.rust, {
        name = "Rust debug ("..args_string..")",
        type = 'codelldb',
        request = 'launch',
        program = rust_debug,
        cwd = '${workspaceFolder}',
        args = vim.split(args_string, " +"),
        initCommands = rustlldbCommands,
      })
      return vim.split(args_string, " +")
    end;
  },
  {
    name = "Cargo build and run",
    type = "codelldbexe",
    request = "launch",
    program = cargo_program,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    initCommands = rustlldbCommands,
  },
  {
    name = "Cargo build and run (with args)",
    type = "codelldbexe",
    request = "launch",
    program = cargo_program,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    initCommands = rustlldbCommands,
    args = function()
      local args_string = vim.fn.input('Arguments: ')
      if args_string == nil or args_string == '' then
        print('dap cancelled.')
        return
      end
      table.insert(dap.configurations.rust, {
        name = "Cargo build and run ("..args_string..")",
        type = 'codelldb',
        request = 'launch',
        program = cargo_program,
        cwd = '${workspaceFolder}',
        args = vim.split(args_string, " +"),
        initCommands = rustlldbCommands,
      })
      return vim.split(args_string, " +")
    end;
  },
  (function()
    local _args = {}
    return {
      name = "Rust binary from target",
      type = "codelldbexe",
      request = "launch",
      program = function()
        local prefix = find_cargo_root() .. '/target/'
        local path = vim.fn.input('Binary path: ', prefix, 'file')
        if path == nil or path == '' or path == prefix then
          print('dap cancelled.')
          _args = {}
          return
        end
        local args_string = vim.fn.input('Flags: ', '--test-threads 1 ')
        _args = args_string ~= '' and vim.split(args_string, ' +') or {}
        local bin_name = vim.fn.fnamemodify(path, ':t')
        local entry_name = args_string ~= ''
          and "Rust run (" .. bin_name .. " " .. args_string .. ")"
          or "Rust run (" .. bin_name .. ")"
        table.insert(dap.configurations.rust, {
          name = entry_name,
          type = "codelldbexe",
          request = "launch",
          program = path,
          args = _args,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          initCommands = rustlldbCommands,
        })
        return path
      end,
      args = function() return _args end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      initCommands = rustlldbCommands,
    }
  end)(),
}
