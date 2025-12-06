-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'scrollbar')
if not ok then
  return
end

local M = {}

-- scrollbar config
require("scrollbar").setup({
  marks = {
    Search = { color = '#c5b107'},
  },
  handlers = {
    cursor = false,
    search = false,
  },
  handle = {
    color = '#39454b',
  },
})

-- nvim-hlslens config
require("scrollbar.handlers.search").setup({
  calm_down = true,
  nearest_only = true,
  nearest_float_when = 'never',
})
require("scrollbar.config").set({
  handlers = {
    search = true,
  },
})

local start_hlslens = '<Cmd>set hlsearch<CR><Cmd>lua require("hlslens").start()<CR>'
vim.keymap.set( 'n', 'n',
  '<Cmd>execute("normal! " . v:count1 . "n")<CR>'..start_hlslens,
  {silent = true})
vim.keymap.set('n', 'N',
  '<Cmd>execute("normal! " . v:count1 . "N")<CR>'..start_hlslens,
  {silent = true})
vim.keymap.set('n', '*', '*'..start_hlslens, { silent = true })
vim.keymap.set('n', '#', '#'..start_hlslens, { silent = true })
vim.keymap.set( 'n', 'g*', 'g*'..start_hlslens, {silent = true})
vim.keymap.set('n', 'g#', 'g#'..start_hlslens, {silent = true})
vim.cmd([[
  function! s:MyEscAction()
    lua require("hlslens").stop()
    set nohlsearch
    return "\<plug>MyEsc"
  endfunction
  nnoremap <plug>MyEsc <Esc>
  nmap <expr> <silent> <Esc> <SID>MyEscAction()
]])

-- aerial config
local aerial = require('aerial')
aerial.setup({
  backends = { 'lsp', 'treesitter' },
  keymaps = {},
  layout = {
    width = 60,
    min_width = 60,
    max_width = 60,
  },
  icons = {
    Method = ' ƒ',
    Function = ' ƒ',
    Constructor = ' ƒ',
    Enum = ' E',
    Interface = ' I',
    Struct = ' S',
    Class = ' 𝓒',
    ClassCollapsed = '▸𝓒',
  }
})
local aerial_map_group = vim.api.nvim_create_augroup("aerialmap", { clear = true })
M.aerial_map = function ()
  vim.keymap.set('n', '<CR>', function() aerial.select({jump=false}) end, {buffer = true})
  vim.keymap.set('n', 'o', aerial.select, {buffer = true})
  vim.keymap.set('n', '<2-LeftMouse>', aerial.select, {buffer = true})
  vim.keymap.set('n', 'zR', aerial.tree_open_all, {buffer = true})
  vim.keymap.set('n', 'zM', aerial.tree_close_all, {buffer = true})
  vim.keymap.set('n', '>', aerial.tree_open, {buffer = true})
  vim.keymap.set('n', '<', aerial.tree_close, {buffer = true})
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "aerial",
  callback = M.aerial_map,
  group = aerial_map_group,
})
vim.keymap.set('n', '<leader>sr', '<Cmd>AerialToggle!<CR>')

-- gitsigns config
-- NOTE: culnumhl is a patch currently not supported in neovim and gitsigns.
require('gitsigns').setup({
  signcolumn = false,
  numhl = true,
  -- base  = 'HEAD',  -- use :Gitsigns change_base HEAD -> to display all including staged
})
vim.keymap.set('n', 'gj', '<Cmd>lua require("gitsigns").nav_hunk("next", {target="unstaged"})<CR>')
vim.keymap.set('n', 'gk', '<Cmd>lua require("gitsigns").nav_hunk("prev", {target="unstaged"})<CR>')
vim.keymap.set('n', '<leader>gj', '<Cmd>lua require("gitsigns").nav_hunk("next", {target="staged"})<CR>')
vim.keymap.set('n', '<leader>gk', '<Cmd>lua require("gitsigns").nav_hunk("prev", {target="staged"})<CR>')
vim.keymap.set('n', 'gp', '<Cmd>Gitsigns preview_hunk<CR><Cmd>Gitsigns preview_hunk<CR>')

