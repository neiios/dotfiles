{ pkgs, ... }:
{
  services.printing.enable = true;

  # Detect network printers (with IPP Everywhere)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Printer drivers, including proprietary ones
  services.printing.drivers = with pkgs; [
    gutenprint
    gutenprintBin
    hplip
    hplipWithPlugin
    postscript-lexmark
    samsung-unified-linux-driver
    splix
    brlaser
    brgenml1lpr
    brgenml1cupswrapper
    # cnijfilter2
  ];
}
