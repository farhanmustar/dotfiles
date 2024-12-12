call plug#begin('~/.config/'.g:NVIM_APPNAME.'/plugged')

Plug 'AndrewRadev/linediff.vim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'Julian/vim-textobj-brace'
Plug 'L3MON4D3/LuaSnip'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'Wansmer/treesj'
Plug 'axelvc/template-string.nvim'
Plug 'beloglazov/vim-textobj-quotes'
Plug 'bkad/CamelCaseMotion'
Plug 'chomosuke/term-edit.nvim', {'tag': 'v1.*'}
Plug 'chrisgrieser/nvim-early-retirement'
Plug 'ckolkey/ts-node-action'
Plug 'cohama/lexima.vim'
Plug 'cshuaimin/ssr.nvim'
Plug 'dawsers/edit-code-block.nvim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'djoshea/vim-autoread'
Plug 'eandrju/cellular-automaton.nvim'
Plug 'easymotion/vim-easymotion'
Plug 'ellisonleao/gruvbox.nvim'
Plug 'f3fora/cmp-spell'
Plug 'farhanmustar/fugitive-delta.nvim'
Plug 'farhanmustar/gv.vim'
Plug 'fidian/hexmode'
Plug 'ggVGc/vim-fuzzysearch'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
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
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-neotest/nvim-nio'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', { 'commit': '5b8b126' }
Plug 'nvim-treesitter/nvim-treesitter-refactor'
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'nvim-treesitter/playground'
Plug 'petertriho/nvim-scrollbar'
Plug 'pogyomo/submode.nvim', {'tag': 'v1.0.0'}
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'rafamadriz/friendly-snippets'
Plug 'rasulomaroff/cmp-bufname'
Plug 'rcarriga/nvim-dap-ui'
Plug 'rcarriga/nvim-notify'
Plug 'farhanmustar/nvim-treesitter-context'
Plug 'saadparwaiz1/cmp_luasnip'
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
Plug 'windwp/nvim-ts-autotag'

Plug 'msva/lua-htmlparser', {'do':'ln -sT ./src lua'}

" http request client need to explore.
" Plug 'rest-nvim/rest.nvim'

" disable nvim-unception to use this.
" Plug 'dstein64/vim-startuptime'

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
