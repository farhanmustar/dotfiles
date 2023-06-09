-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

require('nvim-treesitter.configs').setup({
  context_commentstring = {
    enable = true,
    config = {
      http = '# %s',
      bash = '# %s',
    }
  },
  yati = {
    enable = true,
  },
  indent = {
    enable = false,
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

-- treesj config
local tsj = require('treesj')
tsj.setup({
  use_default_keymaps = false,
  check_syntax_error = true,
  max_join_length = 1200,
  cursor_behavior = 'hold',
  notify = true,
  langs = {
  },
})
vim.keymap.set('n', '<leader>sj', tsj.split)
vim.keymap.set('n', '<leader>sk', tsj.join)
