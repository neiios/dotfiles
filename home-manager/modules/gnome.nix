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

    "org/gnome/desktop/interface" = {
      clock-format = "24h";
      toolkit-accessibility = false;
      document-font-name = "Inter 11";
      font-name = "Inter 11";
      monospace-font-name = "JetBrainsMonoNL Nerd Font 10";
    };

    "org/gnome/desktop/wm/preferences" = {
      titlebar-font = "Inter Bold 11";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      speed = 0.4;
    };

    "org/gnome/desktop/search-providers" = {
      disabled = [ "org.gnome.Software.desktop" ];
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];
      toggle-maximized = [ "<Super>w" ];
      toggle-fullscreen=["<Shift><Super>f"]; # borderless for every window. nice.

      move-to-workspace-last = [ "<Shift><Super>e" ];
      move-to-workspace-left = [ "<Shift><Super>a" ];
      move-to-workspace-right = [ "<Shift><Super>d" ];
      switch-to-workspace-last = [ "<Super>e" ];
      switch-to-workspace-left = [ "<Super>a" ];
      switch-to-workspace-right = [ "<Super>d" ];
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      mic-mute = [ "Num_Lock" ];
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      power-button-action = "interactive";
      power-saver-profile-on-low-battery = true;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = [ ];
    };

    "org/gtk/settings/file-chooser" = {
      clock-format = "24h";
    };

    "system/locale" = {
      region = "en_IE.UTF-8";
    };
  };
}
