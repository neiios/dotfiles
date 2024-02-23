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
      # Impure because of nixGL
      hms = "home-manager switch --impure";
      nrshms = "nrs && hms";
      hmsnrs = "hms && nrs";
      nfc = "nix flake check";

      ls = "ls --color=auto -lah";

      pops = "podman ps -a --format='table {{.ID}}	{{.Names}}	{{.Image}}	{{.Status}}	{{.RunningFor}}'";
      pocu = "podman compose -d";
      pocd = "podman compose down";
      dps = "pops";
      dcu = "pocu";
      dcd = "pocd";
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
