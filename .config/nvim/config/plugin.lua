-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'scrollbar')
if not ok then
  return
end

-- scrollbar config
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

-- aerial config
local aerial = require('aerial')
aerial.setup({
  backends = { "treesitter" },
  default_bindings = false,
  width = 60,
  min_width = 60,
  max_width = 60,
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
function aerial_map()
  vim.keymap.set('n', '<CR>', function() aerial.select({jump=false}) end, {buffer = true})
  vim.keymap.set('n', 'o', aerial.select, {buffer = true})
  vim.keymap.set('n', '<2-LeftMouse>', aerial.select, {buffer = true})
  vim.keymap.set('n', 'zR', '<cmd>AerialTreeOpenAll<CR>', {buffer = true})
  vim.keymap.set('n', 'zM', '<cmd>AerialTreeCloseAll<CR>', {buffer = true})
  vim.keymap.set('n', '>', '<cmd>AerialTreeOpen<CR>', {buffer = true})
  vim.keymap.set('n', '<', '<cmd>AerialTreeClose<CR>', {buffer = true})
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = "aerial",
  callback = aerial_map,
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
  numhl = true,
  -- base  = 'HEAD',  -- use :Gitsigns change_base HEAD -> to display all including staged
})
vim.keymap.set('n', 'gj', '<Cmd>Gitsigns next_hunk<CR>')
vim.keymap.set('n', 'gk', '<Cmd>Gitsigns prev_hunk<CR>')
vim.keymap.set('n', 'gp', '<Cmd>Gitsigns preview_hunk<CR>')

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
