export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
export EDITOR=vim

# Load Nix integration
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

export NIXPKGS_ALLOW_UNFREE=1
export LOCALE_ARCHIVE="/usr/lib/locale/locale-archive" # Fixes locale errors in Nix apps
# TODO: a better way would be to do something like this (but this would require to install glibcLocales packges in a profile):
# export LOCALE_ARCHIVE="$(nix profile list --json | jq -r '.elements[] | select(.attrPath? and (.attrPath | type == "string") and (.attrPath | endswith("glibcLocales"))) | .storePaths[0]')/lib/locale/locale-archive"
export XCURSOR_PATH="$HOME/.local/share/icons:$HOME/.nix-profile/share/icons:/usr/share/icons" # Fixes cursors in Nix apps
export XCURSOR_SIZE=24
export XCURSOR_THEME=Adwaita
