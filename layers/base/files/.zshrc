HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
HISTSIZE="10000"
SAVEHIST="10000"
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE

bindkey -e
WORDCHARS=${WORDCHARS/\//}

NIX_USER_PROFILE="$HOME/.nix-profile"

autoload -Uz vcs_info
precmd_functions+=( vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:*' enable git
PROMPT='%B%F{green}%3~/%f%b $vcs_info_msg_0_%(?..%F{red}[%?]%f)%(!.#.$) '

fpath+="$NIX_USER_PROFILE/share/zsh/site-functions"
fpath+="/nix/var/nix/profiles/default/share/zsh/site-functions"
fpath+="/usr/share/zsh/functions"
fpath+="/usr/share/zsh/site-functions"
fpath+="/usr/share/zsh/vendor-completions"
fpath+="/usr/local/share/zsh/site-functions"

# shut up zsh
unsetopt beep

# thanks to compinstall
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# and https://thevaluable.dev/zsh-completion-guide-examples/
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
eval "$(dircolors -b)" # ls uses built-in defaults without LS_COLORS, but list-colors needs it set
# zstyle ':completion:*' file-list all # Does not use LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # does not work with file-list all
zstyle ':completion:*' squeeze-slashes true

# enable compsys https://zsh.sourceforge.io/Doc/Release/Completion-System.html
autoload -Uz compinit
compinit -d "$HOME/.cache/zcompdump"

source <(fzf --zsh)
source <(direnv hook zsh)
eval "$(mise activate zsh)"

alias ssh0='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias ls='ls -lAh --color=auto'
alias sudo='sudo ' # makes aliases work with sudo

source "$NIX_USER_PROFILE/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$NIX_USER_PROFILE/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
