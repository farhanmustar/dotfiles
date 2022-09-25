inoremap <C-f> <C-r>=<SID>clipboard_completion()<CR>

let g:clipboard_limit = get(g:, 'clipboard_limit', 10)
let s:clipboard_stack = get(s:, 'clipboard_stack', [])

function! s:clipboard_completion() abort
  call complete(col('.'), s:get_stack_completion())
  return ''
endfunction

function! s:on_yank() abort
  call s:save_stack(getreg('0'))
endfunction

augroup ClipboardCompletion
  autocmd!
  autocmd TextYankPost * silent! call <SID>on_yank()
augroup END

function! s:save_stack(content) abort
  if empty(a:content)
    return
  endif

  let idx = index(s:clipboard_stack, a:content)

  if idx >= 0
    call remove(s:clipboard_stack, idx)
  endif

  call add(s:clipboard_stack, a:content)

  if len(s:clipboard_stack) > g:clipboard_limit
    let s:clipboard_stack = s:clipboard_stack[1:]
  endif
endfunction

function! s:get_stack_completion() abort
  let options = []
  for c in s:clipboard_stack
    let abr = trim(c)
    if len(abr) > 20
      let abr = abr[:20-3].'...'
    endif
    call add(options,
    \ {
    \   'menu': '[cb]',
    \   'word': '',
    \   'abbr': abr,
    \   'info': "|".substitute(c, "\n", "\n|", 'g'),
    \   'dup': 1,
    \   'empty': 1,
    \ },
    \)
  endfor
  return reverse(options)
endfunction

function! CB_can_expand() abort
  if !pumvisible()
    return
  endif
  return get(v:completed_item, 'menu', '') == '[cb]'
endfunction

function! s:expand() abort
  if get(v:completed_item, 'menu', '') != '[cb]'
    return
  endif
  let @" = substitute(get(v:completed_item, 'info', ' ')[1:], "\n|", "\n", 'g')

  call feedkeys(
        \"\<C-o>:set paste\<CR>".
        \"\<C-r>\"".
        \"\<C-o>:set nopaste\<CR>"
        \)

  return ''
endfunction

imap <expr> <silent> <plug>CBExpand <SID>expand()