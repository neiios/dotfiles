{
  config,
  lib,
  pkgs,
  self,
  username,
  ...
}@args:
{
  imports = [
    self.homeModules.easyeffects
    self.homeModules.git
    self.homeModules.shell
    self.homeModules.gnome
    self.homeModules.packages
  ];

  home.username = "igor";
  home.homeDirectory = "/home/igor";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
  # will need to be enable on other distros
  targets.genericLinux.enable = false;

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    inter
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  nix.package = pkgs.nix;
  nix.settings.use-xdg-base-directories = true; # Be careful with this, modules can hardcode old paths
  nix.registry.nixpkgs.flake = args.nixpkgs;
  nix.registry.home-manager.flake = args.home-manager;

  nixpkgs.config.allowUnfree = true;
  home.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.configHome}/home-manager - - - - ${config.home.homeDirectory}/Configuration"
  ];

  # default when???
  systemd.user.startServices = "sd-switch";
}
