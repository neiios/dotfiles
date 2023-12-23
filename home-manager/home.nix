{
  config,
  lib,
  pkgs,
  ...
} @ args: {
  imports = [
    ./easyeffects
    ./git
    ./neovim
    ./shell
    ./fonts.nix
  ];

  home.packages = with pkgs; [
    nil
    alejandra
    nixos-rebuild
  ];

  home.username = "igor";
  home.homeDirectory = "/home/igor";
  home.stateVersion = "23.05";
  targets.genericLinux.enable = true;
  programs.home-manager.enable = true;
  systemd.user.startServices = "sd-switch";
  nix.registry.nixpkgs.flake = args.nixpkgs;
  nix.registry.home-manager.flake = args.home-manager;
  nix.package = pkgs.nix;
  nix.settings.use-xdg-base-directories = true; # Be careful with this, modules can hardcode old paths
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _: true;
  home.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.configHome}/home-manager - - - - /home/igor/Dev/dotfiles"
  ];
}
