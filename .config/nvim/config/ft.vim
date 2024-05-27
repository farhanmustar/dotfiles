" Vim FileType Config

" Indentation config for html and htmldjango
let g:html_indent_inctags = 'body,head,tbody,p'

" Prevent auto-indenting of comments
augroup commentindent
  autocmd!
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
augroup END

" Let Vim jump to the last position when reopening a file
augroup cursorpos
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END

" .launch filetype as xml format
augroup rosfiletype
  autocmd!
  autocmd BufRead,BufNewFile *.launch setfiletype xml
augroup END

" git filetype config
augroup gitfiletype
  autocmd!
  autocmd FileType git setlocal foldmethod=syntax
  " TODO: consider modify isfname
  autocmd FileType git nmap <buffer> gF viWogf
augroup END

" python filetype
augroup pythonfiletype
  autocmd!
  autocmd BufEnter *.py setlocal tabstop=4
  autocmd BufEnter *.py setlocal shiftwidth=4
  autocmd BufEnter *.py setlocal expandtab
  autocmd BufEnter *.py setlocal smarttab
augroup END
