{
  config,
  lib,
  pkgs,
  ...
}@args:
let
  ptyxisWrapped = (config.lib.nixGL.wrap args.self.packages.${pkgs.system}.ptyxis);
in
{
  home.packages = [ ptyxisWrapped ];

  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spawn-term/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/spawn-term" = {
      binding = "<Super>Return";
      command = "${lib.getBin ptyxisWrapped}/bin/ptyxis";
      name = "Launch Terminal";
    };
  };

  programs.tmux.extraConfig = ''
    set-option -a terminal-features 'xterm-256color:RGB'
  '';
}
