{ ... }:
{
  imports = [
    ./boot.nix

    ../../nixos

    ../../nixos/gnome.nix
    ../../nixos/keyd.nix
    ../../nixos/nix-compat.nix
    ../../nixos/podman.nix
    ../../nixos/printing.nix
    ../../nixos/secure-boot.nix
    ../../nixos/vms.nix
    ../../nixos/zram.nix
  ];

  networking.hostName = "summit";
  system.stateVersion = "24.05";
  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Europe/Vilnius";

  # Configure user
  home-manager.users.igor.imports = [ ../../home-manager ];
  users.users.igor = {
    isNormalUser = true;
    description = "Igor";
    extraGroups = [
      "wheel"
      "adbusers"
      "networkmanager"
    ];
  };

  # Interact with android phones through adb
  programs.adb.enable = true;

  # Adds udev rules for more controllers
  # since Steam inside the flatpak can't install the udev rules
  hardware.steam-hardware.enable = true;

  # Disable E-MU 0204 silence detection
  services.pipewire.wireplumber.extraConfig = {
    "monitor.alsa.rules" = {
      matches = [
        {
          # Matches all sources
          node.name = ".*E-MU_0204.*";
        }
      ];
      actions = {
        update-props = {
          session.suspend-timeout-seconds = 0; # 0 disables suspend
          dither.method = "wannamaker3"; # add dither of desired shape
          dither.noise = 2; # add additional bits of noise
        };
      };
    };
  };
}
