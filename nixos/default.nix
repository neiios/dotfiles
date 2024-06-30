# This module defines the configuration that can be reused by **every host**
# Don't put anything host specific in this file
{ pkgs, ... }:
{
  # Use the latest kernel version
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Allows to run nixos-rebuild without specifying the path to dotfiles
  systemd.tmpfiles.rules = [ "L+ /etc/nixos - - - - /home/igor/.dotfiles" ];

  nix.settings = {
    # Remove an annoying warning
    warn-dirty = false;
    # Make nix use xdg directories
    use-xdg-base-directories = true;
    # Enable flakes
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  # Set default locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Nicer nixos cli
  programs.nh = {
    enable = true;
    flake = "/home/igor/.dotfiles";
    # Automatically clean up old generations (replaces nix.gc)
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 10";
  };

  # Firmware
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.amd.updateMicrocode = true;
  hardware.cpu.intel.updateMicrocode = true;

  # Make home-manager share system packages
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  # Configure default shell environment
  environment.variables.EDITOR = "nvim";
  programs.fzf.keybindings = true;

  # Install some basic packages
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    curl
    tree
    pciutils
    usbutils
    htop
  ];

  # Allows running and building arm64 binaries on x86
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  # Allows to use unfree packages when building the system
  nixpkgs.config.allowUnfree = true;

  # Use a nicer boot menu
  boot = {
    plymouth.enable = true;

    # Enable "Silent Boot"
    # TODO: does it work?
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "systemd.show_status=auto"
      "rd.udev.log_level=3"
    ];

    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;
  };

  # Include additional fonts for the desktop
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    noto-fonts-monochrome-emoji

    inter
    ubuntu_font_family
    liberation_ttf
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
