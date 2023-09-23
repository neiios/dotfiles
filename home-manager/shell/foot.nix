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
        font = "JetBrainsMono Nerd Font:size=11";
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
        foreground = "ffffff";
        regular0 = "000000";
        regular1 = "ff5f59";
        regular2 = "44bc44";
        regular3 = "d0bc00";
        regular4 = "2fafff";
        regular5 = "feacd0";
        regular6 = "00d3d0";
        regular7 = "bfbfbf";
        bright0 = "595959";
        bright1 = "ff6b55";
        bright2 = "70b900";
        bright3 = "fec43f";
        bright4 = "79a8ff";
        bright5 = "b6a0ff";
        bright6 = "6ae4b9";
        bright7 = "ffffff";
      };
    };
  };

  programs.tmux.extraConfig = ''
    # True color support
    set-option -sa terminal-features ',foot:RGB'
  '';

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>Return";
      command = "${pkgs.foot}/bin/footclient ${pkgs.tmux}/bin/tmux new-session -s default -A";
      name = "Launch Terminal";
    };
  };
}
