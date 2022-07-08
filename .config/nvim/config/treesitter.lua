-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'nvim-treesitter.configs')
if not ok then
  return
end

require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
    -- disable = { "c", "rust" },
    additional_vim_regex_highlighting = false,
  },
  playground = {
    enable = false,
  }
}
