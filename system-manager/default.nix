{ pkgs, system-manager, ... }:
{
  config = {
    system-manager.allowAnyDistro = true;
    nixpkgs.hostPlatform = "x86_64-linux";

    environment.systemPackages = with pkgs; [
      system-manager.packages.x86_64-linux.system-manager
      neovim
    ];
  };
}
