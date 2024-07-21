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
  ];

  environment.variables.EDITOR = "nvim";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.extraSpecialArgs = inputs;
  home-manager.users.igorr = hmArgs: {
    home.username = "igorr";
    home.homeDirectory = lib.mkForce "/Users/igorr";

    imports = [
      inputs.self.homeManagerModules.git
      inputs.self.homeManagerModules.shell
      inputs.self.homeManagerModules.tmux
    ];

    programs.fish.enable = true;

    programs.alacritty.enable = true;

    programs.fish.interactiveShellInit = ''
      # Add IDEs from toolbox to the PATH
      fish_add_path --append --move ~/Library/Application Support/JetBrains/Toolbox/scripts

      # Wixstaller
      fish_add_path --prepend --move ~/.local/bin

      # Rancher Desktop
      fish_add_path --prepend --move ~/.rd/bin
    '';

    home.stateVersion = "24.05";
  };

  # Mandatory boilerplate
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.home-manager.flake = inputs.home-manager;
  services.nix-daemon.enable = true;
  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 4;
  nixpkgs.hostPlatform = "x86_64-darwin";
}
