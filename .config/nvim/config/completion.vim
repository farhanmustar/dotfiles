" Vim Completion Config

" Mucomplete config
function! s:DisableOmniComplete()
  let g:mucomplete#chains.default = {
  \   'default': ['path', 'user', 'c-n', 'dict', 'uspl'],
  \   '.*comment.*': ['path', 'user', 'c-n', 'dict', 'uspl'],
  \   '.*string.*': ['path', 'user', 'c-n', 'dict', 'uspl'],
  \ }
endfunction

function! s:EnableOmniComplete()
  let g:mucomplete#chains.default = {
  \   'default': ['path', 'user', 'omni', 'c-n', 'dict', 'uspl'],
  \   '.*comment.*': ['path', 'c-n', 'user', 'omni', 'dict', 'uspl'],
  \   '.*string.*': ['path', 'c-n', 'user', 'omni', 'dict', 'uspl'],
  \ }
endfunction

let g:mucomplete#enable_auto_at_startup = 1  " comment to disable auto suggestion
let g:mucomplete#chains = {}
let g:mucomplete#chains.vim = ['path', 'cmd', 'c-n']
" call s:EnableOmniComplete()
call s:DisableOmniComplete()

augroup completion
  autocmd!
  autocmd FileType * set completefunc=v:lua.vim.luasnip.completefunc
augroup END

command! DisableOmniComplete call s:DisableOmniComplete()
command! EnableOmniComplete call s:EnableOmniComplete()

" mapping for luasnip and Mucomplete
inoremap <plug>MyEnter <cr>
function! MyCRAction()
  if (pumvisible() && luasnip#expandable())
    return "\<Plug>luasnip-expand-snippet"
  elseif (pumvisible() && CB_can_expand())
    return "\<Plug>CBExpand"
  elseif pumvisible()
    return "\<c-y>"
  else
    return "\<plug>MyEnter"
  endif
endfunction
imap <silent> <expr> <plug>MyCR MyCRAction()
imap <cr> <plug>MyCR

smap <unique> <tab> <Plug>luasnip-jump-next
xmap <unique> <tab> <Plug>luasnip-jump-next
inoremap <plug>MyTab <tab>
function! MyTabAction()
  if pumvisible()
    return "\<plug>(MyFwd)"
  elseif luasnip#jumpable(1)
    return "\<plug>luasnip-jump-next"
  else
    return "\<plug>MyTab"
  endif
endfunction
imap <plug>(MyFwd) <plug>(MUcompleteFwd)
imap <expr> <silent> <tab> MyTabAction()

smap <unique> <S-tab> <Plug>luasnip-jump-prev
xmap <unique> <S-tab> <Plug>luasnip-jump-prev
inoremap <plug>MySTab <S-tab>
function! MySTabAction()
  if pumvisible()
    return "\<plug>(MyBwd)"
  elseif luasnip#jumpable(0)
    return "\<plug>luasnip-jump-prev"
  else
    return "\<plug>MySTab"
  endif
endfunction
imap <plug>(MyBwd) <plug>(MUcompleteBwd)
imap <expr> <silent> <S-tab> MySTabAction()

function! MyEscAction()
  silent LuaSnipUnlinkCurrent
  return "\<plug>MyEsc"
endfunction
inoremap <plug>MyEsc <Esc>
imap <expr> <silent> <Esc> MyEscAction()
xnoremap <plug>MyEsc <Esc>
xmap <expr> <silent> <Esc> MyEscAction()
snoremap <plug>MyEsc <Esc>
smap <expr> <silent> <Esc> MyEscAction()
