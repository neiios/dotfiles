export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/share/JetBrains/Toolbox/scripts:$PATH"
export PATH="$HOME/.local/vscode/bin:$PATH"
export EDITOR=nvim

# Load Nix integration
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi
export NIXPKGS_ALLOW_UNFREE=1
export LOCALE_ARCHIVE="/usr/lib/locale/locale-archive" # Fixes locale errors in Nix apps
export XCURSOR_PATH="$HOME/.local/share/icons:$HOME/.nix-profile/share/icons:/usr/share/icons" # Fixes cursors in Nix apps
