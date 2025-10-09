" Vim Shortcut Config

" set space as leader key
nnoremap <Space> <Nop>
map <Space> <Leader>

" Unmap CTRL-Y(redo) to its original scroll
silent! nunmap <C-Y>
silent! iunmap <C-Y>
silent! xunmap <C-Y>

" Unmap CTRL-A(select all) to its original add to number
silent! nunmap <C-A>
silent! iunmap <C-A>
silent! xunmap <C-A>

" Unmap CTRL-A(cut) to its original add to number
silent! vunmap <C-x>

" Tab Shortcut
" Open new tab remap
nnoremap <silent> <C-w>t :tab sbuffer % \| doautocmd BufEnter<CR>
" Avoid pressing shift key to switch to previous tab
noremap gr gT
" close all tabs to the right or to the left
command! -nargs=0 Tcr silent execute '.+1,$tabdo :tabc'
command! -nargs=0 Tcl silent execute '0,.-1tabdo :tabc'
cnoreabbrev tabcloser Tcr
cnoreabbrev tabclosel Tcl
" move tab shortcut
nnoremap <leader><left> :-tabmove<CR>
nnoremap <leader><right> :+tabmove<CR>

" Move by virtual lines when used without a count
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Quickly select the text that was just pasted. This allows you to, e.g.,
" indent it after pasting.
noremap gV `[v`]

" Stay in visual mode when indenting. You will never have to run gv after
" performing an indentation.
vnoremap < <gv
vnoremap > >gv

" remove single character or add single space shortcut
vnoremap <leader>< :s/^.//<CR>gv
vnoremap <leader>> :s/^/ /<CR>gv

" move text in visual mode
vnoremap <silent> K :<C-u>call MoveSelectionUp(v:count1)<CR>
vnoremap <silent> J :<C-u>call MoveSelectionDown(v:count1)<CR>
function! MoveSelectionUp(count)
  execute "'<,'>move '<--".a:count
  normal gv
endfunction
function! MoveSelectionDown(count)
  execute "'<,'>move '>+".a:count
  normal gv
endfunction

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
noremap Y y$

noremap <leader>v vg_

" Allows you to easily replace the current word and all its occurrences.
nnoremap <Leader>rc :%s/\<<C-r><C-w>\>/
vnoremap <Leader>rc y:%s/<C-r>"/
nnoremap <Leader>cr :%s/\<<C-r><C-w>\>/
vnoremap <Leader>cr y:%s/<C-r>"/

" Allows you to easily change the current word and all occurrences to something
" else. The difference between this and the previous mapping is that the mapping
" below pre-fills the current word for you to change.
nnoremap <Leader>cc :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cc y:%s/<C-r>"/<C-r>"

" Allow you to easily search the current word.
nnoremap <Leader>ff /\<<C-r><C-w>\><CR>:set hlsearch<CR>:lua require("hlslens").start()<CR>
vnoremap <Leader>ff y/<C-r>"<CR>:set hlsearch<CR>:lua require("hlslens").start()<CR>
nnoremap <Leader>fF ?\<<C-r><C-w>\><CR>:set hlsearch<CR>:lua require("hlslens").start()<CR>
vnoremap <Leader>fF y?<C-r>"<CR>:set hlsearch<CR>:lua require("hlslens").start()<CR>

" Diff shortcuts
nnoremap <silent> <leader>df :call <SID>diffToggle()<CR>
function! <SID>diffToggle()
  let l:winid = win_getid()
  if &diff
    diffoff!
    windo execute win_gettype() == '' ? 'setlocal nocursorbind': ''
  else
    windo execute win_gettype() == '' ? 'diffthis' : ''
  endif
  call win_gotoid(l:winid)
endfunction

" Toggle paste mode
nnoremap <silent> <Leader>pm :call <SID>pasteToggle()<CR>
function! <SID>pasteToggle()
  if &paste
		set nopaste
		echo 'Paste Mode Disabled'
  else
		set paste
		echo 'Paste Mode Enabled'
  endif
endfunction

