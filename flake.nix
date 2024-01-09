{
  inputs = {
    nixpkgs.url = "github:/NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        darwin.follows = "";
      };
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixfmt-rfc.url = "github:piegamesde/nixfmt/rfc101-style";
  };

  outputs = inputs: {
    nixosConfigurations = {
      summit = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // {
          username = "igor";
        };
        modules = [ ./nixos/hosts/summit ];
      };

      sierra = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs // {
          username = "igor";
        };
        modules = [ ./nixos/hosts/sierra ];
      };
    };

    nixosModules = {
      common = import ./nixos/modules/common.nix;
      compat = import ./nixos/modules/compat.nix;
      flatpak = import ./nixos/modules/flatpak.nix;
      gnome = import ./nixos/modules/gnome.nix;
      printing = import ./nixos/modules/printing.nix;
      rocm = import ./nixos/modules/rocm.nix;
    };

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

    formatter.x86_64-linux = inputs.nixfmt-rfc.packages.x86_64-linux.default;
  };
}
