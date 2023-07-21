{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.modules.git;
in {
  options.modules.git = {
    enable = lib.mkEnableOption "Git";
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userName = "Igor";
      userEmail = "egor@sgf.lt";

      signing.signByDefault = true;
      signing.key = null; # Choose automatically

      extraConfig = {
        init.defaultBranch = "master";
        core = {
          autocrlf = "false";
          eol = "lf";
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

    home.packages = [
      pkgs.gh
    ];
  };
}