" Paste yank register
nnoremap <silent> <Leader>pp "0p
vnoremap <silent> <Leader>pp "0p

" Remove trailing whitespaces
noremap <silent> <leader>as :%s/\s\+$//e<CR>

" Quickfix shortcuts (grep)
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>
" (this overwrite gn - to go next and select matching search)
nnoremap gn :cnext<CR>
nnoremap gN :cprev<CR>

" Quickfix custom command
command! -nargs=0 Creload silent call <SID>ReloadQFItem()
command! -nargs=0 Cbufopen silent cfdo p

function! s:ReloadQFItem() range
  let win_state = winsaveview()

  call setqflist(map(getqflist(), 'extend(v:val, {"text":get(getbufline(v:val.bufnr, v:val.lnum),0,"(buf not load)")})'))

  call winrestview(win_state)
endfunction

function! s:RemoveQFItem() range
  let win_state = winsaveview()
  let qfall = getqflist()
  call remove(qfall, a:firstline - 1, a:lastline - 1)
  call setqflist(qfall)
  call winrestview(win_state)
endfunction

function! s:YankQFItem() range
  let qfsel = getqflist()[a:firstline - 1: a:lastline - 1]
  " map is mutable operation, make copy
  let sel = qfsel[:]->map('v:val["text"]')->join("\n")."\n"
  let @0 = sel
  let @" = sel

  " highlight indicator
  let pos = qfsel->map('[v:key + a:firstline, v:val["module"]->len() + v:val["lnum"]->len() + 4, v:val["text"]->len()]')
  call AddHighlightWithTimeout('IncSearch', pos, 150)
endfunction

function! s:OlderQF() range
  let win_state = winsaveview()
  let cur_qf = getqflist({'nr' : 0}).nr
  if cur_qf <= 1
    return
  endif
  colder
  call winrestview(win_state)
endfunction

function! s:NewerQF() range
  let win_state = winsaveview()
  let cur_qf = getqflist({'nr' : 0}).nr
  let num_qf = getqflist({'nr' : '$'}).nr
  if cur_qf >= num_qf
    return
  endif
  cnewer
  call winrestview(win_state)
endfunction

augroup quickfix
  autocmd!
  autocmd Filetype qf nnoremap <buffer> <silent> <expr> <CR> &buftype is# 'quickfix' ? '<CR>zz<C-w>p' : '<CR>'
  autocmd Filetype qf nnoremap <buffer> <silent> <expr> o &buftype is# 'quickfix' ? '<CR>' : 'o'
  autocmd Filetype qf nnoremap <buffer> <silent> <expr> O &buftype is# 'quickfix' ? ':tab sbuffer % \| doautocmd BufEnter<CR><CR>' : 'o'
  autocmd Filetype qf nnoremap <buffer> <silent> < :call <SID>OlderQF()<CR>
  autocmd Filetype qf nnoremap <buffer> <silent> > :call <SID>NewerQF()<CR>
  autocmd Filetype qf nnoremap <buffer> <silent> r :Creload<CR>
  autocmd Filetype qf nnoremap <buffer> <silent> dd :call <SID>RemoveQFItem()<CR>
  autocmd Filetype qf vnoremap <buffer> <silent> d :call <SID>RemoveQFItem()<CR>
  autocmd Filetype qf nnoremap <buffer> <silent> yy :call <SID>YankQFItem()<CR>
  autocmd Filetype qf nnoremap <buffer> <silent> <leader>yy yy

  " Auto open quickfix window
  autocmd QuickFixCmdPost [^l]* nested bot cwindow 20 | redraw!
  autocmd QuickFixCmdPost l* nested bot lwindow 20 | redraw!
augroup END

" Hard mode - disable arrow keys
map <Up>	 :echo "no!"<CR>
map <Down>	 :echo "no!"<CR>
map <Left>	 :echo "no!"<CR>
map <Right>	 :echo "no!"<CR>
inoremap <Up>		<Nop>
inoremap <Down>		<Nop>
inoremap <Left>		<Nop>
inoremap <Right>	<Nop>

