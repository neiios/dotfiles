{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.4.1";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
      mkHmConfig = inputs.home-manager.lib.homeManagerConfiguration;
      mkDarwinConfig = inputs.nix-darwin.lib.darwinSystem;
    in
    {
      homeConfigurations."igor" = mkHmConfig {
        inherit pkgs;
        modules = [ ./hosts/summit.nix ];
        extraSpecialArgs = {
          inherit inputs;
        };
      };

      darwinConfigurations."apple" = mkDarwinConfig {
        modules = [ ./hosts/apple ];
        specialArgs = {
          inherit inputs;
        };
      };

      homeManagerModules = {
        git = ./home-manager/git;
        flatpak = ./home-manager/flatpak.nix;
        fonts = ./home-manager/fonts.nix;
        foot = ./home-manager/foot.nix;
        gnome = ./home-manager/gnome.nix;
        shell = ./home-manager/shell.nix;
        tmux = ./home-manager/tmux.nix;
        xdg = ./home-manager/xdg.nix;
      };
    };
}
