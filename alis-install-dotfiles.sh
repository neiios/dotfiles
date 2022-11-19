#!/bin/bash

set -eu

# check if paru is installed
if ! hash paru 2>/dev/null; then
  git clone https://aur.archlinux.org/paru-bin.git "/home/${USER}/paru"
  cd "/home/${USER}/paru" || exit
  makepkg -si --noconfirm --needed
  rm -rf "/home/${USER}/paru"
fi

function pacmanInstall() {
  sudo pacman -S "${@}" --noconfirm --needed
}

function paruInstall() {
  paru -S "${@}" --noconfirm --needed
}

function flatpakInstall() {
  flatpak install -y --noninteractive --system "${@}"
}

function dotfileInstall() {
  stow -v 2 "${@}"
}

# deps
pacmanInstall stow git dialog

# just in case someone decides to copy it to the wrong directory
[[ ! -d ~/.dotfiles ]] && git clone https://github.com/richard96292/dotfiles ~/.dotfiles && cd ~/.dotfiles && git pull && git submodule init && git submodule update && bash alis-install-dotfiles.sh && exit # long boi

# initialize the repo
cd ~/.dotfiles || exit
git pull && git submodule init && git submodule update
mkdir -pv ~/.config

# generic packages
pacmanInstall firefox firefox-ublock-origin thunderbird \
  zsh btop duf fzf bat exa github-cli neofetch ripgrep tldr yt-dlp \
  foot foot-terminfo tmux \
  element-desktop \
  easyeffects \
  keepassxc \
  gimp inkscape \
  libreoffice-fresh libreoffice-fresh-lt libreoffice-fresh-ru \
  qbittorrent \
  simple-scan \
  qpwgraph \
  mpv zathura \
  code \
  nextcloud-client \
  ansible ansible-lint sshpass python-argcomplete python-boto3 \
  dolphin gwenview ark \
  v4l2loopback-utils

paruInstall code-features code-icons code-marketplace \
  rate-mirrors-bin \
  nsxiv

flatpakInstall flathub com.github.tchx84.Flatseal \
  com.discordapp.Discord \
  com.github.Eloston.UngoogledChromium \
  com.github.taiko2k.tauonmb org.musicbrainz.Picard \
  com.obsproject.Studio org.kde.kdenlive \
  org.telegram.desktop

dotfileInstall env
dotfileInstall git
dotfileInstall foot
dotfileInstall tmux
dotfileInstall hotkey
dotfileInstall zsh
[[ ! "$(readlink /proc/$$/exe)" == "/usr/bin/zsh" ]] && sudo chsh -s "$(which zsh)" "$(whoami)" || echo "zsh is already used"
rm -f ~/.bash_logout ~/.bash_profile ~/.bashrc
touch "$HOME/.config/wget-hsts"

# neovim
pacmanInstall neovim python-pynvim stylua cppcheck clang yamllint lua-language-server bash-language-server shellcheck shfmt typescript-language-server ansible-lint fd fzf
paruInstall prettierd vscode-langservers-extracted ansible-language-server
dotfileInstall nvim
[[ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]] && git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# sway
if (dialog --erase-on-exit --title "Sway" --yesno "Should the sway window manager be installed and configured?" 0 0); then
  # copy default wallpaper
  mkdir -pv ~/Pictures/Wallpapers
  cp ~/.dotfiles/wallpapers/default.jpg ~/Pictures/Wallpapers/default.jpg
  pacmanInstall sway wlroots xorg-xwayland swaybg swayidle swaylock \
    xdg-desktop-portal-gtk xdg-desktop-portal-wlr \
    wf-recorder grim slurp swappy \
    pavucontrol bluez-tools \
    udiskie \
    mako
  paruInstall tofi polkit-dumb-agent-git
  dotfileInstall sway tofi mako swappy fonts
  # autologin to tty
  # .zpofile will autostart sway
  execLine="-/sbin/agetty -o '-p -f -- \u' --noclear --autologin $USER %I "'$TERM'
  sudo mkdir -pv "/etc/systemd/system/getty@tty1.service.d"
  sudo tee "/etc/systemd/system/getty@tty1.service.d/autologin.conf" >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=$execLine
EOF
fi

# gtk
dotfileInstall gtk
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

if (dialog --erase-on-exit --title "Gaming" --yesno "Do you really?" 0 0); then
  # mangohud
  # flatpak steam doesnt work if mangohud config is a symlink so just copy it manually
  mkdir -pv ~/.config/MangoHud && cp ~/.dotfiles/mangohud/.config/MangoHud/MangoHud.conf ~/.config/MangoHud
  # programs
  flatpakInstall flathub com.valvesoftware.Steam com.valvesoftware.Steam.CompatibilityTool.Proton-GE com.valvesoftware.Steam.Utility.gamescope org.freedesktop.Platform.VulkanLayer.MangoHud//22.08
fi

echo "Installed successfully!"
