" Vim Plugin Config

" CtrlSpace config
let g:CtrlSpaceUseMouseAndArrowsInTerm = 1
let g:CtrlSpaceIgnoredFiles = '\v(tmp|temp|build|dist|env|node_modules|platforms|plugins|www\/lib)[\/]'
if executable('rg')
  let g:CtrlSpaceGlobCommand = 'rg --color=never --files --hidden -g "!.git"'
endif
command! -nargs=* -range CtrlSpaceSearch :call ctrlspace#window#Toggle(0) | :call feedkeys("O".toupper(<q-args>)."\<CR>")
nnoremap <silent> <Leader>fn :call CMD('CtrlSpaceSearch <C-r><C-w>')<CR>
vnoremap <silent> <Leader>fn y:call CMD('CtrlSpaceSearch <C-r>"')<CR>
nnoremap <silent> <leader>rt :CtrlSpaceTabLabel<CR> \| :redrawtabline<CR>

" Allow ɀ(\u0240) as C-Space alternative used by term emulator for issue with powershell/cmd shell
noremap <silent> ɀ :CtrlSpace<CR>
noremap <silent> <C-space> :CtrlSpace<CR>

if has('termux')
  let g:CtrlSpaceFileEngine = "file_engine_termux"
endif

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
nnoremap <silent> <Leader>gg :call CMD('GG <C-r><C-w>')<CR>
vnoremap <silent> <Leader>gg y:call CMD('GG <C-r>"')<CR>
nnoremap <silent> <Leader>gt :call CMD('GT <C-r><C-w>')<CR>
vnoremap <silent> <Leader>gt y:call CMD('GT <C-r>"')<CR>
nnoremap <silent> <Leader>ll :call CMD('LL <C-r><C-w>')<CR>
vnoremap <silent> <Leader>ll y:call CMD('LL <C-r>"')<CR>
nnoremap <silent> <Leader>lt :call CMD('LT <C-r><C-w>')<CR>
vnoremap <silent> <Leader>lt y:call CMD('LT <C-r>"')<CR>
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
command! -nargs=* GVBB silent execute "GVB --branches ".<q-args>
command! -nargs=* GVDB silent execute "GVB --branches --date-order ".<q-args>

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
vmap <leader>j <Plug>(easymotion-s)
vmap <leader>J <Plug>(easymotion-bd-jk)

" easyalign config
vmap <leader>aa <Plug>(EasyAlign)
nmap <leader>aa <Plug>(EasyAlign)
vmap <leader>al <Plug>(LiveEasyAlign)
nmap <leader>al <Plug>(LiveEasyAlign)

" bufsurf config
nmap gi <Plug>(buf-surf-forward)
nmap go <Plug>(buf-surf-back)

" Asyncrun setting
let g:asyncrun_open = 20
let g:asyncrun_qfid = 'asyncrun'
command! -bang -nargs=+ -range=0 -complete=file Run
		\ call <SID>run('<bang>', '', <q-args>, <count>, <line1>, <line2>)
command! -bang -nargs=+ -range=0 -complete=file RunTerm
    \ call <SID>run('<bang>', {'mode':'term'}, <q-args>, <count>, <line1>, <line2>)
command! -bar -bang -nargs=0 RunStop call asyncrun#stop('<bang>')
command! -bar -bang -nargs=0 RunAgain call <SID>rerun()
" TODO: add compiler option after the command or auto mapping based on buffer filetype..?. investigate if this good feature.
" NOTE: for python we use compiler plugin to add quickfix error format helper.
" run the following command to enable the plugin ':compiler! python'
function! <SID>run(a, b, c, d, e, f)
  let s:run_func = {
  \ 'a': a:a,
  \ 'b': a:b,
  \ 'c': a:c,
  \ 'd': a:d,
  \ 'e': a:e,
  \ 'f': a:f,
  \}
  call <SID>updateCompiler()
  call asyncrun#run(a:a, a:b, a:c, a:d, a:e, a:f)
endfunction
function! <SID>rerun()
  if !has_key(s:, 'run_func')
    echom 'No previous run cmd.'
    return
  endif
  call <SID>updateCompiler()
  let p = s:run_func
  call asyncrun#run(p['a'], p['b'], p['c'], p['d'], p['e'], p['f'])
endfunction
function! <SID>updateCompiler()
  " to ensure error highlight correctly
  if &filetype == 'python'
    compiler! python
  elseif &filetype == 'cpp'
    compiler! gcc
  endif
endfunction
nnoremap <silent> <leader>bb :RunAgain<CR>
nnoremap <silent> <leader>bs :RunStop<CR>

" float_preview config
let g:float_preview#docked = 0

" CamelCaseMotion config
silent! call camelcasemotion#CreateMotionMappings(',')

" cs.vim config
nmap <leader>cs <Plug>(CS-Promp)
vmap <leader>cs <Plug>(CS-Promp)

" vim-fuzzysearch config
nnoremap <Leader>/ :FuzzySearch<CR>

" cg.vim config
let g:cg_api_key = getenv('OPENAPI_KEY')

" linediff.vim config
vnoremap <leader>df :Linediff<CR>
