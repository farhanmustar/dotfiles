-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

require('nvim-treesitter.configs').setup({
  indent = {
    enable = true
  },
  highlight = {
    enable = true,
    -- disable = { "c", "rust" },
    additional_vim_regex_highlighting = false,
  },
  playground = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
  refactor = {
    highlight_definitions = {
      enable = true,
      clear_on_cursor_move = true,
    },
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "<leader>rr",
      },
    },
  },
})

vim.o.fillchars     = "fold: "
vim.o.foldmethod = "expr"
vim.o.foldlevel     = 99
vim.o.foldexpr    = 'nvim_treesitter#foldexpr()'
vim.o.foldtext    = [[
substitute(getline(v:foldstart),'\\\\t',repeat('\\ ',&tabstop),'g').'...'.trim(getline(v:foldend)) . ' (' . (v:foldend - v:foldstart + 1) . ' lines)'
]]

vim.keymap.set('n', '>', 'zo', {silent = true})
vim.keymap.set('n', '<', 'zc', {silent = true})
vim.keymap.set('n', '<leader>>', 'zO', {silent = true})
vim.keymap.set('n', '<leader><', 'zC', {silent = true})

-- ssr config
require("ssr").setup({
  min_width = 50,
  min_height = 5,
  keymaps = {
    close = "q",
    next_match = "n",
    prev_match = "N",
    replace_all = "<leader><cr>",
  },
})
vim.keymap.set({ "n", "x" }, "<leader>rs", function() require("ssr").open() end)
