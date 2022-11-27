#!/bin/bash

set -eu

function error() {
  echo "${1:-"Unknown Error"}" 1>&2
  exit 1
}

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

function installPackages() {
  pacmanInstall firefox firefox-ublock-origin thunderbird \
    zsh btop duf fzf bat exa github-cli neofetch ripgrep tldr yt-dlp \
    ranger atool ffmpegthumbnailer mediainfo odt2txt perl-image-exiftool transmission-cli \
    foot foot-terminfo tmux \
    element-desktop \
    easyeffects \
    keepassxc \
    gimp inkscape \
    libreoffice-fresh libreoffice-fresh-lt libreoffice-fresh-ru \
    qbittorrent \
    simple-scan \
    qpwgraph \
    mpv zathura zathura-cb zathura-djvu zathura-pdf-mupdf zathura-ps \
    code \
    nextcloud-client \
    ansible ansible-lint sshpass python-argcomplete python-boto3 \
    v4l2loopback-utils v4l2loopback-dkms \
    texlive-most texlive-lang texlive-langextra biber ghostscript python perl ruby dialog python-pygments

  paruInstall code-features code-icons code-marketplace \
    rate-mirrors-bin \
    nsxiv \
    texlive-latexindent-meta

  flatpakInstall flathub com.github.tchx84.Flatseal \
    com.github.Eloston.UngoogledChromium \
    com.github.taiko2k.tauonmb org.musicbrainz.Picard \
    com.obsproject.Studio org.kde.kdenlive \
    org.telegram.desktop
}

function installNeovim() {
  pacmanInstall neovim python-pynvim stylua cppcheck clang yamllint lua-language-server bash-language-server shellcheck shfmt typescript-language-server ansible-lint fd fzf
  paruInstall prettierd vscode-langservers-extracted ansible-language-server nodejs-emmet-ls
  dotfileInstall nvim
  [[ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]] && git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
  nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
}

function installSway() {
  if (dialog --erase-on-exit --title "Sway" --yesno "Should the sway window manager be installed and configured?" 0 0); then
    pacmanInstall sway wlroots xorg-xwayland swaybg swayidle swaylock i3status \
      xdg-desktop-portal-gtk xdg-desktop-portal-wlr \
      wf-recorder grim slurp swappy \
      pavucontrol blueman bluez-tools \
      udiskie \
      mako \
      breeze gnome-themes-extra qt5ct \
      dolphin kdegraphics-thumbnailers kde-cli-tools ffmpegthumbs taglib kimageformats qt5-imageformats \
      ark lrzip lzop p7zip unarchiver unrar \
      gwenview kimageformats qt5-imageformats

    paruInstall tofi polkit-dumb-agent-git

    # install sway config
    dotfileInstall sway

    # gtk settings
    gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

    # autologin to tty
    # .zpofile will autostart sway
    execLine="-/sbin/agetty -o '-p -f -- \u' --noclear --autologin $USER %I "'$TERM'
    sudo mkdir -pv "/etc/systemd/system/getty@tty1.service.d"
    sudo tee "/etc/systemd/system/getty@tty1.service.d/autologin.conf" >/dev/null <<EOF
[Service]
ExecStart=
ExecStart=$execLine
EOF

    # wallpapers
    systemctl --user daemon-reload
    systemctl --user enable sway-change-wallpaper.timer
  fi
}

function installGaming() {
  if (dialog --erase-on-exit --title "Gaming" --defaultno --yesno "Do you really?" 0 0); then
    # flatpak steam doesnt work if mangohud config is a symlink so just copy it manually
    mkdir -pv ~/.config/MangoHud && cp ~/.dotfiles/mangohud/.config/MangoHud/MangoHud.conf ~/.config/MangoHud

    flatpakInstall flathub com.valvesoftware.Steam com.valvesoftware.Steam.CompatibilityTool.Proton-GE \
      com.valvesoftware.Steam.Utility.gamescope org.freedesktop.Platform.VulkanLayer.MangoHud//22.08 \
      com.discordapp.Discord
    dotfileInstall hotkey
  fi
}

function main() {
  # check if paru is installed
  if ! hash paru 2>/dev/null; then
    git clone https://aur.archlinux.org/paru-bin.git "/home/${USER}/paru"
    cd "/home/${USER}/paru" || exit
    makepkg -si --noconfirm --needed
    rm -rf "/home/${USER}/paru"
  fi

  pacmanInstall stow git dialog

  # just in case someone decides to copy it to the wrong directory
  [[ ! -d ~/.dotfiles/.git ]] && echo "Dotfile repo should be cloned to ~/.dotfiles directory." && exit 1

  cd ~/.dotfiles || exit
  git submodule init && git submodule update
  mkdir -pv ~/.config

  installPackages || error "Error installing packages."

  dotfileInstall env
  touch "$HOME/.config/wget-hsts"
  mkdir -pv "$HOME/.local/share/npm"

  dotfileInstall easyeffects

  dotfileInstall git

  dotfileInstall foot
  # change default terminal for kde apps
  grep -q "\[General\]" ~/.config/kdeglobals \
    || echo "[General]" >>~/.config/kdeglobals
  sed -i '/^TerminalApplication=/d' ~/.config/kdeglobals
  sed -i '/^\[General\]/a TerminalApplication=footclient' ~/.config/kdeglobals

  dotfileInstall tmux

  dotfileInstall keepassxc

  dotfileInstall zsh
  [[ ! "$(readlink /proc/$$/exe)" == "/usr/bin/zsh" ]] && sudo chsh -s "$(which zsh)" "$(whoami)" || echo "zsh is already used"
  rm -f ~/.bash_logout ~/.bash_profile ~/.bashrc

  installNeovim || error "Error installing neovim."

  installSway || error "Error installing sway."

  installGaming || error "Error installing gaming related 'things'."

  echo "Installed successfully!"
}

main || error "Error in main."
