{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs: {
    packages."x86_64-linux".dotfiles =
      let
        pkgs = import inputs.nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      in
      pkgs.buildEnv {
        name = "dotfiles";
        paths = with pkgs; [
          # shell
          zsh
          zsh-syntax-highlighting
          zsh-autosuggestions
          zsh-completions
          nix-zsh-completions

          # cli tools
          fzf
          eza
          zoxide
          ripgrep
          fd
          wget
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
          docker-compose
          podlet
          (neovim.override {
            vimAlias = true;
            viAlias = true;
            withPython3 = false;
            withRuby = false;
          })

          # js
          nodePackages.nodejs
          nodePackages.pnpm
          bun

          # python
          (python3.withPackages (
            ps: with ps; [
              pandas
              numpy
              matplotlib
              seaborn
              scapy
            ]
          ))

          # nix tools
          nil
          nixd
          nixfmt-rfc-style
          nixos-rebuild
          nix-direnv
          direnv
          nh

          # fonts
          inter
          jetbrains-mono
          nerd-fonts.jetbrains-mono
        ];
      };
  };
}
