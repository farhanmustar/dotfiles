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

" Allows you to easily replace the current word and all its occurrences.
nnoremap <Leader>rc :%s/\<<C-r><C-w>\>/
vnoremap <Leader>rc y:%s/<C-r>"/

" Allows you to easily change the current word and all occurrences to something
" else. The difference between this and the previous mapping is that the mapping
" below pre-fills the current word for you to change.
nnoremap <Leader>cc :%s/\<<C-r><C-w>\>/<C-r><C-w>
vnoremap <Leader>cc y:%s/<C-r>"/<C-r>"

" Allow you to easily search the current word.
nnoremap <Leader>ff /\<<C-r><C-w>\><CR>
vnoremap <Leader>ff y/<C-r>"<CR>
nnoremap <Leader>fF ?\<<C-r><C-w>\><CR>
vnoremap <Leader>fF y?<C-r>"<CR>

" Diff shortcuts
noremap <silent> <leader>df :call <SID>diffToggle()<CR>
function! <SID>diffToggle()
  if &diff
    diffoff!
    windo setlocal nocursorbind
  else
    windo diffthis
  endif
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

" Smooth Scroll shortcuts
noremap <silent> <C-y> :call smooth_scroll#up(3, 0, 3)<CR>
noremap <silent> <C-e> :call smooth_scroll#down(3, 0, 3)<CR>
noremap <silent> <C-u> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <C-d> :call smooth_scroll#down(&scroll, 20, 2)<CR>
noremap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 20, 4)<CR>
noremap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 20, 4)<CR>

" Remove trailing whitespaces
noremap <silent> <leader>as :%s/\s\+$//e<CR>

" Quickfix shortcuts (grep)
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

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
  autocmd Filetype qf nnoremap <buffer> <silent> < :call <SID>OlderQF()<CR>
  autocmd Filetype qf nnoremap <buffer> <silent> > :call <SID>NewerQF()<CR>
  autocmd Filetype qf nnoremap <buffer> <silent> r :Creload<CR>
  autocmd Filetype qf nnoremap <buffer> <silent> dd :call <SID>RemoveQFItem()<CR>
  autocmd Filetype qf vnoremap <buffer> <silent> d :call <SID>RemoveQFItem()<CR>

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

" grep in current file
command! -nargs=+ -range FG silent execute "vimgrep /".(<range>? "\\%(\\%'<\\|\\%>'<\\%<'>\\|\\%'>\\)" : "").<q-args>."/j %"
nnoremap <silent> <Leader>fg :FG <C-r><C-w><CR>
vnoremap <silent> <Leader>fg y:FG <C-r>"<CR>

" grep in current path
command! -nargs=+ GP silent execute "grep! -ri '".<q-args>."' %:p:h/*"
nnoremap <silent> <Leader>gp :GP <C-r><C-w><CR>
vnoremap <silent> <Leader>gp y:GP <C-r>"<CR>

" copy current buffer filename
nnoremap <silent> yn :call CopyFileName() \| echo "Copy Filename!"<CR>
nnoremap <silent> yN :call CopyFileName(':p') \| echo "Copy Filepath!"<CR>
function! CopyFileName(...) abort
  let @0 = fnamemodify(@%, get(a:, '1', ':t'))
  let @" = @0
endfunction

" duplicate line without using register
nnoremap <silent> <leader>yp :copy.<CR>
vnoremap <silent> <leader>yp :copy'><CR>

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
elseif has('unix')
  nnoremap <silent> <leader>yt :let @+=@0<CR> :echo "Copy to + register"<CR>
else
  nnoremap <silent> <leader>yt :let @*=@0<CR> :echo "Copy to * register"<CR>
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
if has('win32')
  command! Terminal execute 'bot new | terminal pwsh.exe'
else
  command! Terminal execute 'bot new | terminal'
endif

" command window shortcut
nnoremap <leader>; :<C-f>
vnoremap <leader>; :<C-f>

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
nnoremap <Leader>/ /\%><C-R>=line('w0')-1<CR>l\%<<C-R>=line('w$')+1<CR>l
nnoremap <Leader>? ?\%><C-R>=line('w0')-1<CR>l\%<<C-R>=line('w$')+1<CR>l
nnoremap <Leader>f/ /\%><C-R>=line('w0')-1<CR>l\%<<C-R>=line('w$')+1<CR>l\<<C-r><C-w>\><CR>
nnoremap <Leader>f? ?\%><C-R>=line('w0')-1<CR>l\%<<C-R>=line('w$')+1<CR>l\<<C-r><C-w>\><CR>

" Shortcut to close all popup
command! -nargs=0 CloseAllPopup silent execute "lua for _, win in ipairs(vim.api.nvim_list_wins()) do local config = vim.api.nvim_win_get_config(win); if config.relative ~= '' then vim.api.nvim_win_close(win, false); print('Closing window', win) end end"