" window resize
nnoremap <silent> <Right> :vertical resize +10<CR>
nnoremap <silent> <Left> :vertical resize -10<CR>
nnoremap <silent> <Up> :resize +10<CR>
nnoremap <silent> <Down> :resize -10<CR>

" Disable Execute Mode
nmap Q	<Nop>

" close pane using shortcut
nnoremap gq <C-w>c

" vimscript dev mapping
nnoremap <silent> <expr> <Leader>so (&filetype is# 'lua' \|\| &filetype is# 'vim') ? ':source % \| echo "Sourced!"<CR>' : ':echo "Not vim config"<CR>'

" pane navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

command! Cadd caddexpr expand("%") .. ":" .. line(".") ..  ":" .. getline(".")

" grep in current file
command! -nargs=+ -range FG silent execute "vimgrep /".(<range>? "\\%(\\%'<\\|\\%>'<\\%<'>\\|\\%'>\\)" : "").<q-args>."/j %"
nnoremap <silent> <Leader>fg :call CMD("FG <C-r>=escape(expand('<cword>'), '"')<CR>")<CR>
vnoremap <silent> <Leader>fg y:call CMD("FG <C-r>=escape(getreg('"'), '"')<CR>")<CR>

" grep in current path
" use ripgrep as grepprg
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-column
  command! -nargs=+ -count GP silent execute "grep! '".<q-args>."' '%:p:h".RepeatStr(<count>,":h")."'/*"
else
  command! -nargs=+ -count GP silent execute "grep! -ri '".<q-args>."' %:p:h".RepeatStr(<count>,":h")."/*"
endif

nnoremap <silent> <Leader>gp :call CMD(VCountStr()."GP <C-r>=escape(expand('<cword>'), '"')<CR>")<CR>
vnoremap <silent> <Leader>gp y:call CMD(VCountStr()."GP <C-r>=escape(getreg('"'), '"')<CR>")<CR>

" copy current buffer filename
nnoremap <silent> yn :call CopyFileName() \| echo "Copy Filename!"<CR>
nnoremap <silent> yN :call CopyFileName(':p') \| echo "Copy Filepath!"<CR>
function! CopyFileName(...) abort
  let @0 = fnamemodify(@%, get(a:, '1', ':t'))
  let @" = @0
endfunction
nnoremap <silent> <Leader>yn :call CopyGitFilePath() \| echo "Copy Git Filepath!"<CR>
function! CopyGitFilePath() abort
  let @0 = fugitive#Path(expand('%'), '')
  let @" = @0
endfunction
" claude instruction shortcut
function! ClaudeCodeCommand(...) abort
  let l:f = get(a:, '1', 'instruction.md')
  let l:f = len(l:f) > 0 ? l:f : 'instruction.md'
  let l:f = substitute(l:f, ' ', '_', 'g')
  if !s:isPrefix('.md', l:f)
    let l:f = l:f.'.md'
  endif
  let l:p = fnamemodify(FugitiveGitDir(), ':h')
  let l:dir = l:p.'/.claude/commands'
  let l:p = l:dir.'/'.l:f
  if !isdirectory(l:dir)
    call mkdir(l:dir, 'p')
  endif
  execute 'botright' 'split'
  execute 'edit' l:p
endfunction
command! -nargs=? ClaudeCodeCommand silent call ClaudeCodeCommand(<q-args>)
nnoremap <silent> <leader>cI <Cmd>ClaudeCodeCommand<CR>

function! s:isPrefix(prefix, str)
    return strpart(a:str, len(a:str) - len(a:prefix)) == a:prefix
endfunction

" duplicate line without using register
nnoremap <silent> <leader>yp :copy.<CR>
vnoremap <silent> <leader>yp :copy'><CR>

" yank and put cursor at the end of selection
vnoremap <silent> <leader>yy y`]

" copy paste buffer using bufnr
nnoremap <silent> <C-w>y :call CopyBuffer()<CR>
nnoremap <silent> <C-w>p :call PasteBuffer()<CR>
function! CopyBuffer() abort
  let s:copy_buffer = bufnr('%')
  let s:copy_buffer_state = winsaveview()
  echom 'Buffer copied'
endfunction
function! PasteBuffer() abort
  if !exists('s:copy_buffer')
    echohl WarningMsg
    echom 'No buffer in clipboard'
    echohl None
    return
  endif
  execute 'buffer '.s:copy_buffer
  call winrestview(s:copy_buffer_state)
endfunction

" refresh syntax
command! -nargs=0 Refresh silent execute 'do Syntax'

" system clipboard integration
if has('unix')
  if !exists('s:wsl')
    let n = system('uname -a')
    let s:wsl = stridx(n, 'microsoft') >= 0
  endif
  " refer help wsl
  if s:wsl && !exists('g:clipboard')
    let g:clipboard = {
    \   'name': 'WslClipboard',
    \   'copy': {
    \     '+': 'clip',
    \     '*': 'clip',
    \   },
    \   'paste': {
    \     '+': 'powershell -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \     '*': 'powershell -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
    \   },
    \   'cache_enabled': 0,
    \ }
  endif
endif

if exists('$TMUX')
  nnoremap <silent> <leader>yt :call system("tmux load-buffer -", @0)<CR> :echo "Copy to tmux"<CR>
  nnoremap <silent> <leader>ys :let @+=@0<CR> :echo "Copy to + register"<CR>
elseif has('unix')
  nnoremap <silent> <leader>yt :let @+=@0<CR> :echo "Copy to + register"<CR>
  nnoremap <silent> <leader>ys :let @+=@0<CR> :echo "Copy to + register"<CR>
else
  nnoremap <silent> <leader>yt :let @*=@0<CR> :echo "Copy to * register"<CR>
  nnoremap <silent> <leader>ys :let @*=@0<CR> :echo "Copy to * register"<CR>
  inoremap <C-q>p <C-r>*
endif

" Vim Terminal Config
" terminal shortcut
tnoremap <Esc> <C-\><C-n>
tmap <C-w>h <Esc><C-w>h
tmap <C-w>j <Esc><C-w>j
tmap <C-w>k <Esc><C-w>k
tmap <C-w>l <Esc><C-w>l
tmap <C-h> <Esc><C-w>h
tmap <C-j> <Esc><C-w>j
tmap <C-k> <Esc><C-w>k
tmap <C-l> <Esc><C-w>l
tnoremap <silent> <expr> <C-r> '<C-\><C-n>"'.nr2char(getchar()).'pi'
nnoremap <Leader>wt :Terminal<CR>

" terminal selection
" TODO: is win32 need fix?
command! Terminal let s:term_dir=expand('%:p:h') | below new | setlocal nonumber | call termopen([&shell], {'cwd': s:term_dir })


" command window shortcut
nnoremap <leader>; q:
vnoremap <leader>; q:

" run macro on multiple selected line
xnoremap @ :<C-u>call <SID>executeMacroOverVisualRange()<CR>
function! <SID>executeMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Repeat macro shortcut.
nnoremap <Leader>. @@
vnoremap <Leader>. @@

" sudo write shortcut
cnoreabbrev w!! SudaWrite

" Search in selection shortcut
xnoremap <Leader>/ <Esc>/<C-R><C-R>=<SID>CachedVisualRangeSearchTerm()<CR>
xnoremap <Leader>? <Esc>?<C-R><C-R>=<SID>CachedVisualRangeSearchTerm()<CR>
function! s:CachedVisualRangeSearchTerm()
    let l:line0 = line("'<")
    let l:line1 = line("'>")
    let l:col0 = virtcol("'<")
    let l:col1 = virtcol("'>")

    if visualmode() == ''
        " visual block mode
        if l:col0 > l:col1
            let l:col0 = l:col1
            let l:col1 = virtcol("'<")
        endif
        if l:line0 == l:line1
            let l:lineconstraints = '\%' . (l:line0) . 'l'
        else
            let l:lineconstraints = '\%>' . (l:line0-1) . 'l' . '\%<' . (line("'>")+1) . 'l' . '\%<' . (l:line1+1) . 'l'
        endif
        if l:col0 == l:col1
            let l:colconstraints = '\%' . (l:col0) . 'v'
        else
            let l:colconstraints = '\%>' . (l:col0-1) . 'v' . '\%<' . (line("'>")+1) . 'l' . '\%<' . (l:col1+1) . 'v'
        endif
        return l:lineconstraints . l:colconstraints
    elseif visualmode() ==# 'v'
        " visual character-wise
        if l:line0 == l:line1
            return '\%' . l:line0 . 'l' . '\%>' . (l:col0-1) . 'v' . '\%<' . (l:col1+1) . 'v'
        elseif l:line1 - l:line0 == 1
            return '\%(' .
                \ '\%' . l:line0 . 'l' . '\%>' . (l:col0-1) . 'v' . '\|' .
                \ '\%' . l:line1 . 'l' . '\%<' . (l:col1+1) . 'v' .
                \ '\)'
        else
            return '\%(' .
                \ '\%' . l:line0 . 'l' . '\%>' . (l:col0-1) . 'v' . '\|' .
                \ '\%' . l:line1 . 'l' . '\%<' . (l:col1+1) . 'v' . '\|' .
                \ '\%>' . l:line0 . 'l' . '\%<' . l:line1 . 'l' .
                \ '\)'
        endif
    else
        " visual line-wise
        if l:line0 == l:line1
            return '\%' . l:line0 . 'l'
        else
            return '\%>' . (l:line0-1) . 'l\%<' . (l:line1+1) . 'l'
        endif
    endif
endfunction
nnoremap <Leader>f/ /\%><C-R>=line('w0')-1<CR>l\%<<C-R>=line('w$')+1<CR>l
nnoremap <Leader>fs /\%><C-R>=line('w0')-1<CR>l\%<<C-R>=line('w$')+1<CR>l\<<C-r><C-w>\><CR>

" Shortcut to close all popup
command! -nargs=0 CloseAllPopup silent execute "lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= '' then vim.api.nvim_win_close(win, false); print('Closing window', win) end end"

" Shortcut change tab width
command! -nargs=1 SetTab silent call <SID>SetTab(<args>)

function! s:SetTab(w) abort
  execute 'setlocal tabstop='.a:w
  execute 'setlocal shiftwidth='.a:w
  setlocal expandtab
  setlocal smarttab
endfunction

command! TabDuplicate silent call <SID>TabDuplicate()
function! s:TabDuplicate() abort
  let sessionoptions = &sessionoptions
  try
    let &sessionoptions = 'blank,help,folds,winsize,localoptions'
    let file = tempname()
    execute 'mksession ' . file
    tabnew
    execute 'source ' . file
  finally
    silent call delete(file)
    let &sessionoptions = sessionoptions
  endtry
endfunction
cnoreabbrev tabduplicate TabDuplicate
nnorem <C-w><C-t> :TabDuplicate<CR>

" Shortcut split and join lines
command! -nargs=1 -range Split silent call <SID>Split(<line1>, <line2>, <q-args>)
function! s:Split(start, end, split) abort
  let l:split = substitute(a:split, '%', '\\%', 'g')
  execute a:start.",".a:end."s%".l:split."%\r%g"
endfunction
command! -nargs=? -range Join silent call <SID>Join(<line1>, <line2>, <q-args>)
function! s:Join(start, end, join) abort
  if a:start == a:end
    return
  endif

  let l:join = substitute(a:join, '%', '\\%', 'g')
  execute a:start.",".a:end."s%\\n\\($\\)\\@!%".l:join."%g"
endfunction

" horizontal navigation
nnoremap gh _
nnoremap gl g_
vnoremap gh _
vnoremap gl g_
nnoremap <A-u> 10zl
nnoremap <A-d> 10zh
vnoremap <A-u> 10zl
vnoremap <A-d> 10zh
