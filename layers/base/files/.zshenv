export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

typeset -U path fpath
path=("$HOME/dotfiles/bin" "$HOME/.local/bin" $path)
export EDITOR=nvim

if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
    source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
fi

export NIXPKGS_ALLOW_UNFREE=1
export LOCALE_ARCHIVE="$HOME/.nix-profile/lib/locale/locale-archive" # nix's glibc reads this variable to find locale data
export XCURSOR_PATH="$HOME/.local/share/icons:$HOME/.nix-profile/share/icons:/usr/share/icons" # fixes cursors in Nix apps
export XCURSOR_SIZE=24
export XCURSOR_THEME=Adwaita
