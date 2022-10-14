" Vim Setting Config

" Inherit aliases from ~/.bash_aliases
let $BASH_ENV = '~/.bash_aliases'

" Import mswin key mappings and behavior.
source $VIMRUNTIME/mswin.vim

" Some tuning
set nocompatible              " be iMproved
set showmatch		" Show matching brackets.
set ignorecase	" Do case insensitive matching
set smartcase		" Do smart case matching
set mouse=a			" Enable mouse usage (all modes)
set ruler
set number
set splitbelow
set splitright
set hidden
set belloff=all
set scrolloff=5
" Tabs settings
set expandtab
set softtabstop=0
set shiftwidth=2
set tabstop=2
" Make tab completion in command mode behave like in Bash
set wildmenu
set wildmode=longest,list
set wildignore=*.o,*.class,*.swp,*.swo,*.pyc
" Undo behaviour
set nobackup
set undodir=~/.cache/nvim/undodir
set undofile
" CursorHold timer
set updatetime=500
" Completion option
set completeopt+=menuone,noselect
set completeopt-=preview
set shortmess+=c
set complete-=t
" Force encoding (windows default to latin)
set encoding=utf-8
set nohlsearch

" Disable netrw plugin
let g:loaded_netrwPlugin=1

" Enable build-in plugin
packadd cfilter

" Highlight yank
au TextYankPost * silent! lua vim.highlight.on_yank()