-- dressing config
require('dressing').setup({
  input = {
    enabled = true,
    start_in_insert = true,
  },
  select = {
    enabled = true,
    -- backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },
    backend = { 'builtin' },
    builtin = {
      relative = 'cursor',
    },
  },
});


-- rest.nvim config
local restOk, restNvim = pcall(require, 'rest-nvim')
if restOk then
  restNvim.setup({
    -- Open request results in a horizontal split
    result_split_horizontal = false,
    -- Keep the http file buffer above|left when split horizontal|vertical
    result_split_in_place = false,
    -- Skip SSL verification, useful for unknown certificates
    skip_ssl_verification = false,
    -- Encode URL before making request
    encode_url = true,
    -- Highlight request on run
    highlight = {
      enabled = true,
      timeout = 150,
    },
    result = {
      -- toggle showing URL, HTTP info, headers at top the of result window
      show_url = true,
      show_http_info = true,
      show_headers = true,
      -- executables or functions for formatting response body [optional]
      -- set them to nil if you want to disable them
      formatters = {
        json = function(body)
          return vim.fn.system({"jq", "."}, body)
        end,
        html = function(body)
          return vim.fn.system({"tidy", "-i", "-q", "-"}, body)
        end
      },
    },
    -- Jump to request line on run
    jump_to_request = false,
    env_file = '.env',
    custom_dynamic_variables = {},
    yank_dry_run = true,
  })
  local rest_map_group = vim.api.nvim_create_augroup("restMap", { clear = true })
  M.rest_map = function ()
    vim.keymap.set('n', '<leader>bu', '<Plug>RestNvim', {buffer = true})
    vim.keymap.set('n', '<leader>bp', '<Plug>RestNvimPreview', {buffer = true})
    vim.keymap.set('n', '<leader>bb', '<Plug>RestNvimLast', {buffer = true})
  end
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "http",
    callback = M.rest_map,
    group = rest_map_group,
  })
end

-- oil.nvim config
require("oil").setup({
  use_default_keymaps = false,
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-v>"] = "actions.select_split",
    ["<C-r>"] = "actions.refresh",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["g."] = "actions.toggle_hidden",
  }
})
vim.keymap.set("n", "-", require("oil").open)

-- neoscroll config
require('neoscroll').setup({
  ignored_events = {           -- Events ignored while scrolling
      'CursorMoved'
  },
})

-- edit-code-block config
require('ecb').setup {
  wincmd = 'tabnew',
}

-- telescope configs
require('telescope').setup{
  defaults = {
    layout_strategy = 'bottom_pane',
    layout_config = {
      prompt_position = 'bottom'
    },
    mappings = {
      i = {
        ['<C-h>'] = 'which_key',
        ['gq'] = 'close',
        ['<esc>'] = 'close', -- TODO: this does not work
        ['<CR>'] = { '<esc>', type = 'command' },
      },
      n = {
        ['<C-h>'] = 'which_key',
        ['gq'] = 'close',
        ['v'] = 'file_vsplit',
        ['t'] = 'file_tab',
        ['o'] = 'file_split',
      }
    }
  },
}
vim.keymap.set('n', '<C-p>', function() require('telescope.builtin').git_files({
  previewer = false
}) end)

-- nvim-ufo config
vim.o.foldlevel  = 99
vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
vim.keymap.set('n', '>', 'zo', {silent = true})
vim.keymap.set('n', '<', 'zc', {silent = true})
vim.keymap.set('n', '<leader>>', 'zO', {silent = true})
vim.keymap.set('n', '<leader><', 'zC', {silent = true})
require('ufo').setup({
  provider_selector = function(bufnr, filetype, buftype) -- luacheck: ignore 212
    if filetype == 'git' then
      return ''
    end
    if vim.api.nvim_buf_line_count(bufnr) > 10000 then
      -- perf issue with indent fold type
      return {'treesitter'}
    end
    return {'treesitter', 'indent'}
  end
})

