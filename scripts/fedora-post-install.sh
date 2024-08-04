#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'
SCRIPT_DIR=$(dirname "$(realpath "$BASH_SOURCE")")

if [ "$#" -ne 1 ]; then
    echo "Error: No argument provided"
    echo "Usage: $0 <hostname>"
    exit 1
fi

function set_hostname {
    hostnamectl set-hostname "$1"
}

function set_editor {
    sudo dnf install -y neovim
    echo "EDITOR=nvim" | sudo tee /etc/environment > /dev/null
}

function fix_trackpad {
    echo "options psmouse synaptics_intertouch=0" | sudo tee /etc/modprobe.d/69-psmouse.conf > /dev/null
}

function enable_mullvad_dot {
    sudo mkdir -pv /etc/systemd/resolved.conf.d
    sudo tee /etc/systemd/resolved.conf.d/69-dot.conf > /dev/null << EOF
[Resolve]
DNS=194.242.2.2#dns.mullvad.net
DNSOverTLS=opportunistic
DNSSEC=no
Domains=~.
EOF
}

function install_rpmfusion_codecs {
    sudo dnf install -y \
        "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm" \
        "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

    sudo dnf config-manager --enable fedora-cisco-openh264
    sudo dnf update -y @core
    sudo dnf swap -y ffmpeg-free ffmpeg --allowerasing
    sudo dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
    sudo dnf update -y @sound-and-video
    sudo dnf install -y intel-media-driver
    sudo dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
    sudo dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
    sudo dnf install -y rpmfusion-free-release-tainted rpmfusion-nonfree-release-tainted
    sudo dnf --repo=rpmfusion-nonfree-tainted install -y "*-firmware"
}

function install_updates {
    sudo fwupdmgr refresh --force
    sudo fwupdmgr update
    sudo dnf upgrade --refresh
}

function remove_pre_installed {
    sudo dnf remove -y firefox* gnome-terminal gnome-maps gnome-weather gnome-tour yelp mediawriter rhythmbox
}

function install_apps {
    flatpak install flathub -y \
        com.github.tchx84.Flatseal \
        com.mattjakeman.ExtensionManager \
        com.github.wwmm.easyeffects \
        re.sonny.Junction \
        io.github.ungoogled_software.ungoogled_chromium \
        io.gitlab.librewolf-community \
        org.mozilla.firefox \
        org.mozilla.Thunderbird \
        app.devsuite.Ptyxis \
        org.gnome.Decibels \
        org.gnome.Fractal \
        org.telegram.desktop
}

set_hostname "$1"
set_editor
[[ "$1" == "rainier" ]] && fix_trackpad
enable_mullvad_dot
install_rpmfusion_codecs
remove_pre_installed
install_updates
install_apps
# TODO: Restore basic GNOME settings
source "$SCRIPT_DIR/hide-desktop-entries.sh"

echo -e "\n\nNow reboot to apply the configuration and updates."
