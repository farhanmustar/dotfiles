" Vim Completion Config

" Mucomplete config
function! s:DisableOmniComplete()
  let g:mucomplete#chains.default = {
  \   'default': ['path', 'c-n', 'dict', 'uspl'],
  \   '.*comment.*': ['path', 'c-n', 'dict', 'uspl'],
  \   '.*string.*': ['path', 'c-n', 'dict', 'uspl'],
  \ }
endfunction

function! s:EnableOmniComplete()
  let g:mucomplete#chains.default = {
  \   'default': ['path', 'omni', 'c-n', 'dict', 'uspl'],
  \   '.*comment.*': ['path', 'c-n', 'omni', 'dict', 'uspl'],
  \   '.*string.*': ['path', 'c-n', 'omni', 'dict', 'uspl'],
  \ }
endfunction

let g:mucomplete#enable_auto_at_startup = 1  " comment to disable auto suggestion
let g:mucomplete#chains = {}
let g:mucomplete#chains.vim = ['path', 'cmd', 'c-n']
call s:EnableOmniComplete()

augroup completion
  autocmd!
  autocmd FileType * set omnifunc=ale#completion#OmniFunc
augroup END

command! DisableOmniComplete call s:DisableOmniComplete()
command! EnableOmniComplete call s:EnableOmniComplete()

inoremap <plug>MyEnter <cr>
imap <silent> <expr> <plug>MyCR pumvisible()
    \ ? "\<c-y>"
    \ : "\<plug>MyEnter"
imap <cr> <plug>MyCR
