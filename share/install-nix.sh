#!/usr/bin/env bash

set -euox pipefail

echo "Installing nix; relogin after installation"
curl -L https://install.determinate.systems/nix | sh -s -- install
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

# Make zsh from nix available for usermod/chsh
echo "Adding Zsh to /etc/shells"
grep -qxF "$HOME/.nix-profile/bin/zsh" /etc/shells || \
    echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells

# Make nix installed fonts work in flatpaks
echo "Adding global flatpak overrides"
mkdir -pv ~/.local/share/fonts
ln -sTf ~/.nix-profile/share/fonts ~/.local/share/fonts/nix
sudo flatpak override --filesystem='~/.nix-profile:ro' --filesystem='~/.local/state/nix:ro' --filesystem='/nix/store:ro'

nix profile install "$HOME/.dotfiles#dotfiles"