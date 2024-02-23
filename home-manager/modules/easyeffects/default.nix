{
  config,
  lib,
  pkgs,
  ...
}@args:
let
  nixGL = import ../../nixGL.nix {
    inherit pkgs config;
    inherit (args) nixGL;
  };
in
{
  services.easyeffects.enable = true;
  services.easyeffects.package = (nixGL pkgs.easyeffects);

  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.configHome}/easyeffects - - - - ${config.home.homeDirectory}/Configuration/home-manager/modules/easyeffects/config"
  ];
}
