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
      xkb-options = ["terminate:ctrl_alt_bksp"];
    };

    "org/gnome/shell/extensions/dock-from-dash" = {
      show-overview = true;
    };

    "org/gnome/desktop/wm/keybindings" = {
      close = ["<Super>q"];
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
  };
}
