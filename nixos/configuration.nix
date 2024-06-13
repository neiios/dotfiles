{ pkgs, ... }@args:
{
  imports = [
    ./gnome.nix
    ./keyd.nix
    ./nix-compat.nix
    ./partitions.nix
    ./podman.nix
    ./printing.nix
    ./secure-boot.nix
    ./vms.nix
  ];

  networking.hostName = "rainier";
  time.timeZone = "Europe/Lisbon";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "en_IE.UTF-8";
  };

  users.users.igor = {
    isNormalUser = true;
    description = "Igor";
    extraGroups = [
      "wheel"
      "adbusers"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.igor.imports = [ ../home-manager ];
  };

  services.flatpak.enable = true;

  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    git
    neovim
    wget
    curl
  ];

  system.stateVersion = "24.05";
  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;
  nix.settings.warn-dirty = false;
  nix.registry.nixpkgs.flake = args.nixpkgs;
  nix.registry.home-manager.flake = args.home-manager;
  nix.settings.use-xdg-base-directories = true;

  # Enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Automatically clean up old generations
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than +5";
  };

  # Creates a vGPU for GVT-G
  virtualisation.kvmgt.enable = true;
  virtualisation.kvmgt.vgpus = {
    "i915-GVTg_V5_4" = {
      uuid = [ "a297db4a-f4c2-11e6-90f6-d3b88d6c9525" ];
    };
  };

  # Make root shell less awful to use
  environment.variables.EDITOR = "nvim";
  programs.fzf.keybindings = true;

  boot = {
    binfmt.emulatedSystems = [ "aarch64-linux" ];

    kernelPackages = pkgs.linuxPackages_latest;

    initrd.systemd.enable = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.efi.efiSysMountPoint = "/efi";

    kernelParams = [
      "psmouse.synaptics_intertouch=0" # Makes trackpad more responsive
    ];

    # Left from hardware-configuration.nix
    kernelModules = [ "kvm-intel" ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Trackpoint Override]
    MatchUdevType=pointingstick
    MatchName=*TPPS/2 IBM TrackPoint*
    AttrTrackpointMultiplier=1
  '';
}
