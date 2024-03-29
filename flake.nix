{
  inputs = {
    nixpkgs.url = "github:/NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    homeConfigurations = {
      igor = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = inputs // {
          username = "igor";
        };
        modules = [ ./home-manager ];
      };
    };

    homeModules = {
      easyeffects = import ./home-manager/modules/easyeffects;
      git = import ./home-manager/modules/git;
      shell = import ./home-manager/modules/shell;
      gnome = import ./home-manager/modules/gnome.nix;
      packages = import ./home-manager/modules/packages.nix;
    };
  };
}
