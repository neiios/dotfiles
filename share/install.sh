#!/usr/bin/env bash

# This script does several things to integrate nix with existing system.
# 1. It links nix installed fonts and systemd units to respective locations in $HOME
# 2. Adds overrides for flatpaks to integrate with nix (useful for (again) fonts)

function install_nix() {
	sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
	source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
	cat <<EOF | sudo tee /etc/nix/nix.conf > /dev/null
# DO NOT EDIT! THIS FILE IS MANAGED BY DOTFILES SCRIPT
extra-experimental-features = nix-command flakes
build-users-group = nixbld
EOF
	sudo systemctl restart nix-daemon
}

function configure_opengl() {
	sudo bash "$(dirname $BASH_SOURCE)/configure-nix-graphics.sh"
}

function install_packages() {
	nix profile add "$HOME/.dotfiles#dotfiles"
}

function create_symlinks() {
	source "$(dirname $BASH_SOURCE)/create-symlinks.sh"
}

function configure_zsh() {
	grep -qxF "$HOME/.nix-profile/bin/zsh" /etc/shells || \
	    echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells
	chsh -s $HOME/.nix-profile/bin/zsh $USER
}

install_nix && \
configure_opengl && \
install_packages && \
create_symlinks && \
configure_zsh
