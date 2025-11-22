#!/usr/bin/env bash

mkdir -pv ~/.config/user-tmpfiles.d

# user programs
cat <<EOF > ~/.config/user-tmpfiles.d/90-dotfiles.conf
L+ $HOME/.zshrc - - - - $HOME/.dotfiles/config/.zshrc
L+ $HOME/.zshenv - - - - $HOME/.dotfiles/config/.zshenv
L+ $HOME/.ideavimrc - - - - $HOME/.dotfiles/config/.ideavimrc
L+ $HOME/.config/Code/User/settings.json - - - - $HOME/.dotfiles/config/vscode/settings.json

L+ $HOME/.config/ghostty - - - - $HOME/.dotfiles/config/ghostty
L+ $HOME/.config/alacritty - - - - $HOME/.dotfiles/config/alacritty
L+ $HOME/.config/git - - - - $HOME/.dotfiles/config/git
L+ $HOME/.config/nvim - - - - $HOME/.dotfiles/config/neovim
EOF

# nix integration
cat <<EOF > ~/.config/user-tmpfiles.d/91-nix.conf
L+ $HOME/.local/share/fonts/nix - - - - $HOME/.nix-profile/share/fonts
L+ $HOME/.local/share/flatpak/overrides - - - - $HOME/.dotfiles/config/flatpak-overrides
EOF

systemd-tmpfiles --user --create
