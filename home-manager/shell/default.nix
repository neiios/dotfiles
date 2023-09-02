{
  config,
  lib,
  pkgs,
  ...
} @ args: {
  imports = [
    ./foot.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    lf
  ];
}
