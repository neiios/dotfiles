{
  config,
  lib,
  pkgs,
  ...
}:
{
  virtualisation.spiceUSBRedirection.enable = true;
  environment.systemPackages = with pkgs; [ virt-manager ];
  virtualisation.libvirtd.enable = true;
}
