#!/bin/bash

while getopts "s" o; do
    case "${o}" in
        s)
          installSway=1
          ;;
        *)
          installSway=0
          ;;
    esac
done

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
pacmanInstall stow git wl-clipboard xclip
[[ ! -d ~/.dotfiles ]] && git clone https://github.com/richard96292/dotfiles ~/.dotfiles 
cd ~/.dotfiles || exit
git submodule init && git pull

# terminal
pacmanInstall foot foot-terminfo xdg-utils libnotify
stow foot

# tmux
pacmanInstall tmux
stow tmux

# zsh and cli stuff
pacmanInstall zsh fzf bat exa
stow zsh

# neovim
pacmanInstall neovim python-pynvim stylua cppcheck clang lua-language-server bash-language-server shellcheck shfmt typescript-language-server ansible-language-server ansbile-lint
paruInstall prettierd vscode-langservers-extracted
stow nvim
# not even sure if it works tbh
nvim --headless -c ':qa'
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# sway
if [[ installSway -eq 1 ]]; then
  pacmanInstall sway wlroots swaybg swayidle swaylock wf-recorder grim slurp mako xdg-desktop-portal-wlr polkit xorg-xwayland
  paruInstall tofi
  stow sway tofi mako
fi
