{ config, ... }:
{
  xdg.enable = true;

  home.sessionVariables = {
    GOPATH = "${config.xdg.dataHome}/go";
    GOMODCACHE = "${config.xdg.cacheHome}/go/mod";

    R_LIBS_USER = "${config.xdg.dataHome}/R/%p-library/%v";
    R_HOME_USER = "${config.xdg.dataHome}/R";
    R_PROFILE_USER = "${config.xdg.dataHome}/R/profile";
    R_HISTFILE = "${config.xdg.cacheHome}/R/history";

    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";

    ANDROID_HOME = "${config.xdg.dataHome}/android";
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";

    CARGO_HOME = "${config.xdg.dataHome}/cargo";

    FFMPEG_DATADIR = "${config.xdg.configHome}/ffmpeg";

    TEXMFHOME = "${config.xdg.dataHome}/texmf";
    TEXMFVAR = "${config.xdg.cacheHome}/texlive/texmf-var";
    TEXMFCONFIG = "${config.xdg.configHome}/texlive/texmf-config";

    DOCKER_CONFIG = "${config.xdg.configHome}/docker";

    DOTNET_CLI_TELEMETRY_OPTOUT = "1"; # <3 Microsoft
    NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";
    DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";

    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NVM_DIR = "${config.xdg.dataHome}/nvm";

    JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";
    KERAS_HOME = "${config.xdg.stateHome}/keras";
    PYTHON_HISTORY = "${config.xdg.stateHome}/python/history";
    PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
    PYTHONUSERBASE = "${config.xdg.dataHome}/python";
  };

  xdg.configFile."npm/npmrc" = {
    text = ''
      cache=${config.xdg.cacheHome}/npm
      init-module=${config.xdg.configHome}/npm/config/npm-init.js
      logs-dir=${config.xdg.dataHome}/npm/logs
    '';
  };
}
