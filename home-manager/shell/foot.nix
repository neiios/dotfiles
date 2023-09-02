{
  config,
  lib,
  pkgs,
  ...
} @ args: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "JetBrainsMono Nerd Font:size=10";
        pad = "8x8 center";
        initial-window-size-pixels = "1200x700";
        title = "⠀"; # What an ugly hack. But oh well.
        locked-title = "yes";
        dpi-aware = "no";
      };
      scrollback = {
        lines = "100000";
        multiplier = "5.0";
      };
      csd = {
        color = "ff000000";
        button-color = "ffb9b9b9";
      };
      cursor = {
        style = "block";
        blink = "no";
        beam-thickness = "1.5";
      };
      mouse = {
        hide-when-typing = "no";
        alternate-scroll-mode = "yes";
      };
      cursor = {
        color = "181818 56d8c9";
      };
      colors = {
        alpha = "1";
        background = "000000";
        foreground = "b9b9b9";
        regular0 = "252525";
        regular1 = "c01c28";
        regular2 = "58af00";
        regular3 = "e59a04";
        regular4 = "12488b";
        regular5 = "a347ba";
        regular6 = "38b49e";
        regular7 = "d0cfcc";
        bright0 = "5e5c64";
        bright1 = "f66151";
        bright2 = "8ec251";
        bright3 = "e9ad0c";
        bright4 = "66aadd";
        bright5 = "c061cb";
        bright6 = "26d1b3";
        bright7 = "ffffff";
      };
    };
  };

  programs.tmux.extraConfig = ''
    # True color support
    set -ag terminal-overrides ",foot:RGB"
  '';

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "footclient -m tmux a";
      name = "Launch Terminal";
    };
    "com/github/stunkymonkey/nautilus-open-any-terminal" = {
      terminal = "footclient";
    };
  };
}
