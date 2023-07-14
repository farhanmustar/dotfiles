" Vim Init Config


" auto install vim plug
let s:plug_path = expand('<sfile>:p:h:h').'/autoload/plug.vim'
if empty(s:plug_path) && executable('curl')
  echom 'Installing Vim-Plug...'
  echom ''
  silent execute '!curl -fLo '.s:plug_path.' --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif
set rtp+=~/.vim  "  fix windows support for .vim file
