{
  config,
  lib,
  pkgs,
  ...
} @ args: {
  # Install as a system package or a flatpak
  systemd.user.tmpfiles.rules = [
    "L+ /home/egor/.config/easyeffects - - - - /home/egor/Dev/dotfiles/home-manager/easyeffects/config"
  ];
}
