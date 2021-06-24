" Vim Plugin Config

" CtrlSpace config
let g:CtrlSpaceUseUnicode = 0
let g:CtrlSpaceSymbols = { 'IV': 'o' }
let g:CtrlSpaceSaveWorkspaceOnExit = 1
let g:CtrlSpaceSaveWorkspaceOnSwitch = 1
let g:CtrlSpaceLoadLastWorkspaceOnStart = 1
let g:CtrlSpaceUseMouseAndArrowsInTerm = 1
let g:CtrlSpaceIgnoredFiles = '\v(tmp|temp|build|dist|env|node_modules|platforms|plugins|www\/lib)[\/]'
if executable('rg')
  let g:CtrlSpaceGlobCommand = 'rg --color=never --files'
endif

" vim-over config 
let g:over#command_line#substitute#replace_pattern_visually = 1
nnoremap <Leader>oo :OverCommandLine %s/<CR>
vnoremap <Leader>oo :OverCommandLine s/<CR>

" vim-table-mode config
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='

" Fugitive shortcuts
command! Gv vertical topleft G
command! Gt tab G
command! Greload :e "<C-r>%"<CR>
command! -nargs=+ GG silent execute "Ggrep! -niI --exclude-standard --untracked '<args>'"
nnoremap <Leader>gg :GG <C-r><C-w><CR>
vnoremap <Leader>gg y:GG <C-r>"<CR>
nnoremap <Leader>gt :tab sbuffer<CR>:GG <C-r><C-w><CR>
vnoremap <Leader>gt y:tab sbuffer<CR>:GG <C-r>"<CR>

" tagbar config
let g:tagbar_map_preview = '<CR>'
let g:tagbar_sort = 0
let g:tagbar_width = 60
nnoremap <Leader>st :TagbarToggle<CR>

" undotree config
nnoremap <Leader>ut :UndotreeToggle<CR>

" startify config
command! S botright split | Startify
command! Sv vertical botright split | Startify
command! St tabnew | Startify
