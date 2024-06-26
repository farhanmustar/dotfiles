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
