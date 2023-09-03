{
  config,
  lib,
  pkgs,
  ...
} @ args: {
  imports = [
    ./easyeffects
    ./shell
    ./vscode
    ./fonts.nix
    ./generic-linux.nix
    ./git.nix
    ./gnome.nix
  ];

  home.packages = with pkgs; [
    nil
    alejandra
    nixos-rebuild
  ];

  home.username = "egor";
  home.homeDirectory = "/home/egor";
  home.stateVersion = "23.05";
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
    "L+ ${config.xdg.configHome}/home-manager - - - - /home/egor/Dev/dotfiles"
  ];
}
