#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

export PATH=$PATH:/nix/var/nix/profiles/default/bin/

nix profile add --profile /nix/var/nix/profiles/drivers nixpkgs#mesa

echo "L+ /run/opengl-driver - - - - /nix/var/nix/profiles/drivers" > /etc/tmpfiles.d/nix-drivers.conf

systemd-tmpfiles --create
