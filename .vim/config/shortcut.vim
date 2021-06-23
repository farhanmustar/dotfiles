" Vim Shortcut Config

" set space as leader key
nnoremap <Space> <Nop>
map <Space> <Leader>

" Unmap CTRL-Y(redo) to its original scroll
nunmap <C-Y>
iunmap <C-Y>

" Open new tab remap
nnoremap <C-w>t :tab sbuffer<CR>

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

" Make Y yank everything from the cursor to the end of the line. This makes Y
" act more like C or D because by default, Y yanks the current line (i.e. the
" same as yy).
noremap Y y$

" Avoid pressing shift key to switch to previous tab
noremap gr gT

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

" Diff shortcuts
noremap <leader>df :call DiffToggle()<CR>
function! DiffToggle()
  if &diff
    diffoff!
    windo setlocal nocursorbind
  else
    windo diffthis
  endif
endfunction

" Toggle paste mode
nnoremap <Leader>pp :call PasteToggle()<CR>
function! PasteToggle()
  if &paste
		set nopaste
		echo 'Paste Mode Disabled'
  else
		set paste
		echo 'Paste Mode Enabled'
  endif
endfunction

" Smooth Scroll shortcuts
noremap <silent> <C-y> :call smooth_scroll#up(3, 0, 3)<CR>
noremap <silent> <C-e> :call smooth_scroll#down(3, 0, 3)<CR>
noremap <silent> <C-u> :call smooth_scroll#up(&scroll, 20, 2)<CR>
noremap <silent> <C-d> :call smooth_scroll#down(&scroll, 20, 2)<CR>
noremap <silent> <C-b> :call smooth_scroll#up(&scroll*2, 20, 4)<CR>
noremap <silent> <C-f> :call smooth_scroll#down(&scroll*2, 20, 4)<CR>

" Remove trailing whitespaces
noremap <leader>as :%s/\s\+$//e<CR>

" Quickfix shortcuts (grep)
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
nnoremap <expr> <CR> &buftype is# 'quickfix' ? '<CR>zz<C-w>p' : '<CR>'

" Auto open quickfix window
augroup quickfix
  autocmd!
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
nnoremap <Right> :vertical resize +10<CR>
nnoremap <Left> :vertical resize -10<CR>
nnoremap <Up> :resize +10<CR>
nnoremap <Down> :resize -10<CR>

" Disable Execute Mode
nmap Q	<Nop>

" close pane using shortcut
nnoremap gq <C-w>c

" vimscript dev mapping
nnoremap <Leader>so :source %<CR>
