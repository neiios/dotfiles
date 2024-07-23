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

  home-manager.users.igorr = hmArgs: {
    imports = [
      inputs.self.homeManagerModules.git
      inputs.self.homeManagerModules.shell
      inputs.self.homeManagerModules.tmux
    ];

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

    home.username = "igorr";
    home.homeDirectory = lib.mkForce "/Users/igorr";
    home.stateVersion = "24.05";
  };

  fonts.packages = with pkgs; [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

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
