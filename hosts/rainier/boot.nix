{ ... }:
{
  boot.initrd.availableKernelModules = [
    "sd_mod"
    "ahci"
    "nvme"
    "usb_storage"
    "usbhid"
    "xhci_pci"
    "ehci_pci"
  ];

  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/efi";

  boot.initrd.luks.devices."root".device = "/dev/disk/by-label/CRYPTROOT";

  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "ext4";
  };

  fileSystems."/efi" = {
    device = "/dev/disk/by-label/EFI";
    fsType = "vfat";
    options = [ "umask=077" ];
  };
}
