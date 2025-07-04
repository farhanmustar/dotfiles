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

" vim-table-mode config
let g:table_mode_corner_corner='+'
let g:table_mode_header_fillchar='='

" Fugitive shortcuts
command! Gv vertical topleft G
command! Gt tab G
command! Greload :e "<C-r>%"<CR>
command! -nargs=+ GG call <SID>gitgrep(<q-args>, 0, 0, 0)
command! -nargs=+ GT call <SID>gitgrep(<q-args>, 1, 0, 0)
command! -nargs=* -count LL call <SID>localgitgrep(<q-args>, 0, <count>)
command! -nargs=* -count LT call <SID>localgitgrep(<q-args>, 1, <count>)
nnoremap <silent> <Leader>gg :call CMD("GG <C-r>=escape(expand('<cword>'), '"')<CR>")<CR>
vnoremap <silent> <Leader>gg y:call CMD("GG <C-r>=escape(getreg('"'), '"')<CR>")<CR>
nnoremap <silent> <Leader>gt :call CMD("GT <C-r>=escape(expand('<cword>'), '"')<CR>")<CR>
vnoremap <silent> <Leader>gt y:call CMD("GT <C-r>=escape(getreg('"'), '"')<CR>")<CR>
nnoremap <silent> <Leader>ll :call CMD(VCountStr()."LL <C-r>=escape(expand('<cword>'), '"')<CR>")<CR>
vnoremap <silent> <Leader>ll y:call CMD(VCountStr()."LL <C-r>=escape(getreg('"'), '"')<CR>")<CR>
nnoremap <silent> <Leader>lt :call CMD(VCountStr()."LT <C-r>=escape(expand('<cword>'), '"')<CR>")<CR>
vnoremap <silent> <Leader>lt y:call CMD(VCountStr()."LT <C-r>=escape(getreg('"'), '"')<CR>")<CR>
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

function! <SID>localgitgrep(args, tab, count)
  " handle command quirks when using nargs and count together.
  " this still not handle if user search LL 404 32 (404 is considered count)

  if len(a:args) > 0
    let l:args = a:args
    let l:count = a:count
  else
    " If no args provided, use count as the second argument
    if a:count == 0
      echohl ErrorMsg
      echom 'E417: Argument required'
      echohl None
      return
    endif
    let l:args = a:count
    let l:count = 0
  endif
  call <SID>gitgrep(l:args, a:tab, 1, l:count)
endfunction

function! <SID>gitgrep(args, tab, local, count)
  let l:gitref = ''
  if match(bufname(), '^fugitive://') >= 0
    let l:obj = fugitive#Object(bufname())
    if l:obj == ':'
      let l:gitref = ''
    elseif match(l:obj, '^:0:') >= 0
      let l:gitref = '' " in staged buf (skip gitref)
    else
      let l:gitref = l:obj[:6]
    endif
  endif

  let l:tab = ''
  if a:tab == 1
    let l:tab = 'tab sbuffer | '
  endif

  let l:tags = ''
  if empty(l:gitref)
    if a:local == 1
      let l:tags = '--no-exclude-standard --untracked '
    else
      " to avoid search in large path such as node_modules
      let l:tags = '--exclude-standard --untracked '
    endif
  endif

  if a:local == 1
    let l:obj = fugitive#Object(bufname())
    if l:obj == ':'
      let l:gitref = ''
    else
      let l:gitref = fnamemodify(fugitive#Path(bufname(), l:gitref == '' ? '' : l:gitref.':'), ":h".RepeatStr(a:count, ":h"))
    endif
  endif

  let l:args = string(substitute(a:args, '\\{-}', '*', 'g'))." "

  silent execute l:tab."Ggrep! -niI ".l:tags.' -- '.l:args.l:gitref
endfunction

" GV.vim shortcuts
command! -nargs=* GVBB silent execute "GVB --branches ".<q-args>
command! -nargs=* GVDB silent execute "GVB --branches --date-order ".<q-args>
command! -nargs=* GVBBB call s:GitBranchesWithRemotes(<q-args>)
function! s:GitBranchesWithRemotes(args)
  let l:data = FugitiveExecute('for-each-ref', '--format="%(refname:short) %(upstream:short)"', 'refs/heads')
  if l:data['exit_status'] != 0
    echoerr 'Branch listing return error'
    return
  endif
  let l:branches = l:data['stdout']
  for i in range(len(l:branches))
      let l:branches[i] = substitute(l:branches[i], '^"\(.*\)"$', '\1', '')
      let l:branches[i] = trim(l:branches[i])
  endfor
  silent execute 'GVB '. join(l:branches, ' ') . ' '. a:args
endfunction

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
" let g:cg_chat_model = 'gpt-3.5-turbo'
let g:cg_chat_model = 'gpt-4o-mini'

" linediff.vim config
vnoremap <leader>df :Linediff<CR>
