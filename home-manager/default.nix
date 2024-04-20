{
  config,
  pkgs,
  self,
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
    ./modules/git
    ./modules/shell
    ./modules/gnome.nix
    ./modules/packages.nix
  ];

  home.username = "igor";
  home.homeDirectory = "/home/igor";
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
  # Flatpaks won't be able to use these
  home.packages = with pkgs; [
    inter
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
      package = (nixGL mpvPackage);
    };

  services.easyeffects = {
    enable = true;
    package = (nixGL pkgs.easyeffects);
  };

  services.syncthing.enable = true;

  nix.package = pkgs.nix;
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