-- nvim-notify
-- list all notification using :Notifications cmd
local notify = require('notify')
notify.setup({
  background_colour = "#00000000",
  render = 'compact',
  stages = 'fade',
  timeout = 100,
})
vim.notify = notify

-- highlight-undo.nvim config
require('highlight-undo').setup()

-- term-edit.nvim config
-- TODO: change config base of type of terminal
require('term-edit').setup({
  prompt_end = '%$ ',
})

-- nvim-early-retirement config
require("early-retirement").setup({})

-- ccc.nvim
local ccc = require("ccc")
ccc.setup({
  highlighter = {
    auto_enable = false,
    lsp = true,
  },
})

-- submode
local submode = require("submode")
submode.setup()

--- treewalker.nvim
local treewalker = require('treewalker')
treewalker.setup({ highlight = true, highlight_duration = 250, highlight_group = 'CursorLine', jumplist = true })

-- treewalker sub mode
submode.create("TreewalkerMode", {
  mode = "n",
  enter = "<leader>sm",
  leave = { "q", "<ESC>" },
  enter_cb = function()
    vim.api.nvim_echo({ { "-- Treewalker --", "ModeMsg" } }, false, {})
    vim.notify('Treewalker Mode Enabled', vim.log.levels.INFO)
  end,
  leave_cb = function()
    vim.api.nvim_echo({ {""} }, false, {})
    vim.notify('Treewalker Mode Disabled', vim.log.levels.INFO)
  end,
}, {
  lhs = "j",
  rhs = treewalker.move_down,
}, {
  lhs = "k",
  rhs = treewalker.move_up,
}, {
  lhs = "h",
  rhs = treewalker.move_out,
}, {
  lhs = "l",
  rhs = treewalker.move_in,
}, {
  lhs = "i",
  rhs = treewalker.move_in,
}, {
  lhs = "o",
  rhs = treewalker.move_out,
})

-- mini.cursorword
require('mini.cursorword').setup({})
vim.api.nvim_set_hl(0, 'MiniCursorwordCurrent', {})

-- claude-code
require("claude-code").setup({
  -- Terminal window settings
  window = {
    split_ratio = 0.5,-- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
    position = "vertical",  -- Position of the window: "botright", "topleft", "vertical", "float", etc.
    enter_insert = true,    -- Whether to enter insert mode when opening Claude Code
    hide_numbers = true,    -- Hide line numbers in the terminal window
    hide_signcolumn = true, -- Hide the sign column in the terminal window
  },
  -- File refresh settings
  refresh = {
    enable = false,           -- Enable file change detection
  },
  -- Git project settings
  git = {
    use_git_root = true,     -- Set CWD to git root when opening Claude Code (if in git project)
  },
  -- Shell-specific settings
  shell = {
    separator = '&&',        -- Command separator used in shell commands
    pushd_cmd = 'pushd',     -- Command to push directory onto stack (e.g., 'pushd' for bash/zsh, 'enter' for nushell)
    popd_cmd = 'popd',       -- Command to pop directory from stack (e.g., 'popd' for bash/zsh, 'exit' for nushell)
  },
  -- Command settings
  command = "claude",        -- Command used to launch Claude Code
  -- Command variants
  command_variants = {
    -- Conversation management
    continue = "--continue", -- Resume the most recent conversation
    resume = "--resume",     -- Display an interactive conversation picker

    -- Output options
    verbose = "--verbose",   -- Enable verbose logging with full turn-by-turn output
  },
  -- Keymaps
  keymaps = {
    toggle = {
      normal = "<leader>cN",       -- Normal mode keymap for toggling Claude Code, false to disable
      terminal = false,     -- Terminal mode keymap for toggling Claude Code, false to disable
      variants = {
        continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
        verbose = "<leader>cV",  -- Normal mode keymap for Claude Code with verbose flag
      },
    },
    window_navigation = false, -- Enable window navigation keymaps (<C-h/j/k/l>)
    scrolling = false,         -- Enable scrolling keymaps (<C-f/b>) for page up/down
  }
})

-- j-hui/fidget.nvim
require("fidget").setup({})
