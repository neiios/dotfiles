{
  description = "Ze Nix Dotfiles III";

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ args: let
    dotfilesPath = "/home/igor/Dev/dotfiles";
  in {
    homeConfigurations = {
      igor = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = args // {inherit dotfilesPath;};
        modules = [
          ./home-manager/home.nix
        ];
      };
    };

    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "";
    };
  };
}
