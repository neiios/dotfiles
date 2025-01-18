HISTFILE="$HOME/.cache/zsh_history"
HISTSIZE="10000"
SAVEHIST="10000"

bindkey -e

NIX_USER_PROFILE="$HOME/.nix-profile"
# NIX_USER_PROFILE="$XDG_STATE_HOME/nix/profile"

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '(%b)'
zstyle ':vcs_info:*' enable git
PROMPT='%B%F{green}%3~/%f%b $vcs_info_msg_0_%(?..%F{red}[%?]%f)%(!.#.$) '

# By default zsh from nixpkgs only uses completions from nix store
# Add nix profiles and common FHS completion paths
fpath+="$NIX_USER_PROFILE/share/zsh/site-functions"
fpath+="/nix/var/nix/profiles/default/share/zsh/site-functions"
fpath+="/usr/share/zsh/functions"
fpath+="/usr/share/zsh/site-functions"
fpath+="/usr/share/zsh/vendor-completions"
fpath+="/usr/local/share/zsh/site-functions"

# Completions for old nix commands
source "$NIX_USER_PROFILE/share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh"
fpath+="$NIX_USER_PROFILE/share/zsh/plugins/nix"

# Completions for hetzner cli
mkdir -p ~/.cache/hcloud/completion/zsh
hcloud completion zsh > ~/.cache/hcloud/completion/zsh/_hcloud
fpath+="$HOME/.cache/hcloud/completion/zsh"

# Zsh just shut up
unsetopt beep

source "$NIX_USER_PROFILE/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$NIX_USER_PROFILE/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Thanks to compinstall
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' expand prefix suffix
zstyle ':completion:*' insert-unambiguous false
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list '' 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
# And https://thevaluable.dev/zsh-completion-guide-examples/
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zcompcache"
zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
# zstyle ':completion:*' file-list all # Does not use LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS} # does not work with file-list all
zstyle ':completion:*' squeeze-slashes true

# Enable compsys https://zsh.sourceforge.io/Doc/Release/Completion-System.html
autoload -Uz compinit bashcompinit
compinit -d "$HOME/.cache/zcompdump"
bashcompinit

source <(fzf --zsh)
source <(zoxide init --cmd cd zsh) # Must be after compinit
source <(direnv hook zsh)

alias ssh0='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
alias ls='eza --long --almost-all'
alias sudo='sudo ' # Makes aliases work with sudo
alias vi="$NIX_USER_PROFILE/bin/nvim"
alias vim="$NIX_USER_PROFILE/bin/nvim"
alias nvim="$NIX_USER_PROFILE/bin/nvim" # Alias to absolute path to make it work with sudo

alias gs="git status --short --branch"
alias gc="git commit --verbose"
alias gca="git add --all && git commit --verbose"
alias gcam="git commit --verbose --amend"
alias gb="git branch"
alias gswc="git switch -c"
alias ga="git add"
alias gap="git add --patch"
alias gaa="git add --all"
alias gp="git push"
alias gpf="git push --force-with-lease --force-if-includes"
alias gd="git diff"
alias gdc="git diff --cached"
alias gdcw="git diff --cached --word-diff"
alias glog="git log --all --decorate --graph --abbrev-commit --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'"
function gsw() { git switch "$@" || git switch -c "$@" }; compdef _git-switch gsw
