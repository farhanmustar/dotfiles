#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

mkdir ~/.config
ln -sT $SCRIPTPATH/.bash_aliases ~/.bash_aliases
ln -sT $SCRIPTPATH/.config/nvim/ ~/.config/nvim
ln -sT $SCRIPTPATH/.gitconfig ~/.gitconfig
ln -sT $SCRIPTPATH/.gitignore_global ~/.gitignore_global

read -p "Setup byobu? (y/n) : " yn
if [ "$yn" = "y" ]; then
  rm -rf ~/.byobu && ln -sT $SCRIPTPATH/.byobu/ ~/.byobu
fi

read -p "Install neovim? (y/n) : " yn
if [ "$yn" = "y" ]; then
  sudo add-apt-repository ppa:neovim-ppa/unstable -yu
  sudo apt-get install neovim -y
  sudo update-alternatives --install $(which vim) vim $(which nvim) 50
  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100
fi
