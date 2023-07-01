{
  config,
  lib,
  ...
}: let
  cfg = config.modules.foot;
in {
  options.modules.foot = {
    enable = lib.mkEnableOption "Foot";
  };

  config = lib.mkIf cfg.enable {
    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          font = "JetBrainsMono Nerd Font:size=10.5";
          dpi-aware = "no";
          pad = "10x10";
          initial-window-size-pixels = "1200x700";
          title = "⠀"; # What an ugly hack. But oh well.
          locked-title = "yes";
        };

        bell.notify = "yes";

        csd = {
          hide-when-maximized = "yes";
          color = "ff002b36";
          button-color = "ffeee8d5";
        };
      };
    };
  };
}
