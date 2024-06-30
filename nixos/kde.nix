{ pkgs, ... }:
{
  # Enables gnome desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Automatic login
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "igor";

  networking.networkmanager.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

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

  # Enable flatpaks
  services.flatpak.enable = true;

  # Add more desktop packages
  environment.systemPackages = with pkgs; [
    junction
    gnome.gnome-themes-extra
    desktop-file-utils # update-desktop-database
  ];

  # Remove useless packages
  services.xserver.excludePackages = [ pkgs.xterm ];
}
