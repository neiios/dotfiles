{...}: {
  programs.zsh.shellAliases = {
    hms = "home-manager switch";
    nfc = "nix flake check";
    sudo = "sudo ";
    ls = "ls --color=auto";
    lsa = "ls -lah";
    dps = "docker ps -a --format=\"table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.RunningFor}}\"";
    dcu = "docker compose -d";
    dcd = "docker compose down";
    dclean = "docker system prune -a --volumes";
  };

  programs.zsh.initExtra = ''
    # Allows to create a shell with specified packages (even unfree). Usage: nsh gimp git discord
    function nsh() { ARGS=("$@"); NIXPKGS_ALLOW_UNFREE=1 nix shell --impure "''${ARGS[@]/#/nixpkgs#}" }

    function telegram-sticker() {
      ffmpeg -i $1 -c:v libvpx-vp9 -vf scale=512:-1 -pix_fmt yuva420p -metadata:s:v:0 alpha_mode="1" -t 00:00:03 ~/Videos/$2.webm
    }

    function unnest() {
      mv ./$1/{.,}* . && rmdir $1
    }

    alias g="git"
    alias gs="git status --short --branch"
    alias gc="git commit --verbose"
    alias gca="git add --all && git commit --verbose"
    alias gcam="git commit --verbose --amend"
    alias gb="git branch"
    alias gsw="git switch"
    alias gswc="git switch -c"
    alias ga="git add"
    alias gap="git add --patch"
    alias gaa="git add --all"
    alias gp="git push"
    alias gpf="git push --force-with-lease --force-if-includes"
    alias grb="git rebase"
    alias grba="git rebase --abort"
    alias grbc="git rebase --continue"
    alias grbi="git rebase --interactive"
    alias gd="git diff"
    alias gdc="git diff --cached"
    alias gdcw="git diff --cached --word-diff"
    alias glog="git log --all --decorate --graph --abbrev-commit --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' "
  '';
}
