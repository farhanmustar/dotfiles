" Vim Init Config

" auto install vim plug
if empty(glob('~/.vim/autoload/plug.vim')) && executable('curl')
  echom 'Installing Vim-Plug...'
  echom ''
  silent execute '!curl -fLo '.glob('~').'/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
set rtp+=~/.vim  "  fix windows support for .vim file

" auto create undodir file (manual delete if too big)
if empty(glob('~/.vim/undodir'))
  silent execute '!mkdir ' . glob('~/.vim/') . 'undodir'
endif
