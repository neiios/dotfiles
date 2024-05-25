{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Enables gnome desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Automatic login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "igor";
  # BUG: https://github.com/NixOS/nixpkgs/issues/103746
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Uses pipewire for audio
  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Add more desktop packages
  environment.systemPackages = with pkgs; [
    gnome.gnome-tweaks
    gnome-extension-manager
    gnome.gnome-themes-extra
    pkgs.keyutils # keyctl

    gnomeExtensions.appindicator # Tray icons
  ];

  # Remove useless packages
  services.xserver.excludePackages = [ pkgs.xterm ];
  environment.gnome.excludePackages = with pkgs; [
    gnome.gnome-music
    gnome.geary
    gnome-tour
  ];

  # User settings
  home-manager.users.igor = import ../home-manager/gnome.nix;

  # Use a nicer boot menu
  boot = {
    plymouth.enable = true;

    # Enable "Silent Boot"
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
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
    liberation_ttf
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];
}
