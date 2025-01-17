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
  apt update
  apt install ripgrep -y
  # build neovim
  apt install ninja gettext cmake unzip curl git openssl \
	  binutils which luarocks libtermkey libvterm -y
  luarocks install mpack
  luarocks install lpeg
  luarocks install luabitop
  mkdir tmp 2>/dev/null || true
  git clone https://github.com/neovim/neovim.git -b v0.9.5 --depth 1 $PREFIX/tmp/neovim
  git clone https://github.com/termux/termux-packages.git -b bootstrap-2022.12.28-r3+apt-android-7 --depth 1 $PREFIX/tmp/termux-packages
  cd $PREFIX/tmp/neovim
  git apply -v $PREFIX/tmp/termux-packages/packages/neovim/src-nvim-eval-funcs.c.patch
  git apply -v $PREFIX/tmp/termux-packages/packages/neovim/src-nvim-os-stdpaths.c.patch
  cmake -S . -B build_dir -D CMAKE_INSTALL_PREFIX=$PREFIX
  cmake --build build_dir -j8
  cmake --install build_dir
  rm -rf $PREFIX/tmp/neovim
  rm -rf $PREFIX/tmp/termux-packages
  # setup neovim
  ln -sT "$(which nvim)" $PREFIX/etc/alternatives/vim
  nvim -c PlugInstall -c "qa"
fi
