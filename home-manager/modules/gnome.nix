{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs.gnomeExtensions; [
    legacy-gtk3-theme-scheme-auto-switcher
    appindicator
    blur-my-shell
    dock-from-dash
  ];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      mic-mute = [ "Num_Lock" ];
    };

    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [
          "xkb"
          "us"
        ])
        (mkTuple [
          "xkb"
          "ru"
        ])
        (mkTuple [
          "xkb"
          "lt"
        ])
      ];
      xkb-options = [ "caps:escape" ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/shell" = {
      enabled-extensions = [
        "legacyschemeautoswitcher@joshimukul29.gmail.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "blur-my-shell@aunetx"
        "dock-from-dash@fthx"
      ];
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];

      switch-to-workspace-left = [ "<Super>a" ];
      move-to-workspace-left = [ "<Shift><Super>a" ];
      switch-to-workspace-right = [ "<Super>d" ];
      move-to-workspace-right = [ "<Shift><Super>d" ];

      toggle-maximized = [ "<Super>w" ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = [ ];
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = true;
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = false;
    };
  };
}
