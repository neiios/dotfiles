{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      gutenprint
      gutenprintBin
      hplip
      postscript-lexmark
      splix
      brlaser
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  environment.etc.papersize.text = ''
    a4
  '';
}
