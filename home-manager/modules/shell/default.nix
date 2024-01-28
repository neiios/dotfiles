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

      # starship transience character
      function starship_transient_prompt_func
        ${config.home.profileDirectory}/bin/starship module character
      end
    '';

    shellAliases = {
      nrs = "sudo nixos-rebuild switch";
      hms = "home-manager switch";
      nrshms = "nrs && hms";
      hmsnrs = "hms && nrs";
      nfc = "nix flake check";

      ls = "ls --color=auto -lah";

      dps = "podman ps -a --format='table {{.ID}}	{{.Names}}	{{.Image}}	{{.Status}}	{{.RunningFor}}'";
      dcu = "podman compose -d";
      dcd = "podman compose down";
    };
  };

  programs.tmux.extraConfig = ''
    set -g default-shell ${pkgs.fish}/bin/fish
  '';

  programs.starship = {
    enable = true;
    enableTransience = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "\\$";
        error_symbol = "[\\$](bold red)";
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
