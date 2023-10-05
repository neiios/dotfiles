{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  # some of the packages that are being used by vscode extensions
  home.packages = with pkgs; [
    hadolint
    black
    ruff
    nil
    alejandra
    nodePackages.prettier
    shellcheck
    nodePackages.bash-language-server
    shfmt
  ];
}
