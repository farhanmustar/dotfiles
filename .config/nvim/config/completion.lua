-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'cmp')
if not ok then
  return
end

local cmp = require('cmp')
local ls = require('luasnip')
local compare = require('cmp.config.compare')
local cmp_buffer = require('cmp_buffer')

local cmp_api = require('cmp.utils.api')
local cmp_str = require('cmp.utils.str')
local cmp_keymap = require('cmp.utils.keymap')
local cmp_feedkeys = require('cmp.utils.feedkeys')
local complete_common_string = function(max_entry)
  max_entry = max_entry or 5
  if cmp.get_selected_entry() then
    return false
  end

  local cursor = cmp_api.get_cursor()
  local offset = cmp.core.view:get_offset() or cursor[2]
  local common_string
  for i, e in ipairs(cmp.core.view:get_entries()) do
    if i > max_entry then
        break
    end
    local vim_item = e:get_vim_item(offset)
    if not common_string then
      common_string = vim_item.word
    else
      common_string = cmp_str.get_common_string(common_string, vim_item.word)
    end
  end
  local cursor_before_line = cmp_api.get_cursor_before_line()
  local pretext = cursor_before_line:sub(offset)
  if common_string and #common_string > #pretext then
    cmp_feedkeys.call(cmp_keymap.backspace(pretext) .. common_string, 'n')
    return true
  end
  return false
end

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
            if not complete_common_string() then
              cmp.select_next_item()
            end
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
        keyword_pattern = [[\k\+]],
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
        keyword_pattern = [[\k\+]],
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
  mapping = cmp.mapping.preset.cmdline({
    ['<Tab>'] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          if not complete_common_string() then
            cmp.select_next_item()
          end
          return
        end
        fallback()
      end, { 'c' }),
  }),
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

local cmdLineConf = {
  mapping = cmp.mapping.preset.cmdline({
    ['<Tab>'] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          if not complete_common_string() then
            cmp.select_next_item()
          end
          return
        end
        fallback()
      end, { 'c' }),
  }),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  }, {
    {
      name = 'buffer',
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
      }
    },
  })
}
cmp.setup.cmdline(':', cmdLineConf)
local nvim_cmp_group = vim.api.nvim_create_augroup("nvimcmp", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
  group = nvim_cmp_group,
  pattern = '*',
  callback = function ()
    -- cannot switch permanently cause cb_plugin not integrate with nvim-cmp yet
    vim.o.completeopt=''
    cmp.setup.buffer(cmdLineConf)
  end
})
vim.api.nvim_create_autocmd("CmdwinLeave", {
  group = nvim_cmp_group,
  pattern = '*',
  callback = function ()
    -- cannot switch permanently cause cb_plugin not integrate with nvim-cmp yet
    vim.o.completeopt='menu,menuone,noselect'
  end
})
