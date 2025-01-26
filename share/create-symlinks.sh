#!/usr/bin/env bash

set -euo pipefail

echo "Creating symlinks via systemd tmpfiles"

mkdir -pv ~/.config/user-tmpfiles.d
cat <<EOF > ~/.config/user-tmpfiles.d/99-dotfiles.conf
L+ $HOME/.zshrc - - - - $HOME/.dotfiles/config/.zshrc
L+ $HOME/.zshenv - - - - $HOME/.dotfiles/config/.zshenv
L+ $HOME/.ideavimrc - - - - $HOME/.dotfiles/config/.ideavimrc
L+ $HOME/.config/Code/User/settings.json - - - - $HOME/.dotfiles/config/vscode/settings.json

L+ $HOME/.config/ghostty - - - - $HOME/.dotfiles/config/ghostty
L+ $HOME/.config/git - - - - $HOME/.dotfiles/config/git
L+ $HOME/.config/neovim - - - - $HOME/.dotfiles/config/neovim
L+ $HOME/.config/zed - - - - $HOME/.dotfiles/config/zed
EOF

systemd-tmpfiles --user --create
