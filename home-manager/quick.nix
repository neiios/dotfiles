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
}
