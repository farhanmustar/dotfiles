let g:NVIM_APPNAME = getenv('NVIM_APPNAME')
if g:NVIM_APPNAME == v:null
  let g:NVIM_APPNAME = 'nvim'
endif
let g:S_MODE = getenv('S_MODE')

command! -nargs=1 Source execute 'source '.substitute(<args>, '^.', '~/.config/'.g:NVIM_APPNAME, '')

if g:S_MODE == v:null
  Source './config/init.vim'
  Source './config/cb_plugin.vim'
endif
Source './config/util.vim'
Source './config/util.lua'
if g:S_MODE == v:null
  Source './config/plugged.vim'
endif
Source './config/setting.vim'
if g:S_MODE == v:null
  Source './config/theme.vim'
  Source './config/ft.vim'
  Source './config/completion.lua'
  Source './config/plugin.lua'
  Source './config/lualine.lua'
  Source './config/plugin.vim'
  Source './config/luasnipcomp.lua'
endif
Source './config/shortcut.vim'
if g:S_MODE == v:null
  Source './config/textobject.vim'
endif
if g:S_MODE == v:null
  Source './config/note.vim'
  Source './config/curl.vim'
  Source './config/treesitter.lua'
  Source './config/lsp.lua'
  Source './config/dap.lua'
endif

" Note Directory
let g:SimpleNoteDir = '~/notes'
let g:SimpleNoteTODOFile = '~/.todo.md'

" Bookmarks
let g:startify_bookmarks = [
\   '~/.config/'.g:NVIM_APPNAME.'/init.vim', 
\   '~/.config/'.g:NVIM_APPNAME.'/snippets/package.json', 
\   '~/notes', 
\]
