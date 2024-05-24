{ system-manager, ... }:
{
  imports = [
    ./keyd
    ./zram
  ];

  systemd.tmpfiles.rules = [ "f /etc/containers/nodocker 755 root root - -" ];
  system-manager.allowAnyDistro = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  environment.systemPackages = [ system-manager.packages.x86_64-linux.system-manager ];
}
