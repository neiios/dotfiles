{
  config,
  lib,
  pkgs,
  ...
} @ args: let
  username = "igor";
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
    tealdeer
  ];

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    defaultKeymap = "emacs";

    autocd = true;
    enableAutosuggestions = true;
    historySubstringSearch.enable = true;

    initExtra = ''
      zle_highlight=('paste:none')

      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey "^X^E" edit-command-line

      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

      [[ -f "/home/${username}/.sdkman/bin/sdkman-init.sh" ]] && source "/home/${username}/.sdkman/bin/sdkman-init.sh"

      export NVM_DIR="$([ -z "''${XDG_CONFIG_HOME-}" ] && printf %s "''${HOME}/.nvm" || printf %s "''${XDG_CONFIG_HOME}/nvm")"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    '';

    envExtra = ''
      export PATH=$HOME/.local/bin:$PATH
    '';

    history = {
      path = "/home/${username}/.cache/zsh";
      ignoreSpace = true;
      share = true;
      size = 20000;
    };
  };
}
