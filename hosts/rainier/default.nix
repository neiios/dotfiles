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

  networking.hostName = "rainier";
  time.timeZone = "Europe/Vilnius";
  system.stateVersion = "24.05";
  nixpkgs.hostPlatform = "x86_64-linux";

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

  programs.adb.enable = true;

  # Creates a vGPU for GVT-G
  virtualisation.kvmgt.enable = true;
  virtualisation.kvmgt.vgpus = {
    "i915-GVTg_V5_4" = {
      uuid = [ "a297db4a-f4c2-11e6-90f6-d3b88d6c9525" ];
    };
  };

  boot.kernelParams = [
    "psmouse.synaptics_intertouch=0" # Makes trackpad more responsive
  ];

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Trackpoint Override]
    MatchUdevType=pointingstick
    MatchName=*TPPS/2 IBM TrackPoint*
    AttrTrackpointMultiplier=1
  '';
}
