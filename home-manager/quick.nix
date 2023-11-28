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
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    R_HOME_USER = "${config.xdg.dataHome}/R";
    R_PROFILE_USER = "${config.xdg.dataHome}/R/profile";
    R_HISTFILE = "${config.xdg.cacheHome}/R/history";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    ANDROID_HOME = "${config.xdg.dataHome}/android";
  };

  programs.zsh.shellAliases = {
    adb = "HOME=${config.xdg.dataHome}/android adb";
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
