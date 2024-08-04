#!/usr/bin/env bash

ENTRIES=(
  "nvim.desktop"
  "htop.desktop"
  "io.gitlab.librewolf-community.desktop"
  "qt6-designer.desktop"
  "qt6-linguist.desktop"
)

TARGET_DIR="$HOME/.local/share/applications"

mkdir -pv "$TARGET_DIR"

for ENTRY in "${ENTRIES[@]}"; do
  cat << EOF > "${TARGET_DIR}/${ENTRY}"
[Desktop Entry]
Hidden=true
EOF
done

