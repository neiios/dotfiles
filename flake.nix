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

          nodePackages.nodejs
          bun

          nixd
          nixfmt
          nixos-rebuild
          direnv

          inter
          jetbrains-mono
          nerd-fonts.jetbrains-mono
        ];
      };
  };
}
