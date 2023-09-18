{
  config,
  lib,
  pkgs,
  ...
} @ args: {
  # Install as a system package or a flatpak
  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.configHome}/easyeffects - - - - /home/egor/Dev/dotfiles/home-manager/easyeffects/config"
  ];
}
