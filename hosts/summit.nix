{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./common.nix
    ./git
    ./flatpak.nix
    ./fonts.nix
    ./gnome.nix
    ./shell.nix
    ./terminal.nix
    ./tmux.nix
    ./xdg.nix
  ];

  programs.bash.enable = true;

  home.packages = with pkgs; [
    fastfetch
    neovim

    nil
    nixfmt-rfc-style
    nh # more convenient nix/home-manager cli
    nixos-rebuild

    nodePackages.nodejs
    nodePackages.pnpm
    bun

    (python3.withPackages (
      ps: with ps; [
        pandas
        numpy
        matplotlib
        seaborn
        scapy
      ]
    ))

    jdk21
    gradle
    maven

    scrcpy

    ripgrep
    fd
    bat
    fzf

    tree
    gnumake

    jq
    yq

    wget
    curl

    tesseract
    ffmpeg-full

    # used by apps
    trash-cli
    wl-clipboard
    gettext
  ];

  programs.fish.interactiveShellInit = ''
    fish_add_path --append '${config.xdg.dataHome}/JetBrains/Toolbox/scripts'
  '';

  services.syncthing.enable = true;
  home.sessionVariables = {
    STNODEFAULTFOLDER = 1; # Don't create default ~/Sync folder
    EDITOR = "nvim";
  };

  programs.tealdeer = {
    enable = true;
    settings.updates.auto_update = true;
  };

  programs.htop.enable = true;

  programs.lf = {
    enable = true;
    settings = {
      autoquit = true;
    };
  };

  programs.pyenv.enable = true;

  programs.mpv = {
    enable = true;
    scripts = with pkgs.mpvScripts; [
      uosc
      thumbfast
      mpris
    ];
  };

  services.ssh-agent.enable = true;

  # Mandatory boilerplate
  programs.home-manager.enable = true;
  home.username = "igor";
  home.homeDirectory = "/home/igor";
  home.stateVersion = "24.05";
  systemd.user.startServices = "sd-switch";
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.home-manager.flake = inputs.home-manager;
  home.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  systemd.user.tmpfiles.rules = [
    "L+ ${config.home.homeDirectory}/.config/home-manager - - - - ${config.home.homeDirectory}/.dotfiles"
  ];
}
