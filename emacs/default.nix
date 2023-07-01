{
  config,
  lib,
  username,
  ...
}: let
  cfg = config.modules.emacs;
in {
  options.modules.emacs = {
    enable = lib.mkEnableOption "Emacs";
  };

  config = lib.mkIf cfg.enable {
    systemd.user.tmpfiles.rules = [
      "L+ /home/${username}/.config/emacs - - - - /home/${username}/Dev/dotfiles/modules/emacs/config"
    ];
  };
}
