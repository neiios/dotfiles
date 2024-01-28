{
  config,
  lib,
  pkgs,
  nixfmt-rfc,
  ...
}:
{
  home.packages = with pkgs; [
    # vscode # TODO: will break on non nixos

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

    # dev tools
    # neovim # NOTE: for now just compile from source manually
    # gcc
    # nodejs
    # tree-sitter
    # wl-clipboard
    # lua-language-server
    # stylua
    # vscode-langservers-extracted
    nil
    nixfmt-rfc-style
    # (python3.withPackages (
    #   ps: with ps; [
    #     setuptools
    #     pip
    #     numpy
    #     scipy
    #     pandas
    #     seaborn
    #     matplotlib
    #     scikit-learn
    #   ]
    # ))
    # pipenv
    # poetry
  ];
}
