-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'cmp')
if not ok then
  return
end

local cmp = require('cmp')
local ls = require('luasnip')
local compare = require('cmp.config.compare')
local cmp_buffer = require('cmp_buffer')

vim.g.lexima_map_escape = ''
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
    ['<CR>'] = cmp.mapping(function(fallback)
          if cmp.visible() and cmp.get_selected_entry() ~= nil then
            cmp.confirm()
            return
          elseif vim.fn.pumvisible() == 1 and vim.fn.CB_can_expand() == 1 then
            vim.fn.CB_expand()
            return
          elseif cmp.visible() then
            cmp.close()
            return
          end
          fallback()
        end, { 'i' }),
    ['<Esc>'] = cmp.mapping(function(fallback)
          ls.unlink_current()
          fallback()
        end, { 'i', 'x', 's' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
            return
          elseif ls.jumpable(1) then
            ls.jump(1)
            return
          end
          fallback()
        end, { 'i' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
            return
          elseif ls.jumpable(0) then
            ls.jump(-1)
            return
          end
          fallback()
        end, { 'i' }),
  }),
  sources = cmp.config.sources({
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
  }, {
    { name = 'bufname' },
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
  }),
  sorting = {
    comparators = {
      compare.recently_used,
      function (...) return cmp_buffer:compare_locality(...) end,
      compare.locality,
      compare.score,
      compare.exact,
      compare.offset,
      compare.order,
    }
  }
})

vim.keymap.set('s', '<Tab>', function() ls.jump(1) end)
vim.keymap.set('x', '<Tab>', function() ls.jump(1) end)
vim.keymap.set('s', '<S-Tab>', function() ls.jump(-1) end)
vim.keymap.set('x', '<S-Tab>', function() ls.jump(-1) end)

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
  }
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
    {
      name = "spell",
      option = {
        preselect_correct_word = false,
      },
    },
  }
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
