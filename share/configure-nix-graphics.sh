#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root" >&2
    exit 1
fi

NIX=/nix/var/nix/profiles/default/bin/nix

$NIX profile install --profile /nix/var/nix/profiles/drivers nixpkgs#mesa.drivers

echo "L+ /run/opengl-driver - - - - /nix/var/nix/profiles/drivers" > /etc/tmpfiles.d/nix-drivers.conf
systemd-tmpfiles --create
