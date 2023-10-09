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

-- LuaSnip config
require("luasnip.loaders.from_vscode").lazy_load()

-- aerial config
local aerial = require('aerial')
aerial.setup({
  backends = { "treesitter" },
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
  signs = {
    add          = {hl = '', text = '', numhl = 'GitSignsAddNr',    culnumhl = 'GitSignsAddCLNr'    },
    change       = {hl = '', text = '', numhl = 'GitSignsChangeNr', culnumhl = 'GitSignsChangeCLNr' },
    delete       = {hl = '', text = '', numhl = 'GitSignsDeleteNr', culnumhl = 'GitSignsDeleteCLNr' },
    topdelete    = {hl = '', text = '', numhl = 'GitSignsDeleteNr', culnumhl = 'GitSignsDeleteCLNr' },
    changedelete = {hl = '', text = '', numhl = 'GitSignsChangeNr', culnumhl = 'GitSignsChangeCLNr' },
  },
  signcolumn = false,
  numhl = true,
  -- base  = 'HEAD',  -- use :Gitsigns change_base HEAD -> to display all including staged
})
vim.keymap.set('n', 'gj', '<Cmd>Gitsigns next_hunk<CR>')
vim.keymap.set('n', 'gk', '<Cmd>Gitsigns prev_hunk<CR>')
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

-- harpoon config
vim.keymap.set('n', '<leader>hh', require("harpoon.ui").toggle_quick_menu)
vim.keymap.set('n', '<leader>hm', require("harpoon.mark").add_file)

-- nvim-tree config
require("nvim-tree").setup({
  on_attach = function()
    local api = require('nvim-tree.api')
    vim.keymap.set('n', '<CR>', api.node.open.preview)
    vim.keymap.set('n', 'o', api.node.open.edit)
    vim.keymap.set('n', 'O', api.node.open.tab)
    vim.keymap.set('n', 's', api.node.open.horizontal)
    vim.keymap.set('n', 'V', api.node.open.vertical)
    vim.keymap.set('n', 'I', api.tree.change_root_to_node)
    vim.keymap.set('n', '.', api.node.run.cmd)
  end
})
vim.keymap.set('n', '<leader>ft', function()
  require("nvim-tree.api").tree.toggle(true, true, vim.fn.expand('%:p:h'))
end)

-- rest.nvim config
require("rest-nvim").setup({
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
require('neoscroll').setup()

-- edit-code-block config
require('ecb').setup {
  wincmd = 'tabnew',
}

-- telescope configs
require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ['<C-h>'] = 'which_key'
      },
      n = {
        ['<C-h>'] = 'which_key',
        ['v'] = 'file_vsplit',
        ['O'] = 'file_tab',
        ['o'] = 'file_split',
      }
    }
  },
}
vim.keymap.set('n', '<C-p>', function() require('telescope.builtin').git_files() end)

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
