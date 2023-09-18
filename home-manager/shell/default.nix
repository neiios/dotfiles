{
  config,
  lib,
  pkgs,
  ...
} @ args: let
  username = "egor";
in {
  imports = [
    ./foot.nix
    ./tmux.nix
    ./completions.nix
    ./aliases.nix
    ./prompt.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    fzf
    fd
    lf
    bat
    jq
    yq
    httpie
  ];

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "emacs";

    autocd = true;
    enableAutosuggestions = true;
    historySubstringSearch.enable = true;

    initExtra = ''
      zle_highlight=('paste:none')

      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

      [[ -f "/home/${username}/.sdkman/bin/sdkman-init.sh" ]] && source "/home/${username}/.sdkman/bin/sdkman-init.sh"
    '';

    history = {
      path = "/home/${username}/.cache/zsh";
      ignoreSpace = true;
      share = true;
      size = 20000;
    };
  };
}
