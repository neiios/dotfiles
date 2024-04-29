{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "d /etc/keyd 0755 root root - -"
    "L+ /etc/keyd/keyd.conf - - - - /home/igor/.dotfiles/system-manager/keyd.conf"
    "L+ /etc/libinput/local-overrides.quirks - - - - /home/igor/.dotfiles/system-manager/local-overrides.quirks"
  ];

  environment.systemPackages = with pkgs; [ keyd ];

  systemd.services.keyd = {
    description = "Keyd remapping daemon";
    documentation = [ "man:keyd(1)" ];
    wantedBy = [ "multi-user.target" ];
    restartTriggers = [ "/etc/keyd/keyd.conf" ];
    serviceConfig = {
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
  };
}
