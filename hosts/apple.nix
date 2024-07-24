{
  lib,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ inputs.home-manager.darwinModules.home-manager ];

  environment.systemPackages = with pkgs; [
    fastfetch

    neovim

    nil
    nixfmt-rfc-style
    nh # more convenient nix/home-manager cli
    nixos-rebuild

    bazel-buildtools
  ];

  environment.variables.EDITOR = "nvim";

  programs.fish.enable = true;

  home-manager.users.igorr =
    { config, ... }:
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      imports = [
        inputs.self.homeManagerModules.git
        inputs.self.homeManagerModules.shell
        inputs.self.homeManagerModules.tmux
      ];

      home.file = {
        "${config.home.homeDirectory}/.ideavimrc".source = mkSymlink "${config.home.homeDirectory}/.dotfiles/configs/.ideavimrc";
      };

      programs.fish = {
        enable = true;
        interactiveShellInit = ''
          # Add IDEs from toolbox to the PATH
          fish_add_path --append --move ~/Library/Application Support/JetBrains/Toolbox/scripts

          # Wixstaller
          fish_add_path --prepend --move ~/.local/bin

          # Rancher Desktop
          fish_add_path --prepend --move ~/.rd/bin
        '';
      };

      programs.alacritty = {
        enable = true;
        settings = {
          shell = {
            program = "${pkgs.tmux}/bin/tmux";
            args = [
              "new-session"
              "-s"
              "default"
              "-A"
            ];
          };

          window = {
            padding = {
              x = 10;
              y = 10;
            };
            dimensions = {
              columns = 160;
              lines = 40;
            };
            dynamic_padding = true;
            opacity = 0.92;
            blur = true;
            decorations_theme_variant = "Dark";
            option_as_alt = "Both";
          };

          font = {
            size = 13;
            normal = {
              family = "JetBrainsMono Nerd Font";
              style = "Regular";
            };
          };
        };
      };

      programs.tmux.extraConfig = ''
        # True color support
        set-option -sa terminal-features ',alacritty:RGB'

        set -g default-shell '/etc/profiles/per-user/igorr/bin/fish'
      '';

      home.username = "igorr";
      home.homeDirectory = lib.mkForce "/Users/igorr";
      home.stateVersion = "24.05";
    };

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  security.pam.enableSudoTouchIdAuth = true;

  homebrew = {
    enable = true;
    casks = [ "alacritty" ];
  };

  # Mandatory boilerplate
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.home-manager.flake = inputs.home-manager;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = inputs;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "x86_64-darwin";
}
