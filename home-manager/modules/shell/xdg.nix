{
  config,
  lib,
  pkgs,
  ...
}:
{
  xdg.enable = true;

  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1"; # <3 Microsoft
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
    R_HOME_USER = "${config.xdg.dataHome}/R";
    R_PROFILE_USER = "${config.xdg.dataHome}/R/profile";
    R_HISTFILE = "${config.xdg.cacheHome}/R/history";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc"; # NOTE: Plasma hardcodes this value
    ANDROID_HOME = "${config.xdg.dataHome}/android";
    TEXMFHOME = "${config.xdg.dataHome}/texmf";
    TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
    TEXMFCONFIG = "${config.xdg.configHome}/texlive/texmf-config";
    KERAS_HOME = "${config.xdg.stateHome}/keras";
    PYENV_ROOT = "${config.xdg.dataHome}/pyenv";
    NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";
    JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
    DOCKER_CONFIG = "${config.xdg.configHome}/docker";
    DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NVM_DIR = "${config.xdg.dataHome}/nvm";
  };

  xdg.configFile."npm/npmrc" = {
    text = ''
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      logs-dir=''${XDG_STATE_HOME}/npm/logs
    '';
  };
}
