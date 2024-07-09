{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/v0.4.1";

    nixos-06cb-009a-fingerprint-sensor = {
      url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    nixosConfigurations = {
      rainier = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/rainier
          inputs.home-manager.nixosModules.home-manager
          { home-manager.extraSpecialArgs = inputs; }
        ];
      };

      summit = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = inputs;
        modules = [
          ./hosts/summit
          inputs.home-manager.nixosModules.home-manager
          { home-manager.extraSpecialArgs = inputs; }
        ];
      };
    };

    darwinConfigurations = {
      "macbook" = inputs.nix-darwin.lib.darwinSystem {
        modules = [ ./hosts/macbook ];
      };
    };

    darwinPackages = inputs.self.darwinConfigurations."macbook".pkgs;
  };
}
