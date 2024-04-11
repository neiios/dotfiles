{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # (pkgs.buildFHSUserEnv {
    #   name = "fhs";
    #   runScript = "zsh";
    #   targetPkgs = pkgs: with pkgs; [ gcc ];
    # })

    # cli tools
    nixos-rebuild # useful for non nixos systems
    ripgrep
    fzf
    fd
    lf
    tree
    bat
    jq
    yq
    wget
    curl
    httpie
    tealdeer
    gnumake
    htop
    tesseract
    ffmpeg-full
    trash-cli
    wl-clipboard

    # dev tools
    # neovim # NOTE: for now just compile from source manually
    # gcc
    # nodejs
    # tree-sitter

    vscode-langservers-extracted
    biome
    eslint_d
    nodePackages.eslint
    prettierd
    nodePackages.prettier

    nil
    nixfmt-rfc-style
    lua-language-server
    stylua
  ];

  programs.pyenv.enable = true;
}
