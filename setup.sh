#!/bin/bash

UBUNTU_YEAR=$(lsb_release -sr | cut -d '.' -f1)

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

read -p "Remove existing dotfiles and replace with link to repo? (y/n) : " yn
if [ "$yn" = "y" ]; then
  rm -rf ~/.bash_aliases
  ln -sT $SCRIPTPATH/.bash_aliases ~/.bash_aliases
  rm -rf ~/.gitconfig
  ln -sT $SCRIPTPATH/.gitconfig ~/.gitconfig
  rm -rf ~/.gitignore_global
  ln -sT $SCRIPTPATH/.gitignore_global ~/.gitignore_global
fi

read -p "Setup byobu? (y/n) : " yn
if [ "$yn" = "y" ]; then
  rm -rf ~/.byobu && ln -sT $SCRIPTPATH/.byobu/ ~/.byobu
fi

read -p "Install neovim and its companion? (y/n) : " yn
if [ "$yn" = "y" ]; then
  mkdir ~/.config > /dev/null 2>&1
  rm -rf ~/.config/nvim
  ln -sT $SCRIPTPATH/.config/nvim/ ~/.config/nvim
  if [ "$UBUNTU_YEAR" -lt 20 ]; then
    sudo add-apt-repository ppa:x4121/ripgrep -yu
  fi
  sudo add-apt-repository ppa:neovim-ppa/unstable -yu
  sudo apt-get install neovim ripgrep xclip -y
  sudo update-alternatives --install $(which vim) vim $(which nvim) 50
  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100
  vim -c PlugInstall -c "qa"
fi
