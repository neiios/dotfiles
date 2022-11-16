# completion configuration

zmodload -i zsh/complist
autoload -Uz compinit; compinit
_comp_options+=(globdots) # complete hidden files

zstyle ':completion:*' completer _extensions _complete _approximate # define used completers

zstyle ':completion:*' use-cache on # use completions cache
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zcompcache" # path completion cache file

zstyle ':completion:*' complete-options true # autocomplete options for cd
zstyle ':completion:*' file-sort modification # sort files by modification

zstyle ':completion:*' menu select # selection menu
# color some menu elements
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:*:*:*:descriptions' format '%F{blue}-- %D %d --%f'
zstyle ':completion:*:*:*:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:*:*:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:*:*:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' group-name '' # group completions
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands # change completion order

# i wont explain this
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# accept with ctrl+space
bindkey '^Z' autosuggest-accept
