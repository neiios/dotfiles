{
  config,
  lib,
  pkgs,
  ...
} @ args: {
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      mic-mute = ["Num_Lock"];
    };

    "org/gnome/desktop/input-sources" = {
      sources = [(mkTuple ["xkb" "us"]) (mkTuple ["xkb" "ru"]) (mkTuple ["xkb" "lt"])];
      xkb-options = ["caps:escape"];
    };

    "org/gnome/shell/extensions/dock-from-dash" = {
      show-overview = true;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      sleep-inactive-ac-type = "nothing";
    };

    "org/gnome/gnome-system-monitor" = {
      show-dependencies = true;
      show-whose-processes = "user";
    };

    "org/gnome/mutter" = {
      workspaces-only-on-primary = true;
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
    };

    "org/gnome/desktop/session" = {
      idle-delay = mkUint32 0;
    };

    "org/gnome/desktop/sound" = {
      event-sounds = false;
      theme-name = "__custom";
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];

      cycle-windows = ["<Super>s"];
      cycle-windows-backward = ["<Shift><Super>s"];

      switch-to-workspace-left = ["<Super>a"];
      move-to-workspace-left = ["<Shift><Super>a"];
      switch-to-workspace-right = ["<Super>d"];
      move-to-workspace-right = ["<Shift><Super>d"];

      switch-group = ["<Alt>Escape"];
      switch-group-backward = ["<Shift><Alt>Escape"];

      toggle-maximized = ["<Super>w"];
    };

    "org/gnome/shell/keybindings" = {
      toggle-application-view = [];
      toggle-quick-settings = [];
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
  };
}
