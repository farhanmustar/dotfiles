command! -nargs=1 SourceRoot execute 'source '.substitute(<args>, '^.', expand('<sfile>:p:h'), '')

SourceRoot './config/init.vim'
SourceRoot './config/cb_plugin.vim'
SourceRoot './config/util.vim'
SourceRoot './config/util.lua'
SourceRoot './config/plugged.vim'
SourceRoot './config/setting.vim'
SourceRoot './config/theme.vim'
SourceRoot './config/ft.vim'
SourceRoot './config/completion.vim'
SourceRoot './config/plugin.lua'
SourceRoot './config/plugin.vim'
SourceRoot './config/luasnipcomp.lua'
SourceRoot './config/shortcut.vim'
SourceRoot './config/textobject.vim'
SourceRoot './config/note.vim'
SourceRoot './config/curl.vim'
SourceRoot './config/treesitter.lua'
SourceRoot './config/lsp.lua'
SourceRoot './config/dap.lua'

" Note Directory
let g:SimpleNoteDir = '~/notes'
let g:SimpleNoteTODOFile = '~/.todo.md'

" Bookmarks
let g:startify_bookmarks = [
\   '~/.config/nvim/init.vim', 
\   '~/notes', 
\]
