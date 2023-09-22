{
  config,
  lib,
  pkgs,
  ...
} @ args: let
  mute-mic = pkgs.writeShellApplication {
    name = "mute-mic";
    runtimeInputs = [pkgs.xdotool];
    text = ''
      xdotool keydown Num_Lock
      xdotool keyup Num_Lock
    '';
  };
in {
  home.packages = with pkgs; [mute-mic];

  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
      ];
    };
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
      binding = "Num_Lock";
      command = "${mute-mic}/bin/mute-mic";
      name = "Mute Mic";
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
      move-to-workspace-left = ["<Shift><Super>a"];
      move-to-workspace-right = ["<Shift><Super>d"];
      switch-group = ["<Alt>Escape"];
      switch-group-backward = ["<Shift><Alt>Escape"];
      switch-to-workspace-left = ["<Super>a"];
      switch-to-workspace-right = ["<Super>d"];
      toggle-maximized = ["<Super>w"];
    };

    "org/gnome/shell/app-switcher" = {
      current-workspace-only = true;
    };
  };
}
