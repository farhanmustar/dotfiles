" Vim Init Config

" auto install vim plug
if empty(glob('~/.config/nvim/autoload/plug.vim')) && executable('curl')
  echom 'Installing Vim-Plug...'
  echom ''
  silent execute '!curl -fLo '.glob('~').'/.config/nvim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
set rtp+=~/.vim  "  fix windows support for .vim file
