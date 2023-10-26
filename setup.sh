#!/bin/bash

UBUNTU_YEAR=$(lsb_release -sr | cut -d '.' -f1)

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

read -p "Set timezone in ~/.profile to 'Asia/Kuala_Lumpur' ? (y/n) : " yn
if [ "$yn" = "y" ]; then
  echo "TZ='Asia/Kuala_Lumpur'; export TZ" >> ~/.profile
fi

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
    sudo add-apt-repository ppa:x4121/ripgrep -y
  fi
  sudo apt-get update
  sudo apt-get install ripgrep xclip -y
  # build neovim
  sudo apt-get install ninja-build gettext cmake unzip curl -y
  git clone https://github.com/neovim/neovim.git -b v0.9.2 --depth 1 /tmp/neovim
  (cd /tmp/neovim && make CMAKE_BUILD_TYPE=Release && sudo make install)
  rm -rf /tmp/neovim
  # setup neovim
  sudo update-alternatives --install $(which vim || echo "/usr/bin/vim") vim $(which nvim) 50
  sudo update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100
  vim -c PlugInstall -c "qa"
fi
