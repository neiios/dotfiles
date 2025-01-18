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
          zsh
          zsh-syntax-highlighting
          zsh-autosuggestions
          zsh-completions
          nix-zsh-completions

          nil
          nixd
          nixfmt-rfc-style
          alejandra
          nixos-rebuild
          nix-direnv
          direnv
          nh

          inter
          jetbrains-mono
          nerd-fonts.jetbrains-mono

          docker-compose
          podman
          distrobox

          butane
          act
          hcloud
          caddy
          age

          nodePackages.nodejs
          nodePackages.pnpm
          bun

          (python3.withPackages (
            ps: with ps; [
              pandas
              numpy
              matplotlib
              seaborn
              scapy
            ]
          ))

          pkgs.htop

          (pkgs.neovim.override {
            vimAlias = true;
            viAlias = true;
            withPython3 = false;
            withRuby = false;
          })
          gnumake
          gcc

          ghostty

          sshfs

          git
          gh
          glab

          tree
          tmux
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
          ffmpeg-full
          yt-dlp
        ];
      };
  };
}
