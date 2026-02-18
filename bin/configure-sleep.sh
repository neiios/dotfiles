#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

mkdir -pv /etc/systemd/logind.conf.d

cat > /etc/systemd/logind.conf.d/sane-laptop.conf << EOF
[Login]
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=ignore
HandleLidSwitchDocked=ignore
EOF
