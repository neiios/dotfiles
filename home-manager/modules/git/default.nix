{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (pkgs.gitAndTools.git.override { sendEmailSupport = true; })
    gh
    glab
  ];

  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.configHome}/git - - - - ${config.home.homeDirectory}/Configuration/home-manager/modules/git/config"
  ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      gh = {
        user = "git";
        hostname = "github.com";
        identityFile = "~/.ssh/github_key";
      };
    };
  };

  programs.zsh.initExtra = ''
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
