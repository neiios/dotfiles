{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      pkgs-master = inputs.nixpkgs-master.legacyPackages.${system};
    in
    {
      packages.${system} = rec {
        neovim-git = pkgs.callPackage ./nix/neovim-git.nix { };

        default = pkgs.buildEnv {
          name = "profile-env";
          paths = with pkgs; [
            ripgrep
            fd
            jq
            fzf
            gh
            mise
            direnv

            gopls
            lua-language-server
            stylua

            pkgs-master.pi-coding-agent
            neovim-git

            zsh-autosuggestions
            zsh-syntax-highlighting
            glibcLocales
          ];
          extraOutputsToInstall = [
            "man"
            "doc"
          ];
        };
      };

      formatter.${system} = pkgs.callPackage ./nix/fmt.nix { };
    };
}
