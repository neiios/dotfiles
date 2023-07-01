{
  config,
  pkgs,
  lib,
  username,
  ...
}: let
  cfg = config.modules.zsh;
in {
  options.modules.zsh = {
    enable = lib.mkEnableOption "Zsh";
  };

  imports = [./aliases.nix ./completions.nix ./prompt.nix];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zsh-z
      zsh-fast-syntax-highlighting
      fzf

      neovim
      exa
      fd
      ripgrep
      bat
      jq
      yq
      httpie
      doggo
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
    };

    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      defaultKeymap = "emacs";

      autocd = true;
      enableAutosuggestions = true;
      historySubstringSearch.enable = true;

      initExtra = ''
        zle_highlight=('paste:none')

        source ${pkgs.zsh-z}/share/zsh-z/zsh-z.plugin.zsh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        source ${pkgs.fzf}/share/fzf/completion.zsh
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

        source "/home/${username}/.sdkman/bin/sdkman-init.sh"
      '';

      localVariables = {
        ZSHZ_DATA = "/home/${username}/.local/share/z-database";
      };

      history = {
        path = "/home/${username}/.cache/zsh";
        ignoreSpace = true;
        share = true;
        size = 20000;
      };
    };
  };
}
