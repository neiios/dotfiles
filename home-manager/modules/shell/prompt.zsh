autoload -Uz add-zsh-hook
autoload -Uz vcs_info

add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' formats " %F{15}%c%u %b%f"
zstyle ':vcs_info:*' actionformats " %F{15}%c%u%b%f %a"
zstyle ':vcs_info:*' stagedstr "%F{green}"
zstyle ':vcs_info:*' unstagedstr "%F{yellow}"
zstyle ':vcs_info:*' check-for-changes true

setopt prompt_subst

PROMPT='%F{12}%3~%f %(?.$.%F{red}$)%f '
RPROMPT='${vcs_info_msg_0_}'
