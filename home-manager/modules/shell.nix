{ config, pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting

        fish_add_path --append '${config.xdg.dataHome}/JetBrains/Toolbox/scripts'
        fish_add_path --prepend '${config.home.homeDirectory}/.local/nvim/bin'
      '';

      shellAliases = {
        nrs = "sudo nixos-rebuild switch";
        hms = "home-manager switch --impure --flake ~/.dotfiles"; # Needs impure because of nixGL
        ssm = "system-manager switch --flake ~/.dotfiles";
        nfc = "nix flake check";

        ls = "ls --color=auto -lah";
        cd = "z";

        dps = "docker ps -a --format='table {{.ID}}	{{.Names}}	{{.Image}}	{{.Status}}	{{.RunningFor}}'";
        dcu = "docker compose up -d";
        dcl = "docker compose logs -f";
        dcd = "docker compose down";
      };
    };

    tmux.extraConfig = ''
      set -g default-shell ${pkgs.fish}/bin/fish
    '';

    zoxide.enable = true;

    fzf.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  services.ssh-agent.enable = true;
}
