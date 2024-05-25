{
  config,
  lib,
  pkgs,
  ...
}:
{
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

  services.zram-generator = {
    enable = true;
    settings = {
      zram0 = {
        zram-size = "ram";
        compression-algorithm = "zstd";
      };
    };
  };

  # https://wiki.archlinux.org/title/Zram#Optimizing_swap_on_zram
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };
}
