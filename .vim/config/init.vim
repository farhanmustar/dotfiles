" Vim Init Config

" auto install vundle
if empty(glob('~/.vim/bundle/Vundle.vim')) && executable('git')
  echom 'Installing Vundle...'
  echom ''
  silent execute '!git clone https://github.com/farhanmustar/Vundle.vim.git ' . glob('~') . '/.vim/bundle/Vundle.vim'
endif

" auto create undodir file (manual delete if too big)
if empty(glob('~/.vim/undodir'))
  silent execute '!mkdir ' . glob('~/.vim/') . 'undodir'
endif
