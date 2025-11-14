-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'c',
    'cpp',
    'css',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'powershell',
    'python',
    'query',
    'rst',
    'rust',
    'svelte',
    'vim',
    'vimdoc',
  },
  sync_install = false,
  indent = {
    enable = true,
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
})

-- nvim-ts-context-commentstring config
require('ts_context_commentstring').setup({
  enable = true,
  config = {
    http = '# %s',
    bash = '# %s',
    dart = '// %s',
  }
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

-- ts-node-action config
vim.keymap.set('n', '<leader>ss', require("ts-node-action").node_action)

-- template-string.nvim config
require('template-string').setup()

-- nvim-ts-autotag config
require('nvim-ts-autotag').setup()
