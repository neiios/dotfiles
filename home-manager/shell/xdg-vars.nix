{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  xdg.enable = true;

  home.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1"; # <3 Microsoft
    GOPATH = "$XDG_DATA_HOME/go";
    GOMODCACHE = "$XDG_CACHE_HOME/go/mod";
    R_HOME_USER = "$XDG_DATA_HOME/R";
    R_PROFILE_USER = "$XDG_DATA_HOME/R/profile";
    R_HISTFILE = "$XDG_CACHE_HOME/R/history";
    # _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"; # intellij really doesnt like this
    # GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"; # Plasma hardcodes the value
    ANDROID_HOME = "$XDG_DATA_HOME/android";
    TEXMFHOME = "$XDG_DATA_HOME/texmf";
    TEXMFVAR = "$XDG_CACHE_HOME/texlive/texmf-var";
    TEXMFCONFIG = "$XDG_CONFIG_HOME/texlive/texmf-config";
    KERAS_HOME = "$XDG_STATE_HOME/keras";
    PYENV_ROOT = "$XDG_DATA_HOME/pyenv";
    NUGET_PACKAGES = "$XDG_CACHE_HOME/NuGetPackages";
    JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    DOTNET_CLI_HOME = "$XDG_DATA_HOME/dotnet";
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
    NVM_DIR = "$XDG_DATA_HOME/nvm";
  };

  xdg.configFile."npm/npmrc" = {
    text = ''
      prefix=''${XDG_DATA_HOME}/npm
      cache=''${XDG_CACHE_HOME}/npm
      init-module=''${XDG_CONFIG_HOME}/npm/config/npm-init.js
      logs-dir=''${XDG_STATE_HOME}/npm/logs
    '';
  };
}
