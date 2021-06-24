" Vim Terminal Config

" terminal shortcut
tnoremap <Esc> <C-\><C-n>
tmap <C-w>h <Esc><C-w>h
tmap <C-w>j <Esc><C-w>j
tmap <C-w>k <Esc><C-w>k
tmap <C-w>l <Esc><C-w>l
nnoremap <Leader>wt :Terminal<CR>

" terminal selection
if has('win32')
  command! Terminal execute 'terminal pwsh.exe'
else
  command! Terminal execute 'terminal'
endif
