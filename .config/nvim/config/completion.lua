-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'cmp')
if not ok then
  return
end

local cmp = require('cmp')
local ls = require('luasnip')

cmp.setup({
  snippet = {
    expand = function(args)
      ls.lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            return
          elseif ls.jumpable(1) then
            ls.jump(1)
            return
          end
          fallback()
        end
      , { 'i' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
            return
          elseif ls.jumpable(0) then
            ls.jump(-1)
            return
          end
          fallback()
        end
      , { 'i' }),
  }),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  }, {
    { name = 'buffer' },
  })
})

vim.keymap.set('s', '<Tab>', function() ls.jump(1) end)
vim.keymap.set('x', '<Tab>', function() ls.jump(1) end)
vim.keymap.set('s', '<S-Tab>', function() ls.jump(-1) end)
vim.keymap.set('x', '<S-Tab>', function() ls.jump(-1) end)

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = {
    { name = 'buffer' }
  }
})
