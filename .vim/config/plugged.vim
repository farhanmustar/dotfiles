call plug#begin('~/.vim/plugged')

Plug 'bkad/CamelCaseMotion'
Plug 'dhruvasagar/vim-table-mode'
Plug 'djoshea/vim-autoread'
Plug 'easymotion/vim-easymotion'
Plug 'farhanmustar/ale'
Plug 'farhanmustar/ale-python-linter'
Plug 'farhanmustar/gv.vim'
Plug 'fidian/hexmode'
Plug 'gruvbox-community/gruvbox'
Plug 'junegunn/vim-easy-align'
Plug 'lifepillar/vim-mucomplete'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'osyo-manga/vim-over'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'rstacruz/vim-closer'
Plug 'skywind3000/asyncrun.vim'
Plug 'szw/vim-ctrlspace'
Plug 'terryma/vim-smooth-scroll'
Plug 'ton/vim-bufsurf'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'

" Plug 'dart-lang/dart-vim-plugin'
" Plug 'erisian/rest_tools'

if executable('roscore')
  Plug 'ompugao/ros.vim'
  Plug 'farhanmustar/ale-roslint'
endif

if executable('curl')
  Plug 'farhanmustar/cs.vim'
endif

if executable('ctags') " universal-ctags
  Plug 'preservim/tagbar'
endif

if executable('yarn')
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'}
endif

call plug#end()
