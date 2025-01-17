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

    jq
    lf
    bun

    nil
    nixfmt-rfc-style
    nixos-rebuild
    inputs.nh.packages.x86_64-darwin.nh

    difftastic

    protolint
    yazi
  ];

  environment.variables.EDITOR = "nvim";

  programs.fish.enable = true;

  security.pam.enableSudoTouchIdAuth = true;
  security.pam.enablePamReattach = true;

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
          fish_add_path --append --move ~/Library/Application\ Support/JetBrains/Toolbox/scripts

          # Wixstaller
          fish_add_path --prepend --move $(brew --prefix python@3.10)/libexec/bin
          fish_add_path --prepend --move ~/.local/bin

          # Rancher Desktop
          fish_add_path --prepend --move ~/.rd/bin

          function gsw; git switch $argv || git switch -c $argv; end
        '';
      };

      programs.tmux.extraConfig = ''
        # True color support
        set-option -sa terminal-features ',ghostty:RGB'

        set -g default-shell '/etc/profiles/per-user/igorr/bin/fish'
      '';

      home.username = "igorr";
      home.homeDirectory = lib.mkForce "/Users/igorr";
      home.stateVersion = "24.05";
    };

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  homebrew = {
    enable = true;
    casks = [ ];
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
