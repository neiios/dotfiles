{ config, pkgs, ... }@args:
{
  imports = [
    ./modules/git
    ./modules/gnome.nix
    ./modules/packages.nix
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/tmux.nix
    ./modules/xdg.nix
  ];

  home.username = "igor";
  home.homeDirectory = "/home/igor";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  nixGL.prefix = "${args.nixGL.packages.x86_64-linux.nixGLIntel}/bin/nixGLIntel";

  fonts.fontconfig.enable = true;
  # Flatpaks won't be able to use these
  home.packages = with pkgs; [
    inter
    liberation_ttf
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # aaaa fucking assertion
  programs.mpv =
    let
      mpvScripts = with pkgs.mpvScripts; [
        uosc
        thumbfast
        mpris
      ];
      mpvPackage = (pkgs.wrapMpv pkgs.mpv-unwrapped { scripts = mpvScripts; });
    in
    {
      enable = true;
      package = (config.lib.nixGL.wrap mpvPackage);
    };

  services.easyeffects = {
    enable = true;
    package = (config.lib.nixGL.wrap pkgs.easyeffects);
  };

  services.syncthing.enable = true;

  targets.genericLinux.enable = true;

  nix.package = pkgs.nixVersions.latest;
  nix.registry.nixpkgs.flake = args.nixpkgs;
  nix.registry.home-manager.flake = args.home-manager;

  # Be careful with this, modules can hardcode old paths
  nix.settings.use-xdg-base-directories = true;
  # Annoying and kinda useless
  nix.settings.warn-dirty = false;

  # TODO: doesn't work with the new cli
  nixpkgs.config.allowUnfree = true;
  home.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

  # Allows using home-manager on cli without specifying the path to dotfiles each time
  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.configHome}/home-manager - - - - ${config.home.homeDirectory}/.dotfiles"
  ];

  # This should really be the default
  systemd.user.startServices = "sd-switch";
}
