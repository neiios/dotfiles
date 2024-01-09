{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.networkmanager.enable = true;
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  hardware.bluetooth = {
    enable = true;
    settings = {
      Policy.AutoEnable = false;
      General = {
        Experimental = true;
        KernelExperimental = true;
      };
    };
  };

  security.rtkit.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    jack.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
  };
  environment.etc."wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
    bluez_monitor.properties = {
      ["bluez5.enable-sbc-xq"] = true,
      ["bluez5.enable-msbc"] = true,
      ["bluez5.enable-hw-volume"] = true,
      ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
    }
  '';

  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "igor";
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.systemPackages = with pkgs.gnome; [
    gnome-themes-extra
  ];

  services.xserver.excludePackages = with pkgs; [ xterm ];
  environment.gnome.excludePackages = with pkgs.gnome; [
    epiphany
    yelp
    geary
    gnome-contacts
    gnome-maps
    gnome-music
    pkgs.gnome-console
    pkgs.gnome-tour
  ];
}
