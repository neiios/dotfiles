{
  config,
  lib,
  pkgs,
  self,
  username,
  ...
}:
{
  imports = [
    ./hardware.nix

    self.nixosModules.common
    self.nixosModules.compat
    self.nixosModules.flatpak
    self.nixosModules.printing
    self.nixosModules.rocm
    self.nixosModules.gnome
  ];

  networking.hostName = "summit";

  age.secrets = {
    password.file = ./secrets/password.age;
  };

  environment.systemPackages = with pkgs; [ bcachefs-tools ];

  services.system76-scheduler.enable = true;

  # default is 128 which is too low for my pc under a heavy disk load
  # https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/3098
  services.pipewire.extraConfig.pipewire-pulse = {
    "20-higher-min-quatum" = {
      "pulse.properties" = {
        "pulse.min.req" = "256/48000";
        "pulse.min.frag" = "256/48000";
        "pulse.min.quantum" = "256/48000";
      };
    };
  };

  users.users = {
    root.hashedPasswordFile = config.age.secrets.password.path;
    ${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPasswordFile = config.age.secrets.password.path;
    };
  };
}
