#!/usr/bin/env bash
set -euo pipefail

# This script does several things to integrate nix with existing system.
# 1. It links nix installed fonts and systemd units to respective locations in $HOME
# 2. Adds overrides for flatpaks to integrate with nix (useful for fonts)

echo "Installing nix; relogin after installation"
curl -L https://install.determinate.systems/nix | sh -s -- install
source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh

echo "Adding Zsh to /etc/shells"
grep -qxF "$HOME/.nix-profile/bin/zsh" /etc/shells || \
    echo "$HOME/.nix-profile/bin/zsh" | sudo tee -a /etc/shells

echo "Creating tmpfiles"
mkdir -pv ~/.config/user-tmpfiles.d
cat <<EOF > ~/.config/user-tmpfiles.d/99-nix.conf
L+ $HOME/.local/share/fonts/nix - - - - $HOME/.nix-profile/share/fonts
L+ $HOME/.config/systemd/user - - - - $HOME/.nix-profile/share/systemd/user
L+ $HOME/.local/share/flatpak/overrides - - - - $HOME/.dotfiles/config/flatpak-overrides
EOF
systemd-tmpfiles --user --create

echo "Configuring graphics acceleration for nix apps"
sudo bash "$(dirname $BASH_SOURCE)/configure-nix-graphics.sh"

echo "Installing dotfiles"
bash "$(dirname $BASH_SOURCE)/create-symlinks.sh"
nix profile install "$HOME/.dotfiles#dotfiles"
