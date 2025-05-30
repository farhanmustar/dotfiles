let g:NVIM_APPNAME = getenv('NVIM_APPNAME')
if g:NVIM_APPNAME == v:null
  let g:NVIM_APPNAME = 'nvim'
endif
let g:LOG_MODE = getenv('LOG_MODE')

command! -nargs=1 Source execute 'source '.substitute(<args>, '^.', '~/.config/'.g:NVIM_APPNAME, '')

Source './config/init.vim'
Source './config/cb_plugin.vim'
Source './config/util.vim'
Source './config/util.lua'
Source './config/plugged.vim'
Source './config/setting.vim'
Source './config/theme.vim'
Source './config/ft.vim'
if g:LOG_MODE == v:null
  Source './config/completion.lua'
endif
Source './config/plugin.lua'
Source './config/lualine.lua'
Source './config/plugin.vim'
Source './config/luasnipcomp.lua'
Source './config/shortcut.vim'
Source './config/textobject.vim'
Source './config/note.vim'
Source './config/curl.vim'
Source './config/treesitter.lua'
Source './config/lsp.lua'
Source './config/dap.lua'

" Note Directory
let g:SimpleNoteDir = '~/notes'
let g:SimpleNoteTODOFile = '~/.todo.md'

" Bookmarks
let g:startify_bookmarks = [
\   '~/.config/'.g:NVIM_APPNAME.'/init.vim', 
\   '~/.config/'.g:NVIM_APPNAME.'/snippets/package.json', 
\   '~/notes', 
\]
