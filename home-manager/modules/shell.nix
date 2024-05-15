{ config, lib, pkgs, ... }:
{
  programs = {
    fish = {
      enable = true;

      interactiveShellInit = ''
        set -g fish_greeting

        fish_add_path --append '${config.xdg.dataHome}/JetBrains/Toolbox/scripts'
        fish_add_path --prepend '${config.home.homeDirectory}/.local/nvim/bin'
      '';

      shellAliases = {
        sudo = "sudo -i"; # Makes sudo source bashrc and friends

        neofetch = "${lib.getBin pkgs.fastfetch}/bin/fastfetch";

        nrs = "sudo nixos-rebuild switch";
        hms = "home-manager switch --impure --flake ~/.dotfiles"; # Needs impure because of nixGL
        ssm = "sudo system-manager switch --flake ~/.dotfiles";
        nfc = "nix flake check";

        ls = "ls --color=auto --classify --group-directories-first --almost-all --human-readable -lv";

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
