call plug#begin('~/.config/'.g:NVIM_APPNAME.'/plugged')

Plug 'AndrewRadev/linediff.vim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'Julian/vim-textobj-brace'
Plug 'L3MON4D3/LuaSnip'
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'Wansmer/treesj'
Plug 'axelvc/template-string.nvim'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'bkad/CamelCaseMotion'
Plug 'chomosuke/term-edit.nvim', {'tag': 'v1.*'}
Plug 'ckolkey/ts-node-action'
Plug 'cohama/lexima.vim'
Plug 'cshuaimin/ssr.nvim'
Plug 'dawsers/edit-code-block.nvim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'djoshea/vim-autoread'
Plug 'eandrju/cellular-automaton.nvim'
Plug 'easymotion/vim-easymotion'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'farhanmustar/gv.vim'
Plug 'fidian/hexmode'
Plug 'ggVGc/vim-fuzzysearch'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'junegunn/vim-easy-align'
Plug 'kana/vim-textobj-diff'
Plug 'kana/vim-textobj-user'
Plug 'karb94/neoscroll.nvim'
Plug 'kevinhwang91/nvim-hlslens'
Plug 'kevinhwang91/nvim-ufo'
Plug 'kevinhwang91/promise-async'
Plug 'lambdalisue/suda.vim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'lifepillar/vim-mucomplete'
Plug 'ludovicchabant/vim-lawrencium'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'mfussenegger/nvim-dap'
Plug 'mfussenegger/nvim-dap-python', { 'branch': 'multi-session' }
Plug 'mhinz/vim-startify'
Plug 'michaeljsmith/vim-indent-object'
Plug 'mong8se/actually.nvim'
Plug 'ncm2/float-preview.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'osyo-manga/vim-over'
Plug 'petertriho/nvim-scrollbar'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'rafamadriz/friendly-snippets'
Plug 'rcarriga/nvim-dap-ui'
Plug 'rcarriga/nvim-notify'
Plug 'rest-nvim/rest.nvim'
Plug 'romgrk/nvim-treesitter-context'
Plug 'samjwill/nvim-unception'
Plug 'skywind3000/asyncrun.vim'
Plug 'stevearc/aerial.nvim'
Plug 'stevearc/dressing.nvim'
Plug 'stevearc/oil.nvim'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'ton/vim-bufsurf'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'tzachar/highlight-undo.nvim'
Plug 'uga-rosa/ccc.nvim'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'yioneko/nvim-yati'

Plug 'msva/lua-htmlparser', {'do':'ln -sT ./src lua'}

" Plug 'dart-lang/dart-vim-plugin'
" Plug 'erisian/rest_tools'

if executable('roscore')
  Plug 'ompugao/ros.vim'
endif

if executable('curl')
  Plug 'farhanmustar/cs.vim'
  Plug 'farhanmustar/cg.vim'
endif

if executable('ctags') " universal-ctags
  Plug 'preservim/tagbar'
endif

if executable('yarn')
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'}
endif

call plug#end()
