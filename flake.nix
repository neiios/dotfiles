{
  description = "Ze Dotfiles";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ args: let
    system = "x86_64-linux";
    username = "egor";
    pkgs = nixpkgs.legacyPackages.${system};
    createHmConfig = home-manager.lib.homeManagerConfiguration;
  in {
    homeConfigurations."egor" = createHmConfig {
      inherit pkgs;

      modules = [
        {imports = import ./modules/module-list.nix;}
        ./home-manager/egor.nix
      ];

      extraSpecialArgs = {
        inherit args username nixpkgs;
      };
    };
  };
}
