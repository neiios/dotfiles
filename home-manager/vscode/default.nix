{
  config,
  pkgs,
  lib,
  username,
  ...
}: {
  systemd.user.tmpfiles.rules = [
    "L+ ${config.xdg.configHome}/Code/User/settings.json - - - - /home/egor/Dev/dotfiles/home-manager/vscode/settings.json"
  ];
}
