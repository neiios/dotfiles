{
  config,
  lib,
  pkgs,
  username,
  ...
}:
{
  imports = [
    ./foot.nix
    ./tmux.nix
    ./xdg.nix
  ];

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting
      fish_add_path ~/.local/nvim/bin
    '';
    shellAliases = {
      nrs = "sudo nixos-rebuild switch";
      hms = "home-manager switch";
      nrshms = "nrs && hms";
      hmsnrs = "hms && nrs";
      nfc = "nix flake check";
      ls = "ls --color=auto";
      lsa = "ls --color=auto -lah";
      dps = "docker ps -a --format='table {{.ID}}	{{.Names}}	{{.Image}}	{{.Status}}	{{.RunningFor}}'";
      dcu = "docker compose -d";
      dcd = "docker compose down";
    };
  };

  programs.tmux.extraConfig = ''
    set -g default-command ${pkgs.fish}/bin/fish
    set -g default-shell ${pkgs.fish}/bin/fish
  '';

  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      add_newline = false;
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
