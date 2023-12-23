{
  config,
  lib,
  pkgs,
  dotfilesPath,
  ...
} @ args: {
  home.packages = with pkgs; [
    neovim
    wl-clipboard
    ripgrep
    gnumake
    lua-language-server
  ];
  home.sessionVariables = {
    EDITOR = "${pkgs.neovim}/bin/nvim";
  };
  # systemd.user.tmpfiles.rules = [
  #   "L+ ${config.xdg.configHome}/nvim - - - - ${dotfilesPath}/home-manager/neovim/config"
  # ];
}
