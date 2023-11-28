{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.git.override {
      sendEmailSupport = true;
    };
    userName = "Igor";
    userEmail = "egor@sgf.lt";
    extraConfig = {
      init.defaultBranch = "master";
      core = {
        autocrlf = "false";
        eol = "lf";
      };
      url = {
        "https://invent.kde.org/" = {
          insteadOf = "kde:";
          pushInsteadOf = "kde:";
        };
      };
    };
  };

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

  home.packages = with pkgs; [
    gh
  ];
}
