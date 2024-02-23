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
    app-hider
    alphabetical-app-grid
  ];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      mic-mute = [ "Num_Lock" ];
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "caps:escape" ];
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
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
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
      toggle-maximized = [ "<Super>w" ];
    };

    "org/gnome/mutter" = {
      edge-tiling = true;
      dynamic-workspaces = false;
    };
  };
}
