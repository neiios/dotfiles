#!/bin/zsh

# use emacs mode
bindkey -e

# configure history
export HISTFILE="$XDG_CACHE_HOME/zsh_history" # history filepath
export HISTSIZE=10000 # maximum events for internal history
export SAVEHIST=10000 # maximum events in history file
setopt EXTENDED_HISTORY       # record timestamp of command in HISTFILE
setopt HIST_VERIFY            # show command with history expansion to user before running it
setopt SHARE_HISTORY          # share command history across all sessions
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY     # add commands to history immediately (to prevent history loss)

# disable paste highlight
zle_highlight=('paste:none')

# directory stack
setopt AUTO_PUSHD           # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.

# prompt
source "${HOME}/.config/zsh/prompt.zsh"

# completions
source "${HOME}/.config/zsh/completion.zsh"

# source config files
for conf in "$HOME/.config/zsh/"*.zsh; do
  source "${conf}"
done

KEYTIMEOUT=1 # reduce how long to wait for additional characters in sequence (5 is 50 ms)

# emit osc7 escape sequance so foot can be spawned in the current working directory
autoload -Uz add-zsh-hook
function osc7 {
    setopt localoptions extendedglob
    input=( ${(s::)PWD} )
    uri=${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}
    print -n "\e]7;file://${HOSTNAME}${uri}\e\\"
}
add-zsh-hook -Uz chpwd osc7

# Enable Ctrl-x-e to edit command line
autoload -U edit-command-line
# Emacs style
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line
# Vi style:
# zle -N edit-command-line
# bindkey -M vicmd v edit-command-line

# add to path
# path=('~/.config/emacs/bin' $path)
# export PATH

# fzf things
source "/usr/share/fzf/key-bindings.zsh"
source "/usr/share/fzf/completion.zsh"

# source plugins
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh
source "${HOME}/.config/zsh/zsh-completions/zsh-completions.plugin.zsh"
source "${HOME}/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "${HOME}/.config/zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "${HOME}/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh"

# up and down arrow to use substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# autostart tmux in foot only
if [ -x "$(command -v tmux)" ] && [ -n "${DISPLAY}" ] && [ -z "${TMUX}" ] && [ ${TERM} = 'foot' ]; then
    tmux attach || tmux >/dev/null 2>&1
fi
