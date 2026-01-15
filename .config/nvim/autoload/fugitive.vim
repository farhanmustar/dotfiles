if exists('g:fugitive_monkey_patch')
  finish
endif

let g:fugitive_monkey_patch = 1

" Load original plugin
runtime! autoload/fugitive.vim

if !exists('*fugitive#Complete')
  finish
endif

" Save a reference to the original function
let s:fugitive_original_complete = funcref('fugitive#Complete')

" Override fugitive#Complete
function! fugitive#Complete(lead, ...) abort
  let l:args = [a:lead] + a:000

  " If command line contains 'please', replace it with 'push'
  if a:0 > 1 && a:1 =~# '\<please\>'
    let l:args[1] = substitute(a:1, '\<please\>', 'push', '')
  endif

  " Call the saved original function
  return call(s:fugitive_original_complete, l:args)
endfunction
