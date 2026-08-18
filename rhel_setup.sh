#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

# Detect RHEL major version
if [ -f /etc/os-release ]; then
    . /etc/os-release
    MAJOR_VERSION="${VERSION_ID%%.*}"
else
    echo "Cannot detect OS version: /etc/os-release not found" >&2
    exit 1
fi

read -p "Remove existing dotfiles and replace with link to repo? (y/n) : " yn
if [ "$yn" = "y" ]; then
  rm -rf ~/.bash_aliases
  ln -sT $SCRIPTPATH/.bash_aliases ~/.bash_aliases
  grep -qF '. ~/.bash_aliases' ~/.bashrc || echo '. ~/.bash_aliases' >> ~/.bashrc && source ~/.bashrc
  rm -rf ~/.gitconfig
  cp $SCRIPTPATH/.gitconfig ~/.gitconfig
  rm -rf ~/.gitignore_global
  ln -sT $SCRIPTPATH/.gitignore_global ~/.gitignore_global
fi

read -p "Setup byobu? (y/n) : " yn
if [ "$yn" = "y" ]; then
  rm -rf ~/.byobu && ln -sT $SCRIPTPATH/.byobu/ ~/.byobu
fi

read -p "Install git-delta? (y/n) " gitdeltayn

read -p "Install neovim and its companion? (y/n) : " yn
if [ "$yn" = "y" ]; then
  mkdir ~/.config > /dev/null 2>&1
  rm -rf ~/.config/nvim
  ln -sT $SCRIPTPATH/.config/nvim/ ~/.config/nvim
  sudo dnf install ripgrep xclip jq -y
  # enable codeReady builder
  sudo subscription-manager repos --enable "codeready-builder-for-rhel-${MAJOR_VERSION}-$(arch)-rpms"
  sudo dnf install -y "https://dl.fedoraproject.org/pub/epel/epel-release-latest-${MAJOR_VERSION}.noarch.rpm"
  # build neovim
  sudo dnf groupinstall "Development Tools" -y
  sudo dnf install ninja-build gettext cmake unzip curl -y
  git clone https://github.com/neovim/neovim.git -b v0.10.4 --depth 1 /tmp/neovim
  (cd /tmp/neovim && make CMAKE_BUILD_TYPE=Release && sudo make install)
  rm -rf /tmp/neovim
  # setup neovim
  sudo ln -s $(which nvim) /usr/local/bin/vim
  vim -c PlugInstall -c "qa"
fi

if [ "$gitdeltayn" = "y" ]; then
  curl -fL https://github.com/dandavison/delta/releases/download/0.19.2/delta-0.19.2-x86_64-unknown-linux-musl.tar.gz | tar -xz -C /tmp
  sudo install -m 755 /tmp/delta-0.19.2-x86_64-unknown-linux-musl/delta /usr/local/bin/delta
  rm -rf /tmp/delta-0.19.2-x86_64-unknown-linux-musl
fi
