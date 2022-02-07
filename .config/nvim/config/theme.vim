" Vim Theme Config

" Colorscheme
set t_Co=256
set t_ut=
set background=dark
set cursorline
let g:gruvbox_contrast_dark='hard'

function! s:ModifyColorScheme()
  highlight CursorLine      ctermbg=235   guibg=#262626
  highlight CursorLineNR    ctermbg=235   guibg=#262626
  highlight TabLine         ctermfg=Black ctermbg=DarkGray cterm=NONE  guifg=#1e1e1e guibg=#6c6c6c gui=NONE
  highlight TabLineFill     ctermfg=Black ctermbg=DarkGray cterm=NONE  guifg=#1e1e1e guibg=#6c6c6c gui=NONE
  highlight TabLineSel      ctermfg=172   ctermbg=234      cterm=NONE  guifg=#d78700 guibg=#1c1c1c gui=NONE
  highlight ALEError        ctermbg=237   guibg=#3a3a3a
  highlight ALEWarning      ctermbg=237   guibg=#3a3a3a
  highlight ALEStyleError   ctermbg=237   guibg=#3a3a3a
  highlight ALEStyleWarning ctermbg=237   guibg=#3a3a3a
  highlight Search          cterm=NONE    ctermfg=NONE     ctermbg=238 gui=NONE      guifg=NONE    guibg=#444444
  highlight QuickFixLine    cterm=NONE    ctermfg=NONE     ctermbg=236 gui=NONE      guifg=NONE    guibg=#303030
  highlight link CtrlSpaceSearch  IncSearch
endfunction
augroup modifycolorscheme
  autocmd!
  autocmd ColorScheme * exe 'call s:ModifyColorScheme()'
augroup END

silent! colorscheme gruvbox
set termguicolors
