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

    system-manager = {
      url = "github:numtide/system-manager";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # dev deps
        nix-vm-test.follows = "";
        treefmt-nix.follows = "";
        pre-commit-hooks.follows = "";
      };
    };
  };

  outputs = inputs: {
    homeConfigurations = {
      igor = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = inputs;
        modules = [ ./home-manager ];
      };
    };

    systemConfigs = {
      rainier = inputs.system-manager.lib.makeSystemConfig {
        extraSpecialArgs = inputs;
        modules = [ ./system-manager ];
      };
    };
  };
}
