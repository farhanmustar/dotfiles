" Vim Plugin Config

" CtrlSpace config
let g:CtrlSpaceUseMouseAndArrowsInTerm = 1
let g:CtrlSpaceIgnoredFiles = '\v(tmp|temp|build|dist|env|node_modules|platforms|plugins|www\/lib)[\/]'
if executable('rg')
  let g:CtrlSpaceGlobCommand = "rg --color=never --files --hidden -g '!.git'"
endif
command! -nargs=* -range CtrlSpaceSearch :call ctrlspace#window#Toggle(0) | :call feedkeys("O".toupper(<q-args>)."\<CR>")
nnoremap <expr> <Leader>fn ':CtrlSpaceSearch ' . expand('<cword>') . '<CR>'
vnoremap <silent> <Leader>fn y:CtrlSpaceSearch <C-r>"<CR>
nnoremap <silent> <leader>rt :CtrlSpaceTabLabel<CR> \| :redrawtabline<CR>

" Allow C-p as C-Space alternative
function! CallCtrlSpace(k)
  execute 'CtrlSpace'
endfunction
noremap <silent> <C-p> :CtrlSpace<CR>
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
command! -nargs=+ GG silent execute "Ggrep! -niI --exclude-standard --untracked ".string(<q-args>)
command! -nargs=+ GT silent execute "tab sbuffer | Ggrep! -niI --exclude-standard --untracked ".string(<q-args>)
command! -nargs=+ LL silent execute "Ggrep! -niI --no-exclude-standard --untracked ".string(<q-args>)." -- ".expand("%:p:h")
command! -nargs=+ LT silent execute "tab sbuffer | Ggrep! -niI --no-exclude-standard --untracked ".string(<q-args>)." -- ".expand("%:p:h")
nnoremap <silent> <Leader>gg :GG <C-r><C-w><CR>
vnoremap <silent> <Leader>gg y:GG <C-r>"<CR>
nnoremap <silent> <Leader>gt :GT <C-r><C-w><CR>
vnoremap <silent> <Leader>gt y:GT <C-r>"<CR>
nnoremap <silent> <Leader>ll :LL <C-r><C-w><CR>
vnoremap <silent> <Leader>ll y:LL <C-r>"<CR>
nnoremap <silent> <Leader>lt :LT <C-r><C-w><CR>
vnoremap <silent> <Leader>lt y:LT <C-r>"<CR>
cnoreabbrev GBlame G blame
cnoreabbrev GFetch G fetch
cnoreabbrev GPull G pull
cnoreabbrev GPush G push
cnoreabbrev GRebase G rebase
cnoreabbrev GStash G stash
cnoreabbrev Gblame G blame
cnoreabbrev Gfetch G fetch
cnoreabbrev Gpull G pull
cnoreabbrev Gpush G push
cnoreabbrev Grebase G rebase
cnoreabbrev Gstash G stash
let g:nremap = {'gr': 'gR'}
let g:oremap = {'gr': 'gR'}
let g:xremap = {'gr': 'gR'}

" GV.vim shortcuts
command! -nargs=0 GVBB silent execute "GVB --branches"

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
" by default st is for :stop cmd which is so anoying.
" this actually suspend the process and can be resume by executing "fg"
" so we can remove this curse, yay!
" cnoreabbrev st St

" easymotion config
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map <leader>j <Plug>(easymotion-overwin-f)
map <leader>J <Plug>(easymotion-overwin-line)

" easyalign config
vmap <leader>aa <Plug>(EasyAlign)
nmap <leader>aa <Plug>(EasyAlign)
vmap <leader>ai <Plug>(LiveEasyAlign)
nmap <leader>ai <Plug>(LiveEasyAlign)

" bufsurf config
nmap gi <Plug>(buf-surf-forward)
nmap go <Plug>(buf-surf-back)

" highlighted yank config
let g:highlightedyank_highlight_duration = 100

" Asyncrun setting
let g:asyncrun_open = 20
let g:asyncrun_qfid = 'asyncrun'
command! -bang -nargs=+ -range=0 -complete=file Run
		\ call <SID>run('<bang>', '', <q-args>, <count>, <line1>, <line2>)
command! -bar -bang -nargs=0 RunStop call asyncrun#stop('<bang>')
command! -bar -bang -nargs=0 RunAgain call <SID>rerun()
function! <SID>run(a, b, c, d, e, f)
  let s:run_func = {
  \ 'a': a:a,
  \ 'b': a:b,
  \ 'c': a:c,
  \ 'd': a:d,
  \ 'e': a:e,
  \ 'f': a:f,
  \}
  call asyncrun#run(a:a, a:b, a:c, a:d, a:e, a:f)
endfunction
function! <SID>rerun()
  if !has_key(s:, 'run_func')
    echom 'No previous run cmd.'
    return
  endif
  let p = s:run_func
  call asyncrun#run(p['a'], p['b'], p['c'], p['d'], p['e'], p['f'])
endfunction
nnoremap <silent> <leader>bb :RunAgain<CR>

" CamelCaseMotion config
silent! call camelcasemotion#CreateMotionMappings(',')

" cs.vim config
nmap <leader>cs <Plug>(CS-Promp)
vmap <leader>cs <Plug>(CS-Promp)
