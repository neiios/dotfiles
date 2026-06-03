{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    inputs:
    let
      system = "x86_64-linux";
      pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      pi-coding-agent = pkgs.callPackage ./pkgs/pi-coding-agent.nix { };
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

            (neovim.override {
              vimAlias = true;
              viAlias = true;
              withPython3 = false;
              withRuby = false;
            })

            # bun

            nixd
            nixfmt
            nixos-rebuild
            direnv

            inter
            jetbrains-mono
            nerd-fonts.jetbrains-mono

            pi-coding-agent
          ];
        };
      };
    };
}
