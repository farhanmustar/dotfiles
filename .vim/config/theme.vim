" Vim Theme Config

" Colorscheme
set t_Co=256
set t_ut=
set background=dark
set cursorline
let g:gruvbox_contrast_dark='hard'

function! ModifyColorScheme()
  highlight CursorLine ctermbg=235
  highlight CursorLineNR ctermbg=235
  highlight TabLine      ctermfg=Black  ctermbg=DarkGray  cterm=NONE
  highlight TabLineFill  ctermfg=Black  ctermbg=DarkGray  cterm=NONE
  highlight TabLineSel   ctermfg=172    ctermbg=234       cterm=NONE
  highlight ALEError ctermbg=237
  highlight ALEWarning ctermbg=237
  highlight ALEStyleError ctermbg=237
  highlight ALEStyleWarning ctermbg=237
  highlight Search cterm=NONE ctermfg=NONE ctermbg=238
  highlight QuickFixLine cterm=NONE ctermfg=NONE ctermbg=236
  highlight link CtrlSpaceSearch  IncSearch
endfunction
augroup modifycolorscheme
  autocmd!
  autocmd ColorScheme * exe 'call ModifyColorScheme()'
augroup END

silent! colorscheme gruvbox
