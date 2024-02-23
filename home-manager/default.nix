{
  config,
  lib,
  pkgs,
  self,
  username,
  ...
}@args:
let
  nixGL = import ./nixGL.nix {
    inherit pkgs config;
    inherit (args) nixGL;
  };
in
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
  
  programs.bash.enable = true;

  # aaaa fucking assertion
  programs.mpv = let 
    mpvScripts = with pkgs.mpvScripts; [ uosc thumbfast mpris ];
    mpvPackage = (pkgs.wrapMpv pkgs.mpv-unwrapped { scripts = mpvScripts; });
  in {
    enable = true;
    package = (nixGL mpvPackage);
  };

  services.ssh-agent.enable = true;

  nix.package = pkgs.nixVersions.nix_2_19;
  nix.settings.use-xdg-base-directories = true; # Be careful with this, modules can hardcode old paths
  nix.settings.warn-dirty = false;
  nix.registry.nixpkgs.flake = args.nixpkgs;
  nix.registry.home-manager.flake = args.home-manager;

  nixpkgs.config.allowUnfree = true;
  home.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.configHome}/home-manager - - - - ${config.home.homeDirectory}/Configuration"
  ];

  # This should really be the default
  systemd.user.startServices = "sd-switch";
}
