{ config, pkgs, ... }@args:
let
  nixGL = import ../../nixGL.nix {
    inherit pkgs config;
    inherit (args) nixGL;
  };
in
{
  services.easyeffects.enable = true;
  services.easyeffects.package = (nixGL pkgs.easyeffects);
}
