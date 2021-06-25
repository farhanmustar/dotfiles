" Vim Vundle Config

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'farhanmustar/Vundle.vim'

Plugin 'Chiel92/vim-autoformat'
Plugin 'dense-analysis/ale'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'djoshea/vim-autoread'
Plugin 'farhanmustar/ale-python-linter'
Plugin 'farhanmustar/gv.vim'
Plugin 'fidian/hexmode'
Plugin 'gruvbox-community/gruvbox'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'ludovicchabant/vim-lawrencium'
Plugin 'mbbill/undotree'
Plugin 'mhinz/vim-startify'
Plugin 'osyo-manga/vim-over'
Plugin 'powerman/vim-plugin-AnsiEsc'
Plugin 'rstacruz/vim-closer'
Plugin 'szw/vim-ctrlspace'
Plugin 'terryma/vim-smooth-scroll'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'

" Plugin 'dart-lang/dart-vim-plugin'
" Plugin 'erisian/rest_tools'

if executable('roscore')
  Plugin 'ompugao/ros.vim'
  Plugin 'farhanmustar/ale-roslint'
endif

if executable('curl')
  Plugin 'farhanmustar/cs.vim'
endif

if executable('ctags') " universal-ctags
  Plugin 'preservim/tagbar'
endif

if executable('yarn')
  Plugin 'iamcco/markdown-preview.nvim', { 'oninstall': '!cd app && yarn install', 'onupdate': '!cd app && yarn install' }
endif

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required