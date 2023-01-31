-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'scrollbar')
if not ok then
  return
end

local M = {}

-- scrollbar config
require("scrollbar").setup({
  marks = {
    Search = { color = '#1d2021'},
  },
  handlers = {
    cursor = false,
    search = true,
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
  view = {
    mappings = {
      custom_only = true,
      list = {
        { key = "<CR>", action = "preview" },
        { key = "o", action = "edit" },
        { key = "O", action = "tabnew" },
        { key = "s", action = "split" },
        { key = "V", action = "vsplit" },
        { key = "I", action = "cd" },
        { key = ".", action = "run_file_command" },
      },
    },
  },
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
