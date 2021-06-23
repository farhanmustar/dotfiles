" Vim Completion Config

" Mucomplete config
let g:mucomplete#enable_auto_at_startup = 1  " comment to disable auto suggestion
let g:mucomplete#chains = {}
let g:mucomplete#chains.vim = ['path', 'cmd', 'c-n']
let g:mucomplete#chains.default = {
\   'default': ['path', 'omni', 'c-n', 'dict', 'uspl'],
\   '.*comment.*': ['path', 'c-n', 'omni', 'dict', 'uspl'],
\   '.*string.*': ['path', 'c-n', 'omni', 'dict', 'uspl'],
\ }
augroup completion
  autocmd!
  autocmd FileType * set omnifunc=ale#completion#OmniFunc
augroup END
inoremap <plug>MyEnter <cr>
imap <silent> <expr> <plug>MyCR pumvisible()
    \ ? "\<c-y>"
    \ : "\<plug>MyEnter"
imap <cr> <plug>MyCR
