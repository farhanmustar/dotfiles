" Vim Setting Config

" Inherit aliases from ~/.bash_aliases
let $BASH_ENV = '~/.bash_aliases'

" Import mswin key mappings and behavior.
source $VIMRUNTIME/mswin.vim

" Some tuning
set showmatch		" Show matching brackets.
set ignorecase	" Do case insensitive matching
set smartcase		" Do smart case matching
set mouse=a			" Enable mouse usage (all modes)
set ruler
set number
set splitbelow
set splitright
set hidden
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
set undodir=~/.vim/undodir
set undofile
" CursorHold timer
set updatetime=1000
" Completion option
set completeopt+=menuone,noselect
set belloff+=ctrlg
set shortmess+=c

" Use tree view for netrw directory browsing
let g:netrw_liststyle=3