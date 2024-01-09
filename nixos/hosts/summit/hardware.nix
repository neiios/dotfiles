{
  config,
  lib,
  pkgs,
  lanzaboote,
  ...
}:
{
  imports = [ lanzaboote.nixosModules.lanzaboote ];

  boot = {
    plymouth.enable = true;
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
    ];

    initrd.systemd.enable = true;

    kernelPackages = pkgs.linuxPackages_zen;
    extraModulePackages = [ pkgs.linuxPackages_zen.v4l2loopback ];
    kernelModules = [
      "kvm-amd"
      "v4l2loopback"
    ];
    initrd.availableKernelModules = [
      "nvme"
      "xhci_pci"
      "ahci"
      "usb_storage"
      "usbhid"
      "sd_mod"
    ];

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = false; # handled by lanzaboote
      systemd-boot.configurationLimit = 10;
      systemd-boot.consoleMode = "max";
    };
  };

  environment.systemPackages = with pkgs; [ sbctl ];

  hardware.cpu.amd.updateMicrocode = true;

  boot.initrd.luks.devices."root".device = "/dev/disk/by-label/NIXOS_ROOT";
  fileSystems = {
    "/" = {
      device = "/dev/mapper/root";
      fsType = "btrfs";
      options = [
        "compress=zstd"
        "noatime"
      ];
    };
    "/boot" = {
      device = "/dev/disk/by-label/NIXOS_BOOT";
      fsType = "vfat";
    };
  };
}
