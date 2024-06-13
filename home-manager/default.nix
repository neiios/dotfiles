{ pkgs, ... }:
{
  imports = [
    ./git
    ./flatpak.nix
    ./fonts.nix
    # ./gnome.nix # sourced in nixos conf
    ./shell.nix
    ./terminal.nix
    ./tmux.nix
    ./xdg.nix
  ];

  home.packages = with pkgs; [
    nodePackages.nodejs
    nodePackages.pnpm

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

    nixfmt-rfc-style
    nil

    # used by apps
    trash-cli
    wl-clipboard
    gettext
  ];

  programs.vscode.enable = true;

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

  services.syncthing.enable = true;

  # This should really be the default
  systemd.user.startServices = "sd-switch";
  home.sessionVariables.NIXPKGS_ALLOW_UNFREE = "1";
  home.stateVersion = "24.05";
}
