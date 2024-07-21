{ lib, ... }:
{
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
    };

    "org/gnome/desktop/interface" = {
      clock-format = "24h";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/privacy" = {
      report-technical-problems = false;
    };

    "org/gnome/system/location" = {
      enabled = false;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = true;
      edge-tiling = true;
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      power-button-action = "interactive";
      power-saver-profile-on-low-battery = true;
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      mic-mute = [ "Num_Lock" ];
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = [ ];
      toggle-quick-settings = [ ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = [ "<Super>q" ];

      move-to-workspace-last = [ "<Shift><Super>e" ];
      move-to-workspace-left = [ "<Shift><Super>a" ];
      move-to-workspace-right = [ "<Shift><Super>d" ];
      switch-to-workspace-last = [ "<Super>e" ];
      switch-to-workspace-left = [ "<Super>a" ];
      switch-to-workspace-right = [ "<Super>d" ];

      toggle-fullscreen = [ "<Shift><Super>w" ];
    };
  };

  services.flatpak.overrides = {
    global = {
      Environment = {
        # Fix unthemed cursor in some Wayland apps
        XCURSOR_THEME = "Adwaita";
      };
    };
  };
}
