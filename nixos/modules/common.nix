{
  config,
  lib,
  pkgs,
  username,
  agenix,
  home-manager,
  ...
}@args:
let
  homePath = "/home/${username}";
in
{
  imports = [ agenix.nixosModules.default ];

  age.identityPaths = [ "${homePath}/.ssh/agenix_key" ];
  environment.systemPackages = [ agenix.packages.x86_64-linux.default ];

  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = false;
    };
    podman = {
      enable = true;
      autoPrune.enable = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  services.openssh = {
    enable = true;
    openFirewall = true;
    startWhenNeeded = true;
  };

  services.fwupd.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.firewall.enable = true;

  services.dbus.implementation = "broker";

  time.timeZone = "Europe/Helsinki";
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "en_IE.UTF-8";
      LC_MEASUREMENT = "en_IE.UTF-8";
      LC_PAPER = "en_IE.UTF-8";
    };
  };

  # add support for some gamepads
  hardware.steam-hardware.enable = true;

  programs.adb.enable = true;
  users.users.${username}.extraGroups = [ "adbusers" ];

  # TODO: zram optimizations are taken from archwiki and should probably be upstreamed to nixpkgs
  zramSwap = {
    enable = true;
    memoryPercent = 200;
  };
  boot.kernel.sysctl = {
    "vm.swappiness" = 180;
    "vm.watermark_boost_factor" = 0;
    "vm.watermark_scale_factor" = 125;
    "vm.page-cluster" = 0;
  };

  system.stateVersion = "24.05";
  nixpkgs.hostPlatform = "x86_64-linux";

  hardware.enableRedistributableFirmware = true;
  nixpkgs.config.allowUnfree = true;
  environment.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";

  systemd.tmpfiles.rules = [ "L+ /etc/nixos - - - - ${homePath}/Configuration" ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Be careful with this, modules can hardcode old paths
      use-xdg-base-directories = true;

      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    registry = {
      nixpkgs.flake = args.nixpkgs;
      home-manager.flake = args.home-manager;
    };

    optimise.automatic = true;

    # NOTE: don't use on servers
    daemonIOSchedClass = "idle";
    daemonCPUSchedPolicy = "idle";

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };
}
