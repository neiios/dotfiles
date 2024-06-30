{ ... }:
{
  # Driver for DisplayLink monitors: https://nixos.wiki/wiki/Displaylink
  boot.kernelModules = [ "udl" ];
  services.xserver.videoDrivers = [
    "displaylink"
    "modesetting"
  ];
}
