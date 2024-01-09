# install

- connect to the network
- partition the drive
  ```bash
  mkfs.vfat -n NIXOS_BOOT /dev/nvme0n1p1

  cryptsetup --label NIXOS_ROOT luksFormat /dev/nvme0n1p2

  cryptsetup --allow-discards --perf-no_read_workqueue --perf-no_write_workqueue --persistent open /dev/nvme0n1p2 root

  mkfs.ext4 -L ROOT_DECRYPTED /dev/mapper/root
  ```
- mount drives
- run `nixos-install --flake github:richard96292/dotfiles#hostname --no-root-password --no-channel-copy`
- create secure boot keys
- transfer secrets
- clone dotfiles
- fix permissions
- run nixos-install again
- ???
- profit

