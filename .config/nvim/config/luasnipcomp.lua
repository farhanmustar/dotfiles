-- source: https://github.com/potamides/dotfiles/blob/master/.config/nvim/plugin/snipcomp.lua

-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'luasnip')
if not ok then
  return
end

-- lazy load LuaSnip, only useful when LuaSnip wasn't already loaded elsewhere
local luasnip = setmetatable({}, {__index = function(_, key) return require("luasnip")[key] end})
vim.luasnip = {}

local function snippet2completion(snippet)
  return {
    word      = snippet.trigger,
    info      = vim.trim(table.concat(vim.tbl_flatten({snippet.dscr or "", "", snippet:get_docstring()}), "\n")),
    dup       = true,
    user_data = "luasnip",
    kind      = "S",
  }
end

local function snippetfilter(line_to_cursor, base)
  return function(s)
    return not s.hidden and vim.startswith(s.trigger, base) and s.show_condition(line_to_cursor)
  end
end

-- Set 'completefunc' or 'omnifunc' to 'v:lua.vim.luasnip.completefunc' to get
-- completion.
function vim.luasnip.completefunc(findstart, base)
  local line, col = vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)[2]
  local line_to_cursor = line:sub(1, col)

  if findstart == 1 then
    return vim.fn.match(line_to_cursor, '\\k*$')
  end

  local snippets = vim.list_extend(vim.list_slice(luasnip.get_snippets("all")), luasnip.get_snippets(vim.bo.filetype))
  snippets = vim.tbl_filter(snippetfilter(line_to_cursor, base), snippets)
  snippets = vim.tbl_map(snippet2completion, snippets)
  table.sort(snippets, function(s1, s2) return string.len(s1.word) < string.len(s2.word) end)
  return snippets
end

function vim.luasnip.completion_expand(item)
  if item.user_data == "luasnip" and luasnip.expandable() then
    luasnip.expand()
  end
end
