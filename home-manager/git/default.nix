{ config, pkgs, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  home.packages = with pkgs; [
    (pkgs.gitAndTools.git.override { sendEmailSupport = true; })
    gh
    glab
  ];

  home.file = {
    "${config.xdg.configHome}/git".source = mkSymlink "${config.home.homeDirectory}/.dotfiles/home-manager/git/config";
  };

  programs.fish.shellAliases = {
    gs = "git status --short --branch";
    gc = "git commit --verbose";
    gca = "git add --all && git commit --verbose";
    gcam = "git commit --verbose --amend";
    gb = "git branch";
    gsw = "git switch";
    gswc = "git switch -c";
    ga = "git add";
    gap = "git add --patch";
    gaa = "git add --all";
    gp = "git push";
    gpf = "git push --force-with-lease --force-if-includes";
    gd = "git diff";
    gdc = "git diff --cached";
    gdcw = "git diff --cached --word-diff";
    glog = "git log --all --decorate --graph --abbrev-commit --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' ";
  };
}
