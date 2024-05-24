{ ... }:
{
  systemd.tmpfiles.rules = [
    "L+ /etc/systemd/zram-generator.conf - - - - /home/igor/.dotfiles/system-manager/zram/zram-generator.conf"
    "L+ /etc/sysctl.d/99-vm-zram-parameters.conf - - - - /home/igor/.dotfiles/system-manager/zram/99-vm-zram-parameters.conf"
  ];
}
