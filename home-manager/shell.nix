{ lib, pkgs, ... }:
{
  programs.fish = {
    enable = true;

    plugins = [
      {
        name = "pure";
        src = pkgs.fetchFromGitHub {
          owner = "pure-fish";
          repo = "pure";
          rev = "28447d2e7a4edf3c954003eda929cde31d3621d2";
          sha256 = "8zxqPU9N5XGbKc0b3bZYkQ3yH64qcbakMsHIpHZSne4=";
        };
      }
    ];

    interactiveShellInit = ''
      set -g fish_greeting

      set pure_enable_nixdevshell true
      set pure_symbol_prompt '$'

      set pure_color_prompt_on_success normal
      set pure_color_mute normal
      set pure_color_primary brcyan
    '';

    shellAliases = {
      neofetch = "${lib.getBin pkgs.fastfetch}/bin/fastfetch";

      ls = "ls --color=auto --classify --group-directories-first --almost-all --human-readable -lv";

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
