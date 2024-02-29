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

  targets.genericLinux.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "emacs";

    enableAutosuggestions = true;
    enableCompletion = true;
    enableVteIntegration = true;

    history.ignoreSpace = true;
    history.path = "${config.xdg.cacheHome}/zsh_history";
    historySubstringSearch.enable = true;

    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = [
      "main"
      "brackets"
    ];

    shellAliases = {
      nrs = "sudo nixos-rebuild switch";
      hms = "home-manager switch --impure"; # Needs impure because of nixGL
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

    envExtra = ''
      export XDG_DATA_DIRS=$XDG_DATA_DIRS:/var/lib/flatpak/exports/share:/home/igor/.local/share/flatpak/exports/share
    '';

    initExtra = ''
      source ${./completions.zsh}
      source ${./prompt.zsh}

      # Disable paste highlight
      zle_highlight=('paste:none')
    '';
  };

  programs.tmux.extraConfig = ''
    set -g default-shell ${pkgs.zsh}/bin/zsh
  '';

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  services.ssh-agent.enable = true;

  programs.fzf.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
