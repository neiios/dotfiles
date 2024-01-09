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
    self.nixosModules.gnome
  ];

  networking.hostName = "sierra";

  age.secrets = {
    password.file = ./secrets/password.age;
  };

  users.mutableUsers = false;
  users.users = {
    root.hashedPasswordFile = config.age.secrets.password.path;
    ${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPasswordFile = config.age.secrets.password.path;
    };
  };
}
