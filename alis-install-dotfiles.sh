#!/bin/bash

function pacmanInstall() {
  sudo pacman -S "${@}" --noconfirm --needed
}

# check if paru is installed
if ! hash paru 2>/dev/null; then
  git clone https://aur.archlinux.org/paru-bin.git "/home/${USER}/paru-bin"
  cd "/home/${USER}/paru-bin" || exit
  makepkg -si --noconfirm --needed
  rm -rf "/home/${USER}/paru-bin"
fi

function paruInstall() {
  paru -S "${@}" --noconfirm --needed
}

# prerequisites
pacmanInstall stow git wl-clipboard xclip libnewt glib2
# just in case someone decides to copy it to the wrong directory
[[ ! -d ~/.dotfiles ]] && git clone https://github.com/richard96292/dotfiles ~/.dotfiles 
cd ~/.dotfiles || exit
git submodule init && git submodule update

# environment variables
stow env

# git
pacmanInstall github-cli
stow git

# terminal
pacmanInstall foot foot-terminfo xdg-utils libnotify
stow foot

# tmux
pacmanInstall tmux
stow tmux

# hotkey
stow hotkey

# zsh and cli stuff
pacmanInstall zsh fzf bat exa
stow zsh
chsh -s /usr/bin/zsh

# neovim
pacmanInstall neovim python-pynvim stylua cppcheck clang lua-language-server bash-language-server shellcheck shfmt typescript-language-server ansible-lint
paruInstall prettierd vscode-langservers-extracted ansible-language-server 
stow nvim
[[ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]] && git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# sway
if (whiptail --title "Sway" --yesno "Should the sway window manager be installed and configured?" 0 0); then
  pacmanInstall sway wlroots swaybg swayidle swaylock wf-recorder grim slurp mako xdg-desktop-portal-wlr polkit xorg-xwayland bluez-utils
  paruInstall tofi polkit-dumb-agent
  stow sway tofi mako swappy fonts
fi

# mangohud
# flatpak steam doesnt work if mangohud config is a symlink so just copy it manually
mkdir -pv ~/.config/MangoHud && cp ~/.dotfiles/mangohud/.config/MangoHud/MangoHud.conf ~/.config/MangoHud

# gtk
stow gtk
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
