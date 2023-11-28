{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  # for quick installs
  home.packages = with pkgs; [
    go
    gopls
    delve
    go-tools
    gotests
    impl
    gomodifytags
  ];

  xdg.enable = true;
  nix.settings.use-xdg-base-directories = true;

  home.sessionVariables = {
    GOPATH = "$XDG_DATA_HOME/go";
    GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
    R_HOME_USER = "$XDG_DATA_HOME/R";
    R_PROFILE_USER = "$XDG_DATA_HOME/R/profile";
    R_HISTFILE = "$XDG_CACHE_HOME/R/history";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
    GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
    ANDROID_HOME = "$XDG_DATA_HOME/android";
    TEXMFHOME = "$XDG_DATA_HOME/texmf";
    TEXMFVAR = "$XDG_CACHE_HOME/texlive/texmf-var";
    TEXMFCONFIG = "$XDG_CONFIG_HOME/texlive/texmf-config";
  };

  programs.zsh.initExtra = ''
    # kdesrc-build #################################################################

    ## Add kdesrc-build to PATH
    export PATH="$HOME/Dev/kde/src/kdesrc-build:$PATH"

    ## Autocomplete for kdesrc-run
    function _comp_kdesrc_run
    {
      local cur
      COMPREPLY=()
      cur="''${COMP_WORDS [COMP_CWORD]}"

      # Complete only the first argument
      if [[ $COMP_CWORD != 1 ]]; then
        return 0
      fi

      # Retrieve build modules through kdesrc-run
      # If the exit status indicates failure, set the wordlist empty to avoid
      # unrelated messages.
      local modules
      if ! modules=$(kdesrc-run --list-installed);
      then
          modules=""
      fi

      # Return completions that match the current word
      COMPREPLY=( $(compgen -W "''${modules}" -- "$cur") )

      return 0
    }

    ## Register autocomplete function
    complete -o nospace -F _comp_kdesrc_run kdesrc-run
    ################################################################################
  '';
}
