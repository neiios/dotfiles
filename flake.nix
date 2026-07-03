{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
      };
      pi-coding-agent = pkgs.callPackage ./pkgs/pi-coding-agent.nix { };
      neovimLatest = pkgs.symlinkJoin {
        name = "neovim-latest";
        paths = [ pkgs.neovim ];
        postBuild = ''
          ln -s nvim $out/bin/vim
          ln -s nvim $out/bin/vi
        '';
      };
    in
    {
      packages.${system} = {
        inherit pi-coding-agent;

        dotfiles = pkgs.buildEnv {
          name = "dotfiles";
          paths = with pkgs; [
            zsh
            zsh-syntax-highlighting
            zsh-autosuggestions
            zsh-completions

            fzf
            tmux
            zoxide
            ripgrep
            fd
            curl
            jq
            yq
            trash-cli
            wl-clipboard
            htop
            sshfs
            age
            caddy
            gnumake
            git
            gh
            glab
            ffmpeg-full
            yt-dlp
            distrobox
            podlet

            neovimLatest
            luajitPackages.tree-sitter-cli
            lua-language-server
            stylua

            gopls

            # bun

            nixd
            nixfmt
            nixos-rebuild
            direnv

            lazygit
            lf

            iosevka-bin
            inter
            jetbrains-mono
            nerd-fonts.jetbrains-mono

            pi-coding-agent
          ];
        };
      };
    };
}
