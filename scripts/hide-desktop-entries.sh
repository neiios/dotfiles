#!/usr/bin/env bash

PATTERN='nvim|qv4l2|qvidcap|htop|avahi|bssh|bvnc|lf|electron|footclient|foot-server|helix|fish|scrcpy|cmake'

TARGET_DIR="$HOME/.local/share/applications"
mkdir -p "$TARGET_DIR"

ENTRIES=$(find -L /usr/share/applications ~/.local/state/nix/profile/share/applications -type f -name "*.desktop" 2>/dev/null | grep -E "$PATTERN")

for ENTRY in $ENTRIES
do
  BASENAME=$(basename "$ENTRY")
  cat << EOF > "$TARGET_DIR/$BASENAME"
[Desktop Entry]
Hidden=true
EOF
done

