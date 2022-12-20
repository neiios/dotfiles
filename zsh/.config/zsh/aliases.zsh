#!/bin/zsh

# vi, vim, nvim
hash nvim && alias vim="nvim"
hash nvim && alias vi="nvim"

# cat and ls
hash bat && alias cat="bat"
hash exa && alias ls="exa -a --long --group"

# bitcoin-cli
alias bcli="bitcoin-cli"

# sudo with aliases
alias sudo='sudo '

# respect xdg
alias wget=wget --hsts-file="$XDG_CACHE_HOME/wget-hsts"
alias yarn='yarn --use-yarnrc "$XDG_CONFIG_HOME/yarn/config"'

# color
alias diff='diff --color=auto'
alias grep='grep --color=auto'
alias ip='ip -color=auto'

# arch mirrorlist
alias rate-mirrors-arch='export TMPFILE="$(mktemp)"; \
  rate-mirrors --save=$TMPFILE --protocol=https arch --max-delay=21600 \
    && sudo mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup \
    && sudo mv $TMPFILE /etc/pacman.d/mirrorlist'

# git
alias gs="git status -sb"
alias ga="git add"
alias gaa="git add ."
alias gau="git add -u"
alias gap="git add -p"
alias gb="git branch"
alias gba="git branch --all"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gcam="gca --amend"
alias gch="git cherry-pick"
alias gco="git checkout"
alias gcop="git checkout -p"
alias gd="git diff -M"
alias gdc="git diff -M --cached"
alias gf="git fetch"
alias gfa="git fetch --all"
alias gl='git log --graph --pretty="format:%C(yellow)%h%C(auto)%d%Creset %s %C(white) %C(cyan)%an, %C(magenta)%ar%Creset"'
alias gla='gl --all'
alias gm="git merge --no-ff"
alias gmf="git merge --ff-only"
alias gpf="git push --force"
alias gp="git push"
alias gpt="git push --tags"
alias gr="git reset"
alias grp="git reset --patch"
alias grh="git reset --hard"
alias grsh="git reset --soft HEAD~"
alias grb="git rebase"
alias grbc="git rebase --continue"
alias grbi="git rebase -i"
alias grv="git remote -v"
alias gst="git stash"
alias gstp="git stash pop"
alias gw="git show"

# ansible
alias ap="ansible-playbook"
alias av="ansible-vault"
alias ave="ansible-vault encrypt"
alias avd="ansible-vault decrypt"

# make
alias make="make -j$(nproc)"

# ssh
# alias ssh='TERM=xterm-256color ssh'

# htop
alias htop="btop"

# wget
alias wget=wget --hsts-file="$XDG_DATA_HOME/wget-hsts"

# directory stack aliases (d - lists, 1..9 - jumps)
alias d='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# i am too lazy to type both
alias update="flatpak update; paru -Syu"

# creates a telegram video sticker
function telegram-sticker() {
  ffmpeg -i $1 -c:v libvpx-vp9 -vf scale=512:-1 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -t 00:00:03 ~/Videos/$2.webm 
}
