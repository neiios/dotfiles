{
  config,
  lib,
  pkgs,
  ...
} @ args: let
  username = "igor";
in {
  imports = [
    ./completions.nix
    ./aliases.nix
    ./foot.nix
    ./prompt.nix
    ./tmux.nix
    ./xdg-vars.nix
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

  # programs.direnv.enable = true;
  # programs.direnv.nix-direnv.enable = true;

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

      [[ -f "/home/${username}/.sdkman/bin/sdkman-init.sh" ]] && source "/home/${username}/.sdkman/bin/sdkman-init.sh"

      export NVM_DIR="$HOME/.config/nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

      [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
      eval "$(pyenv init -)"

      export PATH="$PATH:$HOME/.dotnet/tools"

      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
    '';

    envExtra = ''
      export PATH="$HOME/.local/bin:$PATH"
      # BUG: fix flatpak paths (nix zsh overrides system XDG_DATA_DIRS)
      export XDG_DATA_DIRS="${config.xdg.dataHome}/flatpak/exports/share:/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
    '';

    history = {
      path = "/home/${username}/.cache/zsh";
      ignoreSpace = true;
      share = true;
      size = 20000;
    };
  };
}
