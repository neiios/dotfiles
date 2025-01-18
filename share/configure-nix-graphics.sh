#!/usr/bin/env bash

set -euox pipefail

NIX=/nix/var/nix/profiles/default/bin/nix

$NIX profile install --profile /nix/var/nix/profiles/drivers nixpkgs#mesa.drivers

echo "L+ /run/opengl-driver - - - - /nix/var/nix/profiles/drivers" > /etc/tmpfiles.d/nix-drivers.conf

systemd-tmpfiles --create
