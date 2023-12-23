#!/usr/bin/env bash

# This script is meant to be run on a fresh install of Arch Linux with archinstall.
# It includes various tweaks and settings that are not done by archinstall.

HOSTNAME=$(cat /etc/hostname)

# fix buggy touchpad
if [[ "$HOSTNAME" == "sierra" ]]; then
    sudo tee /etc/modprobe.d/psmouse.conf <<EOF
options psmouse synaptics_intertouch=0
EOF
fi

# run sddm on wayland
sudo pacman -S weston
sudo tee /etc/sddm.conf.d/wayland.conf <<EOF
[General]
DisplayServer=wayland
EOF

# maybe fixes sddm shutdown
sudo mkdir -pv /etc/systemd/system/sddm.service.d
sudo tee /etc/systemd/system/sddm.service.d/override.conf <<EOF
[Service]
TimeoutStopSec=5s
EOF

# hide nix users
sudo tee /etc/sddm.conf.d/hide-nix-users.conf <<EOF
[Users]
HideShells=/usr/bin/nologin,/sbin/nologin
EOF

sudo tee /etc/papersize <<EOF
a4
EOF

# podman setup
sudo pacman -S podman podman-compose buildah \
    netavark aardvark-dns \
    qemu-user-static qemu-user-static-binfmt
systemctl --user enable --now podman.socket
systemctl --user enable --now podman-restart.service

# and docker for when i am feeling dumb
sudo pacman -S docker docker-buildx docker-compose docker-scan

# firewall
sudo pacman -S ufw
sudo systemctl enable --now ufw.service
sudo ufw default deny
sudo ufw limit ssh
sudo ufw logging off
sudo ufw enable

# update firmware
sudo pacman -S fwupd

# no point in actually automating this
echo "1. Add noatime and compress=zstd to btrfs mounts"
echo "2. Check if luks workqueues are disabled and allow discards is set"
echo "https://wiki.archlinux.org/title/Dm-crypt/Specialties#Disable_workqueue_for_increased_solid_state_drive_(SSD)_performance"
echo "https://wiki.archlinux.org/title/Dm-crypt/Specialties#Discard/TRIM_support_for_solid_state_drives_(SSD)"
