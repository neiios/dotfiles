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
  home.sessionVariables = {
    GOPATH = "$XDG_DATA_HOME/go";
    GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
    R_HOME_USER = "$XDG_DATA_HOME/R";
    R_PROFILE_USER = "$XDG_DATA_HOME/R/profile";
    R_HISTFILE = "$XDG_CACHE_HOME/R/history";
  };
}
