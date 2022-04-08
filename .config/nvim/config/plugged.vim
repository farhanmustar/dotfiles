call plug#begin('~/.config/nvim/plugged')

Plug 'L3MON4D3/LuaSnip'
Plug 'dhruvasagar/vim-table-mode'
Plug 'djoshea/vim-autoread'
Plug 'easymotion/vim-easymotion'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'farhanmustar/ale'
Plug 'farhanmustar/ale-python-linter'
Plug 'farhanmustar/gv.vim'
Plug 'farhanmustar/nvim-scrollbar'
Plug 'fidian/hexmode'
Plug 'junegunn/vim-easy-align'
Plug 'kevinhwang91/nvim-hlslens'
Plug 'lifepillar/vim-mucomplete'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python'
Plug 'mhinz/vim-startify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'ncm2/float-preview.nvim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'osyo-manga/vim-over'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'rafamadriz/friendly-snippets'
Plug 'rcarriga/nvim-dap-ui'
Plug 'romgrk/nvim-treesitter-context'
Plug 'rstacruz/vim-closer'
Plug 'skywind3000/asyncrun.vim'
Plug 'szw/vim-ctrlspace'
Plug 'terryma/vim-smooth-scroll'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'ton/vim-bufsurf'
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
