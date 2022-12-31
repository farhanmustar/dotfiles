" Vim Theme Config

" Colorscheme
set t_Co=256
set t_ut=
set background=dark
set cursorline
let g:gruvbox_contrast_dark='hard'

function! s:ModifyColorScheme()
  highlight Normal                guibg=NONE
  highlight CursorLine            ctermbg=235   guibg=#262626
  highlight CursorLineNR          ctermbg=235   guibg=#262626
  highlight Folded                cterm=NONE    ctermfg=NONE     ctermbg=236 gui=NONE      guifg=#689d6a guibg=#303030
  highlight TabLine               ctermfg=Black ctermbg=DarkGray cterm=NONE  guifg=#1e1e1e guibg=#6c6c6c gui=NONE
  highlight TabLineFill           ctermfg=Black ctermbg=DarkGray cterm=NONE  guifg=#1e1e1e guibg=#6c6c6c gui=NONE
  highlight TabLineSel            ctermfg=172   ctermbg=234      cterm=NONE  guifg=#d78700 guibg=None    gui=NONE
  highlight QuickFixLine          cterm=NONE    ctermfg=NONE     ctermbg=236 gui=NONE      guifg=NONE    guibg=#303030
  highlight ScrollbarSearch       ctermfg=224   guifg=#fe8019
  highlight ScrollbarSearchHandle ctermfg=224   guifg=#fe8019
  highlight TreesitterContext     ctermbg=239   guibg=#303030
  highlight GruvboxAquaDark       guifg=#689d6a
  highlight GitSignsAddNr         guifg=#999b46
  highlight GitSignsChangeNr      guifg=#8b98ad
  highlight GitSignsDeleteNr      guifg=#d0695d
  highlight GitSignsAddCLNr       guifg=#b8bb26 guibg=#262626
  highlight GitSignsChangeCLNr    guifg=#668fd1 guibg=#262626
  highlight GitSignsDeleteCLNr    guifg=#fb4934 guibg=#262626
  highlight Variable              guifg=#507481
  highlight! link IncSearch       Search
  highlight link Include         GruvboxAquaDark
  highlight link Function        GruvboxAqua
  highlight link @variable       Variable
  highlight link @text.todo.unchecked GruvboxRed
endfunction
augroup modifycolorscheme
  autocmd!
  autocmd ColorScheme * exe 'call s:ModifyColorScheme()'
augroup END

silent! colorscheme gruvbox
set termguicolors
