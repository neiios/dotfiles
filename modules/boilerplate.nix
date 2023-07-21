{
  config,
  lib,
  pkgs,
  username,
  nixpkgs,
  ...
}: let
  cfg = config.modules.boilerplate;
in {
  options.modules.boilerplate = {
    enable = lib.mkEnableOption "Boilerplate Profile Code";
  };

  config = lib.mkIf cfg.enable {
    home.username = "${username}";
    home.homeDirectory = "/home/${username}";
    programs.home-manager.enable = true;
    home.stateVersion = "23.05";
    targets.genericLinux.enable = true;
    systemd.user.startServices = "sd-switch";
    nix.registry.nixpkgs.flake = nixpkgs;
    xdg.mime.enable = true;

    nix = {
      package = pkgs.nix;
      settings = {
        auto-optimise-store = true;
        experimental-features = ["nix-command" "flakes"];
        warn-dirty = false;
        use-xdg-base-directories = true;
      };
    };
  };
}
