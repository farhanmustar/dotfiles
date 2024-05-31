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
  return vim.o.filetype == 'fugitive' or vim.o.filetype == 'git'
end
local function showFilename()
  return not vim.o.previewwindow and
    vim.fn.bufname() ~= '' and not isSpecialFiletype() and not isFugitive()
end
local function showFiletype()
  return not vim.o.previewwindow and (vim.fn.bufname() == '' or isSpecialFiletype())
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
  return obj:sub(1,6)
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
    lualine_b = {{fugitiveBranch, icon=''}, 'branch', 'diff', 'diagnostics', ctrlspace},
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
    },
    lualine_x = {'filetype'},
    lualine_y = {'progress', 'location'},
    lualine_z = {}
  },
  inactive_sections = {
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
    },
  }
})
