#!/usr/bin/env bash

set -euox pipefail

echo "Creating symlinks"

ln -sTf ~/.dotfiles/config/ghostty/ ~/.config/ghostty
ln -sTf ~/.dotfiles/config/git/ ~/.config/git
ln -sTf ~/.dotfiles/config/neovim/ ~/.config/neovim
ln -sTf ~/.dotfiles/config/zed/ ~/.config/zed
ln -sTf ~/.dotfiles/config/.ideavimrc ~/.ideavimrc
ln -sTf ~/.dotfiles/config/.zshrc ~/.zshrc
ln -sTf ~/.dotfiles/config/.zshenv ~/.zshenv
