{ system-manager, ... }:
{
  imports = [
    ./keyd
    ./zram
  ];

  config = {
    system-manager.allowAnyDistro = true;
    nixpkgs.hostPlatform = "x86_64-linux";
    environment.systemPackages = [ system-manager.packages.x86_64-linux.system-manager ];
  };
}
