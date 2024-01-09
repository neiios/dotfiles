{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.easyeffects.enable = true;
  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.configHome}/easyeffects - - - - ${config.home.homeDirectory}/Configuration/home-manager/modules/easyeffects/config"
  ];
}
