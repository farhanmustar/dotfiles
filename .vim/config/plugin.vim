" Vim Plugin Config

" CtrlSpace config
let g:CtrlSpaceUseMouseAndArrowsInTerm = 1
let g:CtrlSpaceIgnoredFiles = '\v(tmp|temp|build|dist|env|node_modules|platforms|plugins|www\/lib)[\/]'
if executable('rg')
  let g:CtrlSpaceGlobCommand = 'rg --color=never --files'
endif
command! -nargs=* -range CtrlSpaceSearch :call ctrlspace#window#Toggle(0) | :call feedkeys("O<args>\<CR>")
nnoremap <expr> <Leader>fn ':CtrlSpaceSearch ' . expand('<cword>') . '<CR>'
vnoremap <silent> <Leader>fn y:CtrlSpaceSearch <C-r>"<CR>

" Allow C-p as C-Space alternative
function! CallCtrlSpace(k)
  execute 'CtrlSpace'
endfunction
map <silent> <C-p> :CtrlSpace<CR>
let g:CtrlSpaceKeys = {
\    "Search": { "C-p": "CallCtrlSpace" },
\    "Help": { "C-p": "CallCtrlSpace" },
\    "Nop": { "C-p": "CallCtrlSpace" },
\    "Buffer": { "C-p": "CallCtrlSpace" },
\    "File": { "C-p": "CallCtrlSpace" },
\    "Tab": { "C-p": "CallCtrlSpace" },
\    "Workspace": { "C-p": "CallCtrlSpace" },
\    "Bookmark": { "C-p": "CallCtrlSpace" },
\}

" vim-over config
let g:over#command_line#substitute#replace_pattern_visually = 1
nnoremap <silent> <Leader>oo :OverCommandLine %s/<CR>
vnoremap <silent> <Leader>oo :OverCommandLine s/<CR>

" vim-table-mode config
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='

" Fugitive shortcuts
command! Gv vertical topleft G
command! Gt tab G
command! Greload :e "<C-r>%"<CR>
command! -nargs=+ GG silent execute "Ggrep! -niI --exclude-standard --untracked '<args>'"
command! -nargs=* -complete=customlist,fugitive#PushComplete Gpush execute "Git push <args>"
command! -nargs=* -complete=customlist,fugitive#PullComplete Gpull execute "Git pull <args>"
command! -nargs=* -complete=customlist,fugitive#FetchComplete Gfetch execute "Git fetch <args>"
command! -nargs=* Gblame execute "Git blame <args>"
command! -nargs=* Gstash execute "Git stash <args>"
nnoremap <silent> <Leader>gg :GG <C-r><C-w><CR>
vnoremap <silent> <Leader>gg y:GG <C-r>"<CR>
nnoremap <silent> <Leader>gt :tab sbuffer<CR>:GG <C-r><C-w><CR>
vnoremap <silent> <Leader>gt y:tab sbuffer<CR>:GG <C-r>"<CR>

" Git Gutter disable by default
let g:gitgutter_map_keys = 0
let g:gitgutter_enabled = 0

" tagbar config
let g:tagbar_map_close = 'gq'
let g:tagbar_map_closefold = '<'
let g:tagbar_map_jump = 'o'
let g:tagbar_map_openfold = '>'
let g:tagbar_map_preview = '<CR>'
let g:tagbar_map_togglefold = ''
let g:tagbar_sort = 0
let g:tagbar_width = 60
nnoremap <silent> <Leader>st :TagbarToggle<CR>

" undotree config
nnoremap <silent> <Leader>ut :UndotreeToggle<CR>

" startify config
command! S botright split | Startify
command! Sv vertical botright split | Startify
command! St tabnew | Startify

" easymotion config
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map <leader>j <Plug>(easymotion-s)
map <leader>J <Plug>(easymotion-bd-jk)

" easyalign config
vmap <leader>aa <Plug>(EasyAlign)
nmap <leader>aa <Plug>(EasyAlign)
