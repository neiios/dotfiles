{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "hydro";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "hydro";
          rev = "bc31a5ebc687afbfb13f599c9d1cc105040437e1";
          sha256 = "0MMiM0NRbjZPJLAMDXb+Frgm+du80XpAviPqkwoHjDA=";
        };
      }
    ];

    interactiveShellInit = ''
      set -g fish_greeting

      set -g hydro_symbol_prompt '$'
      set -g hydro_symbol_git_dirty ''''''
      set -g hydro_cmd_duration_threshold 690000000

      set -g hydro_color_pwd blue
      set -g hydro_color_git cyan
    '';

    shellAliases = {
      neofetch = "${lib.getBin pkgs.fastfetch}/bin/fastfetch";

      ls = "ls --color=auto -lAh";

      dps = "docker ps -a --format='table {{.ID}}	{{.Names}}	{{.Image}}	{{.Status}}	{{.RunningFor}}'";
      dcu = "docker compose up -d";
      dcl = "docker compose logs -f";
      dcd = "docker compose down";
    };
  };

  programs.tmux.extraConfig = ''
    set -g default-shell ${pkgs.fish}/bin/fish
  '';

  programs.fzf.enable = true;

  programs.zoxide = {
    enable = true;
    options = [ "--cmd cd" ];
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
