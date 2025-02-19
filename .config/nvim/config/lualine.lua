-- use first plugin to check for installed plugin
local ok, _ = pcall(require, 'lualine')
if not ok then
  return
end

-- lualine config
local lualine = require('lualine')
local function ctrlspace()
  if vim.o.previewwindow then
    return vim.fn['ctrlspace#api#Statusline']()
  end
  return ''
end
local function isFugitive()
  if vim.fn.bufname():sub(1, 11) == 'fugitive://' then
    return true
  end
  return false
end
local function isSpecialFiletype()
  if vim.o.filetype == 'git' then
    local obj = vim.fn['fugitive#Object'](vim.fn.bufname())
    if obj:find(':') then
      return false
    end
  end
  return vim.o.filetype == 'fugitive' or vim.o.filetype == 'git'
end
local function showQuickfix()
  return vim.o.filetype == 'qf'
end
local function showBranch()
  return not showQuickfix()
end
local function showFilename()
  return not vim.o.previewwindow and
    vim.fn.bufname() ~= '' and not isSpecialFiletype() and not isFugitive()
end
local function showFiletype()
  return not showQuickfix() and not vim.o.previewwindow and (vim.fn.bufname() == '' or isSpecialFiletype())
end
local function fugitiveFilename()
  if isSpecialFiletype() or not isFugitive() then
    return ''
  end
  local filename = vim.fn['fugitive#Real'](vim.fn.bufname())
  filename = vim.fn.fnamemodify(filename, ':~:.')
  if vim.o.readonly then
    filename = filename .. ' [RO]'
  end
  if vim.bo.modified then
    filename = filename .. ' [+]'
  end
  return filename
end
local function fugitiveBranch()
  if not isFugitive() then
    return ''
  end
  local obj = vim.fn['fugitive#Object'](vim.fn.bufname())
  if obj == ':' then
    return vim.fn.FugitiveHead()
  elseif obj:sub(1, 3) == ':0:' then
    return 'Staged'
  end
  local commitHash = obj:sub(1,6)

  local out = vim.fn.FugitiveExecute('tag', '--points-at', commitHash)
  if #out['stdout'] > 1 then
    out = out['stdout'][1]
    return trimString(out)
  end
  out = vim.fn.FugitiveExecute('branch', '--points-at', commitHash)
  if #out['stdout'] > 1 then
    out = out['stdout'][1]
    -- cleanup * indicator for HEAD
    if string.sub(out, 1, 1) == '*' then
        out = string.sub(out, 2)
    end
    return trimString(out)
  end
  out = vim.fn.FugitiveExecute('branch', '-r', '--points-at', commitHash)
  if #out['stdout'] > 1 then
    out = out['stdout'][1]
    return trimString(out)
  end

  return commitHash
end
local fugitiveFilenameColor = { bg = '#314f26', fg = '#f7f0df' }
local gruvbox = require('lualine.themes.gruvbox_dark')
gruvbox['insert'] = gruvbox['normal']
gruvbox['visual'] = gruvbox['normal']
gruvbox['replace'] = gruvbox['normal']
gruvbox['command'] = gruvbox['normal']
gruvbox['inactive'] = gruvbox['normal']
lualine.setup({
  options = {
    theme = gruvbox,
  },
  sections = {
    lualine_a = {},
    lualine_b = {
      {fugitiveBranch, icon=''},
      {'branch', cond=showBranch},
      {'%t', cond=showQuickfix},
      'diff',
      'diagnostics',
      ctrlspace,
    },
    lualine_c = {
      {
        'filename',
        path=1,
        cond=showFilename,
        symbols={
          readonly = '[RO]'
        }
      },
      {
        fugitiveFilename,
        color=fugitiveFilenameColor,
        separator={ right = '' },
      },
      {'filetype', cond=showFiletype},
      {'w:quickfix_title', cond=showQuickfix},
    },
    lualine_x = {},
    lualine_y = {'progress', 'location'},
    lualine_z = {}
  },
  inactive_sections = {
    lualine_c = {
      {fugitiveBranch, icon=''},
      {'branch', cond=showBranch},
      {'%t', cond=showQuickfix},
      {
        'filename',
        path=1,
        cond=showFilename,
        symbols={
          readonly = '[RO]'
        }
      },
      {
        fugitiveFilename,
        color=fugitiveFilenameColor,
        separator={ right = '' },
      },
      {'filetype', cond=showFiletype},
      {'w:quickfix_title', cond=showQuickfix},
    },
  }
})
